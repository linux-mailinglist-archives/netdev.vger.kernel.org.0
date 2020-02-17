Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E537161D61
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgBQWgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:36:53 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:35170 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgBQWgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:36:52 -0500
Received: by mail-qv1-f66.google.com with SMTP id u10so8303921qvi.2
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=muLz7NpwuqzQffvLv7y71moNFLRuCrH6WvBmQYEqjwI=;
        b=H8USq53SNUzxwu21CVgTvrGHPyJ7FdC+7GFXqUG519SbsdIvwipclM3/mfayVd4jgm
         4JlhHVucpd0GhGGOIqU5Nw96dszdKr0M8uIj7q22UiQtazI5zCaIfMKVZhXTa82zhbU6
         rSvLRPIfsTZ+ykjcis5N9ZeV6tn+qRJvv1unE2L9b01Qe4PEGOI69tJkK+u4YYGazwmS
         F9aUsqfwAwPwG7yB8iK3bYC4KeSF1c3bYVfSt3lbYr7sKWKYQRbAl1iVDwFeBshijs55
         re3/82gUiwCv6cDw9jEbkFH6phmmHO3HlmtayTHWDRsoAdY/U2+LgycceqQ8OMoAQcLa
         p9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muLz7NpwuqzQffvLv7y71moNFLRuCrH6WvBmQYEqjwI=;
        b=T8Pz3SKMkpJzAGqHddCYSCuO3ExSkk+40gfShDbNsHnoT0Ujj7LCLxvHDvcAbPpyuB
         dJLa5gLkV+sRPmcrqzNgxmYMqdZg7zBydK+cI9Uzd566ATExqpBrTePeZ9GXpWjq2tgg
         jX0OwuXaS2HhdBMnR3yJtSiITG+fOLSpTaxcn1XCTCXRmGdTfKaSo/9C41X54hQRK4gb
         dJLsMUYTLje7ewzeqVQXLDaxQQdKzP78G7QdY6HpHuXqKdzxI7vF9yx+VuZ45b2C0jXx
         4c7vjvUmHf8Y0CzvzUzz0nt44ujzmjfLzEIChYT9AiMemprZqDzsRuAQwNuHPxxH9KE5
         V0OA==
X-Gm-Message-State: APjAAAXrNw6MfjEtZ+87AlPdRAaAikcfqsGFHZGfUQyD0V0ff0FPVFw7
        RcLKY0Wzez/fWw9U+n70B+M=
X-Google-Smtp-Source: APXvYqwalbqTGAteGNYGO3ht8BgkYcUuPktlEFJapSGfMQGk1siGor69q5ADlZXiz4q1Oa7OIGx0rg==
X-Received: by 2002:a0c:e2cf:: with SMTP id t15mr14641337qvl.127.1581979011842;
        Mon, 17 Feb 2020 14:36:51 -0800 (PST)
Received: from localhost.localdomain ([216.154.21.195])
        by smtp.gmail.com with ESMTPSA id a2sm964031qka.75.2020.02.17.14.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:36:51 -0800 (PST)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PACTH net-next 2/5] addrconf: add functionality to check on rpl requirements
Date:   Mon, 17 Feb 2020 17:35:38 -0500
Message-Id: <20200217223541.18862-3-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200217223541.18862-1-alex.aring@gmail.com>
References: <20200217223541.18862-1-alex.aring@gmail.com>
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
index cb493e15959c..66b40ae579a1 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4394,6 +4394,59 @@ int ipv6_chk_home_addr(struct net *net, const struct in6_addr *addr)
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

