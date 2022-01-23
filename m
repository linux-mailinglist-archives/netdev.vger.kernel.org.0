Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE334974A4
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbiAWSma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiAWSld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:41:33 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D636C06176F;
        Sun, 23 Jan 2022 10:41:32 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d1so13471773plh.10;
        Sun, 23 Jan 2022 10:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=C5MxD9/CL9NsuqJ/4TQY8GLvDJf1hYVoh5cAUlzqQTg=;
        b=T16FcQMzIxc211JT8TxZ/iueFxAKmECInlg3Y+mQrSHrf7jHbkKVJ3VC30/X8nmvhk
         m7C5wa+DA3mOvsxQnVyk/nzrmQ3zY3xxWoSRqAi7R9GvfSXNHyGRXg7bJrx5g3+VTx6p
         ywIh7sngyIjjK4wfy9uxfdQ8mYadaqT+M7hJfZv8UUK+RJ2IZt64YtQ4+mdmPCi/PTjx
         qrGczB53zqAMOaTeMj5pglxTBuE1/s52Gqr5cQ+KGlbt3ZdWTJTE+ROhEEnJrvvJRr1l
         9n1lftGq5Hdt5dZsWyrP/qeoV7yKCwiB74yKaPlJsIUKx8M/vqJF04dwzpeGxm8JLwes
         thiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C5MxD9/CL9NsuqJ/4TQY8GLvDJf1hYVoh5cAUlzqQTg=;
        b=2fsUQQ3ZAwqtyPNsdKqR6WzHF1C6Ewv3TsTtWFbEXscu14lYcquim5JACNUsSoZzLF
         xlwMsajoN2+SzMha3R7Roerbcnrpbw+NnAwCSS/ndz0xx+L8E8SxcJWlihAbW6u5Esof
         W2fYghXI5LtK/BlboMGsEfFsJBpsvXWKftVNZ9FUz6eKI+sX0beOoJ91GkbjDQxSRLV1
         PTbEdcPoV+fedNjBRbE/LDY8tlCVPKQvUcOV/PkWDfbIP+pxuFuemq/tq0biH4XUyqXW
         Z1rg3q5VxBOvFJfHB82+p6uNtC/gb3zoAyio8UFdspiGLtzqxATRRcjplfZG0MPFNBia
         94sw==
X-Gm-Message-State: AOAM533s1r9n/WuaHa7m1VN0vk159tHsDZkhu6V6Z+bQfw24b4lSI4EY
        nWnSHG1ajoUfHmLq0dDnbzg=
X-Google-Smtp-Source: ABdhPJw2IERdv9EjDfTFfQgHtN7IRDQvs7Jvm28asGSoFXUNkoy5rYrqcLKI+IMbX0TTAZ1cRWBWxQ==
X-Received: by 2002:a17:90a:8b82:: with SMTP id z2mr9751869pjn.146.1642963291689;
        Sun, 23 Jan 2022 10:41:31 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id e2sm9947439pgl.91.2022.01.23.10.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:41:31 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 33/54] net: ethernet: replace bitmap_weight with bitmap_weight_{eq,gt,ge,lt,le} for mellanox
Date:   Sun, 23 Jan 2022 10:39:04 -0800
Message-Id: <20220123183925.1052919-34-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mellanox code uses bitmap_weight() to compare the weight of bitmap with
a given number. We can do it more efficiently with bitmap_weight_{eq, ...}
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c  | 10 +++-------
 drivers/net/ethernet/mellanox/mlx4/eq.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/fw.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/main.c |  2 +-
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index c56d2194cbfc..5bca0c68f00a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2792,9 +2792,8 @@ int mlx4_slave_convert_port(struct mlx4_dev *dev, int slave, int port)
 {
 	unsigned n;
 	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(dev, slave);
-	unsigned m = bitmap_weight(actv_ports.ports, dev->caps.num_ports);
 
-	if (port <= 0 || port > m)
+	if (port <= 0 || bitmap_weight_lt(actv_ports.ports, dev->caps.num_ports, port))
 		return -EINVAL;
 
 	n = find_first_bit(actv_ports.ports, dev->caps.num_ports);
@@ -3404,10 +3403,6 @@ int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_active_ports actv_ports = mlx4_get_active_ports(
 			&priv->dev, slave);
-	int min_port = find_first_bit(actv_ports.ports,
-				      priv->dev.caps.num_ports) + 1;
-	int max_port = min_port - 1 +
-		bitmap_weight(actv_ports.ports, priv->dev.caps.num_ports);
 
 	if (slave == mlx4_master_func_num(dev))
 		return 0;
@@ -3417,7 +3412,8 @@ int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
 	    enabled < 0 || enabled > 1)
 		return -EINVAL;
 
-	if (min_port == max_port && dev->caps.num_ports > 1) {
+	if (dev->caps.num_ports > 1 &&
+	    bitmap_weight_eq(actv_ports.ports, priv->dev.caps.num_ports, 1)) {
 		mlx4_info(dev, "SMI access disallowed for single ported VFs\n");
 		return -EPROTONOSUPPORT;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 414e390e6b48..0c09432ff389 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1435,8 +1435,8 @@ int mlx4_is_eq_shared(struct mlx4_dev *dev, int vector)
 	if (vector <= 0 || (vector >= dev->caps.num_comp_vectors + 1))
 		return -EINVAL;
 
-	return !!(bitmap_weight(priv->eq_table.eq[vector].actv_ports.ports,
-				dev->caps.num_ports) > 1);
+	return bitmap_weight_gt(priv->eq_table.eq[vector].actv_ports.ports,
+				dev->caps.num_ports, 1);
 }
 EXPORT_SYMBOL(mlx4_is_eq_shared);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 42c96c9d7fb1..855aae326ccb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1300,8 +1300,8 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 	actv_ports = mlx4_get_active_ports(dev, slave);
 	first_port = find_first_bit(actv_ports.ports, dev->caps.num_ports);
 	for (slave_port = 0, real_port = first_port;
-	     real_port < first_port +
-	     bitmap_weight(actv_ports.ports, dev->caps.num_ports);
+	     bitmap_weight_gt(actv_ports.ports, dev->caps.num_ports,
+			      real_port - first_port);
 	     ++real_port, ++slave_port) {
 		if (flags & (MLX4_DEV_CAP_FLAG_WOL_PORT1 << real_port))
 			flags |= MLX4_DEV_CAP_FLAG_WOL_PORT1 << slave_port;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index b187c210d4d6..cfbaa7ac712f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1383,7 +1383,7 @@ static int mlx4_mf_bond(struct mlx4_dev *dev)
 		   dev->persist->num_vfs + 1);
 
 	/* only single port vfs are allowed */
-	if (bitmap_weight(slaves_port_1_2, dev->persist->num_vfs + 1) > 1) {
+	if (bitmap_weight_gt(slaves_port_1_2, dev->persist->num_vfs + 1, 1)) {
 		mlx4_warn(dev, "HA mode unsupported for dual ported VFs\n");
 		return -EINVAL;
 	}
-- 
2.30.2

