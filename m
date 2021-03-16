Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738F433D615
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbhCPOsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbhCPOr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:47:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDB2C06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:57 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e7so21828947edu.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RePJBW/g54muuXnPyV/NLg+5wnsE8oNrG8mbSfM4rOg=;
        b=U60RxrCup5C2RZ6uyVoPQw8MZ8Y2jK+G8+DSm4RNhwCpQBppJNAu/jVf7aLQnbXCai
         JngNkxAZ5U4qaGofV90LoO6ibAONvsojSI15DAw39zFrBR0xUoFnbfbAOhNyxG52XzZG
         QXMKG1T23BInel0pPpIiPezQLTiKiNrMHNILU0PNhvQxVn/oTfxMngeycmHLzsof3PD6
         ebfKpGmtj8GlCjVNaZ1PNJ8/x8DJiTwdHZKH/e5nXj3X8eeCEM9ptyA4cbNBR/D6gHpP
         7FKc4f6LB55YFtr4t4aRT6mpgvtBKxijSo4Jt4dw1axvSsOOGxqljL8jj6G7mfEvgINi
         FgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RePJBW/g54muuXnPyV/NLg+5wnsE8oNrG8mbSfM4rOg=;
        b=koK3HlJERkBYHS9fI+o44O4wqSEi4eljxoMovlHwl2nVQH/FSZANMExNKYKOekQ9zD
         HmaG3O2wiYBxttYuUjq8PTwtn1aGNLwzchjWjKyCidic1gGp6b65COUVpA8JOAOBbjyh
         48nbx682h19ewhnd0fKaKKMgjK+0BqpuSg04wsxctId/fXbIMpE5A7Ky22GqeGrvFDaP
         CObdIOhISIWmmtSZSDCy8Dc1zza4bH/GIbzZYtcGCALrqIE+HufC7TFHDDMOrI5/uf19
         jc3sBRh4L/ivNMRv9QWULVOsBCz5wNejtLQ7/gSaOHCJDqn4iDm4kPRuiqp2Jw6VqQWs
         iOWA==
X-Gm-Message-State: AOAM533LwZ+hg1s+8Ijobn9LapY/94KOJ5xgwNii0Pjfcy4N+4i9JsnW
        zXY/vFRW3kHKFhmwSyQDSC0=
X-Google-Smtp-Source: ABdhPJw/q82gGieGV0xD2WFLU4EPNcpcQUIAuylHbxbJ3ucgUCns1pUc/ehBJyNtp1EBdA3mguwmPQ==
X-Received: by 2002:aa7:d1d0:: with SMTP id g16mr19970077edp.358.1615906076531;
        Tue, 16 Mar 2021 07:47:56 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id de17sm9467441ejc.16.2021.03.16.07.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:47:56 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-eth: use indirect calls wrapper for FD consume
Date:   Tue, 16 Mar 2021 16:47:29 +0200
Message-Id: <20210316144730.2150767-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316144730.2150767-1-ciorneiioana@gmail.com>
References: <20210316144730.2150767-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

We can avoid an indirect call per Rx packet by wrapping the consume
function on a frame descriptor with the appropriate helper.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7702b921ab0b..4ea0bbd9e4c2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -605,7 +605,8 @@ static int dpaa2_eth_consume_frames(struct dpaa2_eth_channel *ch,
 		fd = dpaa2_dq_fd(dq);
 		fq = (struct dpaa2_eth_fq *)(uintptr_t)dpaa2_dq_fqd_ctx(dq);
 
-		fq->consume(priv, ch, fd, fq);
+		INDIRECT_CALL_3(fq->consume, dpaa2_eth_rx, dpaa2_eth_tx_conf, dpaa2_eth_rx_err,
+				priv, ch, fd, fq);
 		cleaned++;
 		retries = 0;
 	} while (!is_last);
-- 
2.30.0

