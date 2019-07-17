Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114036B9E2
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfGQKPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:15:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37905 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfGQKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 06:15:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so10613476pfn.5;
        Wed, 17 Jul 2019 03:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/BlyQx1CQtUbdljXgzQOEsVnyderN3F/tQOkowCKWUQ=;
        b=uoi9pWh55AGnrKz9wQDRxTJfvIcPJinWznMSgdB5DGm0cknbCFwgPfFWhOgEBvElB1
         i42m9r0OGAkelxiCQIDlL2hp8hEEbbwm7bJuLiOfGmCFnbS+CJLgZT3QqwJN03CR+tlq
         boLrhs+XrkOS7ixrKkFOx/vnbD7ifqx89CuacC4xpnWIiPMy7vh6A5WUl6okNbV2aKwy
         SPJXLBlDmdFOHyx5KUGKMbKXFgUAcCtQ9LPts0uvw/XkethOsOVq2pYj2Hxi4ZmfJb4g
         hcHrqIY1ha1gkQEHhic27MeMZ2i/yqU6iYUAJ2B2tEO+V0De9vSOur7AzRsSfTqyOt7V
         6xxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/BlyQx1CQtUbdljXgzQOEsVnyderN3F/tQOkowCKWUQ=;
        b=qtRq3PT8xGPcG/nGfaVEDnNSMsb4yyaiEpiBpG3iviV4z5WRwAI8eLWiH4sQdQaDER
         EDLUh9SbIe2YsFwKuDQevkhqruaO/kq3I2T2YaqRlP4ud75O86Jp0T32QqAdrulDsFor
         FjKMQTrT22wuiIUP8uSHWwY+ANVBqFbf4BOPPgeaYBh7OkRUQ0uwCQA74V53A177s74Z
         Ma5MHFakAFZ5dcNvSTNorP0AtSpzRmgk68SmXv/6o+8Ygl1Ja2iEc7rKUooGJmigDjJz
         16zo2YNcFUlPGfHzGgpKZWzbHC42tioKTyDRIfeuXV26h65blsyLqyPAymXjFa5OTqvf
         FpYA==
X-Gm-Message-State: APjAAAUppw0CWyrxIN8Cy2E1bo0lZZz6+Bn8hahIiNmweee48aGQctxa
        16jG0bUSr/Gslcgo8YIamgM=
X-Google-Smtp-Source: APXvYqwWhm7rVxZHAj0f1r/DpXT/jcfTW6iEkijvx6IfwCp8/Bv9nTsdhSHr+aH/njjPw08BemjU/w==
X-Received: by 2002:a63:9318:: with SMTP id b24mr30103146pge.31.1563358507047;
        Wed, 17 Jul 2019 03:15:07 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id q198sm23342176pfq.155.2019.07.17.03.15.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 03:15:06 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2] net/mlx5: Replace kfree with kvfree
Date:   Wed, 17 Jul 2019 18:14:57 +0800
Message-Id: <20190717101456.17401-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable allocated by kvmalloc should not be freed by kfree.
Because it may be allocated by vmalloc.
So replace kfree with kvfree here.

Fixes: 9b1f298236057 ("net/mlx5: Add support for FW fatal reporter dump")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Add corresponding Fixes tag

 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 2fe6923f7ce0..9314777d99e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -597,7 +597,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 
 free_data:
-	kfree(cr_data);
+	kvfree(cr_data);
 	return err;
 }
 
-- 
2.20.1

