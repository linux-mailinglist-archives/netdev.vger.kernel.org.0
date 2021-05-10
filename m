Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ED4377F8A
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhEJJkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhEJJk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3B0C061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:21 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so8487169wmh.4
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nlEE7d+pfgB+nDRoRKdy3JbmugaRLKlWWEIWRuI///o=;
        b=TNAQofFA9Bi4PTYIJIT/nmwET2L6Yim2+BU6ZFkwuz3DtqxhkiOuf/jRXydWJc64yk
         LUidxssciot8G9JiAAbQTUyxX2q4VKljxafif+qzN5zRf6zHtLgfvrlF4NLxMjPJjvry
         gZDQ+shFkScjRUFSCcbjQPguLHO4vECwEyBHCBkC82HeBKcACUms+K9oDvUa8xqA1mvY
         NEY/F89YdgYfqUCdZmUFJKEDXTcBWcbjxPMyX9LocOWXvTYBZCY0TkaxheeOBKYztHW6
         EbRC0X7x1gxL0M/PMZJ5z0Yzj0rYmAESersoBaQx9VxPfIF3cTNIZ1xdcIICGiLpZwmg
         UH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nlEE7d+pfgB+nDRoRKdy3JbmugaRLKlWWEIWRuI///o=;
        b=C7RzSAhnei8gCYh7Sw1fx0aWxCGRPnv5kGuJaxnS6axt++ASjKYXZEe48M/CO+ij/U
         /LIb99AFqvU3YDFxGdoh3TpTuFQSfScArMQKFgEZq5sYzdLcomL6500fmf7om8aBCBXW
         caujHvxG4jVHdTQKzk64UzbrIvcNqYrOLsPgXADcM0pItm9xFbiAVP+XoQ5qqS4YKg5R
         Tv9X3XRjhy3O55oPyWXaSUxzAlrHCFsNVQRJF5dNc0o9A8JZTAYGSjV0qu3qSUPAQ862
         wDkY4KuetslVNBrpGTdMH9Ggx2htiYWQZfKcp4hjnkTqilHFaG2YVyI+/6qf3vHOoAGv
         s+rA==
X-Gm-Message-State: AOAM530MNrM7xQVTy1yWIrf4bTYKGR5d3h7OS9naF7mmfyzaliUw/Uql
        v5+60Skf14id4FOGvUw17Qo=
X-Google-Smtp-Source: ABdhPJyaiLBWLE3zFTCZLPlp+ZAwUyW27M71G7rGAITLCWWKI367KfUUS++FDzxLynxREvbGP+lHQQ==
X-Received: by 2002:a05:600c:4ba3:: with SMTP id e35mr24752681wmp.47.1620639560175;
        Mon, 10 May 2021 02:39:20 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:19 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 3/6] ixgbe: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:51 +0200
Message-Id: <20210510093854.31652-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210510093854.31652-1-magnus.karlsson@gmail.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 ++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 14 ++++++++------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c5ec17d19c59..2ac5b82676f3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2213,23 +2213,23 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
+		if (unlikely(!xdpf))
+			goto out_failure;
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		if (result == IXGBE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (!err)
-			result = IXGBE_XDP_REDIR;
-		else
-			result = IXGBE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IXGBE_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 91ad5b902673..f72d2978263b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -106,9 +106,10 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
 		rcu_read_unlock();
-		return result;
+		return IXGBE_XDP_REDIR;
 	}
 
 	switch (act) {
@@ -116,16 +117,17 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		break;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf)) {
-			result = IXGBE_XDP_CONSUMED;
-			break;
-		}
+		if (unlikely(!xdpf))
+			goto out_failure;
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
+		if (result == IXGBE_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.29.0

