Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC6E660519
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbjAFQv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjAFQvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:51:52 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A30377D3C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:51:50 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c11so2422095qtn.11
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yF1AvuMTVkFygmNKOlNT/iJoiBFb/b0AumdSvkZogws=;
        b=hMqXtfyvQkfbDsvUm8b3F3H2o7QztZxBG3+qVFCeAKf/8DbBr/Lla68XrjgDe6a3XI
         CT+P7nBEPU9ZO20tHcw2QXclcOzA8pVD5CEqbbxWnLkSU2nUIDVRtGMKBt9sU28X0CQL
         ZKKLuQTQI3+fCj//1gAzm/B0dYlzh910R48bmaDN2mWIgJncG066e2TKaLd6Gc0+CF1d
         2Ej1LLFTWsMu/ku9EdoXEqn6oq/uaRX7bjBP0LoKA9+cCKPUgFdUzBMzymgqB4sT0xwn
         DM/RlZxBqxvbWRn6/2qDcYf9hNFdxPeMCdxF2soPsT2sV2TJQvUydmR0RaTLLMGuGLF8
         MA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yF1AvuMTVkFygmNKOlNT/iJoiBFb/b0AumdSvkZogws=;
        b=yIOmv5JedI4BYcgtz9gruOyruUowl8995q66hTLYGx3UHsQkpsh7KrZdNq8OmBYzRQ
         69cR+8RXaKhA/I76uOKFCRNSiOy2Ph/8QV7EmFzF8yLIRdUQO2I2Dr+Xuhn4D7RICE8f
         RODI+ln0MUqcoDuwvgaR9vi5gVL5pBx5L1BN6BYrGuWzUj0wnOzhGrhpRgS85LY6gbgS
         cZnjffCasY0gqhjp4UMZivjUDe2CdBrkOB9fwn0lwobeTOrgDDOaBAdspGUoMLsiGdEn
         6ZXfKmxEzM+2NRYoL4f7y0nrL9ZT7MwDNpk+6bay9glTV8k5PUl7oTfUmx4psQxlcUnT
         AH+Q==
X-Gm-Message-State: AFqh2koivF7XCacYu4K1oYlHqW9hES0sc8mo1h45z2lQYus39wlxuZtW
        65gIaa6LNwN/XJZjkNF9FSUX3n5+PilnYA==
X-Google-Smtp-Source: AMrXdXuA8QoHOUFdvvKyYjm5U4JxsjCjci96lxUO4P/oLrm1jdpgkYauoGQ1MwQJ2HR1x66pt6fkxw==
X-Received: by 2002:ac8:728f:0:b0:3a9:68c6:2368 with SMTP id v15-20020ac8728f000000b003a968c62368mr70477806qto.30.1673023909287;
        Fri, 06 Jan 2023 08:51:49 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r25-20020ac867d9000000b003431446588fsm736082qtp.5.2023.01.06.08.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 08:51:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        LiLiang <liali@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        jianghaoran <jianghaoran@kylinos.cn>,
        Jay Vosburgh <fubar@us.ibm.com>
Subject: [PATCH net] ipv6: prevent only DAD and RS sending for IFF_NO_ADDRCONF
Date:   Fri,  6 Jan 2023 11:51:47 -0500
Message-Id: <ab8f8ce5b99b658483214f3a9887c0c32efcca80.1673023907.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
slave ports of team, bonding and failover devices and it means no ipv6
packets can be sent out through these slave ports. However, for team
device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
link will be marked failure.

The orginal issue fixed by IFF_NO_ADDRCONF was caused by DAD and RS
packets sent by slave ports in commit c2edacf80e15 ("bonding / ipv6: no
addrconf for slaves separately from master") where it's using IFF_SLAVE
and later changed to IFF_NO_ADDRCONF in commit 8a321cf7becc ("net: add
IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf").

So instead of preventing all the ipv6 addrconf, it makes more sense to
only prevent DAD and RS sending for the slave ports: Firstly, check
IFF_NO_ADDRCONF in addrconf_dad_completed() to prevent RS as it did in
commit b52e1cce31ca ("ipv6: Don't send rs packets to the interface of
ARPHRD_TUNNEL"), and then also check IFF_NO_ADDRCONF where IFA_F_NODAD
is checked to prevent DAD.

Fixes: 0aa64df30b38 ("net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/addrconf.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f7a84a4acffc..c774cf34bf2e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1124,7 +1124,8 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ifa->flags = cfg->ifa_flags;
 	ifa->ifa_proto = cfg->ifa_proto;
 	/* No need to add the TENTATIVE flag for addresses with NODAD */
-	if (!(cfg->ifa_flags & IFA_F_NODAD))
+	if (!(cfg->ifa_flags & IFA_F_NODAD) &&
+	    !(idev->dev->priv_flags & IFF_NO_ADDRCONF))
 		ifa->flags |= IFA_F_TENTATIVE;
 	ifa->valid_lft = cfg->valid_lft;
 	ifa->prefered_lft = cfg->preferred_lft;
@@ -3319,10 +3320,6 @@ static void addrconf_addr_gen(struct inet6_dev *idev, bool prefix_route)
 	if (netif_is_l3_master(idev->dev))
 		return;
 
-	/* no link local addresses on devices flagged as slaves */
-	if (idev->dev->priv_flags & IFF_NO_ADDRCONF)
-		return;
-
 	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
 
 	switch (idev->cnf.addr_gen_mode) {
@@ -3564,7 +3561,6 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			if (event == NETDEV_UP && !IS_ERR_OR_NULL(idev) &&
 			    dev->flags & IFF_UP && dev->flags & IFF_MULTICAST)
 				ipv6_mc_up(idev);
-			break;
 		}
 
 		if (event == NETDEV_UP) {
@@ -3855,7 +3851,8 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 			/* set state to skip the notifier below */
 			state = INET6_IFADDR_STATE_DEAD;
 			ifa->state = INET6_IFADDR_STATE_PREDAD;
-			if (!(ifa->flags & IFA_F_NODAD))
+			if (!(ifa->flags & IFA_F_NODAD) &&
+			    !(dev->priv_flags & IFF_NO_ADDRCONF))
 				ifa->flags |= IFA_F_TENTATIVE;
 
 			rt = ifa->rt;
@@ -3997,6 +3994,7 @@ static void addrconf_dad_begin(struct inet6_ifaddr *ifp)
 
 	net = dev_net(dev);
 	if (dev->flags&(IFF_NOARP|IFF_LOOPBACK) ||
+	    dev->priv_flags & IFF_NO_ADDRCONF ||
 	    (net->ipv6.devconf_all->accept_dad < 1 &&
 	     idev->cnf.accept_dad < 1) ||
 	    !(ifp->flags&IFA_F_TENTATIVE) ||
@@ -4218,6 +4216,7 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
 		  (dev->flags & IFF_LOOPBACK) == 0 &&
+		  (dev->priv_flags & IFF_NO_ADDRCONF) == 0 &&
 		  (dev->type != ARPHRD_TUNNEL);
 	read_unlock_bh(&ifp->idev->lock);
 
-- 
2.31.1

