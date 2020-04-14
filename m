Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D351A7256
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405168AbgDNEQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405148AbgDNEQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:16:44 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AC7C0A3BE2;
        Mon, 13 Apr 2020 21:16:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id u13so12222424wrp.3;
        Mon, 13 Apr 2020 21:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SXFXDht7/3iXzvI5k60WQfsBzoAI9Y3+puLs1Yp6VtY=;
        b=YNkCAZdknXK8VmHZ0F4x4nF47T2prrmOKC/yEOWk3nGbcOx8VquapD9JJceuakhCY6
         6kvUNrn+E+xETPUkALedeJFBA8i17rBIHTn4wOxYobMpZFQtaw4q1iS6z+eZnpmHwbBd
         OgCDKSTrSYtCDJfnHBFrV+EHwnwMA+knrJ51Q6QWBbCZJgN4xOQ3C9/0UCxSoChpEZc1
         MNGnapOeY6n55g7Rw6MjLSM/4l79U0/V72Wf3cCL+7MQY7vB5il8XFwWHTphIvX/d30e
         u2RrjeICrrmZFtsLBZTBzqnzR8N8KJPp/V9Wemr/AoCAWO0NcjCCvFMTgVdw+YyOrPcT
         NFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SXFXDht7/3iXzvI5k60WQfsBzoAI9Y3+puLs1Yp6VtY=;
        b=RcTEaiKRaaXY7o+085T0E9psq+deifwxAvD4N1Ih5kv/Ooci1SvbvXOHdD6ocYiRtd
         itGhplo20hua+z8fsPWran60E7Bh1mxwDHe9OB4dw4CPrzYf31M2tiLqwOMk01hng06w
         Zuq6USDbiTRxyell5f3uyO43m22Mvns+O/FUmZ1OvirfyvF4TOb2LuQgY0xP13+wDd9M
         X60SGtbCuw1iiqYD95rXzCvgRTvSAOpdO+i+ed3my/MFaLB4lROQBCAJJ6TVkXEw0oHt
         wDs+TWAMv1ZO/DAhCz7ludui8Et/ke+TJuleWk5l4Yfy/xZ2q+xC8X6EVGtqcCWJb7gD
         0KuQ==
X-Gm-Message-State: AGi0PuYRanXgQU11/naH8NgZp4iACDlqVBjoO2aR/03KxTorqbUVgT9H
        psGKrhZbg0d0COviGpDfVjk9E3C3
X-Google-Smtp-Source: APiQypIcZDxxr2Eu1lQZSjSFJyoLmGE3ZTB8XGWig3h8cGrZ3uZ0abVEthSGjKHd95e3BVxrCkgQjg==
X-Received: by 2002:a5d:410a:: with SMTP id l10mr21315456wrp.355.1586837802152;
        Mon, 13 Apr 2020 21:16:42 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n4sm16704471wmi.20.2020.04.13.21.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 21:16:41 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net 2/4] net: dsa: b53: Fix valid setting for MDB entries
Date:   Mon, 13 Apr 2020 21:16:28 -0700
Message-Id: <20200414041630.5740-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414041630.5740-1-f.fainelli@gmail.com>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When support for the MDB entries was added, the valid bit was correctly
changed to be assigned depending on the remaining port bitmask, that is,
if there were no more ports added to the entry's port bitmask, the entry
now becomes invalid. There was another assignment a few lines below that
would override this which would invalidate entries even when there were
still multiple ports left in the MDB entry.

Fixes: 5d65b64a3d97 ("net: dsa: b53: Add support for MDB")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index fa9b9aca7b56..e937bf365490 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1561,7 +1561,6 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		ent.is_valid = !!(ent.port);
 	}
 
-	ent.is_valid = is_valid;
 	ent.vid = vid;
 	ent.is_static = true;
 	ent.is_age = false;
-- 
2.17.1

