Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5482061E1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392480AbgFWUvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404066AbgFWUrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:47:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ED9C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g18so6943wrm.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PsVnZiU164smHUvfeaLehL8S/X1w62QMfoibHkfcTw8=;
        b=Djy+o3H71e3jVrH1oxVs/TKg65SF8T1ef5c1OnJdOmNtq1nGUFiJfPUyk6RBFwagNy
         q6mO8rf8A2KSQu5/Nd0Cdu0/nslWy9hcaIFGfRO8u9dJz1rTVZIgXjbvVYumTIyv2b/Y
         H6bdubYoXoYX97JdYF2kdf9/2eDkUgHJ5zOJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsVnZiU164smHUvfeaLehL8S/X1w62QMfoibHkfcTw8=;
        b=I6m8pSwWbgTqOjYMORSlUjVjRQf22P3YkCMNOk/2B5pnlWUrvNRaPqpzwwUVBnyoiI
         voyb+DRhJW0WEBNQzdTIdz66kBe5exyCv9AzX5SMGXU3z4O3dk2DMGjypXtNachX1CTE
         DCz34Aazg3NUClCULZsXrw/fjFKlWOErx3DbYkpnWjtaI3DE5e8RcWhDGg4CerdAJNjg
         YcbDbRsoKdGQcbPWid2EjR2jLWpIwrFuiz6roChWUWXluL804tgAXV/hjmhRBlAoQ9Nd
         vuWQLgvraTsq0UEEPHnO+hwaz9mn21AR5HSTvyzYTfNI8c8FxKTI2cEAulUpRp09/YlZ
         Svig==
X-Gm-Message-State: AOAM530hBsIcN9FfQ057MdRzvM7a6oyVSR/In+zw19XoMHVLzdHVaxHy
        /vcjwGeD/ml/FlwRgpWbFVdqZOrY8X7lWA==
X-Google-Smtp-Source: ABdhPJw6gRorTuL7N34Xr6y8T1Wtr2ZATURck/BUB/8ILF8R5bw8TtxeRWJshC+xHcpRsERcSFzdfQ==
X-Received: by 2002:a5d:6651:: with SMTP id f17mr13908746wrw.29.1592945262228;
        Tue, 23 Jun 2020 13:47:42 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id j6sm5686924wmb.3.2020.06.23.13.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 13:47:41 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, anuradhak@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 4/4] net: bridge: add a flag to avoid refreshing fdb when changing/adding
Date:   Tue, 23 Jun 2020 23:47:18 +0300
Message-Id: <20200623204718.1057508-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
References: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we modify or create a new fdb entry sometimes we want to avoid
refreshing its activity in order to track it properly. One example is
when a mac is received from EVPN multi-homing peer by FRR, which doesn't
want to change local activity accounting. It makes it static and sets a
flag to track its activity.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/neighbour.h | 1 +
 net/bridge/br_fdb.c            | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 21e569297355..dc8b72201f6c 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -191,6 +191,7 @@ enum {
 enum {
 	NFEA_UNSPEC,
 	NFEA_ACTIVITY_NOTIFY,
+	NFEA_DONT_REFRESH,
 	__NFEA_MAX
 };
 #define NFEA_MAX (__NFEA_MAX - 1)
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 642deb57c064..9db504baa094 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -860,6 +860,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			 struct nlattr *nfea_tb[])
 {
 	bool is_sticky = !!(ndm->ndm_flags & NTF_STICKY);
+	bool refresh = !nfea_tb[NFEA_DONT_REFRESH];
 	struct net_bridge_fdb_entry *fdb;
 	u16 state = ndm->ndm_state;
 	bool modified = false;
@@ -937,7 +938,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 
 	fdb->used = jiffies;
 	if (modified) {
-		fdb->updated = jiffies;
+		if (refresh)
+			fdb->updated = jiffies;
 		fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 	}
 
@@ -977,6 +979,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 
 static const struct nla_policy br_nda_fdb_pol[NFEA_MAX + 1] = {
 	[NFEA_ACTIVITY_NOTIFY]	= { .type = NLA_U8 },
+	[NFEA_DONT_REFRESH]	= { .type = NLA_FLAG },
 };
 
 /* Add new permanent fdb entry with RTM_NEWNEIGH */
-- 
2.25.4

