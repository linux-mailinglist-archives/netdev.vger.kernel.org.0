Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7859F392C1F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhE0Kt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbhE0Kt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:49:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7504C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:48:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z17so4248163wrq.7
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ohvBACWV5LDam32O5DXli6hP49rS6nusm5l3Pi9Ge5k=;
        b=ccjm1qUN09GfpTnvIQ6ZeE5OPcqJj6wuDRJUTPf1DgkZU1Oe35QHpbPP3ArOaUhB19
         vBXoRpdkGhlDp+JjoE6sCqr+39OJuQV70CyYXQCOVxM8GmoHASeTZuaEJdDRQ2wOBVKG
         0vqJ7ymHmIx+iyWpAWZp3m0hFyWzywObKRSlv4Q3mp+ubJn/s5l8FmjpDtsiT7ZGvz0R
         azM+oRC390+HOy3JPL84V6agiRWyLgn3BuqMNdWD6W+5TTWRdJcXwdFxP7oZNnlYB7QL
         stPwa9AmC6NpCBHOK43Fne+U0/V4ceVm+HaztZ/0utgWku1RNb3Z3YcJMfFuSYszqvhD
         v7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ohvBACWV5LDam32O5DXli6hP49rS6nusm5l3Pi9Ge5k=;
        b=EzmlYwQHR4eJzpkqf7zmXqFDlslXgPycIXPv9ivVbCHwt3kkfswft1jdV8MST1fE3U
         2jHRqzYoIpVEl4HrNCuDW1ePDJDQLoT0F3p9r0Jj4as80DJhgVBkemuDqrC0d1bdMYQa
         SM22Kc+JkqUb6NsvZTtIxT2bsRb40f++UoaG8XJv6EaiywggbRfLZNsgDRK9LmrJ0/Ao
         XOnSb/vEob3BQ1wKlXXfl4xarV7uOy3g3XgdbH3fNc2xnwfcyD/yvQKU1yiDt/rXCQgo
         c8ePPclRziXT71X18nWsYmDQs1fj8Xhow47mUFHhTF7N5OEODvcKlmHAF+2/u0TpX2ss
         nTfw==
X-Gm-Message-State: AOAM532uh2HKm2gK3piQ2CK5JOzrs8j6d/24nb/RJ33Le/faqD3pjgr5
        aWL7N10MgFGk4CJfrDiw/aN84q9CxDVhcCQe
X-Google-Smtp-Source: ABdhPJx8mQdjfp9YVnA0/X+3D89XuLfaIMBRvP78gn2WhWGZEKjbRYgkYGDc/TgYf3xGRdIY5nqjjA==
X-Received: by 2002:adf:ce0b:: with SMTP id p11mr2076487wrn.335.1622112501414;
        Thu, 27 May 2021 03:48:21 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id u14sm9955257wmc.41.2021.05.27.03.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 03:48:20 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com
Subject: [patch net-next v2] devlink: append split port number to the port name
Date:   Thu, 27 May 2021 12:48:19 +0200
Message-Id: <20210527104819.789840-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of doing sprintf twice in case the port is split or not, append
the split port suffix in case the port is split.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- added check for buffer overflow
---
 net/core/devlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 06b2b1941dce..8f9a5de44117 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8632,12 +8632,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->phys.port_number);
-		else
-			n = snprintf(name, len, "p%us%u",
-				     attrs->phys.port_number,
-				     attrs->phys.split_subport_number);
+		n = snprintf(name, len, "p%u", attrs->phys.port_number);
+		if (n < len && attrs->split)
+			n += snprintf(name + n, len - n, "s%u",
+				      attrs->phys.split_subport_number);
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-- 
2.31.1

