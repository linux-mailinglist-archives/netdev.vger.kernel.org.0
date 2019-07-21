Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D4F6F208
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 08:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfGUGhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 02:37:52 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42009 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGUGhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 02:37:52 -0400
Received: by mail-io1-f65.google.com with SMTP id e20so36694164iob.9;
        Sat, 20 Jul 2019 23:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w2/QR4w2cNvOQUCkgHOxW+cRJj9M6ZE6T2QZx8BYURY=;
        b=FaVd2GXtLCiyYaTF8VT5+5FZrP/CBEj23yu9VFy128TbAQo/REhIUbNjcbBX2VJo5J
         TNiWx2ywU2kUwPtERgWksHjOC0nPVQcLDPr0WNLX9B2jMHjU3V4aCiiktfsLTUd5YORH
         e8xFFb7+RwLweCytJJZSr/gxpE2EAeoGTExfCwZ5KtenBySZ9qruP2T2tK3mPVhMi6wD
         OJA+VSFNXI/9o1tKSwlyrdZYeUCdyB1LzaZVsS37vPbOvDLRYVMejWDExOmM+xGTar3s
         xHj+5qY5F2WTZEUwFOCKkmiHR1osCMhDn6iLWhx4IwruG7H7QoMHkpdXFE4w2WyfWip+
         Th3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w2/QR4w2cNvOQUCkgHOxW+cRJj9M6ZE6T2QZx8BYURY=;
        b=REhThF0tD0kwm6+8fhSqPsJqgK5L6PINrM6ZKd/CYeMmfwmUJeTPHPxT3SC3ADUPFg
         keQMCKFjAiorrKAW06JCBQA7PDMLa4RkCrV42oysIt3oBOB4pS8jFY0VD3tJ5rsZcXAw
         bpEDAjcmrMkPZHBzDgQ2Ulg/DL7e9mmXuoxvet/r8O0ceusR31DH3ybwmSa2hTueAduJ
         GRIX7ys+d9g55tPSCkO7+drcGE8Zh+XdDPZGIg2b9C/GggNZPpI711Gg0SDYa8h2J+Q6
         yfgzyMJM6eh2DptT678F3cDOd/5Ni81YzBd9LfTwnqwV8t/bD6NGbiOoGSX9xE+fFUyy
         fpnQ==
X-Gm-Message-State: APjAAAWGS8PdYrw8OmUe3OSEivRFX8xb9+Flhvg8X/8l2Q9n5Q4SlOyI
        zMHpYHW37fy3zE/rASTADms=
X-Google-Smtp-Source: APXvYqy7XvZaGc1MHmM7yMV5xZeVoKhEvG//TjYcx31IZRJKpMiz4du6AM1cNC9BiSPUQ2Y9ymIlDA==
X-Received: by 2002:a02:c492:: with SMTP id t18mr65823345jam.67.1563691071187;
        Sat, 20 Jul 2019 23:37:51 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id n17sm29474573iog.63.2019.07.20.23.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 23:37:50 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     kjlu@umn.edu, smccaman@umn.edu, secalert@redhat.com,
        emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] allocate_flower_entry: should check for null deref
Date:   Sun, 21 Jul 2019 01:37:31 -0500
Message-Id: <20190721063731.7772-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

allocate_flower_entry does not check for allocation success, but tries
to deref the result. I only moved the spin_lock under null check, because
 the caller is checking allocation's status at line 652.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 312599c6b35a..e447976bdd3e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -67,7 +67,8 @@ static struct ch_tc_pedit_fields pedits[] = {
 static struct ch_tc_flower_entry *allocate_flower_entry(void)
 {
 	struct ch_tc_flower_entry *new = kzalloc(sizeof(*new), GFP_KERNEL);
-	spin_lock_init(&new->lock);
+	if (new)
+		spin_lock_init(&new->lock);
 	return new;
 }
 
-- 
2.17.1

