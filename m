Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EED1E5D12
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbgE1KVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 06:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387824AbgE1KUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 06:20:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A14CC05BD1E;
        Thu, 28 May 2020 03:20:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fs4so2981649pjb.5;
        Thu, 28 May 2020 03:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=um3Qhq7FPm3pIrTiMtJYWGUD76JNI3D8F0QN7947rKw=;
        b=HERijm1Aj9kxFWBlKgf+0qEZIKlAMQq8MMmgBPSVHTKA5EA3DkgyN9Wz5B/lxkx0nn
         fyFb9B3kJ2P2jB2NVgGsHky7T7FykGT0FmRgcgm1at4sEopmk3Y8c+HcC3abaY1+aU/R
         LPFfsDzvrUIC8GD3xZ6+wLQn4NBuBzc0zwIwFtHThW3CAl910oGrth8AfX7MnwW+D40B
         1t41FZGGwb3pwnOzx8p0f3wqtAAsa7cLHb5mo5OTx5V0+PgR92TdHXxGCEpZVVOYGQ8G
         1fGu6JKrxZvHuTpxM3I8zdi8lC533YMwu6lhflGCR34yuzHly3sViS9NLzeERmAYlSiO
         SeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=um3Qhq7FPm3pIrTiMtJYWGUD76JNI3D8F0QN7947rKw=;
        b=kVw8jc+USux0pYqj9lrz0tW1OQzdHd9vMaQbcyMrW8VoFGBrTh9fCTnFhKL3EICNCP
         X/hgiP9DGOnXsi5yuj08ZXMhP76e2N/+hRDNN1574VpGdA753q6azLx54J2/Boy3EEsz
         Cb+0DT3YWFnmlk67CkmEQEppPg8bwsD/MOGXcGN86lPmYGIXLw/rMfJW3Y2jUaH2PS9b
         6JpexoMeQH8hdsZXneVakGwK+8bmB0FYOn+uL8sm9Uu+z3PxXrZTjys8t35gs2fijMh0
         VnQQ1BYXuzje/tum6lIJvJ0iBt2kcQYO8RiTV07iGxV4g0rBGvrD194MuObtw+9b22hJ
         bvJg==
X-Gm-Message-State: AOAM533StG8MTtdmjdvJQNHQy82NwO+mViaOYXs3FBUyg5yX7neqkq2K
        UL1p54LtOnehZWMORLmFpwg=
X-Google-Smtp-Source: ABdhPJxBlgwmLNKVsM03ksShfQegKt9EPrGs8huX9dt0ljfQMQ9uXBkCriVD+nbKxtbvHEz3TcuaeQ==
X-Received: by 2002:a17:90a:dc10:: with SMTP id i16mr2989191pjv.137.1590661247707;
        Thu, 28 May 2020 03:20:47 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id x6sm4430039pfn.90.2020.05.28.03.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 03:20:47 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] NFC: st21nfca: add missed kfree_skb() in an error path
Date:   Thu, 28 May 2020 18:20:37 +0800
Message-Id: <20200528102037.911766-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

st21nfca_tm_send_atr_res() misses to call kfree_skb() in an error path.
Add the missed function call to fix it.

Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/nfc/st21nfca/dep.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index a1d69f9b2d4a..0b9ca6d20ffa 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -173,8 +173,10 @@ static int st21nfca_tm_send_atr_res(struct nfc_hci_dev *hdev,
 		memcpy(atr_res->gbi, atr_req->gbi, gb_len);
 		r = nfc_set_remote_general_bytes(hdev->ndev, atr_res->gbi,
 						  gb_len);
-		if (r < 0)
+		if (r < 0) {
+			kfree_skb(skb);
 			return r;
+		}
 	}
 
 	info->dep_info.curr_nfc_dep_pni = 0;
-- 
2.26.2

