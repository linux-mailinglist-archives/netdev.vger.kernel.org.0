Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1175BB4E3
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 02:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiIQAK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 20:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiIQAK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 20:10:56 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A6772FDF;
        Fri, 16 Sep 2022 17:10:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y136so22727803pfb.3;
        Fri, 16 Sep 2022 17:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=KFW8Lrz6qD+umd1mS93Z94RJAGOU/7BuklYES2+tlvc=;
        b=S95XJ2h2Yh/uY9gQVigHf5hGkQGVe0J9Tj8MSR8adO647oBGzf/84YU+IAySuCQ5mp
         wlHZ8JXl7AX8P4wcHea7TQgV86TSdMoYQe5NybR0gYEtM1vAQnzxL2gzzvszg+9xeATh
         VggxVJeSI+WETjVLlqARja3Jh7reXGk7t8ZLZ82Q7aDxUrq8h6AgdVr21qKVc1rJzRzV
         DsjO4th/qWFnTNy3hfd/OKBS6d3AYsZrCAmbUAup+fI+UAcs/PO6ea2bCk55NHVxGke3
         7pJ8KPiCn8WMfn9sG0DN1eCaVlYO1kMMIY/XJO4nizzphuahDNoDbxDvtpmG95yd7cAC
         Syrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=KFW8Lrz6qD+umd1mS93Z94RJAGOU/7BuklYES2+tlvc=;
        b=m2RdIPdxdcwAFNcNsVyZfJFTjyTsXWXdMh7hDP2/HLo+KQMwEIyLx2HCyDzAaJmY8I
         GwBil8i5hF2iaAWSKZgsBn3G3D6XJDSbCk3eG4AdJCxWdi1qKSEa0l+Bg8LkDB7UIiHO
         UXYB3y3namM5knouUjbtXzRNAAI2/OAK5oANC9a5ZATOwRdytUai65kj3y9/8RtN0I+c
         MIvztiV4Ct5qWRrCBBSt2NsSpwHjMAIhCEDtc0CYIcWeUC/Wdx0UbrT2I2eqmns1XbJP
         /+b34aAxwugOjSq6bPWJarmYeOUKKnXtLAadCPguNV27USrN4+HQsPSPYP5JfGm4nWRJ
         97GA==
X-Gm-Message-State: ACrzQf3Zl5jytI6gH8sLVHopeHLLRLqBHphD2nHwYyEDJ3tWh/H2EXOp
        G4gq+Xo72dcsvEB9Oo27NO2xhvnZ4f4sUg==
X-Google-Smtp-Source: AMsMyM4OTX8idl0VD6igHHYK4x6jOOquNrCi3+1u78eYaUGk2HxEcyhIuyMjxNmPUDs9UsjzhTGDng==
X-Received: by 2002:a05:6a02:309:b0:434:efcb:ccf4 with SMTP id bn9-20020a056a02030900b00434efcbccf4mr6615874pgb.304.1663373454281;
        Fri, 16 Sep 2022 17:10:54 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id p67-20020a625b46000000b00540d03f3792sm15002041pfb.81.2022.09.16.17.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 17:10:53 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v2] drivers/net/ethernet/intel/e100: check the return value of e100_exec_cmd()
Date:   Fri, 16 Sep 2022 17:10:27 -0700
Message-Id: <20220917001027.3799634-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of e100_exec_cmd() which could return error code
when execution fails.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 drivers/net/ethernet/intel/e100.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 11a884aa5082..0d133cd4d01b 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1911,7 +1911,9 @@ static inline void e100_start_receiver(struct nic *nic, struct rx *rx)
 
 	/* (Re)start RU if suspended or idle and RFA is non-NULL */
 	if (rx->skb) {
-		e100_exec_cmd(nic, ruc_start, rx->dma_addr);
+		if (e100_exec_cmd(nic, ruc_start, rx->dma_addr))
+			netif_printk(nic, tx_err, KERN_DEBUG, nic->netdev,
+			     "exec ruc_start failed\n");
 		nic->ru_running = RU_RUNNING;
 	}
 }
-- 
2.25.1

