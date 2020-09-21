Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B4C272BD7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgIUQYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:24:17 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43083 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIUQYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 12:24:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id y2so14678671lfy.10;
        Mon, 21 Sep 2020 09:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s8QzOTOjah+WertfUySnnF7ugxfBVl0ryTdPuxS2HPo=;
        b=VtnIyFnN5XZZ4Ns4rfNwz/wN+TXlLWOJFWy9izXWRd2JMKQXvEwOLOWpPRszT7HA0s
         Zti46F59WDr2V7GQMg0T4NIOHzjq0Qyj5+7UMKHkVyerPG0GMb2PD9ye/V+Fuls5V8E7
         bNNd1HTRxW0u3HZJQ7Vmz4rRBbNPqrbjTU2pghZX48fTVYQn1RJ1mxjpZZMwTQn/KjaA
         yhaRG444hDSUqqGM2rXikWRzg/hO9tPVqCqkkLmubPhVUd9JpUlZadKGuz6UNL8wsfLl
         XTHJxQ3Iyarc7cOU4CWLnWbcDTRbcRHsiL1QxRwNMMnJcDixpH+m1T9jI7qtSkxkpAy5
         D1PA==
X-Gm-Message-State: AOAM533ajgwcaev7aX59QVeS87doYQ7wTuPuyxo6Mu6VTI0atPbPeB9S
        HzXKtd+Pagx5E5NcwWcxamQ=
X-Google-Smtp-Source: ABdhPJybUCfGWS9WyBnXuiUJe8163Fh8P9TSwT4PuBFC7F6G9dUwdzn/m/W3hOebbEoXbHM0Y5gjbw==
X-Received: by 2002:a19:6b08:: with SMTP id d8mr220904lfa.218.1600705452390;
        Mon, 21 Sep 2020 09:24:12 -0700 (PDT)
Received: from green.intra.ispras.ru (winnie.ispras.ru. [83.149.199.91])
        by smtp.googlemail.com with ESMTPSA id x21sm2686642lff.67.2020.09.21.09.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 09:24:11 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
Date:   Mon, 21 Sep 2020 19:23:44 +0300
Message-Id: <20200921162345.78097-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variables flow_group_in, spec in rx_fs_create() are allocated with
kvzalloc(). It's incorrect to free them with kfree(). Use kvfree()
instead.

Fixes: 5e466345291a ("net/mlx5e: IPsec: Add IPsec steering in local NIC RX")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 429428bbc903..b974f3cd1005 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -228,8 +228,8 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 	fs_prot->miss_rule = miss_rule;
 
 out:
-	kfree(flow_group_in);
-	kfree(spec);
+	kvfree(flow_group_in);
+	kvfree(spec);
 	return err;
 }
 
-- 
2.26.2

