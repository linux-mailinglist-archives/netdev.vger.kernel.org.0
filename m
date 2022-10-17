Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FE5601732
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiJQTSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJQTSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:18:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2766F54E;
        Mon, 17 Oct 2022 12:18:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l1-20020a17090a72c100b0020a6949a66aso11885943pjk.1;
        Mon, 17 Oct 2022 12:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U4Nk30ocrTukmioveUlnotlj+PapV0iR+FJEhpHiAp0=;
        b=m4Hxgw0EsBEydaoNTLAp3+U5g8haDMBA2kQ7yoIV99yfRUfqqAvXBBmRCEacCSulSz
         tpRIxa3v61fN2j00tFYbrNQlG1Q/yF+AUKRNlOTRN3yWthcp6w8to4PLAAKSQQf6z6Q+
         WAM/PuP3jaEOcDB8weTVphcOJUz66b/+wkpUFKG+3Mr5tixrjZsSKm88S3X7TqOEvcae
         pfOF5x7er8E/chPHlv73fBDgz6AaGRqzGfxqj0zMJ74TetIFga1Ft12D0J39xEnjCXYb
         LRV89WdxQBQp3RB3IUiNVh8BoO3uWQEHQ754ZnNLJ68CLXh6wfqX/hcNnhhLNSimJn2d
         8Fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U4Nk30ocrTukmioveUlnotlj+PapV0iR+FJEhpHiAp0=;
        b=at4+os9w7gesuHxBRtKcv7lYTsLf79wBErM/xdMFl6+rjecXUvKhzQw7/7BpurbPZh
         Dpz/f1KdesqhhTU54S4YFS6zn/zWp30wjKca96MsLaHIW5AC1RycuuB+d07i0SZzeovj
         YIKNYBQ175pDkOwpp+tdbzzkIi+60pQNNguYr1P5K0Om6QeEn7Dvyg8PhVx6UBXnBqup
         g5VE8yqe0KOGACSDGSOJf/zSWIBAV7JjIi9G2e5DjMGjYBHui1qxgY3fxic4ruXarB3d
         X//cXGUatWEiJHnTat4SZTKkCNGWlvk07ysOV9ClAemkWQ9J2xk0D66hKMX5HtXkkkcB
         n90g==
X-Gm-Message-State: ACrzQf395RpbE2cORQMscryQB0hfIJ5SrFbPUNgbrgkkqNh0Khyoidqi
        wZ2MC3P6zLgX1ySDn9LpTXI=
X-Google-Smtp-Source: AMsMyM4Lps+cZQm/kHGrgJQFOEbfOrnNJi5HRvWLq2W6P1Yndg48fAfT8RemXaESF1dctKNQf7ZaXw==
X-Received: by 2002:a17:903:22c1:b0:184:983f:11b2 with SMTP id y1-20020a17090322c100b00184983f11b2mr13764303plg.40.1666034294242;
        Mon, 17 Oct 2022 12:18:14 -0700 (PDT)
Received: from localhost ([115.117.107.100])
        by smtp.gmail.com with ESMTPSA id x123-20020a626381000000b005613220346asm7416351pfb.205.2022.10.17.12.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:18:13 -0700 (PDT)
From:   Manank Patel <pmanank200502@gmail.com>
To:     sgoutham@marvell.com
Cc:     gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manank Patel <pmanank200502@gmail.com>
Subject: [PATCH] ethernet: marvell: octeontx2 Fix resource not freed after malloc
Date:   Tue, 18 Oct 2022 00:47:44 +0530
Message-Id: <20221017191743.75177-1-pmanank200502@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix rxsc not getting freed before going out of scope

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")

Signed-off-by: Manank Patel <pmanank200502@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 9809f551fc2e..c7b2ebb2c75b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -870,6 +870,7 @@ static struct cn10k_mcs_rxsc *cn10k_mcs_create_rxsc(struct otx2_nic *pfvf)
 	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_FLOWID,
 			    rxsc->hw_flow_id, false);
 fail:
+	kfree(rxsc);
 	return ERR_PTR(ret);
 }
 
-- 
2.38.0

