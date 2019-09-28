Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8363C127D
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 01:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfI1Xkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 19:40:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32836 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfI1Xkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 19:40:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so11258224wme.0
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 16:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H0rOdULGOXvh7HrVp8ppExmcLgFrhdpnvBepWmanWCo=;
        b=KcG36WIDBlYbDNsJwYNr7TfqIYfIp9Hmh7vDFryL+XL/qWR0f4mFnTi29kCy4WW1eM
         zVffTmQ3DTzb5zrynTDbyGtyhvqpE2G3Mff6Iccrfz4qtOolK6qM1beNTzAQ3Jg+OF+Z
         L+XGroXISvlgQuLT8MMbBCOsi2tK/G+0QZ4VXIVnwYiuLm+MRB8lvVh0eC7CYHeB8g6O
         Cn16p3MfCCC2dgEUS2A04zdlkh3faBxWPfRiQD3j6XjZ/6s2d3f2r8R7Lqf0g5XKL60d
         whAYYCme4BzK9lroGDYnvlZvI1KIx1VgwFq1dFkOgZO7mmDzYIyIYc32rkXidKaIRVOQ
         MLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H0rOdULGOXvh7HrVp8ppExmcLgFrhdpnvBepWmanWCo=;
        b=BX6JkBRGBzkRLqG0Zi4UOMBXXjqTQbjGeoGfmC3QXJ/3QBdWxm51TFUkabhx8LF4mR
         LdoXR8BErDBQ9nFS+DWZK/XcPesUGVCLuKlIpa0vYczMmJhnaNZn5ueoLruqDzmf0aSZ
         AwcWdNqDUZCnKMH7EeiRVO68aWSmPNB7SOFgE/82jd7FkS1R+knqBAT9NLJ9huGpulBD
         Hwauvt+RMKFwKnHpWueVb/M6uYgAE2FkUF+WIkQrYurJa2XHGHnXwdAAgl1WOvuZu9tg
         h4kCqo5Y97WBCjezphCq6rXOeVUwH8TT9GHDJMJDrsDCb9u3BomrML7EeewZh+AEgBJX
         x1+A==
X-Gm-Message-State: APjAAAUg4mGnAzvdEdOZJg77SkPDMMU44qrPjVtdOONBBVBTA16aQBgF
        sGb9sm9EqRBYYuIRCOneIFQ=
X-Google-Smtp-Source: APXvYqwYTeu7MxSgN2O4i+xCvy1goPjNGwduQwz7BcUENJTk09/QWqnKH161noT1p7owyD/VHdWi+w==
X-Received: by 2002:a1c:c5c3:: with SMTP id v186mr11807180wmf.125.1569714040354;
        Sat, 28 Sep 2019 16:40:40 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id t13sm12967623wra.70.2019.09.28.16.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 16:40:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: sched: cbs: Avoid division by zero when calculating the port rate
Date:   Sun, 29 Sep 2019 02:39:48 +0300
Message-Id: <20190928233948.15866-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in the "net: sched: taprio: Avoid division by zero on
invalid link speed" commit, it is legal for the ethtool API to return
zero as a link speed. So guard against it to ensure we don't perform a
division by zero in kernel.

Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/sched/sch_cbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 1bef152c5721..b2905b03a432 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -306,7 +306,7 @@ static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 	if (err < 0)
 		goto skip;
 
-	if (ecmd.base.speed != SPEED_UNKNOWN)
+	if (ecmd.base.speed && ecmd.base.speed != SPEED_UNKNOWN)
 		speed = ecmd.base.speed;
 
 skip:
-- 
2.17.1

