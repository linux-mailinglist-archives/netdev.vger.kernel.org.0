Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8209D55431B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 09:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351639AbiFVGve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 02:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351334AbiFVGvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 02:51:32 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2045B35DC0;
        Tue, 21 Jun 2022 23:51:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s185so9530306pgs.3;
        Tue, 21 Jun 2022 23:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=niUUVRIRw4J6TsPTvzTZNTwxYV2pE3XjscebFTdFk/s=;
        b=aDzOpZs430kj0B3FbQJdRU99FdbqzgXH5ogGDVHmt2zc88EkmYFIvkfjTrb36sVHNQ
         +Fq/Sa7ZdiCLazdgbhnfpHsfZixsJrNSmBJq4cgbUS4Y/FDQOCn92kk7snSjhdyG6Mdi
         VqKYElPoFWKZG8hYa5QFUwbLsiUJMPFdhuFJBMAc9XDj9bOFm8/ceoqG71WJVdScQE1s
         H9aSK7RiP8SXerWZWl1pvtqEn+CNDRkWycE5pYUkbCLr/KxECC82/GEBl6ucNzEiqwPV
         yOwPMNm7uUVuBATNan3CGxFnaBIKsE1UX1gGi2kyNRq7mQqTEtoV9aZrmqzstB4delFg
         s6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=niUUVRIRw4J6TsPTvzTZNTwxYV2pE3XjscebFTdFk/s=;
        b=DRnod1t8SN7FadpfyK+cJC9f3wjd1j+SCdX6bwNSQhA7DC9+561KSLFMBv29WnRjWB
         n2QSgXvSHzlVO7GBEd0/B/SFsvV2pdRhFJ43nBVBqh5KAsLXL0T8Nat/l5stcxxTLip2
         4Ayu2TjsATOdj4MakvtXT8Mmdg0lj2vVXmVTupsjYs6l66D4hKxadqQqAmhNp7t2nmHM
         7wTxsBrXpczHYgb7KY/IiD5qocBKdFlb9EKa6sh++jo5TUR/aiQ4JEJTK6+gntpaT2CS
         KbITeXb9AL76ODPiqHOT0d32JcApSfjMgyfC7M2ykmDIWF3a6MM27cv1OQWhupxR6zkF
         2mHA==
X-Gm-Message-State: AJIora9Y/ZSt1a0ZtxPBiirY5jchPWYI1IxEt81VixWKmrUbCLrsmLoE
        2HaDKV0nuf/Fn36cskXGi2k=
X-Google-Smtp-Source: AGRyM1ucRbo0zkixEc3lxNBaFFOCSRntJD+QdEDuVi0zQvwm8xxuW+tLf4pkaPcZSNa1NKFz8Rz9GQ==
X-Received: by 2002:a63:35c4:0:b0:40c:99f6:8889 with SMTP id c187-20020a6335c4000000b0040c99f68889mr1684738pga.387.1655880690601;
        Tue, 21 Jun 2022 23:51:30 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id bx5-20020a17090af48500b001e0899052f1sm13585858pjb.3.2022.06.21.23.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 23:51:30 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     krzysztof.kozlowski@linaro.org, sameo@linux.intel.com,
        christophe.ricard@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] nfc: st21nfca: fix possible double free in st21nfca_im_recv_dep_res_cb()
Date:   Wed, 22 Jun 2022 14:51:17 +0800
Message-Id: <20220622065117.23210-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfc_tm_data_received will free skb internally when it fails. There is no
need to free skb in st21nfca_im_recv_dep_res_cb again.

Fix this by setting skb to NULL when nfc_tm_data_received fails.

Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/nfc/st21nfca/dep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index 1ec651e31064..07ac5688011c 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -594,7 +594,8 @@ static void st21nfca_im_recv_dep_res_cb(void *context, struct sk_buff *skb,
 			    ST21NFCA_NFC_DEP_PFB_PNI(dep_res->pfb + 1);
 			size++;
 			skb_pull(skb, size);
-			nfc_tm_data_received(info->hdev->ndev, skb);
+			if (nfc_tm_data_received(info->hdev->ndev, skb))
+				skb = NULL;
 			break;
 		case ST21NFCA_NFC_DEP_PFB_SUPERVISOR_PDU:
 			pr_err("Received a SUPERVISOR PDU\n");
-- 
2.25.1

