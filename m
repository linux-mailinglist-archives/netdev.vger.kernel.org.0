Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C3232DBD0
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbhCDVap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239444AbhCDVae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 16:30:34 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E1DC06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 13:29:54 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id cw15so13586880qvb.11
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 13:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=x4Z+DisI/8o2HYT+CH6xxotXu806Acbm+rcHwITIcF4=;
        b=LKOLjajsWej/VvbaJrfgnDS8nl8lXk2eR1wWHPrZNYJGajh1g/xYlRCIDYHOKSFBSG
         RDiQRtzKhyn44xj9nSowEDjNAGSEopsVNLWWiCATCxCLB4ETqiV8h/sM2Aix+3onQ1d8
         OhFEmYiF3xBdtg2GAWW14TABFhd+sv/IhK1LbUxTTxWa+RA/uz/OxDNofkNgZMer4qMA
         af4VkYvUCrjyfcIz7flYEXRukNYm2vnoUOomQNiYugbP+YqCGlkL1u1EKICnt3IFL8VU
         9Wwa+CoQJjFGP6qr0Oo5v5sKP9mUS+pE8u+9lyXOz7wLirRScdOXdvcFuNav9ZIZVRzH
         UiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=x4Z+DisI/8o2HYT+CH6xxotXu806Acbm+rcHwITIcF4=;
        b=YwvT8ql2n4RTEVpntwc8CaWuvhWpsxBcaMEF1Sbw5yuulu4+jT1bFckyJ6GMP727VZ
         JDO1XFde5H2dEljIBicIkDFR8J231FyCIWYjB43/YMzZSQEzebZOhrYNVzIyiz739tUy
         Rnws1cuvBfEZ5HGwkfoEfBXGoDhawXPeavPAyb22+3ZF7DcqQzA1B01EgXOK/BVM8uWv
         2HkPD/9rp4Ke79y3g1Mzpc2TorYpaC+5X3zlXA+z5/fZjks969u/cF3L2tet7iHUHl85
         Y7Ty0g0T7iAwuJsSIEc03chHOFaT4xZGo9/UL5LgZPz4N4M0YP6oa9euqM2m0f4JBiUh
         412A==
X-Gm-Message-State: AOAM531QEA1taqn0tEzeYybHyDJyAPeURQJXwbRDTNSVSiKhra597OLE
        fNrBAnol3//4123sXl8lS3pPbCBfbh+e804=
X-Google-Smtp-Source: ABdhPJwdITITDox4GcVh6xb24molA1ZfNb1cR2YE1+P++Zm/LjSddQ/IITvYLY3uFTL3mFwiOs6XyA==
X-Received: by 2002:a0c:f946:: with SMTP id i6mr6063551qvo.40.1614893393105;
        Thu, 04 Mar 2021 13:29:53 -0800 (PST)
Received: from localhost ([151.203.60.33])
        by smtp.gmail.com with ESMTPSA id z65sm606102qtd.15.2021.03.04.13.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 13:29:52 -0800 (PST)
Subject: [PATCH] cipso,calipso: resolve a number of problems with the DOI
 refcounts
From:   Paul Moore <paul@paul-moore.com>
To:     netdev@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 04 Mar 2021 16:29:51 -0500
Message-ID: <161489339182.63157.2775083878484465675.stgit@olly>
User-Agent: StGit/1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current CIPSO and CALIPSO refcounting scheme for the DOI
definitions is a bit flawed in that we:

1. Don't correctly match gets/puts in netlbl_cipsov4_list().
2. Decrement the refcount on each attempt to remove the DOI from the
   DOI list, only removing it from the list once the refcount drops
   to zero.

This patch fixes these problems by adding the missing "puts" to
netlbl_cipsov4_list() and introduces a more conventional, i.e.
not-buggy, refcounting mechanism to the DOI definitions.  Upon the
addition of a DOI to the DOI list, it is initialized with a refcount
of one, removing a DOI from the list removes it from the list and
drops the refcount by one; "gets" and "puts" behave as expected with
respect to refcounts, increasing and decreasing the DOI's refcount by
one.

Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking with refrerence counts")
Fixes: d7cce01504a0 ("netlabel: Add support for removing a CALIPSO DOI.")
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 net/ipv4/cipso_ipv4.c            |   11 +----------
 net/ipv6/calipso.c               |   14 +++++---------
 net/netlabel/netlabel_cipso_v4.c |    3 +++
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 471d33a0d095..be09c7669a79 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -519,16 +519,10 @@ int cipso_v4_doi_remove(u32 doi, struct netlbl_audit *audit_info)
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!refcount_dec_and_test(&doi_def->refcount)) {
-		spin_unlock(&cipso_v4_doi_list_lock);
-		ret_val = -EBUSY;
-		goto doi_remove_return;
-	}
 	list_del_rcu(&doi_def->list);
 	spin_unlock(&cipso_v4_doi_list_lock);
 
-	cipso_v4_cache_invalidate();
-	call_rcu(&doi_def->rcu, cipso_v4_doi_free_rcu);
+	cipso_v4_doi_putdef(doi_def);
 	ret_val = 0;
 
 doi_remove_return:
@@ -585,9 +579,6 @@ void cipso_v4_doi_putdef(struct cipso_v4_doi *doi_def)
 
 	if (!refcount_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&cipso_v4_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&cipso_v4_doi_list_lock);
 
 	cipso_v4_cache_invalidate();
 	call_rcu(&doi_def->rcu, cipso_v4_doi_free_rcu);
diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 51184a70ac7e..1578ed9e97d8 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -83,6 +83,9 @@ struct calipso_map_cache_entry {
 
 static struct calipso_map_cache_bkt *calipso_cache;
 
+static void calipso_cache_invalidate(void);
+static void calipso_doi_putdef(struct calipso_doi *doi_def);
+
 /* Label Mapping Cache Functions
  */
 
@@ -444,15 +447,10 @@ static int calipso_doi_remove(u32 doi, struct netlbl_audit *audit_info)
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!refcount_dec_and_test(&doi_def->refcount)) {
-		spin_unlock(&calipso_doi_list_lock);
-		ret_val = -EBUSY;
-		goto doi_remove_return;
-	}
 	list_del_rcu(&doi_def->list);
 	spin_unlock(&calipso_doi_list_lock);
 
-	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
+	calipso_doi_putdef(doi_def);
 	ret_val = 0;
 
 doi_remove_return:
@@ -508,10 +506,8 @@ static void calipso_doi_putdef(struct calipso_doi *doi_def)
 
 	if (!refcount_dec_and_test(&doi_def->refcount))
 		return;
-	spin_lock(&calipso_doi_list_lock);
-	list_del_rcu(&doi_def->list);
-	spin_unlock(&calipso_doi_list_lock);
 
+	calipso_cache_invalidate();
 	call_rcu(&doi_def->rcu, calipso_doi_free_rcu);
 }
 
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 726dda95934c..4f50a64315cf 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -575,6 +575,7 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 
 		break;
 	}
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
 
 	genlmsg_end(ans_skb, data);
@@ -583,12 +584,14 @@ static int netlbl_cipsov4_list(struct sk_buff *skb, struct genl_info *info)
 list_retry:
 	/* XXX - this limit is a guesstimate */
 	if (nlsze_mult < 4) {
+		cipso_v4_doi_putdef(doi_def);
 		rcu_read_unlock();
 		kfree_skb(ans_skb);
 		nlsze_mult *= 2;
 		goto list_start;
 	}
 list_failure_lock:
+	cipso_v4_doi_putdef(doi_def);
 	rcu_read_unlock();
 list_failure:
 	kfree_skb(ans_skb);

