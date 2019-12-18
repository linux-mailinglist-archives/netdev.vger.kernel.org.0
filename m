Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A348F124526
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfLRKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:39 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35187 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRKyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:38 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so1011962pfo.2;
        Wed, 18 Dec 2019 02:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ffll5z/HdKuY2j0qz/oK6leLDyBgLuz3FCqAnXD0Cd8=;
        b=BXKUQmdRSUI41KXNfEcH/+xohlUI4YPrqpTuRJiuDUfohbKlG2Oz7WguEXVW6E8vD2
         K7ExI6jhLOzkMCgVt40F43fAtk9le1YFkjRZ19rNcsdg/ZA0EsGXLCTzoA+GLokHj0Ef
         NEgFK2iyqLO08IplMz+KenYaD7kT6EecoPQy1XHhZkFSei+KskEcKKYahfAC7bLZ6Znv
         SZg9EPOSEYtMNANFHuL7YA39ubDvodtYapNSYHF6D2TCvFEvvLJSRJXITVWu72qWPT/u
         SROzM3htvN9QLZbh+aVbOXzXN8OhPQkiBpysidPgZ5TSqF6D/4r7hxTMJZF91KDRw+KB
         HM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ffll5z/HdKuY2j0qz/oK6leLDyBgLuz3FCqAnXD0Cd8=;
        b=i+LVGyc9UJZBf1Cqy22Ifylr8vh9R2GHre+gNhY+EHdeB5IiqbWfgybp78vpKJb+gi
         pjhV91+XeOkosxJD2CIJFDV4IJ2wvEFTLo+WNi8WyK91M+Lgmt4i57M1FLfHIou0B8re
         W1bAyXsmNBqtfdTUNmG4LTn73BHYqGyoOCaFb/5qyGiVmoDa4+sdts+mE2ZejNEpzADS
         1qD6OBE1+gcmSUWGmtj+ws/EE2wSQ0TUKwUMhpZu9FFnI8tM/Aa+i9cO2cxwGojVr3nG
         xf5hPk2+rhSTcEX9NeMEdGlX5ZolNltmRhIW84+Iu5yhKDUiexdjgPl0Tv+t3UlB0KD8
         OpDA==
X-Gm-Message-State: APjAAAUyDC49kja6NtV6YmXUTWLv/P9JPGSs7nRgLG7pm/+7zVEsfZAo
        4HpgmiudVLU5euAz1lgcsXZV1Z5r1ZxcQw==
X-Google-Smtp-Source: APXvYqzoZLkyHqkShChLJuv1/HsXqPHUyFmP9qkVBoW0kbbUv0hTVTxNPPPERYtMVxdYqV2qg8CFUA==
X-Received: by 2002:a63:6c82:: with SMTP id h124mr2316444pgc.328.1576666478031;
        Wed, 18 Dec 2019 02:54:38 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:37 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 7/8] xdp: remove map_to_flush and map swap detection
Date:   Wed, 18 Dec 2019 11:53:59 +0100
Message-Id: <20191218105400.2895-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218105400.2895-1-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Now that all XDP maps that can be used with bpf_redirect_map() tracks
entries to be flushed in a global fashion, there is not need to track
that the map has changed and flush from xdp_do_generic_map()
anymore. All entries will be flushed in xdp_do_flush_map().

This means that the map_to_flush can be removed, and the corresponding
checks. Moving the flush logic to one place, xdp_do_flush_map(), give
a bulking behavior and performance boost.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/filter.h |  1 -
 net/core/filter.c      | 27 +++------------------------
 2 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 37ac7025031d..69d6706fc889 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -592,7 +592,6 @@ struct bpf_redirect_info {
 	u32 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
-	struct bpf_map *map_to_flush;
 	u32 kern_flags;
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index c706325b3e66..d9caa3e57ea1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3547,26 +3547,9 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 
 void xdp_do_flush_map(void)
 {
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
-	struct bpf_map *map = ri->map_to_flush;
-
-	ri->map_to_flush = NULL;
-	if (map) {
-		switch (map->map_type) {
-		case BPF_MAP_TYPE_DEVMAP:
-		case BPF_MAP_TYPE_DEVMAP_HASH:
-			__dev_map_flush();
-			break;
-		case BPF_MAP_TYPE_CPUMAP:
-			__cpu_map_flush();
-			break;
-		case BPF_MAP_TYPE_XSKMAP:
-			__xsk_map_flush();
-			break;
-		default:
-			break;
-		}
-	}
+	__dev_map_flush();
+	__cpu_map_flush();
+	__xsk_map_flush();
 }
 EXPORT_SYMBOL_GPL(xdp_do_flush_map);
 
@@ -3615,14 +3598,10 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
 	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
-	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
-		xdp_do_flush_map();
-
 	err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
 	if (unlikely(err))
 		goto err;
 
-	ri->map_to_flush = map;
 	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
 	return 0;
 err:
-- 
2.20.1

