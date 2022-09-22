Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB755E5AC0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 07:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiIVFdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 01:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIVFdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 01:33:09 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996AEB14CE;
        Wed, 21 Sep 2022 22:33:07 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id c81so8856693oif.3;
        Wed, 21 Sep 2022 22:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5sVpTjiX8PDcq85GSFzudWH5HXyQnSsOhJdWBSFi2rM=;
        b=F/COc8Lpjinzm1Gpy8ZWNozb7DhrHGtef9IaP86dJIysTTl+fslNV5MJrM1Vj8tMCp
         Bqemt1nda/AhguSA/BBe++D1MjZYIaNsDEChdezGsKGMonk7gLKAMIlF52d/JJS1VBfS
         zLTxZyIgVun8jROUf3E6MvaRISb7FWh5YWdOZWWUrcRbSuIoFQeCpihUTet2AB8Nv4CD
         aGo5sc7a11CXe27HZ/lv4iXaL9ve4ip8h2VChQ5uxszRbJ8rRVVvZBtdvU43JGLDK2wM
         afDZ792+vFIfaIM2Gq+6Gs4fpJaWRCQjEj/cVF5BQzwolbRNR7Nok3/MpR3il8eOitRT
         zRYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5sVpTjiX8PDcq85GSFzudWH5HXyQnSsOhJdWBSFi2rM=;
        b=AcvGAyZwGiM+cEAAct8HOQon/nYkfZuRKYkO1PrEQum5ChmMsIBcsK/7bALGDhJ8Vm
         cqlrZPbSfTkgekIULrjt3PzSV+IHA/1xQjesMjnqL0b0QSOz869mGI0GTTamZiOB+sf/
         wlqacfyfJyS5peNM0g+7ppgzg4nDli8O2D5CEGhPzo3exjYLa8+Qa3yAlAR2q3q2iGdA
         xYHWtS2ptz2yWcV65eJF091/sW9omr16NrbDhzIwbhi7pjunorr0PcOk5FUc5WdHntPg
         d5KinChA/LOrLFSDupinRZ2xilPTCaNRaK4G3wFt4cAWLyZta2YHInTr13BqTBuGz2/J
         Jf/w==
X-Gm-Message-State: ACrzQf2D7pDv4JPVCjfGxxwUPBrSg55frbLCCDa94wfcf8n9/TSmeMw+
        pEnGhBY9TxQQCV/aFjPxf5A=
X-Google-Smtp-Source: AMsMyM5kw+GX4j+RvtO3CffIFSTsA9LuEtzc0KHe1l+5MOlDkLG6qHQSPuYdyaJ76oYnAKs33kJG4A==
X-Received: by 2002:a05:6808:159d:b0:350:4f51:890 with SMTP id t29-20020a056808159d00b003504f510890mr5659409oiw.281.1663824786766;
        Wed, 21 Sep 2022 22:33:06 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:3499:2e9e:5862:e0eb:f33b])
        by smtp.gmail.com with ESMTPSA id w19-20020a056870231300b00118281a1227sm2570957oao.39.2022.09.21.22.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 22:33:06 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 1/1] cxgb4: fix missing unlock on ETHOFLD desc collect fail path
Date:   Thu, 22 Sep 2022 02:32:36 -0300
Message-Id: <20220922053237.750832-2-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922053237.750832-1-rafaelmendsr@gmail.com>
References: <20220922053237.750832-1-rafaelmendsr@gmail.com>
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

