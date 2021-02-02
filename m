Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212ED30B80E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhBBGxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhBBGwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:52:53 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21068C0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:13 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a12so26422793lfb.1
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qm3Xf/zORcOQpWtLlmivgXe4uJE/D2V+lZIMUhUMIQ=;
        b=eTYgf3ZUCvptwnOPq107as0VmwBFkXhdLr9NoV1JmpSh2Z7WBe2FGDygXslBd6aK06
         pmJz7D/G0x0Al1aJvKMmUMxLFN4ioIeOi8irnAe/LzKQV0gMXracHNbnh8EvuBnDzkLp
         c/BOOTTX6mb7LKfl77w/Absx41MPvLwXrOOx+hkIq87f27PxTSP1BG/bW5YEu3yXyyN7
         25By2JGMjgJ7jO3ceYXKeuVYOJTdDPdLopQoiEwOy5S911cxTxow7Tq0xDhpriOryPtk
         9v+OcLaj3pUCD+bLlGLp3heZIsDYEyxkkTeY41vGqzCXy1pVSPbkg9ET6tZysSgZWHlz
         T9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qm3Xf/zORcOQpWtLlmivgXe4uJE/D2V+lZIMUhUMIQ=;
        b=BV6L64sB1fmVrdKRELPM20ThDkUgZ9IIIJ7MPjiV9HArCa9KW5ZLXhA0P/NO+pdHhn
         r7+S+0IOF0H7p456zUwCpsALBrYS+vXUJoBwtd2v5kBW+VQ+eudGTuEPb0PQ1x/2n8J9
         zS2VWwKnWbWNHA0bohqqldg8C1cad4mPMFRCxlRR89iZev7aZU3wtMumdiBSszO3BVU9
         H5Z/50+Z0LJaAz+zq8xnaVYlKj7cejW26cGtewgStIqXKaVbwCL4YIrp9+GV/R4bBPWe
         KJRtqIAJqs4HkeLcLYxKZqNTK5uIi2w9ZhPZ6G9/QK3esKtDSnnOFaQu3y4WZw+5SKNi
         g4Xw==
X-Gm-Message-State: AOAM531wst4k0du7Wox658Lvvi/KZMZCgabQAX1hvnikTKKByUUr3Dzg
        M8KqzgSERS9P0QY5us+W/xgtNg==
X-Google-Smtp-Source: ABdhPJz1qXIt0EKEguQsenzN+cvtoTPcKUmIOGfc0z+zIZvZjUlxNmaDCyW0CsUfPly796bFM/5iAQ==
X-Received: by 2002:a19:b01:: with SMTP id 1mr9834658lfl.643.1612248731692;
        Mon, 01 Feb 2021 22:52:11 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:11 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 4/7] gtp: really check namespaces before xmit
Date:   Tue,  2 Feb 2021 07:51:56 +0100
Message-Id: <20210202065159.227049-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Blindly assuming that packet transmission crosses namespaces results in
skb marks being lost in the single namespace case.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5682d3ba7aa5..e4e57c0552ee 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -592,7 +592,9 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 				    ip4_dst_hoplimit(&pktinfo.rt->dst),
 				    0,
 				    pktinfo.gtph_port, pktinfo.gtph_port,
-				    true, false);
+				    !net_eq(sock_net(pktinfo.pctx->sk),
+					    dev_net(dev)),
+				    false);
 		break;
 	}
 
-- 
2.27.0

