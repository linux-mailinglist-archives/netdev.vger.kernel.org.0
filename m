Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEFE6023CF
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 07:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJRFeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 01:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJRFeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 01:34:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5230F98349;
        Mon, 17 Oct 2022 22:34:01 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p14so13115522pfq.5;
        Mon, 17 Oct 2022 22:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+oImAqUi4TycUnQDZjAUtxnRF+A1Z+mDlOgFraFVAI=;
        b=L1yIl/Sue5u90YPFN5ors2MuFXNZ6H2mucAk6Ya4TgUp42FMCUh/B2RHLvDdNp/Lmw
         GicCot03vuYGlB5tm4y9o4azJNxnUJne8HNrZ4SW89IjaJ46NmmLfGSkIYnpf/C5UfGG
         4MvFZid+6jWa4pqSO/xVcIc+NvILy2jw40NBRIQZRCZU/9JsIBwggz9//JxJ+0utdadW
         1ITjFvJ0GZP6imyGSztKP9pE3cl2B6H7IRDIIkNroCmKZO6xAeWkkGmrFJ8o7pUZl4yA
         zB+nDM0VAW7UzwYQiYUQ7yCSqSbkcPwIERlram/AoqF3dneDBaefL3N48nr111VJiGl7
         E/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+oImAqUi4TycUnQDZjAUtxnRF+A1Z+mDlOgFraFVAI=;
        b=rmppm4XlCvzaFWo3lKiONIFnLeOo9rOpYP9JTC4WMJel7F5xg4Vcp/gbPR30jcpBV6
         5TEfJrZc2REysgz1ojfSeFQ/NjCjRho6R60nZQvSSqqVoszIwY6oXKn3NTcEE1sq2g5b
         xRCW/peqPpyf/jjVDOR+5XBiZo5jmZNPtQ7m1wkxG671HMkcgj1rYV/NeThFb0poMEO2
         hYNzDmf+v6N6/Dez/gjQDqt+VbqQpYceAT7YbZ07VjGWz95EZ62QpM9XWKVDXqK/HHc9
         UImiP9kv52DAhJIwo6N6svHVkMCfDQEg3ipz29kTsgx6LODT3c9T0kvbMS9LC/9ROUNs
         qOhg==
X-Gm-Message-State: ACrzQf2PBzFFGDAoNHQKfwyyoLyeUst4EwrccQTh+LWMIACFjg38RMP2
        twVaa6nxQWq1fZuSPoVWdJU=
X-Google-Smtp-Source: AMsMyM6PHbGeHp26NsSHh/G1u+W4EsbhYRa8Hl5LaXbf6eTRwnXqDQ0SYYiysRXjZST9tKf2vbw3Fw==
X-Received: by 2002:a63:5b05:0:b0:460:a6a:ec38 with SMTP id p5-20020a635b05000000b004600a6aec38mr1210011pgb.485.1666071240786;
        Mon, 17 Oct 2022 22:34:00 -0700 (PDT)
Received: from localhost ([115.117.107.100])
        by smtp.gmail.com with ESMTPSA id f5-20020aa79d85000000b005637e5d7770sm8049644pfq.219.2022.10.17.22.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 22:34:00 -0700 (PDT)
From:   Manank Patel <pmanank200502@gmail.com>
To:     sgoutham@marvell.com
Cc:     gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sundeep.lkml@gmail.com,
        Manank Patel <pmanank200502@gmail.com>
Subject: [PATCH v2] ethernet: marvell: octeontx2 Fix resource not freed after malloc
Date:   Tue, 18 Oct 2022 11:03:18 +0530
Message-Id: <20221018053317.18900-1-pmanank200502@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <CALHRZupuBVAhd=fK+4E=keBTnt=GEGrWOTpN0-xBfu2Yj1+PDA@mail.gmail.com>
References: <CALHRZupuBVAhd=fK+4E=keBTnt=GEGrWOTpN0-xBfu2Yj1+PDA@mail.gmail.com>
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

fix rxsc and txsc not getting freed before going out of scope

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")

Signed-off-by: Manank Patel <pmanank200502@gmail.com>
---

Changelog
    v1->v2:
            add the same fix in cn10k_mcs_create_txsc

 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 9809f551fc2e..9ec5f38d38a8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -815,6 +815,7 @@ static struct cn10k_mcs_txsc *cn10k_mcs_create_txsc(struct otx2_nic *pfvf)
 	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_FLOWID,
 			    txsc->hw_flow_id, false);
 fail:
+	kfree(txsc);
 	return ERR_PTR(ret);
 }
 
@@ -870,6 +871,7 @@ static struct cn10k_mcs_rxsc *cn10k_mcs_create_rxsc(struct otx2_nic *pfvf)
 	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_FLOWID,
 			    rxsc->hw_flow_id, false);
 fail:
+	kfree(rxsc);
 	return ERR_PTR(ret);
 }
 
-- 
2.38.0

