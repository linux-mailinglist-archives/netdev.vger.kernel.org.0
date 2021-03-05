Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1EA32EDA9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 16:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCEPFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 10:05:02 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:45440 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhCEPE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 10:04:57 -0500
Received: by mail-lf1-f42.google.com with SMTP id k9so4084869lfo.12;
        Fri, 05 Mar 2021 07:04:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FxXT3yR6v7qc7jItpADfb+0ke++RwOmzj7MngvZr5H0=;
        b=Wa3cT24mzVV/z1aC9S8Lmgg1h8Cnw1lDhtHGoNYGrmFEkTIysg1zLKPD90Un74Y1Nx
         MYJpyIjrhKhACy6jSDBM7eyPmB5TbOxOmxgAJV9qJPthT3eo80C4B6mtLuR1gn5ohdSz
         9ZIoyTltQOxGTV8Wp/+zp+wggoSgIoO1aBUpvjk12Sm/flQZahya9LMvmzdhW6gjng9j
         l2NtqyGsvxgX9G2Qy0NZiaYFBuQXZWkftWFAdLNvKNLDemm7HEHxqD2QPV70qbfSvQvu
         k7qCF8+Ih7NvbkinNuca+goe71MxS5WigfJA87rRLs2AMMlAJ8rx1XCBQnuvSDvGRK73
         YTpw==
X-Gm-Message-State: AOAM532YMBtSjmZJYY6oeU86qmksWJg7mVURD44Cjs8yLaGhSb+oH9VH
        tlDvsJ1DiEJjW4OE3Gy7GbU=
X-Google-Smtp-Source: ABdhPJxRyfHpDbCj9qZT15SJ39uV3oF8q5NUtgIH64IzW3fW+0ck5pg1xjdiX43XIaQLNW1ttGLwIw==
X-Received: by 2002:a05:6512:b18:: with SMTP id w24mr5707094lfu.212.1614956695685;
        Fri, 05 Mar 2021 07:04:55 -0800 (PST)
Received: from localhost.. (broadband-188-32-236-56.ip.moscow.rt.ru. [188.32.236.56])
        by smtp.googlemail.com with ESMTPSA id q26sm351475ljg.90.2021.03.05.07.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:04:55 -0800 (PST)
From:   Denis Efremov <efremov@linux.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Denis Efremov <efremov@linux.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Fri,  5 Mar 2021 20:02:12 +0300
Message-Id: <20210305170212.146135-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXMAC_BC_FRM_CNT_COUNT added to mp->rx_bcasts twice in a row
in niu_xmac_interrupt(). Remove the second addition.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
I don't know the code of the dirver, but this looks like a real bug.
Otherwise, it's more readable as:
   mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT * 2;

 drivers/net/ethernet/sun/niu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 68695d4afacd..707ccdd03b19 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3931,8 +3931,6 @@ static void niu_xmac_interrupt(struct niu *np)
 		mp->rx_mcasts += RXMAC_MC_FRM_CNT_COUNT;
 	if (val & XRXMAC_STATUS_RXBCAST_CNT_EXP)
 		mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT;
-	if (val & XRXMAC_STATUS_RXBCAST_CNT_EXP)
-		mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST1_CNT_EXP)
 		mp->rx_hist_cnt1 += RXMAC_HIST_CNT1_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST2_CNT_EXP)
-- 
2.26.2

