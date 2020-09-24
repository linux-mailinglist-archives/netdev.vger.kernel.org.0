Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E90276563
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgIXAsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:48:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D674CC0613CE;
        Wed, 23 Sep 2020 17:48:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d13so798803pgl.6;
        Wed, 23 Sep 2020 17:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=IeSXMBVcVqOJv+ick5hpJlRuUlPUh1dEBXZ1ahX+5iQ=;
        b=qazrzgmEz80xNxddpR8Ymwev6mBT9p1Gd//S9xmd/LufiF1CERFfGj5PtdccwRv78S
         1sP3FOfQWXHM4Wt9V+qFTib5icZjrlDuKUeqFXGgfwDjpqy53DIHwm3taMwi1tUXN3aR
         EXCPBtVQgDBVhn7p+jnj2C5Tn//tntVHn5YSmNMPl8CgmocUlufQk0+L4EU8oeAi08xf
         WN1q9ZEz570rnwvv8+nyeLjlJNdf24x2n68udhYpRECVn/6+syTGiyz7euVG2Y/jQT4W
         CbwC0MPjz4KqHRwKcGKgRP2l0Pv3cvj6+iw6TZc2hx7XksY9YHZpWmtLme4957hBRfG0
         WXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=IeSXMBVcVqOJv+ick5hpJlRuUlPUh1dEBXZ1ahX+5iQ=;
        b=s8B3/ZApwoj5312790VdcAyI9uxXQznyGA7jpbzkwQqQRK+upDpv8dcTIx5zypYdHd
         F95Su+UlgfLuxQujfrMmjZkwo++AiwVSRvoBArc9/m4zDUjqkVWvia1hH+g6HZy7vZTr
         Njtf4aV0XIZq5IZnYEHDJQsKqMAR/2NsRMLg5gBmISSEjo71cQB5/bDkxZPLiNI8fmjS
         TrSKntjJgMKsAaRTmPaWJtL0e1ssi5F3XNECMv8Ov01GcXd7bKCjBjtsCu5vRzjkiidN
         3+sMcXcxgYW4RIKTSoOazkEqNlRUyq4Ab7dOn2zVr5oBTUw9yHfehSiRLuUp8v2ZNM7l
         EJQA==
X-Gm-Message-State: AOAM533B/MP8pajzu/1gd4OtjR5kniMavHLAqPA4pbmnLolEsgK6Kr74
        yveVb2g2cBWbgSE3Cj4Qdz0=
X-Google-Smtp-Source: ABdhPJwTXwvZmpuuH0Dohsw8+m3zb/qXZWYKtOXMNtxNyDebN16JVnpjXeNu6RXcgz8x+zxpLvk3cA==
X-Received: by 2002:a62:3706:0:b029:142:2501:39e5 with SMTP id e6-20020a6237060000b0290142250139e5mr2346642pfa.52.1600908480415;
        Wed, 23 Sep 2020 17:48:00 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id v1sm5724363pjn.1.2020.09.23.17.47.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:47:59 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 07/16] mptcp: add accept_subflow re-check
Date:   Thu, 24 Sep 2020 08:29:53 +0800
Message-Id: <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com> <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The re-check of pm->accept_subflow with pm->lock held was missing, this
patch fixed it.

Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 39a76620d0a5..be4157279e15 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -48,7 +48,7 @@ void mptcp_pm_new_connection(struct mptcp_sock *msk, int server_side)
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
-	int ret;
+	int ret = 0;
 
 	pr_debug("msk=%p subflows=%d max=%d allow=%d", msk, pm->subflows,
 		 pm->subflows_max, READ_ONCE(pm->accept_subflow));
@@ -58,9 +58,11 @@ bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk)
 		return false;
 
 	spin_lock_bh(&pm->lock);
-	ret = pm->subflows < pm->subflows_max;
-	if (ret && ++pm->subflows == pm->subflows_max)
-		WRITE_ONCE(pm->accept_subflow, false);
+	if (READ_ONCE(pm->accept_subflow)) {
+		ret = pm->subflows < pm->subflows_max;
+		if (ret && ++pm->subflows == pm->subflows_max)
+			WRITE_ONCE(pm->accept_subflow, false);
+	}
 	spin_unlock_bh(&pm->lock);
 
 	return ret;
-- 
2.17.1

