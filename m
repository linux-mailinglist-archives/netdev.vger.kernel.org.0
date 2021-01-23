Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E4B3014FF
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 13:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbhAWMIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 07:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbhAWMIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 07:08:17 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A08C06174A
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:37 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id j21so190761pls.7
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lLh25oDN7zLCnZK7Cfcri55AhH7wovHU7ekkGi35cG0=;
        b=gJ8cJfW45dRpeRUIM2i3j4j3Lr7ok0OtZf1ybZQfi4XZLuWvlnqleHaUpAo45zzIBu
         1ScJPTuRQBme1NBstJc6oEZCiViSJPSxSbt3FE5pThtUJU4yYxuIob3bPuuofestEcOW
         tEZ5q/pv1LBGSx9ZQim/hrkOKZHCE/Vln01rFeExdwKaf3uaBMuSKSVfz8lyWTsl+UvA
         SH1iA1YrOWKrA9ii1N5/Sf1V7GUwIW3UOTptHZk5i8fiJmjstQxnDNiVBH5Qr9Re8siX
         fNP4GWrpf1hSpby0c34bvOk1T6UdK29hBMKhDSDJfDbsP42k9q53H0zZhvrlBcpAJs6m
         I+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lLh25oDN7zLCnZK7Cfcri55AhH7wovHU7ekkGi35cG0=;
        b=gyBPd/Snhu0funqmrgobempTmBgqQm2l84DLU/2Fd7BnX7M2etNMSw2ytNvdWH//zc
         YqR3wE0D0Vte7V/4M2zxcP9CJddpXBVNsIPNZy2VK3FTnYQEttmWCxbzuOT95aF4zS/7
         pLTWBV1EtbYtFYLMTv+tmSyz02Z9nPKqjdt89IdAfnBKufsnnAfS4NrxBKs9ZlgRnZnr
         aMIEFqGys02DkFPix3kxFe8BPSNVjsacubHmv3czKXIYuu0GpJqyQSHOy/yJFSpxvjdB
         t+CbBWtaebkBDHpOqz0j7Op66fX311gqSQeKuWFO0hLM0RYZUztRHrtYtRQcbKeGz3VR
         P2EA==
X-Gm-Message-State: AOAM5336EBAsYoT++Lctp/ePNwHHKEN3TfuHZtinFTXJdNgIMIeTwaKf
        KmCrJraH++Cm7vSsC3730fk=
X-Google-Smtp-Source: ABdhPJyh/eogwAXHe84EEzB0o3ejH93w2KCJVnaJy6+TaOMQfIU94XUI80/hXamq3IKygyW6NwVGqQ==
X-Received: by 2002:a17:902:26a:b029:da:af47:77c7 with SMTP id 97-20020a170902026ab02900daaf4777c7mr9945055plc.10.1611403657192;
        Sat, 23 Jan 2021 04:07:37 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id v9sm11471079pff.102.2021.01.23.04.07.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 04:07:35 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>
Subject: [PATCH net-next 3/4] net: octeontx2: Use napi_alloc_frag_align() to avoid the memory waste
Date:   Sat, 23 Jan 2021 19:59:02 +0800
Message-Id: <20210123115903.31302-4-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210123115903.31302-1-haokexin@gmail.com>
References: <20210123115903.31302-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_alloc_frag_align() will guarantee that a correctly align
buffer address is returned. So use this function to simplify the buffer
alloc and avoid the unnecessary memory waste.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index e6869435e1f3..6fbceabae1ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -478,11 +478,10 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
 	dma_addr_t iova;
 	u8 *buf;
 
-	buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
+	buf = napi_alloc_frag_align(pool->rbsize, OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	buf = PTR_ALIGN(buf, OTX2_ALIGN);
 	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
-- 
2.29.2

