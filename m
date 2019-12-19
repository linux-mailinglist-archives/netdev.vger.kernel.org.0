Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76498125B52
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfLSGKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:53 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33995 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:53 -0500
Received: by mail-pj1-f65.google.com with SMTP id s94so2163410pjc.1;
        Wed, 18 Dec 2019 22:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=utd1Hqu7RRNBlQe9bT/Ku0KqdnYMgvtr/pTMjx58tKw=;
        b=FLvvq0k2z5q+440WameVkfcrOa8VeXMzqwSzNe1r9ndjPo8sAbPGE2E3qYARAesrdc
         W6NMRvO9hQrNEz6NiTrovrJ4Bo8+wa3xcTTkhU7KrvL56mg7XJICs+gfAqcATWw+fJTk
         ltpFCoCeuXM1uOiwJ268gbObOgumLubSKh6KILHxBsj2les82guw5adOPP7fhTMNHJtN
         z3/D+dykrXWvumNYrnQr8fnroiEJ1fVmPJqQUfmrWLM9JwVjORm8acqItT20C40Y9wNK
         o9wV4PHZd97y+GpuDYpm4hhOYh9hmyN87jGP2YP6Ys7/Ewdsu3nY2LUPNLlHzqRlIlbR
         Ifyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=utd1Hqu7RRNBlQe9bT/Ku0KqdnYMgvtr/pTMjx58tKw=;
        b=Ak4IHzqWJucqntGlXdtDV+yrYB6OXKu/9YHDEnNFMsNTbP5tHmfQyk0Lfclo6jEWyM
         ca+dFY2odFShoRcKOhwQefTYXTGW5kTMsupOyD9e+zQzyXVXtA+CBKbk3Xt9+0K0ynrB
         u1j+b2zm7WKypQ6bAhp9Fjdh2gPFTZEbW95a9mI0EtgF/VED4ofhreJ4pc/qx6f+eUbw
         N1044xijt/whu2h/PhIAHA2SPDijUKy9h/2kNNfiiysHBCG+Q6yuDRIUp57CWQ5lkTMP
         0suDgra5QKN8W7USzoIoNDf1hO4+ceq0TC5SPEGKtR9IjwCKzvZyAQfTSOfX1CEdDCiy
         zD1Q==
X-Gm-Message-State: APjAAAUlizqxdcrnc8z8NmxkmIDBbsBzBNZKlpVE4BuKyA6KuAFBfMpq
        4Bft7uCQJPyQXXGkmVo2oqKrlz4lj9P1Yw==
X-Google-Smtp-Source: APXvYqwefORJJxeEsXsY2YBiZP2QtNcGKKl53AaMiPREUyLPaX3xjtCIwm7IpWbf8scImVwHjiZTHA==
X-Received: by 2002:a17:902:b704:: with SMTP id d4mr6989162pls.54.1576735852284;
        Wed, 18 Dec 2019 22:10:52 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:51 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 8/8] xdp: simplify __bpf_tx_xdp_map()
Date:   Thu, 19 Dec 2019 07:10:06 +0100
Message-Id: <20191219061006.21980-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191219061006.21980-1-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The explicit error checking is not needed. Simply return the error
instead.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/core/filter.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d9caa3e57ea1..217af9974c86 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3510,35 +3510,16 @@ xdp_do_redirect_slow(struct net_device *dev, struct xdp_buff *xdp,
 }
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map,
-			    struct xdp_buff *xdp)
+			    struct bpf_map *map, struct xdp_buff *xdp)
 {
-	int err;
-
 	switch (map->map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
-	case BPF_MAP_TYPE_DEVMAP_HASH: {
-		struct bpf_dtab_netdev *dst = fwd;
-
-		err = dev_map_enqueue(dst, xdp, dev_rx);
-		if (unlikely(err))
-			return err;
-		break;
-	}
-	case BPF_MAP_TYPE_CPUMAP: {
-		struct bpf_cpu_map_entry *rcpu = fwd;
-
-		err = cpu_map_enqueue(rcpu, xdp, dev_rx);
-		if (unlikely(err))
-			return err;
-		break;
-	}
-	case BPF_MAP_TYPE_XSKMAP: {
-		struct xdp_sock *xs = fwd;
-
-		err = __xsk_map_redirect(xs, xdp);
-		return err;
-	}
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		return dev_map_enqueue(fwd, xdp, dev_rx);
+	case BPF_MAP_TYPE_CPUMAP:
+		return cpu_map_enqueue(fwd, xdp, dev_rx);
+	case BPF_MAP_TYPE_XSKMAP:
+		return __xsk_map_redirect(fwd, xdp);
 	default:
 		break;
 	}
-- 
2.20.1

