Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E50141D8FA
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350620AbhI3Lla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 07:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350526AbhI3Ll0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 07:41:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9828C061776
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:34 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so20711985edv.12
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 04:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3oPkwLF07ucODw09XipvnMRYPpppZlPu8H5ouu9mekQ=;
        b=fbKvs8whjINoqUBfIPh/BawFh9MHAZD6GYmMZL8+PGOZv4yXBWEoasphsS5VMiiFjG
         IoRNtSCkLiHWo6Gxg/II+azKA5F4H+jr0WZ0mkD01G1WJlEBvpbH8+vtm+Uu2FdcYJJC
         M5KpgjkgoXT6dkhB9DgUOLl5gpfb+eKf1+m1opEBAq7YS9plWp4vyvD7Wo1dsc3+xMbR
         LR+Ryn+ODKWLJtpsiCd0FsUY90V1tZiVud5O+SHTWS6BT5km43NwjfDh6mHgE9Hd9Nte
         WvM38F/UQCE/l1t7Xo8gtHA4bBfAoGTRm606Yv5S1PXm7SazQo0TVEv2zL3vGn71YtVE
         x8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3oPkwLF07ucODw09XipvnMRYPpppZlPu8H5ouu9mekQ=;
        b=Eoa1SB1l0igqs8byzBq7rWWAQu/odlab4fwrZ/nvXpMIZz6HXvO52f9TPXNDJ3s4Pi
         DW0db5vGK3cPIW5H/9qBlEjG604NIt8IyfRpJWrTRbdgqDc/7hignVpvS/H3OwmjDnIB
         Zl4pmloc/r4WN/zvPtupidUSwrKn3ghVC9bFGn8SthQghNHOCZWHnBFrUVzdzoYGmbdS
         tfcd3HHdj1rWtPxzDdcdeIZTyrrH6HhoUIMxEYZsNEVlN9nUpf4njJiA0yxOg4NyCW8v
         BsxSfy3thc0JhePxegApvPnamWM30FTKnGP5kVUe31VKuGSzy3Z5X/hPrJ3uIA3MvYNE
         2ByQ==
X-Gm-Message-State: AOAM532kiSCIkDkhn2ZYcgbqutIVkMEWoakTNL8WZNEW979EHw96MSo7
        x3c9ibOaLMKCuQ+1wa0/vW6+3P7K9BFbF0fL
X-Google-Smtp-Source: ABdhPJy2mErOZde4ivAYTtUaMMZ+2HaFajWz1IHObjAG0fb1TREHyqWbsTxax+yrp05ueIYSO/polA==
X-Received: by 2002:a17:906:8510:: with SMTP id i16mr6242087ejx.442.1633001972917;
        Thu, 30 Sep 2021 04:39:32 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b27sm1277704ejq.34.2021.09.30.04.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 04:39:32 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 10/12] ip: nexthop: add a helper which retrieves and prints cached nh entry
Date:   Thu, 30 Sep 2021 14:38:42 +0300
Message-Id: <20210930113844.1829373-11-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930113844.1829373-1-razor@blackwall.org>
References: <20210930113844.1829373-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a helper which looks for a nexthop in the cache and if not found
reads the entry from the kernel and caches it. Finally the entry is
printed.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 16 ++++++++++++++++
 ip/nh_common.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index e0f0f78460c9..31462c57d299 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -602,6 +602,22 @@ static void ipnh_cache_del(struct nh_entry *nhe)
 	free(nhe);
 }
 
+void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
+			    __u32 nh_id)
+{
+	struct nh_entry *nhe = ipnh_cache_get(nh_id);
+
+	if (!nhe) {
+		nhe = ipnh_cache_add(nh_id);
+		if (!nhe)
+			return;
+	}
+
+	if (fp_prefix)
+		print_string(PRINT_FP, NULL, "%s", fp_prefix);
+	__print_nexthop_entry(fp, jsobj, nhe, false);
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
diff --git a/ip/nh_common.h b/ip/nh_common.h
index ee84d968d8dd..b448f1b5530b 100644
--- a/ip/nh_common.h
+++ b/ip/nh_common.h
@@ -46,4 +46,7 @@ struct nh_entry {
 	struct nexthop_grp	*nh_groups;
 };
 
+void print_cache_nexthop_id(FILE *fp, const char *fp_prefix, const char *jsobj,
+			    __u32 nh_id);
+
 #endif /* __NH_COMMON_H__ */
-- 
2.31.1

