Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6796CD250
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjC2Gvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjC2Gvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:51:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15499ED;
        Tue, 28 Mar 2023 23:51:48 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e18so14520061wra.9;
        Tue, 28 Mar 2023 23:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680072706;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNO5XYtDO9To2qYmyMq2g+OLzkP9KIoauMNo8WVsbjM=;
        b=qc/ldFUmg+pKlj3x3qaztDtEw2ajppo85yBgRxykjcdJiTRCIIt1JFMcXWPtMMlhQ+
         QrJEIAaBz1O5mgbfWJJi3OIfchnghb77dvYkwM+ZX87Edo1nAOnu5zqGuLetnUgYSW+D
         BriDnb/8jyL4sROmYJ9ldSqBE3tx+r9/FSoTrj3UXYh2lsD3tjRIHy96lZSbl503gMbB
         y0G3yPgTuXHUad9+zqyAunI5ut72VbsuJ6GLhDl0iDT+b5vgnbzYRf1W0ldkhwmeV7Ly
         bTujQ7BtEzFrlfQRtb3BWOwHEPfA9FAMzFQ5GsMZbXjc/wbkWqOzER0oREXS0ZgGfIkf
         J/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680072706;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNO5XYtDO9To2qYmyMq2g+OLzkP9KIoauMNo8WVsbjM=;
        b=F23tm3HLetdZdF34JJJo5LeUbEsaxVgEp+x4DlGL08KQhej1fVe3fAtTxpIdxcrQvt
         VF+wrIiAnRTh681O8GCkgCEWTC8lRWFv+WBx7DIj93Omtl2CwYmOIcDoC+o8urD51XcE
         qU/qS7lsIg8hU5SLqXJFILrnALHy/sp/ZpJWI/uVGCzr4TTrtWixL5Qn5fD3nbD1ay/Y
         VtDFdzLtm3B8UmA1isc/Cw2ofP5R+o+qBIm+9d2WgGXw9wh8lOzSKOh9kjM4jOQnH0ZI
         w1P52AYMMlQQqFFCSfcCAvjNwlUHJW6DbjZzePtN/UE7RlB9TulHoflTsjJpr89mea3F
         KyLw==
X-Gm-Message-State: AAQBX9cqMy8IG6zAN4d0+VOS6I7b7Cz2GpyLrJMbDuLfi9u9v3nn4lSw
        69uORtHaFkUS0+NQ7xne73M=
X-Google-Smtp-Source: AKy350ZD6q8OH4oGBAzNhlW6NoCd36G3p0py/C6ppvOo0ZriqrCiUvpj9N2FlcY5inL3Ff2L1IzwJQ==
X-Received: by 2002:adf:e288:0:b0:2ce:a93d:882d with SMTP id v8-20020adfe288000000b002cea93d882dmr14868026wri.11.1680072706471;
        Tue, 28 Mar 2023 23:51:46 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm29392968wro.61.2023.03.28.23.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 23:51:46 -0700 (PDT)
Date:   Wed, 29 Mar 2023 09:51:37 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] octeon_ep: unlock the correct lock on error path
Message-ID: <251aa2a2-913e-4868-aac9-0a90fc3eeeda@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The h and the f letters are swapped so it unlocks the wrong lock.

Fixes: 577f0d1b1c5f ("octeon_ep: add separate mailbox command and response queues")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Thees vairable nmaes are terirble.  The huamn mnid deos not raed ervey
lteter by istlef, but the wrod as a wlohe.

https://www.dictionary.com/e/typoglycemia/

 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
index a4ee6f3ae354..035ead7935c7 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
@@ -167,7 +167,7 @@ int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_ms
 	ci = readl(q->hw_cons);
 
 	if (octep_ctrl_mbox_circq_space(pi, ci, q->sz) < (msg->hdr.s.sz + mbox_hdr_sz)) {
-		mutex_unlock(&mbox->f2hq_lock);
+		mutex_unlock(&mbox->h2fq_lock);
 		return -EAGAIN;
 	}
 
-- 
2.39.1

