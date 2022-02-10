Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBAE4B095F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiBJJWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:22:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiBJJWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:22:21 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CE610B5;
        Thu, 10 Feb 2022 01:22:22 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id h8so5990870lfj.10;
        Thu, 10 Feb 2022 01:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=nsTVaT+UT9MHEz7rhHRMqhy05TbGiCCQO6axpgS2mow=;
        b=bSNPCd7D7+ZPmKMhWJm+NE7jDlibmc7BV/Wfg3NIFdY6l5NMTPKPjWG4G1SeghmOiW
         4Mo4FTsE2ARgtf/IPMJ8sMVVbiq+BfVlkCnjdqMsJSTwpl+dV0rRlU+TLUuCvPZ8zTLK
         dlO/k/qeIP+RjIEMrDMwElUmhfFKcY+Sq1RLnd5K+mUiwHWTthNL6cVQOu8jhEXxu3wL
         3fKQpbhBxaKDLe/ZkhiQee9T+VZxK+uPmVBTyvzVRnbW0T3LklhEDGQXWqcuxZLJ/WAm
         Eu7v5rjieKB9FK668L7of1I8vnl8S4illOAhUxTN63oAAWFk0gbCZKidv2q5I63YqmXE
         RzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nsTVaT+UT9MHEz7rhHRMqhy05TbGiCCQO6axpgS2mow=;
        b=aoN/Af6wAazLXQlFEV+Me2Tnk3+pDk0iXCX+2bgAj//5k5jruJvjSQ/BAyO+ylCEfs
         xZaL06Kp00kJwKWcQ1B9xwm5Hk59NM/IuzNorZ/YEGXZYoUiITQMR8QFeOaHwhWzL80h
         3ah6Rwkq6oaP0BqofoDyX0dbdS7UyHNbjbOGnLWzgR/8pBvctKOZMQEvXqloy3Z+eBpF
         ijb87zH/qf0nyqhmNvcMU0gOQnZZPOWWkl3LsM5c3M77NWE7r4n87ZwpPUzLg5p1TJhN
         y9NzIitFTK8MzJZVqv1UFcDzHn4bkplNFT6yAi+gOxM3Tb+rn4TIgvknzDTC5M3XDnxZ
         bYeQ==
X-Gm-Message-State: AOAM530CFykAfzC+MC6uNJnEyil86TQa+0yucNs/w4Fqu7vMD9qak6M8
        z1Ndn+l9YenUHxFG4cdrzTf0OGmC8bFnF2s4VW8=
X-Google-Smtp-Source: ABdhPJy3ngnKMEfBOmDyt9BDD0Fk/R8gFeaOkOvPjAAvY1gYVeuYXBWsEIS8hn6/chXIWRfJZSDGgw==
X-Received: by 2002:a05:6512:104a:: with SMTP id c10mr4619459lfb.297.1644484941078;
        Thu, 10 Feb 2022 01:22:21 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k1sm2712230lfu.136.2022.02.10.01.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:22:20 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <schultz.hans+lkml@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/5] net: bridge: Refactor bridge port in
 locked mode to use jump labels
In-Reply-To: <fed43e8d-de8c-aa76-1451-877cf4cc76d2@blackwall.org>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <20220209130538.533699-6-schultz.hans+netdev@gmail.com>
 <fed43e8d-de8c-aa76-1451-877cf4cc76d2@blackwall.org>
Date:   Thu, 10 Feb 2022 10:22:17 +0100
Message-ID: <86o83fuldi.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, feb 10, 2022 at 10:31, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 09/02/2022 15:05, Hans Schultz wrote:
>> From: Hans Schultz <schultz.hans+lkml@gmail.com>
>> 
>> As the locked mode feature is in the hot path of the bridge modules
>> reception of packets, it needs to be refactored to use jump labels
>> for optimization.
>> 
>> Signed-off-by: Hans Schultz <schultz.hans+lkml@gmail.com>
>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>> ---
>
> Why two (almost) identical sign-offs?

Ups, a mistake...

>
> Also, as Ido mentioned, please fold this patch into patch 01.
>
>>  net/bridge/br_input.c   | 22 ++++++++++++++++++----
>>  net/bridge/br_netlink.c |  6 ++++++
>>  net/bridge/br_private.h |  2 ++
>>  3 files changed, 26 insertions(+), 4 deletions(-)
>> 
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>> index 469e3adbce07..6fc428d6bac5 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -23,6 +23,18 @@
>>  #include "br_private.h"
>>  #include "br_private_tunnel.h"
>>  
>> +static struct static_key_false br_input_locked_port_feature;
>> +
>> +void br_input_locked_port_add(void)
>> +{
>> +	static_branch_inc(&br_input_locked_port_feature);
>> +}
>> +
>> +void br_input_locked_port_remove(void)
>> +{
>> +	static_branch_dec(&br_input_locked_port_feature);
>> +}
>> +
>>  static int
>>  br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
>>  {
>> @@ -91,10 +103,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>  				&state, &vlan))
>>  		goto out;
>>  
>> -	if (p->flags & BR_PORT_LOCKED) {
>> -		fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>> -		if (!(fdb_entry && fdb_entry->dst == p))
>> -			goto drop;
>> +	if (static_branch_unlikely(&br_input_locked_port_feature)) {
>> +		if (p->flags & BR_PORT_LOCKED) {
>> +			fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>> +			if (!(fdb_entry && fdb_entry->dst == p))
>> +				goto drop;
>> +		}
>>  	}
>>  
>>  	nbp_switchdev_frame_mark(p, skb);
>> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
>> index 7d4432ca9a20..e3dbe9fed75c 100644
>> --- a/net/bridge/br_netlink.c
>> +++ b/net/bridge/br_netlink.c
>> @@ -860,6 +860,7 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
>>  static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
>>  			     int attrtype, unsigned long mask)
>>  {
>> +	bool locked = p->flags & BR_PORT_LOCKED;
>>  	if (!tb[attrtype])
>>  		return;
>>  
>> @@ -867,6 +868,11 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
>>  		p->flags |= mask;
>>  	else
>>  		p->flags &= ~mask;
>> +
>> +	if ((p->flags & BR_PORT_LOCKED) && !locked)
>> +		br_input_locked_port_add();
>> +	if (!(p->flags & BR_PORT_LOCKED) && locked)
>> +		br_input_locked_port_remove();
>>  }
>>  
>>  /* Process bridge protocol info on port */
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index 2661dda1a92b..0ec3ef897978 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -832,6 +832,8 @@ void br_manage_promisc(struct net_bridge *br);
>>  int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
>>  
>>  /* br_input.c */
>> +void br_input_locked_port_add(void);
>> +void br_input_locked_port_remove(void);
>>  int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
>>  rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
>>  
