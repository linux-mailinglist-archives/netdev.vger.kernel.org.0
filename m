Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3A4411B58
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343975AbhITQ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:57:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244828AbhITQzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:55:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632156850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zzlABCzc1z/h8/5FAcURoAK3fN+JbZCA63Q184+5bRE=;
        b=DYXQvRvjdaqBGMtGnB22fWfyHLkmAcaW2ZoiyBs4Lir9dddKBzWmxmGHfcG4v7RJXf3ZZr
        J+MIieXT6RkqOeJiinxKRIHvMrDayH8ql6PNI4qS1YTapX4r5HqaFVhKVRLk9mAc3YsrfM
        mzVkePhcMkb8O/L/gyvku6dYncIyEXQ=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-QPIC6NfqOJaAR6-0kohATA-1; Mon, 20 Sep 2021 12:54:08 -0400
X-MC-Unique: QPIC6NfqOJaAR6-0kohATA-1
Received: by mail-oi1-f199.google.com with SMTP id l6-20020a056808020600b00273c0972441so1147801oie.14
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 09:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zzlABCzc1z/h8/5FAcURoAK3fN+JbZCA63Q184+5bRE=;
        b=VL3o8Ke51hiLZ8f4Fd+X64k5Nsyx4pr45GHoak4f797JKQf6MbkiJ5sVmc5O97Dq8Y
         Fcx03J9T1seTsewFbtBqwAseaWLoLJLILU9RaSwIV+X6KUuz7Dr4ktYX9Z9gzjsbtXqU
         Xax1Zc+GlhWXghIUWODPz1uLbO994jmgGEFWcnzzjBUMGM6o7LAD8WQIZY7LPP2/xEfZ
         ARaXO4uev1BDHkppiYicxW7d3j/3LAYBJTJKZGYHyDuyTu9mkWnl1XOOIT0OM9CIZCiI
         T2Yi9AGUHvwo5e/tpwGttIF+Ixafqd+fjC9CVta8OF35lFLqtBlKdBBo9geHhI3nyHH2
         BkCg==
X-Gm-Message-State: AOAM532IB9NDCQ3Eozc+EyPi01DyHvG53jV//O13J3VsV3FovbI2WQSp
        8SG2PHQFwPRKpnxdOp+kkXJLbZDOVaxRRR+uC+OSXthkTnEnyehg3wT0JFbiwUZfE5zzbssKljM
        a7CAVL11cyCHtCVu6
X-Received: by 2002:a9d:730f:: with SMTP id e15mr9610549otk.260.1632156848200;
        Mon, 20 Sep 2021 09:54:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygBfy+NDy+BtEjDMWKR++vLlpw334lp+eSEKAbxnS8Kvxh8fx/uF1qqFopyFLbZUtFviSxKg==
X-Received: by 2002:a9d:730f:: with SMTP id e15mr9610531otk.260.1632156847992;
        Mon, 20 Sep 2021 09:54:07 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id r23sm3502079otu.54.2021.09.20.09.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:54:07 -0700 (PDT)
From:   trix@redhat.com
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, schalla@marvell.com, vvelumuri@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] octeontx2-af: fix uninitialized variable
Date:   Mon, 20 Sep 2021 09:53:47 -0700
Message-Id: <20210920165347.164087-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Building with clang 13 reports this error
rvu_nix.c:4600:7: error: variable 'val' is used uninitialized whenever
  'if' condition is false
                if (!is_rvu_otx2(rvu))
                    ^~~~~~~~~~~~~~~~~

So initialize val.

Fixes: 4b5a3ab17c6c ("octeontx2-af: Hardware configuration for inline IPsec")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ea3e03fa55d45c..70431db866b328 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4592,7 +4592,7 @@ static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *r
 				 int blkaddr)
 {
 	u8 cpt_idx, cpt_blkaddr;
-	u64 val;
+	u64 val = 0;
 
 	cpt_idx = (blkaddr == BLKADDR_NIX0) ? 0 : 1;
 	if (req->enable) {
-- 
2.26.3

