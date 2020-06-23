Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6432061AD
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403969AbgFWUrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392277AbgFWUrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:47:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D7C0613ED
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:41 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g21so155423wmg.0
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kDvcE8bgVLnQmVLk1Xzq+JHO7t/A7+JPYOpEZQ7t0NQ=;
        b=WJ7ugitIgMYh9Ww55r4ot8/2Nm8x2Kyn1/BxY+UkEcHeXa9LlBXrjycJ/rp+twNWd9
         5D+0TPnNsCc5dojT+du6DUvapnbpyj2HQvmjM/ToERVKR+edYUnvr8+u0WneWvZAq0Zt
         qixCGtvJzNYDMKs8uclC0wcv2hfS2TDUxVW9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kDvcE8bgVLnQmVLk1Xzq+JHO7t/A7+JPYOpEZQ7t0NQ=;
        b=nt+fNycbTaDiEp62tI13MAGqspeZ2QRFu+1l7gElJEHtirmVqPuursihsNC62GbEaZ
         BwLWllerHbcflcSyaHFzREP73ptAPnbODm/5LjHdBWNgPeh2P4fVTvFHc/KygzED8D93
         Yk/xuDC7Ab8v+fK9pHYi1DKKuakLZ5QOANb1pPSqN1JjuX3GkyQxfXLudwzUIRqD0xnS
         P6o4Gp30n9An60J4NeW9QyTDWopWjBSKRkODHXdcgNow/cWntfqY4hI8Lbk5lZo98dGS
         AXzK6OaUpXQVkh9RxLv0Eyw1QtcchMdoUX2/FfFNd72M4QS/QXGMqIGYYNWaCZfoi+Cz
         nSWw==
X-Gm-Message-State: AOAM530RG+gT98433cOQudUPedtmziKzuNEd2lUZIY+6k29/VgwWGbF6
        5vXtSaAEcz/vz+1k80hRD0hFMhwrsgDyPA==
X-Google-Smtp-Source: ABdhPJxRBapKolkz51XsYCkXmzq0IWz+vAgelSl91Nq69sAf3U/bC5e9BkKvdrKf0Gr7PSJdczYk6w==
X-Received: by 2002:a1c:2901:: with SMTP id p1mr26965088wmp.144.1592945259707;
        Tue, 23 Jun 2020 13:47:39 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id j6sm5686924wmb.3.2020.06.23.13.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 13:47:39 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, anuradhak@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/4] net: neighbor: add fdb extended attribute
Date:   Tue, 23 Jun 2020 23:47:16 +0300
Message-Id: <20200623204718.1057508-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
References: <20200623204718.1057508-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an attribute to NDA which will contain all future fdb-specific
attributes in order to avoid polluting the NDA namespace with e.g.
bridge or vxlan specific attributes. The attribute is called
NDA_FDB_EXT_ATTRS and the structure would look like:
 [NDA_FDB_EXT_ATTRS] = {
    [NFEA_xxx]
 }

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/uapi/linux/neighbour.h | 12 ++++++++++++
 net/core/neighbour.c           |  1 +
 2 files changed, 13 insertions(+)

diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index eefcda8ca44e..540ff48402a1 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -30,6 +30,7 @@ enum {
 	NDA_SRC_VNI,
 	NDA_PROTOCOL,  /* Originator of entry */
 	NDA_NH_ID,
+	NDA_FDB_EXT_ATTRS,
 	__NDA_MAX
 };
 
@@ -172,4 +173,15 @@ enum {
 };
 #define NDTA_MAX (__NDTA_MAX - 1)
 
+/* embedded into NDA_FDB_EXT_ATTRS:
+ * [NDA_FDB_EXT_ATTRS] = {
+ *     ...
+ * }
+ */
+enum {
+	NFEA_UNSPEC,
+	__NFEA_MAX
+};
+#define NFEA_MAX (__NFEA_MAX - 1)
+
 #endif
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ef6b5a8f629c..8e39e28b0a8d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1783,6 +1783,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
 	[NDA_MASTER]		= { .type = NLA_U32 },
 	[NDA_PROTOCOL]		= { .type = NLA_U8 },
 	[NDA_NH_ID]		= { .type = NLA_U32 },
+	[NDA_FDB_EXT_ATTRS]	= { .type = NLA_NESTED },
 };
 
 static int neigh_delete(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.25.4

