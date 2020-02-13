Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A97315B9D0
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 07:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgBMGya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 01:54:30 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54796 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgBMGya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 01:54:30 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so1955582pjb.4;
        Wed, 12 Feb 2020 22:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8OPE3QClCM3tJ/k8M5VunHmvW/7oEs/dWvoTT+1C/w=;
        b=BGCcKoMqQT1f4WrwRoQM+uU2rWZx8+pR3R+Hto3Iy59l7qrYHGsbyCBMFRD/UIW9cG
         m0mWDZpfJ6DlISgJcZRZNN3qj3IEgPDqqXF2MhCNl/yszIYtXTvPfV9xEShYAwVjahlY
         98WFL2jzaLBe2RGwdtpOKb0eoFkemjBRu86EBa21KDtKnKm0TpVHW4iaJcTurHka74y0
         qmUwtw360q7GN9vDUTWVf7Ws0grYk+1t3yE321JUKs2VVEuWIWUcam36qVVDi2leiXKQ
         eAYR7/pbXCraf0rLYbiv3geSGoHbK17fO1oc1RoAbT3oozHfF0qFS3U+BLmSD/zCx7Ui
         Fc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8OPE3QClCM3tJ/k8M5VunHmvW/7oEs/dWvoTT+1C/w=;
        b=gD3CFgOrG+JKtRUT3gC5fp5YxuUtb94QKG59fHNTWZeVZcrcoChGdrmdD1XxxDgELi
         kJyUWqlRO0BSv2bKlPxsgk7qRGkz2g7M/UFPbLIQKhdCUG7o1Cwpq/VAzAb09MAinbQh
         sLNcXF0yFWhsViLd9bqGkApdx3rvJPV6wI2h1M2xPNIRp04jILuJxICPx1QpGiuh3Ipp
         CxSGFUmSxouibOtNEUBOMFENRfiwceRuk/zyOesEt1pfZCL54ejfmjcWT9LH7887wx3w
         yUxFvcuUBsLmaiYFyI91xQ9vQtVIVXG/DZ1FGuETNRb4nRq25zD68uIRWpxi06aIjthk
         xgUA==
X-Gm-Message-State: APjAAAX4UrLsY+i+WsL1+bfdcItCyzeo7/gCKIF2L23qN3nJt1RSp6UY
        oCYV0Rpzu1y+BxoIQGIAhW2Ck4Iw
X-Google-Smtp-Source: APXvYqymgooCRcFXaTTCTOB9wLJD4VlCpjgkje5+whVps+yfri+vh9v3RU5TRPt2N0KXXExfTus7pQ==
X-Received: by 2002:a17:90a:a78b:: with SMTP id f11mr3558719pjq.8.1581576867716;
        Wed, 12 Feb 2020 22:54:27 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id y16sm1430168pfn.177.2020.02.12.22.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 22:54:27 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [Patch nf] netfilter: xt_hashlimit: unregister proc file before releasing mutex
Date:   Wed, 12 Feb 2020 22:53:52 -0800
Message-Id: <20200213065352.6310-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before releasing the global mutex, we only unlink the hashtable
from the hash list, its proc file is still not unregistered at
this point. So syzbot could trigger a race condition where a
parallel htable_create() could register the same file immediately
after the mutex is released.

Move htable_remove_proc_entry() back to mutex protection to
fix this. And, fold htable_destroy() into htable_put() to make
the code slightly easier to understand.

Reported-and-tested-by: syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
Fixes: c4a3922d2d20 ("netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()")
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 7a2c4b8408c4..8c835ad63729 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -402,15 +402,6 @@ static void htable_remove_proc_entry(struct xt_hashlimit_htable *hinfo)
 		remove_proc_entry(hinfo->name, parent);
 }
 
-static void htable_destroy(struct xt_hashlimit_htable *hinfo)
-{
-	cancel_delayed_work_sync(&hinfo->gc_work);
-	htable_remove_proc_entry(hinfo);
-	htable_selective_cleanup(hinfo, true);
-	kfree(hinfo->name);
-	vfree(hinfo);
-}
-
 static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 						   const char *name,
 						   u_int8_t family)
@@ -432,8 +423,13 @@ static void htable_put(struct xt_hashlimit_htable *hinfo)
 {
 	if (refcount_dec_and_mutex_lock(&hinfo->use, &hashlimit_mutex)) {
 		hlist_del(&hinfo->node);
+		htable_remove_proc_entry(hinfo);
 		mutex_unlock(&hashlimit_mutex);
-		htable_destroy(hinfo);
+
+		cancel_delayed_work_sync(&hinfo->gc_work);
+		htable_selective_cleanup(hinfo, true);
+		kfree(hinfo->name);
+		vfree(hinfo);
 	}
 }
 
-- 
2.21.1

