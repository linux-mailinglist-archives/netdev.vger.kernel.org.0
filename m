Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B452B3FF1
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgKPJf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbgKPJfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:25 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C93C0613CF;
        Mon, 16 Nov 2020 01:35:25 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y16so19372056ljh.0;
        Mon, 16 Nov 2020 01:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xjKI+uXD1rIyIentr7mrBSJHdfu/MHgatUlVOaWAXlI=;
        b=cDPHv24oTHEX7YQkY8mjQ96GdRrPcLLdcQW+iC1k+iB5T5OzEUbdvWgM1BlXtDb4dn
         pcicfUlNOTdMMIMHbbc/8JLzdEY/JcZghKW9qbiM8y3murdRmvEgx76f18JM/mvHnFEK
         dEZqDy6Akif9d4N+7jXJy6FB6A8Tus5N1BUBwpa6cZiQAw0j89J+064FeuSLF45dGU6m
         oESyyAhOroxTSx3/CUSXJDf+2zl6ezS0DglUTcTu2waFS/8/1ozE+JjpJTOjtPYg3uEQ
         c3eCrQcl2rfFATqMhBdOrXL0HaKuhndXVZ90OhAK5xVwzkUBI1kz4PatN2L6lpjBrsuT
         kPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xjKI+uXD1rIyIentr7mrBSJHdfu/MHgatUlVOaWAXlI=;
        b=WwSWt/NE7rwNuKt37HidzoDz4SAOPPrCn8nwu0Qqnhkoqd6VHKwfg9tdQAKGIc8aAk
         s+/wrIoy8ElDRag4iivvGB2LE+v4beJElaJ2wZtEoxEprjlGB3V11RI3VXIBzY6EJunc
         15Bgess5yGkFpePzPYoSv+AnluJXpDnGnnbWnD9YrE7Xewc7Dofjl9+SysIz4HsYwCll
         CtGouC9wnz5ESYdZPNTKTrYA/B63M8ySjz4ihaf2o2zRNKsZnUlR2VXwtzwOYy0UKMiJ
         S408Vmi5HDX2R/79Vwa84TehvUsB7hjI32cyERkaG5/o57jlpmj0zZ/2oYcgoKGBQq7v
         HmIA==
X-Gm-Message-State: AOAM531sbc6Y/dkaUy/YuZyWQD+9nGUgGN5HFiVY+ve2v7QwVeW7DPGT
        hReoTn5MIRz+8YD2YTsODW8=
X-Google-Smtp-Source: ABdhPJxB2RvKVk0J2Cs9J1O5tFxnkHr1WM/Lod9LC5+VROtR/Hhp0o7RgpJd4PJ1RwuHVfIOm+qtdA==
X-Received: by 2002:a05:651c:1075:: with SMTP id y21mr5421055ljm.330.1605519324005;
        Mon, 16 Nov 2020 01:35:24 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:23 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH 7/8] libbpf: add API to get XSK/XDP caps
Date:   Mon, 16 Nov 2020 10:34:51 +0100
Message-Id: <20201116093452.7541-8-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Add public xsk API to read supported XDP functions of a netdev:
 - XDP driver mode (SKB, DRV),
 - XSK bind mode (COPY, ZEROCOPY).

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 tools/lib/bpf/libbpf.map |  1 +
 tools/lib/bpf/xsk.c      | 51 +++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/xsk.h      |  3 ++-
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 29ff4807b909..0867dd078a65 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -345,4 +345,5 @@ LIBBPF_0.3.0 {
 		btf__parse_split;
 		btf__new_empty_split;
 		btf__new_split;
+		xsk_socket__get_caps;
 } LIBBPF_0.2.0;
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 7951f7ea6db3..433c58fbed68 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -15,7 +15,6 @@
 #include <arpa/inet.h>
 #include <asm/barrier.h>
 #include <linux/compiler.h>
-#include <linux/ethtool.h>
 #include <linux/filter.h>
 #include <linux/if_ether.h>
 #include <linux/if_link.h>
@@ -31,6 +30,7 @@
 #include <sys/types.h>
 
 #include "bpf.h"
+#include "ethtool.h"
 #include "libbpf.h"
 #include "libbpf_internal.h"
 #include "xsk.h"
@@ -931,3 +931,52 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 		close(xsk->fd);
 	free(xsk);
 }
+
+int xsk_socket__get_caps(const char *ifname, __u32 *xdp_caps, __u16 *bind_caps)
+{
+	struct ethnl_params param;
+	int ret;
+
+	if (!xdp_caps || !bind_caps || !ifname ||
+	    (strnlen(ifname, IFNAMSIZ) >= IFNAMSIZ))
+		return -EINVAL;
+
+	param.nl_family = ETHTOOL_GENL_NAME;
+	param.xdp_zc_flags = 0;
+	param.ifname = ifname;
+	param.xdp_flags = 0;
+
+	/* First, get the netlink family id */
+	ret = libbpf_ethnl_get_ethtool_family_id(&param);
+	if (ret)
+		return ret;
+
+	/* Second, get number of features */
+	param.features = 0;
+	ret = libbpf_ethnl_get_netdev_features(&param);
+	if (ret)
+		return ret;
+
+	/* Third, get the features description */
+	ret = libbpf_ethnl_get_netdev_features(&param);
+	if (ret)
+		return ret;
+
+	*xdp_caps  = XDP_FLAGS_SKB_MODE;
+	*bind_caps = XDP_COPY;
+
+	if (param.xdp_idx == -1 || param.xdp_zc_idx == -1)
+		return 0;
+
+	/* Finally, get features flags and process it */
+	ret = libbpf_ethnl_get_active_bits(&param);
+	if (!ret) {
+		if (param.xdp_flags) {
+			*xdp_caps |= XDP_FLAGS_DRV_MODE;
+			if (param.xdp_zc_flags)
+				*bind_caps |= XDP_ZEROCOPY;
+		}
+	}
+
+	return ret;
+}
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 1069c46364ff..ae29004570b2 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -247,7 +247,8 @@ xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 /* Returns 0 for success and -EBUSY if the umem is still in use. */
 LIBBPF_API int xsk_umem__delete(struct xsk_umem *umem);
 LIBBPF_API void xsk_socket__delete(struct xsk_socket *xsk);
-
+LIBBPF_API int xsk_socket__get_caps(const char *ifname, __u32 *xdp_caps,
+				    __u16 *bind_caps);
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.20.1

