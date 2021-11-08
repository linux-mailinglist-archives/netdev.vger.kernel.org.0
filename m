Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830A6447D66
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 11:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhKHKPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbhKHKPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 05:15:13 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E42C061714;
        Mon,  8 Nov 2021 02:12:26 -0800 (PST)
Received: from zn.tnic (p200300ec2f33110088892b77bd117736.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:8889:2b77:bd11:7736])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8B61B1EC0516;
        Mon,  8 Nov 2021 11:12:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636366345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81p4IKlZUJtfRfnIfPVwCEdhFh/UCrCf47nC2WuyJyI=;
        b=hk/VQz6TaLZ5BMhEiZkVv867QuxxYSUFl64uJ6A+1q39/ledBAMMCVtgeWcENM9g8qlIYX
        65yMvc3jmxRQpS1GqB+pTpQOLRn6gdf0F2JS8zIWyokH/hWhK/vNgePGV0kJ2iE/jRl1x8
        Mw4OhnKEFjN50AD+MrGOVZ5gLLz/Hxs=
From:   Borislav Petkov <bp@alien8.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v0 22/42] net: fib_notifier: Check notifier registration return value
Date:   Mon,  8 Nov 2021 11:11:37 +0100
Message-Id: <20211108101157.15189-23-bp@alien8.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211108101157.15189-1-bp@alien8.de>
References: <20211108101157.15189-1-bp@alien8.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Avoid homegrown notifier registration checks.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: netdev@vger.kernel.org
---
 net/core/fib_notifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index fc96259807b6..fa07d6a81ba0 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -86,7 +86,9 @@ static bool fib_dump_is_consistent(struct net *net, struct notifier_block *nb,
 {
 	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 
-	atomic_notifier_chain_register(&fn_net->fib_chain, nb);
+	if (atomic_notifier_chain_register(&fn_net->fib_chain, nb))
+		pr_warn("FIB notifier already registered\n");
+
 	if (fib_seq == fib_seq_sum(net))
 		return true;
 	atomic_notifier_chain_unregister(&fn_net->fib_chain, nb);
-- 
2.29.2

