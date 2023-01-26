Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D82E67CF2F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjAZPGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjAZPGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:06:02 -0500
Received: from mail.linogate.de (mail.linogate.de [213.179.141.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F476B988
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:05:59 -0800 (PST)
Received: from riab.mowin.de (support.linogate.de [213.179.141.14] (may be forged))
        by mail.linogate.de with ESMTPS id 30QF93VM058523
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 26 Jan 2023 16:09:03 +0100
Received: from riab.mowin.de (localhost [127.0.0.1])
        (authenticated bits=128)
        by riab.mowin.de with ESMTPSA id 30QF5rgI031687
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 16:05:53 +0100
X-Virus-Scanned: by amavisd-new at 
Received: from [192.168.0.163] ([192.168.0.163])
        by riab.mowin.de with ESMTP id 30QF5qc6031614;
        Thu, 26 Jan 2023 16:05:52 +0100
Message-ID: <4f805210-8f70-01dc-c0e9-4e573875eeab@linogate.de>
Date:   Thu, 26 Jan 2023 16:05:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net] xfrm: remove inherited bridge info from skb
Content-Language: en-GB, de-DE
To:     Florian Westphal <fw@strlen.de>
Cc:     steffen.klassert@secunet.com, netdev@vger.kernel.org
References: <20230126125637.91969-1-wolfgang@linogate.de>
 <20230126135555.GC26056@breakpoint.cc>
From:   Wolfgang Nothdurft <wolfgang@linogate.de>
In-Reply-To: <20230126135555.GC26056@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 213.179.141.2
X-Scanned-By: MIMEDefang 2.78
X-Greylist: ACL 256 matched, not delayed by milter-greylist-4.6.2 (mail.linogate.de [213.179.141.2]); Thu, 26 Jan 2023 16:09:03 +0100 (CET)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 26.01.23 um 14:55 schrieb Florian Westphal:
> wolfgang@linogate.de <wolfgang@linogate.de> wrote:
>> From: Wolfgang Nothdurft <wolfgang@linogate.de>
>>
>> When using a xfrm interface in a bridged setup (the outgoing device is
>> bridged), the incoming packets in the xfrm interface inherit the bridge
>> info an confuses the netfilter connection tracking.
>>
>> brctl show
>> bridge name     bridge id               STP enabled     interfaces
>> br_eth1         8000.000c29fe9646       no              eth1
>>
>> This messes up the connection tracking so that only the outgoing packets
>> show up and the connections through the xfrm interface are UNREPLIED.
>> When using stateful netfilter rules, the response packet will be blocked
>> as state invalid.
> 
> How does that mess up connection tracking?
> Can you explain further?

By "messed up" I meant that the reply packets were not showing up. I'm 
not that far into the netfilter code, so my guess was that the packets 
could not be mapped due to the additional bridge info.

I had this problem before with the KLIPS ipsec interface from the 
Libreswan project. It appeared by the change from kernel 4.4 to 5.10. 
Probably due to connection tracking support for bridge: 
https://lwn.net/Articles/787195/.
I used the same as workaround here.

> 
>> telnet 192.168.12.1 7
>> Trying 192.168.12.1...
>>
>> conntrack -L
>> tcp      6 115 SYN_SENT src=192.168.11.1 dst=192.168.12.1 sport=52476
>> dport=7 packets=2 bytes=104 [UNREPLIED] src=192.168.12.1
>> dst=192.168.11.1 sport=7 dport=52476 packets=0 bytes=0 mark=0
>> secctx=system_u:object_r:unlabeled_t:s0 use=1
>>
>> Chain INPUT (policy DROP 0 packets, 0 bytes)
>>      2   104 DROP_invalid all -- * * 0.0.0.0/0 0.0.0.0/0  state INVALID
>>
>> Jan 26 09:28:12 defendo kernel: fw-chk drop [STATE=invalid] IN=ipsec0
>> OUT= PHYSIN=eth1 MAC= SRC=192.168.12.1 DST=192.168.11.1 LEN=52 TOS=0x00
>> PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=7 DPT=52476 WINDOW=64240 RES=0x00
>> ACK SYN URGP=0 MARK=0x1000000
> 
> So it looks like for some reason reply packets are not passed to
> conntrack.
> 
>> This patch removes the bridge info from the incoming packets on the xfrm
>> interface, so the packet can be properly assigned to the connection.
> 
> To me it looks like this is papering over the real problem, whatever
> that is.
> 
>> +	/* strip bridge info from skb */
>> +	if (skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
>> +		skb_ext_del(skb, SKB_EXT_BRIDGE_NF);
> 
> skb_ext_del(skb, SKB_EXT_BRIDGE_NF) would be enough, no need for a
> conditional, but this only builds with CONFIG_BRIDGE_NETFILTER=y.
> 
> Does this work too?

Yes, this work also.

> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index f20f4373ff40..9554abcfd5b4 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -871,6 +871,7 @@ static unsigned int ip_sabotage_in(void *priv,
>          if (nf_bridge && !nf_bridge->in_prerouting &&
>              !netif_is_l3_master(skb->dev) &&
>              !netif_is_l3_slave(skb->dev)) {
> +               nf_bridge_info_free(skb);
>                  state->okfn(state->net, state->sk, skb);
>                  return NF_STOLEN;
>          }
> 
> 
> This is following guess:
> 
> 1. br netfilter on, so when first (encrypted) packet is received on eth1,
>     conntrack is called from br_netfilter, which allocated nf_bridge info
>     for skb.
> 2. Packet is for local machine, so passed on to ip stack from bridge
> 3. Packet passes through ip prerouting a second time, but br_netfilter
>     ip_sabotage_in supresses the re-invocation of the hooks
> 4. Packet passes to xfrm for decryption
> 5. Packet appears on network stack again, this time after decryption
> 6. ip_sabotage_in prevents re-invocation of netfilter hooks because
>     packet allegedly already passed them once (from br_netfilter).
>     But the br_netfilter packet seen was before decryption, so conntrack
>     never saw the syn-ack.
> 
> I think the correct solution is to disable ip_sabotage_in() after it
> suppressed the call once.
> 

