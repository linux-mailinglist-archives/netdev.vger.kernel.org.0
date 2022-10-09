Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C57A5F932B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiJIW42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiJIWy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA23DF25;
        Sun,  9 Oct 2022 15:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2217AB80DEF;
        Sun,  9 Oct 2022 22:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE15C43144;
        Sun,  9 Oct 2022 22:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354369;
        bh=/XB4y2LpgVtKSLfj2FRGEXMsobFlbWAbbPzG5tqVxqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSQ0TR4Uh1yB+qc5ad//2rVZWhcrl3nJoV2PGGfVCljyS/7aKECytlNrsFGF1qzNC
         Rm1OEXdW/OdrtF84NNY9uO0j/KUmM66AIhxMxM82K0zWw2nURCnEgHPXcLG6GxnNhw
         JFjwRkf6BNQpXS0DHtciebutvjqxG1Ibs3PncOcnigD9rSdN8eHi26/u+J/G83Rjxx
         QzAk+2mBGiLfymhil9h5lTfBfgYc6EaQq0XWxurNOzbuZ4mUXecBmdjXDeeTBfLxT4
         SjZoHWzz7CMf6Tu/+4Fl4bEgAfxzauDbiXmMFmbXUwj2XQDVebUgs5Go9Op2O8wB6Z
         OMoHVYJsO+frA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khalid Masum <khalid.masum.92@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/23] xfrm: Update ipcomp_scratches with NULL when freed
Date:   Sun,  9 Oct 2022 18:25:36 -0400
Message-Id: <20221009222557.1219968-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Masum <khalid.masum.92@gmail.com>

[ Upstream commit 8a04d2fc700f717104bfb95b0f6694e448a4537f ]

Currently if ipcomp_alloc_scratches() fails to allocate memory
ipcomp_scratches holds obsolete address. So when we try to free the
percpu scratches using ipcomp_free_scratches() it tries to vfree non
existent vm area. Described below:

static void * __percpu *ipcomp_alloc_scratches(void)
{
        ...
        scratches = alloc_percpu(void *);
        if (!scratches)
                return NULL;
ipcomp_scratches does not know about this allocation failure.
Therefore holding the old obsolete address.
        ...
}

So when we free,

static void ipcomp_free_scratches(void)
{
        ...
        scratches = ipcomp_scratches;
Assigning obsolete address from ipcomp_scratches

        if (!scratches)
                return;

        for_each_possible_cpu(i)
               vfree(*per_cpu_ptr(scratches, i));
Trying to free non existent page, causing warning: trying to vfree
existent vm area.
        ...
}

Fix this breakage by updating ipcomp_scrtches with NULL when scratches
is freed

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_ipcomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index a00ec715aa46..32aed1d0f6ee 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -216,6 +216,7 @@ static void ipcomp_free_scratches(void)
 		vfree(*per_cpu_ptr(scratches, i));
 
 	free_percpu(scratches);
+	ipcomp_scratches = NULL;
 }
 
 static void * __percpu *ipcomp_alloc_scratches(void)
-- 
2.35.1

