Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4122B3FE9
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgKPJfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKPJfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:18 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD03CC0613CF;
        Mon, 16 Nov 2020 01:35:17 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id j205so24205450lfj.6;
        Mon, 16 Nov 2020 01:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0DzanoXf+Rurog+Hlx/WrxuOA7D1b5nHXR/Q/et4xVw=;
        b=KcQ7lnr8ME1nWv3TXTyZasG6grf5LR8dXvDvvzOYiTKpVKG3mrqLOpACgb43kUJUX9
         0gKatk6sjy2mFQ83pHil7qZqgC5JbIwhwoaaJcNjHFkH4k42ya+84Z21vap3um0iQkzn
         BBgTX6l4LgjInzb7OS5eL8kAi1g2KACnnAsr/0TIcUNAtBQO8/dxInGsbhHygfPISj+c
         oze/b+H0YKcvVPWW16wizVlpsvrcQz4orb2Xnrj3bXsjLKGUxYE9unLHvu6EA/mCoVVt
         nbRLbHP0hn9Ca8MB3BXa9lXM/9p760WgDYXc1YwxsoGa+cfsh27va5oYnWCe5UZAI6fw
         EZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0DzanoXf+Rurog+Hlx/WrxuOA7D1b5nHXR/Q/et4xVw=;
        b=WOMBVO3BGREiLxLjQpkFatkkaddfaDxaBWS6AozhC/0xu7kxKohh8up23dY5fLnnaW
         M44q2SlTrig9rR4DHWRzODdekWe8BJuhtV3f7oFpS5z80HE2P/KDrBaKGuBfYLe0B16P
         pKkSCYoz+aMY0cwcQpTIYwoz1jeUijxV7wtUCH+mqtyUZnLlmCD3f0GvAayCD5vwjUKx
         3l2E6eURDphZjDgzPeMNxglvOADRpypmgPkguspDDYLkjMLeyRz7OSkNDqjtEq48dh//
         N798SgrDvp2VeEmRjKJerIa/d+A7IVyWkRsMp05F8311Kl9eMoJqzKvveb6u/W99PX1U
         5TFw==
X-Gm-Message-State: AOAM531ekHPZM+U5mXetO3p0N7LpxyeoQitWnUtYmvKVJuiVi4M0j5E8
        ujuXD1g83SWZne7IIewwbOE=
X-Google-Smtp-Source: ABdhPJxcf9hMdxH0lal4xExvGUX1Up5lEvIVx/4IX/TSAYxNtm9a0J8u2sdH+8sImF2RxnBq/l9zug==
X-Received: by 2002:a19:4a41:: with SMTP id x62mr4928267lfa.398.1605519316379;
        Mon, 16 Nov 2020 01:35:16 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:15 -0800 (PST)
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
Subject: [PATCH 3/8] xsk: add usage of xdp netdev_features flags
Date:   Mon, 16 Nov 2020 10:34:47 +0100
Message-Id: <20201116093452.7541-4-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Change necessary condition check for XSK from ndo functions to
netdev_features flags.

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 net/xdp/xsk_buff_pool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8a3bf4e1318e..76922696ad3c 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -159,8 +159,8 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 		/* For copy-mode, we are done. */
 		return 0;
 
-	if (!netdev->netdev_ops->ndo_bpf ||
-	    !netdev->netdev_ops->ndo_xsk_wakeup) {
+	if (!(NETIF_F_XDP & netdev->features &&
+	      NETIF_F_AF_XDP_ZC & netdev->features)) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_pool;
 	}
-- 
2.20.1

