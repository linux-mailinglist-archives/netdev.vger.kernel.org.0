Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E68055358
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbfFYP1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:27:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39112 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732283AbfFYP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:27:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so9660254pfe.6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 08:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FNXeq6wLnPS0n8tlAUsMq9eNL61tG6XHI5aj6+mae6s=;
        b=sjySoLtWOu5l/FG63caknYbmD7W/NLSfb3gOPHQEYRsOClCqm/RfqyqpMVGd7I/Pkg
         Wkjvqhd2R1dXZBG4raWUK+iygif4FeiHbu3hz+HRr9IsAXUakO85tFzIrhdZ+Ls09ykf
         +HAncA8IoFzPLlEFkzrR8+8inMzWKTgpd3ZSnW3rDy8FdwvRKkUz/8PCL/6m36I9e81W
         nRglEa1dPSNpyaoTwZLh2ChZvqsCLH/m7Pk85GWaZiFTq8P73/6Lf8UAs/ohF7ebE/fP
         aleddr7aLSWg0rfV929I75YZhSAfy/MfBpKM+3XvjmugrzWYq3eYWUEdd/hm3UaNoD96
         Y7xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FNXeq6wLnPS0n8tlAUsMq9eNL61tG6XHI5aj6+mae6s=;
        b=KRzvhsS5oGl0NFqA/b0UH0+WW8D7AMODt/R53Buuaw8jcaDeFv8ngcJ8wzzL2qYlIP
         SJik5ayketf4TTUZQjaccScClRnBiJXMAc0KzhyXB1kEb3OWheZsNJVPln0L6xbw3gSp
         unwCK6bE05faha1DwQQ/TjzTGVgnLu3g1bQfalUlkUrFMUs4ILebAOdq+S0WA/35WZ1V
         VvDO1u/ri+67qr+TbueJ056ZO9FmVKDsEFC6lph1qOVVFnhjIb2Iltejcyjtynuq/vnw
         5uybK+ENyhPE/AgLozgD05tHJx0mA6BK/zvgtYJRKAUIHQ4zI3ELGpJ/CROlwGcLIDmI
         DE6g==
X-Gm-Message-State: APjAAAUWZeG8lh6YWXnsThDuMT0SptCU8GkHEDlXa8X8V+/IJU/uAwFE
        rDTYKLY9j9KmCDfWUjxA1f4=
X-Google-Smtp-Source: APXvYqwwM+FoM1MYoRwpQQS4xWbJjLdFew4WU/ZX4UAUHAApjafQYdwB85PsWYThwb5v+QMDO7aHJg==
X-Received: by 2002:a17:90a:d681:: with SMTP id x1mr31980267pju.13.1561476441563;
        Tue, 25 Jun 2019 08:27:21 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::3:20fe])
        by smtp.gmail.com with ESMTPSA id x14sm17451604pfq.158.2019.06.25.08.27.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 08:27:20 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is disabled
Date:   Tue, 25 Jun 2019 11:27:08 -0400
Message-Id: <20190625152708.23729-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

The previous patch broke the build with a static declaration for
a public function.

Fixes: 8f0916c6dc5c (net/mlx5e: Fix ethtool rxfh commands when CONFIG_MLX5_EN_RXNFC is disabled)
Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index dd764e0471f2..776040d91bd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1905,7 +1905,8 @@ static int mlx5e_flash_device(struct net_device *dev,
 /* When CONFIG_MLX5_EN_RXNFC=n we only support ETHTOOL_GRXRINGS
  * otherwise this function will be defined from en_fs_ethtool.c
  */
-static int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
+int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
+		    u32 *rule_locs)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
-- 
2.21.0

