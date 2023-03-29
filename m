Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC706CD782
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjC2KTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjC2KTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:19:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFDE210D
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:19:14 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id kq3so14406547plb.13
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680085154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/j1xEMQoVnKjzoSFlFNFypG2jSgdXMzD4JxZdtxftQ=;
        b=XJ/UYvMtnUWRer9aT3LA6G9cgJTMeVswbWmB/9Vs7T1kHaOu/E5R22MSVGC/KtpbDl
         /sonwVdjnakbsSgWFVIYx8rUb0IJIE7O/vMw9/tEwydciMga3kzi+CEf6xXADJgPTz+H
         dHQ4STmlUGI+ftZUCD1peftb+TQixvA8neTxwN6Z/hacQIj9AgF4nLLsfuUqBrssBNXh
         GZPoeJK41EgQgSquQbUGLLIfd/PHPRAfrXRvy7ZOU9f74lzSPbzV3ashYNyPMsxgqmun
         btQFu9xd+Xp7nRGN8yRO4/75IEeFghy8zUipcpqshG6XWtvVQKz/bMrQ8vAG6U7Iglg1
         PZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680085154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/j1xEMQoVnKjzoSFlFNFypG2jSgdXMzD4JxZdtxftQ=;
        b=A7EWcZcMBmGp7s4PI7qN9605F+6EgbOHivcNOdyCyVeh6JaWTA7b0g2QHGtYBUwULR
         wNyGdyaAanGpqpeoblEW+vItLM3M2yD9PscctQvH6uh6RY5GHtwbnuS9avPAmtpmXNcn
         +un4xg9RHtaFzpbJR7H3IeiHfNFmOQxqfp+p37/uW+aXT/WPrX2XcSqTQWPlm3Ezfp4K
         Fm+DliTZdOg3Owg9cTQCfp+oZyEYLvQQ2H6AKtlPAkp8zcsjUvd824n0KIDhchUKoLwU
         eP5o8kN+k2F8keFmcJXPjfZTgqt0Vmfhze1Mt/p8xaNfgleODqEJd2PCj2AsOSCkQGzb
         ZzQw==
X-Gm-Message-State: AAQBX9dLBXlMRKMFdArMsYzpISYEKHlfpEWvXjGYZ6Msgo3hcdwR06wu
        usjC1LpVkVsebSWQ7vtNGue7Z95ZovhEqw==
X-Google-Smtp-Source: AKy350bg/5/bEikJDKo87xcCHWKHsgvZlcrxsUdFZuCEQ7y/lGSezm0Y6NZsYyN58atyEQrKgYX5NQ==
X-Received: by 2002:a17:902:f9cf:b0:19c:b7da:fbdf with SMTP id kz15-20020a170902f9cf00b0019cb7dafbdfmr17288091plb.26.1680085153838;
        Wed, 29 Mar 2023 03:19:13 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id a17-20020a631a11000000b0051322ab5ccdsm9304653pga.28.2023.03.29.03.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 03:19:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/3] bonding: fix ns validation on backup slaves
Date:   Wed, 29 Mar 2023 18:18:57 +0800
Message-Id: <20230329101859.3458449-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230329101859.3458449-1-liuhangbin@gmail.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When arp_validate is set to 2, 3, or 6, validation is performed for
backup slaves as well. As stated in the bond documentation, validation
involves checking the broadcast ARP request sent out via the active
slave. This helps determine which slaves are more likely to function in
the event of an active slave failure.

However, when the target is an IPv6 address, the NS message sent from
the active interface is not checked on backup slaves. Additionally,
based on the bond_arp_rcv() rule b, we must reverse the saddr and daddr
when checking the NS message.

Note that when checking the NS message, the destination address is a
multicast address. Therefore, we must convert the target address to
solicited multicast in the bond_get_targets_ip6() function.

Prior to the fix, the backup slaves had a mii status of "down", but
after the fix, all of the slaves' mii status was updated to "UP".

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 5 +++--
 include/net/bonding.h           | 8 ++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 236e5219c811..8cc9a74789b7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3269,7 +3269,8 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 
 	combined = skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
 	if (!combined || combined->ip6.nexthdr != NEXTHDR_ICMP ||
-	    combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    (combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_SOLICITATION &&
+	     combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT))
 		goto out;
 
 	saddr = &combined->ip6.saddr;
@@ -3291,7 +3292,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 	else if (curr_active_slave &&
 		 time_after(slave_last_rx(bond, curr_active_slave),
 			    curr_active_slave->last_link_up))
-		bond_validate_na(bond, slave, saddr, daddr);
+		bond_validate_na(bond, slave, daddr, saddr);
 	else if (curr_arp_slave &&
 		 bond_time_in_interval(bond, slave_last_tx(curr_arp_slave), 1))
 		bond_validate_na(bond, slave, saddr, daddr);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index ea36ab7f9e72..c3843239517d 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -761,13 +761,17 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 #if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
 {
+	struct in6_addr mcaddr;
 	int i;
 
-	for (i = 0; i < BOND_MAX_NS_TARGETS; i++)
-		if (ipv6_addr_equal(&targets[i], ip))
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++) {
+		addrconf_addr_solict_mult(&targets[i], &mcaddr);
+		if ((ipv6_addr_equal(&targets[i], ip)) ||
+		    (ipv6_addr_equal(&mcaddr, ip)))
 			return i;
 		else if (ipv6_addr_any(&targets[i]))
 			break;
+	}
 
 	return -1;
 }
-- 
2.38.1

