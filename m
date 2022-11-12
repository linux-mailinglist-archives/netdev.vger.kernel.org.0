Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438DB6265C4
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiKLAF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKLAFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:05:25 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F45D252B0;
        Fri, 11 Nov 2022 16:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hOjwZzcNBym1jYh8JPbeeK1TzJNtOiX/GrSls8yxePI=; b=LYmWzFGlPQ9b0AYgsYUpkBGNMh
        mIlVpjEw7+WUsaJOoVKWn4I1UvcBbs6nreHH+lbXhx5C+X2yz13hjOgQxXX7AHhcFSm86NogYoHem
        8xV997J33u1+Xk3+rdf2LFkVDtDwRdMgAoPE/KDoJbEgDxPzuitm+aiODGTll+aHcnuU=;
Received: from p54ae9c3f.dip0.t-ipconnect.de ([84.174.156.63] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ote1I-001EJk-AF; Sat, 12 Nov 2022 01:05:12 +0100
Message-ID: <b2420602-8d64-a75b-2296-059ac0ba26ef@nbd.name>
Date:   Sat, 12 Nov 2022 01:05:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20221110212212.96825-1-nbd@nbd.name>
 <20221110212212.96825-2-nbd@nbd.name> <20221111233714.pmbc5qvq3g3hemhr@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v3 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
In-Reply-To: <20221111233714.pmbc5qvq3g3hemhr@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.11.22 00:37, Vladimir Oltean wrote:
> On Thu, Nov 10, 2022 at 10:22:08PM +0100, Felix Fietkau wrote:
>> If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
>> port netdev, assume that it carries the port number and that there is no DSA
>> tag present in the skb data.
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>  				else
>> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>> index 64b14f655b23..0b67622cf905 100644
>> --- a/net/dsa/dsa.c
>> +++ b/net/dsa/dsa.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/netdevice.h>
>>  #include <linux/sysfs.h>
>>  #include <linux/ptp_classify.h>
>> +#include <net/dst_metadata.h>
>>  
>>  #include "dsa_priv.h"
>>  
>> @@ -216,6 +217,7 @@ static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
>>  static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>>  			  struct packet_type *pt, struct net_device *unused)
>>  {
>> +	struct metadata_dst *md_dst = skb_metadata_dst(skb);
>>  	struct dsa_port *cpu_dp = dev->dsa_ptr;
>>  	struct sk_buff *nskb = NULL;
>>  	struct dsa_slave_priv *p;
>> @@ -229,7 +231,22 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>>  	if (!skb)
>>  		return 0;
>>  
>> -	nskb = cpu_dp->rcv(skb, dev);
>> +	if (md_dst && md_dst->type == METADATA_HW_PORT_MUX) {
>> +		unsigned int port = md_dst->u.port_info.port_id;
>> +
>> +		skb_dst_set(skb, NULL);
> 
> If you insist on not using the refcounting feature and free your
> metadata_dst in the master's remove() function, that's going to
> invalidate absolutely any point I'm trying to make. Normally I'd leave
> you alone, however I really don't like that this is also forcing DSA to
> not use the refcount, and therefore, that it's forcing any other driver
> to do the same as mtk_eth_soc. Not sure how that's gonna scale in the
> hypothetical future when there will be a DSA master which can offload
> RX DSA tags, *and* the switch can change tagging protocols dynamically
> (which will force the master to allocate/free its metadata dst's at
> runtime too). I guess that will be for me to figure out, which I don't
> like.
> 
> Jakub, what do you think? Refcounting or no refcounting?
If think that refcounting for the metadata dst is useful in this case, I 
can replace the skb_dst_set call with skb_dst_drop() in v4, so it would 
work for both cases.

- Felix
