Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCEA25FCB3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgIGPKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730076AbgIGPCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:02:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BC4C061575;
        Mon,  7 Sep 2020 08:02:44 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so8155409pgl.2;
        Mon, 07 Sep 2020 08:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20qb1PrS9WvdGhOBMmVu4rcGaoMhXb3TvepgXEEtkl0=;
        b=fvrtt6tPyQSbFrTpjxYv8U5rDkmMgenUO5J0ggstNhE5gcolf4NmL6Er+INHZu2Yyb
         tx66dQnvotkg5JDTJpPBhcTTeDRLKlvwutS5O/lhjRSHNgCbPpkk9Yam2gkVdCmKER98
         YEnQCcMWXSsKM/cOzRh/Q2VTwJLJzXIEzXhOGOYOyLH+1rAwuoEu59ItzlPskfJRAwpd
         WRRI+/1uu7reFk38ARWVVXKfTD8zQlDosKXvvnWvl1w5R7tSnBDJWGEGQrpRScU28OV/
         SW3LxcEL9Z2Waf20MgTmcWtpa/1gh79Mq/1SL2WJ7ufy5//5vl3g29jMMnvgofyrBAci
         vj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20qb1PrS9WvdGhOBMmVu4rcGaoMhXb3TvepgXEEtkl0=;
        b=f7PHNmwARA7e+akjCgvYwSJk4A2EnhNKgifi8X7BKxfFru27hIkWB9PpCriRI1WYPh
         va7LJl7a5OUhGJZggri+rTLPDdx1p2EGEtV1JM/4b8Q3WbOH51mk9KHEbOjNT9k2v1Pr
         I7gTxdyk/6DnPSCU6YPBHZMZhcukBDG13vcRTqz512L4ed6YmOesggLmcHlcFfvlVjMM
         wZlvdKAGNDZMumhsAxXfM4oFnUJLVU2fNxILaafLtVYW5e8SvbI07phSttCfcr8csHDX
         4DqUGwAmjv25wtz5lNhBaqzKlgmJSbbp+fpwjLnVk+b7eFxZMmgYZLpbVTDepvBcZxY5
         XTSw==
X-Gm-Message-State: AOAM531Ne6ZP1bggzd3JEs1Ikh5vPB/6dJHZUw5fEVOBgqO1I8GMT9SR
        02A5oxSCHCBcDArH1ZrqNXBXgpmJ1Fi9AJ8D
X-Google-Smtp-Source: ABdhPJyxOmNl4CGI0TR1mp6x1IKkJ/CH0fUtgkmDA9Z+xMWew2DG+MBShq9F3GJYdCJpmjwbx1on0Q==
X-Received: by 2002:a63:c446:: with SMTP id m6mr3513703pgg.95.1599490963666;
        Mon, 07 Sep 2020 08:02:43 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id g129sm15436022pfb.33.2020.09.07.08.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 08:02:43 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 2/4] i40e, xsk: use XSK_NAPI_WEIGHT as NAPI poll budget
Date:   Mon,  7 Sep 2020 17:02:15 +0200
Message-Id: <20200907150217.30888-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907150217.30888-1-bjorn.topel@gmail.com>
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
zero-copy path.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2a1153d8957b..a8018736ca32 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -272,7 +272,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	bool failure = false;
 	struct sk_buff *skb;
 
-	while (likely(total_rx_packets < (unsigned int)budget)) {
+	while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {
 		union i40e_rx_desc *rx_desc;
 		struct xdp_buff **bi;
 		unsigned int size;
-- 
2.25.1

