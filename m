Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88B346C3B8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhLGTfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbhLGTfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 14:35:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BA2C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 11:32:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso254427pjl.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 11:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j2D/6ZjxS8l0T6vGxlryRAPT5kM3gSJLzys2PNellyY=;
        b=M9PWQztRJ4PlVm0cykhO+r/D3epx433R73tfEolB5NuSkd9or0CIJ4yxF6YBSgC8GZ
         s22yhuQXM2cL/6ix0/YfqYgybMyihaW34Z3KSbLBOlq02U5EoP7JTp7R2/FL29jWRISs
         iYEN+4yR+H2fyo9biXg+UOT4TIVYelH+dg1xoQkVdjnue+H+zLM1/U75Zg6ir4L71rY7
         Aculwg67NSVcJQhojSLxpxBK4ShVQK847yi/kfcTOWtwEB9759xm5suwLYI4+e+mEGcG
         4Io0S3PbPviZWnh/Nad19fAKqpJwMOGzsb4TP6K5LI04sxnxn1MXqm9NlCAxntbWtzYB
         gu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j2D/6ZjxS8l0T6vGxlryRAPT5kM3gSJLzys2PNellyY=;
        b=w2S9YCVWPiZGnc/W8BVzC9EJABDLDUffp6eg+251EGxVyqjZaj4I+Tpr624OwXRDcc
         i+BhLt+leAbdtDO7PK5R752Gwk0zPL+lmYxVpiQVumAiPe12B+IvcJRxq9YwEH5VFDEN
         uXpxY21Qr089UsNhM1vOwbZipiwwwZ1fzjV41BzVFbncDqB7qLxkJS/6jOX7cZCScLQr
         HIWGvQucYuEgirCcZOV9w1cyzgcJp3GGWUXFjV1YR8kaUfcC1AJnyIyrKgNMhdKCk26t
         C3aW4WX5A22cIiijm2hps0tRvEIIkM8kE7VhMU7FCBI59XxZuPK9sPATwUmz2fSP7sua
         iAkw==
X-Gm-Message-State: AOAM530B+ruwUmkUrD1zhuobqXayWMHNNUvayQKIfqaf/3YGJQMQFEta
        ImfdqYbFPpNWuRVsmOwayh8=
X-Google-Smtp-Source: ABdhPJwBGcPBULx9nU3RqJFqPDuz0ZS9rhCDqcI707nWDiBxf7bWslLqbk001VlorGjIblQ0c19yeg==
X-Received: by 2002:a17:902:f24a:b0:141:c6fc:2e18 with SMTP id j10-20020a170902f24a00b00141c6fc2e18mr54011500plc.55.1638905526905;
        Tue, 07 Dec 2021 11:32:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:387:45f:971d:350a])
        by smtp.gmail.com with ESMTPSA id e35sm267420pgm.92.2021.12.07.11.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 11:32:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <amwang@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next] xfrm: use net device refcount tracker helpers
Date:   Tue,  7 Dec 2021 11:32:03 -0800
Message-Id: <20211207193203.2706158-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

xfrm4_fill_dst() and xfrm6_fill_dst() build dst,
getting a device reference that will likely be released
by standard dst_release() code.

We have to track these references or risk a warning if
CONFIG_NET_DEV_REFCNT_TRACKER=y

Note to XFRM maintainers :

Error path in xfrm6_fill_dst() releases the reference,
but does not clear xdst->u.dst.dev, so I wonder
if this could lead to double dev_put() in some cases,
where a dst_release() _is_ called by the callers in their
error path.

This extra dev_put() was added in commit 84c4a9dfbf430 ("xfrm6:
release dev before returning error")

Fixes: 9038c320001d ("net: dst: add net device refcount tracking to dst_entry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/xfrm4_policy.c | 2 +-
 net/ipv6/xfrm6_policy.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 9ebd54752e03b81a01f6c53cc17cebbccd928137..9e83bcb6bc99dd8cb7e71c9f1dbb5b7ae5570626 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -77,7 +77,7 @@ static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	xdst->u.rt.rt_iif = fl4->flowi4_iif;
 
 	xdst->u.dst.dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &xdst->u.dst.dev_tracker, GFP_ATOMIC);
 
 	/* Sheit... I remember I did this right. Apparently,
 	 * it was magically lost, so this code needs audit */
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index af7a4b8b1e9c4a46a0b0cf4245a981efa24b9152..fad687ee6dd81af9ee3591eb2333cfed8ceae8ce 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -74,11 +74,11 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	struct rt6_info *rt = (struct rt6_info *)xdst->route;
 
 	xdst->u.dst.dev = dev;
-	dev_hold(dev);
+	dev_hold_track(dev, &xdst->u.dst.dev_tracker, GFP_ATOMIC);
 
 	xdst->u.rt6.rt6i_idev = in6_dev_get(dev);
 	if (!xdst->u.rt6.rt6i_idev) {
-		dev_put(dev);
+		dev_put_track(dev, &xdst->u.dst.dev_tracker);
 		return -ENODEV;
 	}
 
-- 
2.34.1.400.ga245620fadb-goog

