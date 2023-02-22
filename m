Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5474069FD22
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 21:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjBVUms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 15:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjBVUmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 15:42:46 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84D541B5F;
        Wed, 22 Feb 2023 12:42:45 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id o3so9155532qvr.1;
        Wed, 22 Feb 2023 12:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0vtPEhMUNqkWXDdBt+R+nfjd+3sGMrjlOQ9R+WZNT54=;
        b=OSndZFfc26x9kmEwajq4237zfFwTzUiS60h+95gaNeEg1ymvPjMeJ67xbu1ayX3kAS
         WWsxcDo9pmOdNyG4RcQ/fciJDSJda5KEXvgHn7NhTQveg9hASvcoxDjt4fCp4dvcGhpu
         OrrXD1d0ufpDonIc8+yyC3pwZ7/U3cQe9ff2s2wqrrSX9gPJMbpxd6EUZz6ad6zePF9Q
         l+WfTewLzVp1ozUvLFMAFIvecOze8xi7XP1TwlSdh/eYu/f5zUE19GlJcFbIxBD5W/2h
         VYHUjyDyIuJ3Xb7v1sPxtdL9ndBHkjZZLdFXtwQ4Mu6eo3Gkq3SY/GSlX0aw/Z22tMQP
         4z7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0vtPEhMUNqkWXDdBt+R+nfjd+3sGMrjlOQ9R+WZNT54=;
        b=xqEiQ8F84Fch3x3N3+/MhVzTsdhYV//nK8oylezzrNBjr/Ad8lzGHFfyrC3UqHg2tk
         JNdReqepxIFrb7RvWfAYL3B3Ih+yv2KEPJnWR4Kul45j4fEsVtb8RTVGA4lxOMJHULI1
         jtVeE2w8xva1YXNRNPjDGh7KystHqmG/pXoZK5Glk5ix/rhjNTUmdqiBW/1Elt0ZzeBS
         luGwR4rikUpMR6f5Mw8JAmKXCqj6fA0NmN4vCTHqrW+o4TACmPEG2UFRva7femGupyO7
         KYvmKHp1rGCKBPrGANIYgMekM3ButAWDO4qrLkMBnYIFM49+gZZGC7llRP77oxJH9PaA
         2nrQ==
X-Gm-Message-State: AO0yUKUvNsEL/O/dzTWsZOdGubjrsTtrw2BS50qRevFJHyJeWhYuWJif
        UQnAham+sOX6h8kD4pTMi+E=
X-Google-Smtp-Source: AK7set/HkHLtZD4DM17Cbm3JUb8+wP0KArWacpqCjYU1cxliORJN5mnHFxwa4vSma4FWw4MLpr5xWQ==
X-Received: by 2002:ad4:5bca:0:b0:56e:a556:f28f with SMTP id t10-20020ad45bca000000b0056ea556f28fmr14192168qvt.34.1677098564922;
        Wed, 22 Feb 2023 12:42:44 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id h18-20020a05622a171200b003b9bca1e093sm4814092qtk.27.2023.02.22.12.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 12:42:44 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net] net: sunhme: Fix region request
Date:   Wed, 22 Feb 2023 15:42:41 -0500
Message-Id: <20230222204242.2658247-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
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

devm_request_region is for I/O regions. Use devm_request_mem_region
instead.  This fixes the driver failing to probe since 99df45c9e0a4
("sunhme: fix an IS_ERR() vs NULL check in probe"), which checked the
result.

Fixes: 914d9b2711dd ("sunhme: switch to devres")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1c16548415cd..b0c7ab74a82e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2894,8 +2894,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_clear_quattro;
 	}
 
-	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0), DRV_NAME);
+	hpreg_res = devm_request_mem_region(&pdev->dev,
+					    pci_resource_start(pdev, 0),
+					    pci_resource_len(pdev, 0),
+					    DRV_NAME);
 	if (!hpreg_res) {
 		err = -EBUSY;
 		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
-- 
2.37.1

