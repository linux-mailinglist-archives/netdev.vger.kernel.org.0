Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B181F0062
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgFETWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 15:22:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46773 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgFETWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 15:22:43 -0400
Received: by mail-lj1-f196.google.com with SMTP id z9so13071845ljh.13;
        Fri, 05 Jun 2020 12:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u3eZ7mL6mFM01PKlmqjTQsyiKjw3u8JrGHY34L8anUM=;
        b=uRC/FLX7G6ET1Q97f3P81rPPqcegQUN6cSKoSZPSnXjrx+5twmv0k6aoTvsz0/uBOK
         EO5yvnJK4llgh7ksipY8K4dlFC6ZJ/ndtJK276UXL7VTd/8/DutjHZjGMhbMw48qmiJw
         lrCGgrbfvzZ+m7ZmqqsWjq9/XSywzSTx/R6l/fW2y+ThjhLISOPrx1kN+FjVc2A8Cxsk
         7hfw8SWCxxx+1v+TYkT9KKu9FpTilPRgh5DoEmD1x0mftvJ7/3r6C7yolv+vM4ANUd1R
         QmVxBpZS8C/zEqwmbfMh96Jl6ulVywulAu/nVnukc0RILdaz7vOdyiYAUtW/uIZtyK2s
         7jkw==
X-Gm-Message-State: AOAM533D0hZW31g+txk6ZLisw/5FmRQjMmaJMEBCIqnFtsadMPsHzkBX
        5nRSPp81RMd1Ob4N04ik9bk=
X-Google-Smtp-Source: ABdhPJxl8k1NIvglkEw1dVGG/SGuEX0lmR7gxxVj8EctcxXnNDqOxxj+X2HFswA0sou507Kl0ADy5g==
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr4991886ljo.276.1591384961808;
        Fri, 05 Jun 2020 12:22:41 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id w6sm1118983ljw.11.2020.06.05.12.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 12:22:41 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date:   Fri,  5 Jun 2020 22:22:35 +0300
Message-Id: <20200605192235.79241-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
the memory is allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 014639ea06e3..c4c9d6cda7e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -220,7 +220,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 			sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.26.2

