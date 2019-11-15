Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E265FE634
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKOUMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:12:43 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:40263 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfKOUMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:12:43 -0500
Received: by mail-pg1-f202.google.com with SMTP id k10so4458717pgm.7
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 12:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Sbu+XQWMurh2GLbIyBKUUnQnRbxa6ToLvKnRjUx2+mk=;
        b=kJhUtVpgdk+g5aBIsUyY+QtH27c5HF16vPkrUjCEM5Pwwaqzb2GGmppUJuBtJ2uEmE
         xtPzgwpzAQPIoJY/rL7pbuAyIUVWPFXDzaUWNuRf4Fv80wsomquUVelupyvev2v/ICw5
         Kz/MqcK/ccdPC7sM4LJct9KbW2bWOCOHnxazL8HarJM+tCmTbblt+4xDjvhL0oN4ziia
         trPLPk3ZyBd+a9u45n2nx7U6HwWO3E+tE8ZA6NLvEPYTufe0it+tmbdew7Ubj1GQvJrP
         Mtgyqiheax6VYwAmbmr5OnynG21/mkmKBvsUHm0snlOBwpcajeCZILEAJwozH5jLK0Gu
         /LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Sbu+XQWMurh2GLbIyBKUUnQnRbxa6ToLvKnRjUx2+mk=;
        b=lwcJ/RIUAVzJeGM0GqvmaMGcVO/Kda98qqOEn1ElUooqQNX6Y6La6mcPbAjWZrjp9V
         FzrBGekEwhhcRqWQoTpwv35dlwAJOlY3sYx2Alyr7Orc0ELGq5tKZHzTtlExtW++MwC/
         bDOtoF7EvZZcrflJLdJxQvNBQAeGmHH8ZNOPht0YPsFjBWFEPSs/AgrPhhEH8vKlMu34
         8W7NQWahIZXyahc5wBUs+VAQOWNG1sjWx+HkHobZvYCc4xlB6WR4TgiVNpzTdDRylvCl
         Pg0SwgUUsupiwUKmNfqXERR4VZImvRR3ex6QGPuYjhkaCaete+vdNuVHAGXwtw/RLTgu
         /H6A==
X-Gm-Message-State: APjAAAUhgSgBG7b67h5dpgmm9NbimD1/OMxX8sxwdFHeXWqNBKrlFDRA
        jK+WLzrRtMGd0FMtyl2Kx3i3bZeTDmIHjVoWEHdQ8Ae0KmhmUahpGUKwiZnmVNd/eslHO6ly3Fp
        UTZWkgFM0iGLHkRwWzQmFm6HfY1Z5bSUaYpFSz6mSuc4soGW0Sr3pDQvNKETd+w==
X-Google-Smtp-Source: APXvYqyDBw0YFLaXPMxws6oIH6CoH8g04h4hUhbLnfPSZ1F6jkuwh61Lp96GwRDqu+epjyPBXas46UvTQs0=
X-Received: by 2002:a65:6685:: with SMTP id b5mr9039818pgw.94.1573848761875;
 Fri, 15 Nov 2019 12:12:41 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:12:25 -0800
Message-Id: <20191115201225.92888-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH] net/mlx4_en: fix mlx4 ethtool -N insertion
From:   Luigi Rizzo <lrizzo@google.com>
To:     netdev@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool expects ETHTOOL_GRXCLSRLALL to set ethtool_rxnfc->data with the
total number of entries in the rx classifier table.  Surprisingly, mlx4
is missing this part (in principle ethtool could still move forward and
try the insert).

Tested: compiled and run command:
	phh13:~# ethtool -N eth1 flow-type udp4  queue 4
	Added rule with ID 255

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
Change-Id: I18a72f08dfcfb6b9f6aa80fbc12d58553e1fda76
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index d8313e2ee6002..c12da02c2d1bd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1745,6 +1745,7 @@ static int mlx4_en_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 		err = mlx4_en_get_flow(dev, cmd, cmd->fs.location);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
+		cmd->data = MAX_NUM_OF_FS_RULES;
 		while ((!err || err == -ENOENT) && priority < cmd->rule_cnt) {
 			err = mlx4_en_get_flow(dev, cmd, i);
 			if (!err)
-- 
2.24.0.432.g9d3f5f5b63-goog

