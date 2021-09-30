Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55D241D8F5
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350582AbhI3LlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350553AbhI3LlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AB1C06176F
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:30 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v18so20650028edc.11
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SgkYHibwTe58Khm5JgG7/EGU8NHLAlFwGU/k53gw75U=;
        b=HUFSow4i9QZcwPiHcL4rNDHv+JHqAmg1gzIylgwqU4vv2uAODtObHhTOQRnkfAadbC
         ARSb9rKkBM5NvKx7f6rf4IM9guiu+KgaONXt9SdXMQHAPEflFAoWa2iNvIZo62UNWdIQ
         tny+flu9k15SclQW7ODWG3p87lZF/kWNKBKaxynO6iy1sSNE3bYLWM1y+kujoxGcGJ+x
         K6rc/bVQugJNeYGCsIGqZGQUpmtUA+QTD94wSPCAGvMCohmXpYaPU0eRuQj+KWQKXfMR
         cKxxRjdF/YjOyNvTkrye3i8s+oP+0ZeoKTDCNrop51rTo/ifwmaeD8mpqV1IlKkG9TZ3
         +JFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SgkYHibwTe58Khm5JgG7/EGU8NHLAlFwGU/k53gw75U=;
        b=V/PXSPUoVU9mzjnVApxWG68UyBsZaNOxtDyoEPkySqHErMg8WeM0p5RpSZWLU6NbM1
         vHxIymD5i+NUQu+XY6zucyFnpCtfbH7OYJP59wv+Bp0xEDUhXpRruQs56JobojzHMhQZ
         oUvgzLXULg3FiaiNEAwl8WfCaNpdytfW5bsaEgwBAtMgy8lGrWDDnmxARGj55t6Tpi5K
         TtDAMccAMyxWPxRIZI8VrYj6S+A7ZEVjZ8f2e9QiHlRe8sgiZeM8uUymuKklcXWPrgqL
         I049eaSXUE2C9hN+MFzJye1wW/gII3xEyQKzw0UvOv0cltGaSMmNUl4KK+V6/rgN2e1A
         N25A==
X-Gm-Message-State: AOAM5335VOgHRLK6FiN4N2ckWLfcaVA2EG2kNY+S4Gi6Idds9coWuRxH
        uRMa7QgnATsBDzrM7puLJlGZuba4XzV1KCug
X-Google-Smtp-Source: ABdhPJz+ccfx01qIcvHnFD4TeH4EtMPThEMuGXnqzwiImaFaRTLI+02L3DVpAHCFmkVAq2rVQ8dVLg==
X-Received: by 2002:a05:6402:19ad:: with SMTP id o13mr6624888edz.109.1633001968389;
        Thu, 30 Sep 2021 04:39:28 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 05/12] ip: nexthop: add nh entry structure
Date:   Thu, 30 Sep 2021 14:38:37 +0300
Message-Id: <20210930113844.1829373-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a structure which describes a nexthop, it will be later used to
parse, print and cache nexthops.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/nh_common.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/ip/nh_common.h b/ip/nh_common.h
index f747244cbcd0..d9730f45c6fb 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -9,4 +9,35 @@ struct nha_res_grp {
 	__u64			unbalanced_time;
 };
 
+struct nh_entry {
+	__u32			nh_id;
+	__u32			nh_oif;
+	__u32			nh_flags;
+	__u16			nh_grp_type;
+	__u8			nh_family;
+	__u8			nh_scope;
+	__u8			nh_protocol;
+
+	bool			nh_blackhole;
+	bool			nh_fdb;
+
+	int			nh_gateway_len;
+	union {
+		__be32		ipv4;
+		struct in6_addr	ipv6;
+	}			nh_gateway;
+
+	struct rtattr		*nh_encap;
+	union {
+		struct rtattr   rta;
+		__u8		_buf[RTA_LENGTH(sizeof(__u16))];
+	}			nh_encap_type;
+
+	bool			nh_has_res_grp;
+	struct nha_res_grp	nh_res_grp;
+
+	int			nh_groups_cnt;
+	struct nexthop_grp	*nh_groups;
+};
+
 #endif /* __NH_COMMON_H__ */
-- 
2.31.1

