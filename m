Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064B618C54B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCTCcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:32:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34521 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgCTCcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:32:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so2324019pgn.1
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HbQVdEF54f94ZDG1LFQPZsH9GhURnXxjD80x/frEOdc=;
        b=1cOyFnYvfCWpU9dkBr/qN223/qSUqKnr53wfB4/9W7hqSUGnJj4g1KRYVS/BVprYyW
         D44L99g4gXWF1CMQ3Ws66fLX9th/Y0areipsozehGH/cDPhgIJhSaPc5FT3pFe8GVHnq
         eOV5jLoISuxSnFURSzNl3kkyrZYEBiD5kDvyc5YwyRXtaAA5uezuyAmBouLlvUkda5Oc
         U9xlnfoPj/hzTpP4iC8WdxW9GezV/wHRJb5c+y0WTwaVA6D7gLuKbq5ege5sNu757t6I
         tR3SR+5/q/X933LXF9Ny33ekxhDgUKYCGKYN5lK9hvz38Zn6Cibm7rwHqFLjPlgFoAVw
         E/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HbQVdEF54f94ZDG1LFQPZsH9GhURnXxjD80x/frEOdc=;
        b=siSj802vEZbI1CKPIKDfaikxEUqiVxmipf0TIAv6dogNZwg01vI30OtQoCxuv+vFyz
         G5Rt4T4cN4wfmrAxjJhOFT7aOh9gtVFPP6qpw74NcAkcUekMEqld2l/W/DDnZ+3gNYBk
         2P+ERIQ4R+IuqZFoTS2Ox/5SpHX3B0TWcnMcZfEL3OfAHgLbnsg0w2n2PJeDV856vgJD
         LLwEy3nDsvMx31fKvGaaXw2u2WE/3qTg+ePyvhb3KvhybO0T8b1apb6uEsztIIxQ168L
         I4+AEhVedNV3irWiTUam3iFP1sKPZp+/K/6N14Nd71v8BhZuQO3aB25OAcBHMXFQyzph
         hc8Q==
X-Gm-Message-State: ANhLgQ3JW6QzE0bYpH2cIVtdrPsW3wEtnSwS3QJ9Y0U6e2Q9zY3d7pHS
        bB8HvHDHMXbm+0kEIc8UGK+sWWcpHbA=
X-Google-Smtp-Source: ADFU+vsgEVd1+ZhE+sLv7oPcw4d501zsdQxQgzOukyKACdog/bB1BeaMGgpbjJpkV2tZNJlNqyzf1Q==
X-Received: by 2002:a65:60d7:: with SMTP id r23mr2300666pgv.321.1584671523240;
        Thu, 19 Mar 2020 19:32:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i124sm3606485pfg.14.2020.03.19.19.32.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 19:32:02 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/6] ionic: only save good lif dentry
Date:   Thu, 19 Mar 2020 19:31:50 -0700
Message-Id: <20200320023153.48655-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't save the lif->dentry until we know we have
a good value.

Fixes: 1a58e196467f ("ionic: Add basic lif support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index bc03cecf80cc..5f8fc58d42b3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -228,7 +228,13 @@ DEFINE_SHOW_ATTRIBUTE(netdev);
 
 void ionic_debugfs_add_lif(struct ionic_lif *lif)
 {
-	lif->dentry = debugfs_create_dir(lif->name, lif->ionic->dentry);
+	struct dentry *lif_dentry;
+
+	lif_dentry = debugfs_create_dir(lif->name, lif->ionic->dentry);
+	if (IS_ERR_OR_NULL(lif_dentry))
+		return;
+	lif->dentry = lif_dentry;
+
 	debugfs_create_file("netdev", 0400, lif->dentry,
 			    lif->netdev, &netdev_fops);
 }
-- 
2.17.1

