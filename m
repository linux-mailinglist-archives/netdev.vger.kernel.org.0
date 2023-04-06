Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6018B6D918C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbjDFI3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbjDFI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:29:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09EF4C0E
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:29:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so42177681pjt.2
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680769784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hkz3Gtomz0cRO3U1muyvjCZmQJyg1v7u5jA9irU/p2M=;
        b=OkT8a+i136AYw3AoBVux6APjYYjJ7sCNYeIa2DEWXsqRPxY5eNRnZpEVqAKrSXWqTA
         jxpfT8hpIlu5939AEqSEuGnrA1xgrAT4EL8zgxQrFcZXXZVBMXbC0pZ4Redm3d6xuTwI
         DXoN3yPjTzcm8dO119pVay3DYTsWCUpk6pea5kyOk1FAO1uzcVWM1mdcQhBtytNOsykM
         7jmLMQN9chxC3IjZivsSmyoEl4gXtWBM9RZvLhHIFUDodxWoUCycKj4jcfSK/KItJT65
         fp1jFOaNFrP5N6Wr/VyHf/ovUFoFRAREUrOM6NyUew1JxuGjFXj+bi52Gl0mfEbinXfj
         Du1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hkz3Gtomz0cRO3U1muyvjCZmQJyg1v7u5jA9irU/p2M=;
        b=fMSP4FribALFynuejvm3A7kg5foM8EfnbNRQoe9XLh2xJzQZi5R4Jxwm/54yT+CAt7
         30RsQWRFn0/yTCTbDx//sRTGof5BnV8XZYFyemZbGbpO9WRrrfcScrsWWXR0AIZLiE+N
         38y5CI62VAPA1Vi5v//DLkPZ7f5uZ76v7Jh4N27Lxcv534FKQvtxHIe21qBZp8LoEGJM
         qOrjkDUYB69P7yFLKfFCJSFujUYz+DvfvUL8TxUuUJkeVJX9TnOLMEdTNr7+Y6bbMNGB
         ioX+2sHsepyjB/A9imrPgYYvG2gp/7RXphnnpqGnXEnSvuG0XRGKOa9ESucX1xl8Kv1+
         AC/A==
X-Gm-Message-State: AAQBX9eT9IYj9wUuLL8xVkFeUTKFX6lZ2jlgE29zX38oHfZWt6n2DWci
        901s+bod8RQztNkv9BXWLuSjXb8U5+JPog==
X-Google-Smtp-Source: AKy350YHbD7qCvkhD8eIM+sjryAZXw+zQbyP2tRJjV0LDVfRqvGrzwjogaPP+rFEjFUxl2kXZZQZAQ==
X-Received: by 2002:a17:90b:1d09:b0:23f:1c6d:2b60 with SMTP id on9-20020a17090b1d0900b0023f1c6d2b60mr5694070pjb.5.1680769783754;
        Thu, 06 Apr 2023 01:29:43 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id on13-20020a17090b1d0d00b0023493354f37sm2644433pjb.26.2023.04.06.01.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:29:42 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCHv2 net 1/3] bonding: fix ns validation on backup slaves
Date:   Thu,  6 Apr 2023 16:23:50 +0800
Message-Id: <20230406082352.986477-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230406082352.986477-1-liuhangbin@gmail.com>
References: <20230406082352.986477-1-liuhangbin@gmail.com>
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
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: no update
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

