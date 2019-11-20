Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D0E10354F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfKTHkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 02:40:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37591 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKTHkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 02:40:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id f3so3773239pjg.4
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgSP24loHZw6jwqErmf4Bp/5oiIuWZ7J2UnOMQvOIWo=;
        b=kqaUe2ZH145iWV9XVU9k3hiy99NvOaiNXpz6mVZwbcx5MDLuE//kzM8PIGfWNdbrRb
         CPfy/pAqa63eL52MVQn4qzko8eV01mJSMwA96Nnli4KoVGoofAUwD2q4RhGDv17dVbT1
         zlF8lCDa3tpvjHlIdXYZ/ifmUVC5TeFW/wWm1wY7nDQLm6kyH8Hgw8f5gmhDUBx2jpZ1
         izIN0Ywrwajhi8hG6Woyt0fXIS7/cbHj7MFuUwb/GoHElMUy7xN5pXT6Em40Gkt76f8M
         ciJJk92GFqRqJ2PCyw5j29B9LzyXgy/1g2Yunm5z8tTeV2QuNCXYKuhq2HDpxe1PcCEM
         sXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgSP24loHZw6jwqErmf4Bp/5oiIuWZ7J2UnOMQvOIWo=;
        b=sXI9YEA0d8Alv+6DWfbJaAwl/1XQMgKrotIREKGfl+TBvc6mWSDGMapIUWdjQoAvtD
         hpWlX8+A0FXvVldcAcGeX4lc+ZIdxbRm9MGCXDkjhcxByINDk6+sJ/qF+zbWRxzuu2Ch
         Msq5cpHixnHovHzGxZWOewMcFD5J1RJhxuAzuCaa+1xOvhCqq/sHdYX7mi3b0//GoPoH
         d1CF5jl/gAyr+U9iALK8wl/a4dCzCAeirlY9Nolvhpae+RM+ERbb5I6VyCtfNrR80ARw
         0aQVMeG48Et2ZB3gIHApmyOP/NM48PP6Dj/V4DSl1XlKwe644eLF7CFZzAO+UovzslSv
         7EKg==
X-Gm-Message-State: APjAAAVNB0nWuZ9dsE9vYW3beHveiRxxzYqwrV5EaStOlP2du7+qhQqX
        l0Xmv9XWi5cMFxfb/Q+5EYspuEdnFJMRnw==
X-Google-Smtp-Source: APXvYqxdSjTWFc41Qzf0B2n9U0zzoA8YTIM8pPJuvyI6MUi/D64nFqksIrZnG4RAwkV4q1XHMbrUQg==
X-Received: by 2002:a17:90a:2369:: with SMTP id f96mr2205127pje.127.1574235604475;
        Tue, 19 Nov 2019 23:40:04 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k5sm5793862pju.14.2019.11.19.23.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 23:40:04 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipv6/route: return if there is no fib_nh_gw_family
Date:   Wed, 20 Nov 2019 15:39:06 +0800
Message-Id: <20191120073906.15258-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously we will return directly if (!rt || !rt->fib6_nh.fib_nh_gw_family)
in function rt6_probe(), but after commit cc3a86c802f0
("ipv6: Change rt6_probe to take a fib6_nh"), the logic changed to
return if there is fib_nh_gw_family.

Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e60bf8e7dd1a..3f83ea851ebf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -634,7 +634,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	 * Router Reachability Probe MUST be rate-limited
 	 * to no more than one per minute.
 	 */
-	if (fib6_nh->fib_nh_gw_family)
+	if (!fib6_nh->fib_nh_gw_family)
 		return;
 
 	nh_gw = &fib6_nh->fib_nh_gw6;
-- 
2.19.2

