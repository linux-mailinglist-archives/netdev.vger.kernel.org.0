Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E104F602E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbiDFNuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbiDFNt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:49:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E264B54881A;
        Wed,  6 Apr 2022 04:19:39 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so2352921pjk.4;
        Wed, 06 Apr 2022 04:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZzrJzEO0/L2Fv829K067oD4D3q7XNJ2h/EQeJLl1REM=;
        b=e1q6suMh+HRmHJvIosuu5YyBROUGiQBsGv64joCiBUFBmQ+I5ihJ9NCB7ms02X33Qm
         G9eiv3v3ohR1WsMjpLqUYYZXPEML+O2y51nABHRMfYCuro11ClvNQEu6GQgyJuLZg9Df
         8PtQP4kF+csQfKQG0PrDLtDsdQF5PcNBV5/IpGrBhnUK3NnxrUevCj8SWUUsnwmJ6HSZ
         /CDc3/GWrkBrIJwJMI2aPzBii9lMAFfRR+0r5rjm+/EHrwbVEksVn5WEwpp6Zoh6JCy+
         nD60DzgFJ0JBgRq/pROX1sQXYNl8TmEzzxJ1EPSAxomOCpaH1TMFSLNDJcB49rReg2dC
         NuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZzrJzEO0/L2Fv829K067oD4D3q7XNJ2h/EQeJLl1REM=;
        b=UTXX5lksn1dkKM+3dlYIxkLQSECCLBUuHbO6ECXoIbZzy2YESEWS6cP8hs35zqET3l
         A6BxLxiwOl+8WtGKAOKSOuWCS20KLKblnxZdOQWu+LdcWxj/W2cXckFKEJSxqLJXS3+O
         CQCG9633xBlT3myzNGgoUXE1yoxqsCHxqeJR1BdXyHEWaVdak8sRXZ9dmWa6btAT+fwY
         +M8U/J3g8r2UK84rtnu4Go19O55uMibjhhWFbrTlCoLU5lZCIrilb8uZoXDJtXPVHa8F
         vK4088SRPlZfPGa8+GePxATmHMXmGTyT0pf3OzvnQ1EKr48H5qgXp35qM+nZpPu2ndrQ
         /a8Q==
X-Gm-Message-State: AOAM530Ty9YxlEQgsUgSuiXis8ckLWJEK0qEVeaN4YHZ+pfWc3Iwiw6v
        31s8mQWiIzy5wMuj7vLS9R8QgG+1R5Vw1A==
X-Google-Smtp-Source: ABdhPJx49C5uI7nHegDpc4R0pKmz+Db+BOqX82s95K2GSR4hJWF3SDNT8p8KyB78kMdFSlm5hsGp1w==
X-Received: by 2002:a17:90a:1697:b0:1ca:526a:5dcd with SMTP id o23-20020a17090a169700b001ca526a5dcdmr9361783pja.143.1649243979367;
        Wed, 06 Apr 2022 04:19:39 -0700 (PDT)
Received: from localhost.localdomain ([180.150.111.33])
        by smtp.gmail.com with ESMTPSA id nn7-20020a17090b38c700b001c9ba103530sm5507294pjb.48.2022.04.06.04.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:19:38 -0700 (PDT)
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Ariel Elior <ariel.elior@cavium.com>,
        Manish Chopra <manish.chopra@cavium.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] qede: confirm skb is allocated before using
Date:   Wed,  6 Apr 2022 21:19:19 +1000
Message-Id: <b86829347bc923c3b48487a941925292f103588d.1649210237.git.jamie.bainbridge@gmail.com>
X-Mailer: git-send-email 2.35.1
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

qede_build_skb() assumes build_skb() always works and goes straight
to skb_reserve(). However, build_skb() can fail under memory pressure.
This results in a kernel panic because the skb to reserve is NULL.

Add a check in case build_skb() failed to allocate and return NULL.

The NULL return is handled correctly in callers to qede_build_skb().

Fixes: 8a8633978b842 ("qede: Add build_skb() support.")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index b242000a77fd8db322672e541df074be9b5ce9ef..b7cc36589f592e995e3a12bb80bc7c8e3af7dc42 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -748,6 +748,9 @@ qede_build_skb(struct qede_rx_queue *rxq,
 	buf = page_address(bd->data) + bd->page_offset;
 	skb = build_skb(buf, rxq->rx_buf_seg_size);
 
+	if (unlikely(!skb))
+		return NULL;
+
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
 
-- 
2.35.1

