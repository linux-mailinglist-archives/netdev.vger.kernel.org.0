Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4295608EA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiF2ST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiF2STZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:19:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8622015A07
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46FF6B8263D
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B62CC34114;
        Wed, 29 Jun 2022 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656526762;
        bh=Ggo/tigiQ3gcO0iX7aD4pWLL8EvGRuOOI9y1Jx7oS6s=;
        h=From:To:Cc:Subject:Date:From;
        b=KpQuAc2SMlx5AFl48Mi1n3jzF5Ai4k9Ie1M+AF1W/P4DGKlaDkEZch3ERPbTFVAIJ
         voWEbm/zPuhuVe08kLm34sKxi65F8uVqTZC3/qmL1AygGJgbGAu1lpTUjAY2mzml28
         d6n03F8yLBESIAMiArbwTEtGhYcHvwqt7E7T4ndy+GSyN2C4bNiZUcfXh4G0B3uKeq
         L/bMVcz5pQZL5MF11Ix7SQFVrg3iWOoS/wlUK/Rab07igvD5W4AF1LX9EiBuhLrXyP
         YMhQOpWALqdq4ceg3zfBkVLpqfyItkAS7drj5BG/SLxe5gXDDvol1JM1BTlpAL5Pwg
         wcIH1qbL0xGYA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@aviatrix.com>
Subject: [PATCH net 1/2] net: tun: avoid disabling NAPI twice
Date:   Wed, 29 Jun 2022 11:19:10 -0700
Message-Id: <20220629181911.372047-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric reports that syzbot made short work out of my speculative
fix. Indeed when queue gets detached its tfile->tun remains,
so we would try to stop NAPI twice with a detach(), close()
sequence.

Alternative fix would be to move tun_napi_disable() to
tun_detach_all() and let the NAPI run after the queue
has been detached.

Fixes: a8fc8cb5692a ("net: tun: stop NAPI when detaching queues")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Cc: Petar Penkov <ppenkov@aviatrix.com>
---
CC: ppenkov@aviatrix.com
---
 drivers/net/tun.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e2eb35887394..259b2b84b2b3 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -640,7 +640,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 	tun = rtnl_dereference(tfile->tun);
 
 	if (tun && clean) {
-		tun_napi_disable(tfile);
+		if (!tfile->detached)
+			tun_napi_disable(tfile);
 		tun_napi_del(tfile);
 	}
 
-- 
2.36.1

