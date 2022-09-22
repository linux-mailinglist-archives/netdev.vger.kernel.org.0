Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C67E5E69ED
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiIVRvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiIVRvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:51:31 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADB1F9624;
        Thu, 22 Sep 2022 10:51:30 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id j17-20020a9d7f11000000b0065a20212349so6709162otq.12;
        Thu, 22 Sep 2022 10:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=BJ/yvKtQ5BG9zSSbeGDdjkvo6GheThwdGsGb8epOyK8=;
        b=dvl4Suxy+t9oSHiC6HvqGtcg+tcB/dneyOzvSrr/u1HoIlo44KCUSL8QqrptOAA4sV
         PC6agyuwX0s2aVsNNYhs+G8JbQw23pweckbk+MDmNxCLkBaTPD9LscmHnzUM4yLycEwZ
         ITagGst+qaENmFdxeMFzqJN3ueCSTUngu0v9P6DKEizIxIOll0E5bFHpx5FQPQkvNtlm
         97kRYmSmgs4PRuichRHp3xv2cR07IHqDKX35DhQZnja+cf0DpJvBxhJxtt8IO7PygIbx
         WB/jIYj9pKRlisM66lLwMgd2sWpeZzSPvgMjlQfj1rK1jgaNldLZTLv2Xbnsu15fGinn
         xIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=BJ/yvKtQ5BG9zSSbeGDdjkvo6GheThwdGsGb8epOyK8=;
        b=6aMHbr11wnIWygO/KaymIxA1nmh+XlLYiwbvpB6s5bJIZLwHX7b7NYayTzNVAcUYII
         tOA3wkcwS1jlErgOw5sRboO8Ots3wuPCW4K+Vf/JqjSshTTP1+lOQb2ncCSv0S2sX9cL
         puO4ba+k0CCybX3mvbVkShXPRxVEsXioDQsFXKQo9vmg6ZKoWTm6G7PjwIaInL3EeW3f
         WxpPL9zZTtWuw6093jHv4HFvKCOJN9C4rXSeHC+4mVHgOo0ltaaPk9SOBbkBW/oJlGJw
         SpK//lRaa+aUEO8tsicS9n+Vf7qpKs/1dVFf+qDOD1zOYl8O72MHvqzyeHt1DuH2J+yH
         ROBQ==
X-Gm-Message-State: ACrzQf0vj9DfJZbFYrI+8oHwSkUlXxPgiBQlu1ZdQHuPdngsgvjaq/d+
        0KSbU0BvOsyp3LBnKLhzPmY=
X-Google-Smtp-Source: AMsMyM7S6wpy8rTV2SU/jlmaH7Yz+WyOSM1+hDERACIzV2iJUsU2HoSTMi64ekeKrkUpwDqY+25Tww==
X-Received: by 2002:a9d:19ca:0:b0:655:bcdc:f546 with SMTP id k68-20020a9d19ca000000b00655bcdcf546mr2318584otk.304.1663869089432;
        Thu, 22 Sep 2022 10:51:29 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:3499:cbd4:711b:1d15:59e0])
        by smtp.gmail.com with ESMTPSA id ck12-20020a056830648c00b0063696cbb6bdsm2925130otb.62.2022.09.22.10.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:51:29 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] cxgb4: fix missing unlock on ETHOFLD desc collect fail path
Date:   Thu, 22 Sep 2022 14:51:08 -0300
Message-Id: <20220922175109.764898-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The label passed to the QDESC_GET for the ETHOFLD TXQ, RXQ, and FLQ, is the
'out' one, which skips the 'out_unlock' label, and thus doesn't unlock the
'uld_mutex' before returning. Additionally, since commit 5148e5950c67
("cxgb4: add EOTID tracking and software context dump"), the access to
these ETHOFLD hardware queues should be protected by the 'mqprio_mutex'
instead.

Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
Fixes: 5148e5950c67 ("cxgb4: add EOTID tracking and software context dump")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
v1 from previous RFC:
- No changes
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index a7f291c89702..557c591a6ce3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -14,6 +14,7 @@
 #include "cudbg_entity.h"
 #include "cudbg_lib.h"
 #include "cudbg_zlib.h"
+#include "cxgb4_tc_mqprio.h"
 
 static const u32 t6_tp_pio_array[][IREG_NUM_ELEM] = {
 	{0x7e40, 0x7e44, 0x020, 28}, /* t6_tp_pio_regs_20_to_3b */
@@ -3458,7 +3459,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < utxq->ntxq; i++)
 				QDESC_GET_TXQ(&utxq->uldtxq[i].q,
 					      cudbg_uld_txq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 	}
 
@@ -3475,7 +3476,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nrxq; i++)
 				QDESC_GET_RXQ(&urxq->uldrxq[i].rspq,
 					      cudbg_uld_rxq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 
 		/* ULD FLQ */
@@ -3487,7 +3488,7 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nrxq; i++)
 				QDESC_GET_FLQ(&urxq->uldrxq[i].fl,
 					      cudbg_uld_flq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 
 		/* ULD CIQ */
@@ -3500,29 +3501,34 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 			for (i = 0; i < urxq->nciq; i++)
 				QDESC_GET_RXQ(&urxq->uldrxq[base + i].rspq,
 					      cudbg_uld_ciq_to_qtype(j),
-					      out_unlock);
+					      out_unlock_uld);
 		}
 	}
+	mutex_unlock(&uld_mutex);
+
+	if (!padap->tc_mqprio)
+		goto out;
 
+	mutex_lock(&padap->tc_mqprio->mqprio_mutex);
 	/* ETHOFLD TXQ */
 	if (s->eohw_txq)
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_TXQ(&s->eohw_txq[i].q,
-				      CUDBG_QTYPE_ETHOFLD_TXQ, out);
+				      CUDBG_QTYPE_ETHOFLD_TXQ, out_unlock_mqprio);
 
 	/* ETHOFLD RXQ and FLQ */
 	if (s->eohw_rxq) {
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_RXQ(&s->eohw_rxq[i].rspq,
-				      CUDBG_QTYPE_ETHOFLD_RXQ, out);
+				      CUDBG_QTYPE_ETHOFLD_RXQ, out_unlock_mqprio);
 
 		for (i = 0; i < s->eoqsets; i++)
 			QDESC_GET_FLQ(&s->eohw_rxq[i].fl,
-				      CUDBG_QTYPE_ETHOFLD_FLQ, out);
+				      CUDBG_QTYPE_ETHOFLD_FLQ, out_unlock_mqprio);
 	}
 
-out_unlock:
-	mutex_unlock(&uld_mutex);
+out_unlock_mqprio:
+	mutex_unlock(&padap->tc_mqprio->mqprio_mutex);
 
 out:
 	qdesc_info->qdesc_entry_size = sizeof(*qdesc_entry);
@@ -3559,6 +3565,10 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 #undef QDESC_GET
 
 	return rc;
+
+out_unlock_uld:
+	mutex_unlock(&uld_mutex);
+	goto out;
 }
 
 int cudbg_collect_flash(struct cudbg_init *pdbg_init,
-- 
2.34.1

