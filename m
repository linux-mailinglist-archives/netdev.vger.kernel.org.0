Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC39418C567
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgCTCjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:39:23 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44449 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTCjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:39:23 -0400
Received: by mail-qk1-f195.google.com with SMTP id j4so5435406qkc.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOcbegi1l7xTihrE+PQU6zO4Dow+M35LYDDeoAcbal4=;
        b=cunoUNmblo/g9vYxph0WuVThslBa2UuXavEBY2uJU5YDU17NDG7LnOFw/mUyYozeTR
         UsUB6x41+VMC9Dk9FP0gLien+5cbZAkhYMpM0Oa/9N3O0RKRsudffs8p+16jQ1zUL2iz
         vjzDIAzdVt917ytwB8ExnLggdB6hKLOr5fTVzZDD+T2ehCboqtfWkw5nZttHT4iYxPVc
         wY2Ok7VqdLW8mUMSjvmQ71VV66658lJIAywp9llMMps6MvWokzyPYbE2CLiyOmLYgaNT
         1w/DTaqs2Ch88GnU1OJbOpF7jd7f/lp1y+RXA1gW5LcUQJ6ZXfoumHK/xxXha4e53XBn
         Evkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOcbegi1l7xTihrE+PQU6zO4Dow+M35LYDDeoAcbal4=;
        b=csDOKRx9mUDy5gPdt4hwfKsTBrMaAc4MZSo+eHw5mdOmdcG3s1VKk8yLVo22uPFFuQ
         U+YR9WBvU/WsmhzQlNkLkMTt81/HsI/Ws/eZ6yeWsV2Y/EYL8FZrkPCBCTaAhyiBmtyA
         f6vMBpHiozKce1FuFeLTHELJHe8tcI92pFLRFhjN/iSV0lzZ1RChz3hDUi96nxK0ab7U
         LqWSZ/MkZh9X5JPaKkrPuG3eVSg3TOu4aW1bgjRg+4xbVnWFUCgIBWcMsTHPPq10KJVx
         IV8v1Bc7+CPl+iEfIvBAb13nNHwbheHFFq6ZV0sevQCBkR0zD/4dYNEqAv7XQOUTgaUV
         Uxfg==
X-Gm-Message-State: ANhLgQ0YzpOgUvzznngmuqZbmOYu/JCyq48OIMVXqDbjVFEuXRnvAONO
        7bItFDTjLrlxrVjHwnbBckA=
X-Google-Smtp-Source: ADFU+vsOycVdlEM87sgghqGBl9w6G5KYSN5P3WyuaNycmASoSSMs9malfXOsxhxHXNB77bGD4FEFtg==
X-Received: by 2002:a37:61d0:: with SMTP id v199mr5874063qkb.292.1584671961778;
        Thu, 19 Mar 2020 19:39:21 -0700 (PDT)
Received: from localhost.localdomain (69-196-128-153.dsl.teksavvy.com. [69.196.128.153])
        by smtp.gmail.com with ESMTPSA id d9sm2979465qth.34.2020.03.19.19.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:39:21 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv2 net-next 2/5] addrconf: add functionality to check on rpl requirements
Date:   Thu, 19 Mar 2020 22:38:58 -0400
Message-Id: <20200320023901.31129-3-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320023901.31129-1-alex.aring@gmail.com>
References: <20200320023901.31129-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a functionality to addrconf to check on a specific RPL
address configuration. According to RFC 6554:

To detect loops in the SRH, a router MUST determine if the SRH
includes multiple addresses assigned to any interface on that
router. If such addresses appear more than once and are separated by
at least one address not assigned to that router.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 include/net/addrconf.h |  3 +++
 net/ipv6/addrconf.c    | 53 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index a088349dd94f..e0eabe58aa8b 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -90,6 +90,9 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 int ipv6_chk_home_addr(struct net *net, const struct in6_addr *addr);
 #endif
 
+int ipv6_chk_rpl_srh_loop(struct net *net, const struct in6_addr *segs,
+			  unsigned char nsegs);
+
 bool ipv6_chk_custom_prefix(const struct in6_addr *addr,
 				   const unsigned int prefix_len,
 				   struct net_device *dev);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 5b9de773ce73..594963a7e1ec 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4398,6 +4398,59 @@ int ipv6_chk_home_addr(struct net *net, const struct in6_addr *addr)
 }
 #endif
 
+/* RFC6554 has some algorithm to avoid loops in segment routing by
+ * checking if the segments contains any of a local interface address.
+ *
+ * Quote:
+ *
+ * To detect loops in the SRH, a router MUST determine if the SRH
+ * includes multiple addresses assigned to any interface on that router.
+ * If such addresses appear more than once and are separated by at least
+ * one address not assigned to that router.
+ */
+int ipv6_chk_rpl_srh_loop(struct net *net, const struct in6_addr *segs,
+			  unsigned char nsegs)
+{
+	const struct in6_addr *addr;
+	int i, ret = 0, found = 0;
+	struct inet6_ifaddr *ifp;
+	bool separated = false;
+	unsigned int hash;
+	bool hash_found;
+
+	rcu_read_lock();
+	for (i = 0; i < nsegs; i++) {
+		addr = &segs[i];
+		hash = inet6_addr_hash(net, addr);
+
+		hash_found = false;
+		hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
+			if (!net_eq(dev_net(ifp->idev->dev), net))
+				continue;
+
+			if (ipv6_addr_equal(&ifp->addr, addr)) {
+				hash_found = true;
+				break;
+			}
+		}
+
+		if (hash_found) {
+			if (found > 1 && separated) {
+				ret = 1;
+				break;
+			}
+
+			separated = false;
+			found++;
+		} else {
+			separated = true;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  *	Periodic address status verification
  */
-- 
2.20.1

