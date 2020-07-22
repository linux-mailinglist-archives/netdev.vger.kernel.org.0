Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7092D2296C9
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgGVLBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGVLBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:01:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBFCC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:01:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p1so800186pls.4
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/lw3L2a4O6r9+8ujRDSrWE8Z9WKk+Ix5MhB5UaF3Ks=;
        b=aN4DaK5g7tWRGugpRFhlfT++AV0FJ8hMycQ9kLmkaj60XmSafduW25uhNXH0KnV51F
         WX3ihi0uM/2v2OF2mQHwStLtfEVWDQvHpPNsCqPD06MeNEEi6+NW/MhFXp2fwac1p2DM
         b0o497LMfLuWrsNP00dg2El5fpfYEP3vCfrm7QrvyXqOxd2ve4KIohTc6w8zRLluvEDA
         xicNg/Eiv7fYfUHR9pymJTPTgZeHpV34XaOVFDHrRZSDyGwgUz9+nFdnLDI2woKug1F8
         6JY+KXSoAjjyJ6ZKy6MK6QmQEb6ashgCZP9qSSmRxAmAmNvckfOtkuzZVw3LKU9ti2K6
         GdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/lw3L2a4O6r9+8ujRDSrWE8Z9WKk+Ix5MhB5UaF3Ks=;
        b=CwMS8e0c67VRml5Xt2IHsUZwB9Fj68KkHdgP0a8OAZsGzQ9DJMudrPSbtYQkvOVGSe
         hBydD2Q8pSY9SqAe53xYWDxsjnH/yjhNwnKGZieMMyWvVD0/vAQpR78S71y9ybD4fSRj
         t2xYj031fsWCK6i/xEgXEmjFv0P7sfxfhbr2UZlyxU2M+AGccq3pm39ae0DynbWqr5fn
         NP5FtJAFkmLb/kz5muMUfqtesTItT1kNbfn6y0bMrLuiOt9oD6tyin4Gr/zyMcYSpxBY
         HXAuhoVfRzhnOfZZgT70n64LlRBfxMMemvPvHh4PZiy+OePXgs7YjxEPM9lwGqkplBRj
         i3eA==
X-Gm-Message-State: AOAM531xTW08idop07I43lfBpIKTLYe0rXXzEe1pw5WnrD9Zbe/hH/J/
        e0fNoKmpXU2xxnuQVJCI2YTxxQ==
X-Google-Smtp-Source: ABdhPJxRpXIIC0VKbI6quRIEHj6Nui9ulEJ5hOugSp6d9DYf8+st0/Z1rRVcorJnkX/hgDOcMLEe1A==
X-Received: by 2002:a17:90a:f206:: with SMTP id bs6mr9533822pjb.48.1595415673141;
        Wed, 22 Jul 2020 04:01:13 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:0:4a0f:cfff:fe35:d61b])
        by smtp.gmail.com with ESMTPSA id d190sm23074673pfd.199.2020.07.22.04.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 04:01:12 -0700 (PDT)
From:   Mark Salyzyn <salyzyn@android.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] af_key: pfkey_dump needs parameter validation
Date:   Wed, 22 Jul 2020 04:00:53 -0700
Message-Id: <20200722110059.1264115-1-salyzyn@android.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pfkey_dump() dplen and splen can both be specified to access the
xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
when it calls addr_match() with the indexes.  Return EINVAL if either
are out of range.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
---
v2: Added Fixes tag

 net/key/af_key.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index b67ed3a8486c..dd2a684879de 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1849,6 +1849,13 @@ static int pfkey_dump(struct sock *sk, struct sk_buff *skb, const struct sadb_ms
 	if (ext_hdrs[SADB_X_EXT_FILTER - 1]) {
 		struct sadb_x_filter *xfilter = ext_hdrs[SADB_X_EXT_FILTER - 1];
 
+		if ((xfilter->sadb_x_filter_splen >=
+			(sizeof(xfrm_address_t) << 3)) ||
+		    (xfilter->sadb_x_filter_dplen >=
+			(sizeof(xfrm_address_t) << 3))) {
+			mutex_unlock(&pfk->dump_lock);
+			return -EINVAL;
+		}
 		filter = kmalloc(sizeof(*filter), GFP_KERNEL);
 		if (filter == NULL) {
 			mutex_unlock(&pfk->dump_lock);
-- 
2.28.0.rc0.105.gf9edc3c819-goog

