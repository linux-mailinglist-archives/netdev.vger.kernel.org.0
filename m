Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF667CCED
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjAZN42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjAZN4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:56:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CD2171F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 05:56:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pL2jL-0006R0-PD; Thu, 26 Jan 2023 14:55:55 +0100
Date:   Thu, 26 Jan 2023 14:55:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     wolfgang@linogate.de
Cc:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] xfrm: remove inherited bridge info from skb
Message-ID: <20230126135555.GC26056@breakpoint.cc>
References: <20230126125637.91969-1-wolfgang@linogate.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126125637.91969-1-wolfgang@linogate.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wolfgang@linogate.de <wolfgang@linogate.de> wrote:
> From: Wolfgang Nothdurft <wolfgang@linogate.de>
> 
> When using a xfrm interface in a bridged setup (the outgoing device is
> bridged), the incoming packets in the xfrm interface inherit the bridge
> info an confuses the netfilter connection tracking.
> 
> brctl show
> bridge name     bridge id               STP enabled     interfaces
> br_eth1         8000.000c29fe9646       no              eth1
> 
> This messes up the connection tracking so that only the outgoing packets
> show up and the connections through the xfrm interface are UNREPLIED.
> When using stateful netfilter rules, the response packet will be blocked
> as state invalid.

How does that mess up connection tracking?
Can you explain further?

> telnet 192.168.12.1 7
> Trying 192.168.12.1...
> 
> conntrack -L
> tcp      6 115 SYN_SENT src=192.168.11.1 dst=192.168.12.1 sport=52476
> dport=7 packets=2 bytes=104 [UNREPLIED] src=192.168.12.1
> dst=192.168.11.1 sport=7 dport=52476 packets=0 bytes=0 mark=0
> secctx=system_u:object_r:unlabeled_t:s0 use=1
> 
> Chain INPUT (policy DROP 0 packets, 0 bytes)
>     2   104 DROP_invalid all -- * * 0.0.0.0/0 0.0.0.0/0  state INVALID
> 
> Jan 26 09:28:12 defendo kernel: fw-chk drop [STATE=invalid] IN=ipsec0
> OUT= PHYSIN=eth1 MAC= SRC=192.168.12.1 DST=192.168.11.1 LEN=52 TOS=0x00
> PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=7 DPT=52476 WINDOW=64240 RES=0x00
> ACK SYN URGP=0 MARK=0x1000000

So it looks like for some reason reply packets are not passed to
conntrack.

> This patch removes the bridge info from the incoming packets on the xfrm
> interface, so the packet can be properly assigned to the connection.

To me it looks like this is papering over the real problem, whatever
that is.

> +	/* strip bridge info from skb */
> +	if (skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
> +		skb_ext_del(skb, SKB_EXT_BRIDGE_NF);

skb_ext_del(skb, SKB_EXT_BRIDGE_NF) would be enough, no need for a
conditional, but this only builds with CONFIG_BRIDGE_NETFILTER=y.

Does this work too?

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f20f4373ff40..9554abcfd5b4 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -871,6 +871,7 @@ static unsigned int ip_sabotage_in(void *priv,
        if (nf_bridge && !nf_bridge->in_prerouting &&
            !netif_is_l3_master(skb->dev) &&
            !netif_is_l3_slave(skb->dev)) {
+               nf_bridge_info_free(skb);
                state->okfn(state->net, state->sk, skb);
                return NF_STOLEN;
        }


This is following guess:

1. br netfilter on, so when first (encrypted) packet is received on eth1,
   conntrack is called from br_netfilter, which allocated nf_bridge info
   for skb.
2. Packet is for local machine, so passed on to ip stack from bridge
3. Packet passes through ip prerouting a second time, but br_netfilter
   ip_sabotage_in supresses the re-invocation of the hooks
4. Packet passes to xfrm for decryption
5. Packet appears on network stack again, this time after decryption
6. ip_sabotage_in prevents re-invocation of netfilter hooks because
   packet allegedly already passed them once (from br_netfilter).
   But the br_netfilter packet seen was before decryption, so conntrack
   never saw the syn-ack.

I think the correct solution is to disable ip_sabotage_in() after it
suppressed the call once.
