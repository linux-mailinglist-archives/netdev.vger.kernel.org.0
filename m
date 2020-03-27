Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263471960C9
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgC0WAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:00:49 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45316 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbgC0WAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:00:48 -0400
Received: by mail-qt1-f194.google.com with SMTP id t17so9932398qtn.12
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOcbegi1l7xTihrE+PQU6zO4Dow+M35LYDDeoAcbal4=;
        b=oHIEyf8BV6rtMa5rypGf1eImZMoa3UNrlklRnooXf42OyZdaEIAxZGonRoIYsWG2HR
         Wv2EJ44YxEAohuvk5nl0/IsJ3reUr4oScti03lLizHr2h7wTSv6qezuU6N4FLmX+mmUq
         TMpiw9pchk+1bkJSTmIS6HNIMcdThsuzIqfF+6llDcGnbc6lcnGqZnAnqpXw3RSo86ZI
         e1Z8RCA36m4GlQxs/rw04zcwsQWh6yo5eEWT1ARYghRNPHyBXjktplKS3UcAt2VkNol/
         oA8yoXwUqDvpyGKBOSvVO8DX6dK7Pen6/kfr+6IEVNOgYGQ0vZ7cEKjZAPQCwqzNgqqY
         ujyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOcbegi1l7xTihrE+PQU6zO4Dow+M35LYDDeoAcbal4=;
        b=E4vUyGUfRXug8wJhypcBHDoHZ/AtOu+Wo6FVhsv53iKjNXPivVUCi4XnX/66qF3hZk
         UVotto3GZcEIwfgHPyaoAZFSHlGqlhtV/PgLA7w1+HKzfh0NoYl/I23NP+D6mm1gcWdx
         XUC6rBFeJoOahWqdLJdtUVB4HBkMtTCtCg7EbW15/fcaCC5FPtz6APPkU2k/Ruyv/ew6
         iEWFSWKJPoLPKTI6fFG6ostBE870SFKA70N1Is+9reBE8r+M/Yza+oZ6a6/ILRc4Hrl+
         V1LNlPsdPzlHqCMlgcrw6qZKwswQ8k+kiudskXsNZcoZsBX6YZAqZo+C09krjOL/WGmt
         GVQg==
X-Gm-Message-State: ANhLgQ2iKSy6u1WdcWhWumaPu4FuDUuahrDOucw2jqw6fjqCLeIYDKZr
        yfJFTMrNOBoOgxD0hoNny4I=
X-Google-Smtp-Source: ADFU+vtDj+Vf5yvmv+AZQ6PcXUW8+3Gotgba8dBR6SU1H8SrrwnT4nCsXWiFUo3AGWc8oBAJ1Ybp/g==
X-Received: by 2002:ac8:5291:: with SMTP id s17mr1472891qtn.156.1585346446569;
        Fri, 27 Mar 2020 15:00:46 -0700 (PDT)
Received: from localhost.localdomain ([45.72.142.47])
        by smtp.gmail.com with ESMTPSA id v20sm5073659qth.10.2020.03.27.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:00:46 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv3 net-next 2/5] addrconf: add functionality to check on rpl requirements
Date:   Fri, 27 Mar 2020 18:00:19 -0400
Message-Id: <20200327220022.15220-3-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327220022.15220-1-alex.aring@gmail.com>
References: <20200327220022.15220-1-alex.aring@gmail.com>
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

