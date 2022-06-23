Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B59F55719F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiFWEk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345854AbiFWEUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:20:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D582D1E9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58BD0B821A7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 04:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7985C3411B;
        Thu, 23 Jun 2022 04:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655958047;
        bh=pXDhgRnCAQcHo4czXek2baUga02PF8hJfKEnTUaZjVs=;
        h=From:To:Cc:Subject:Date:From;
        b=NuO1GZzs9y37WnLBUeadyG97PyILWh9w4oYFQcRSKEhFdKJ6ltqJjM82HVJXtxVLe
         hP1JSoSb4pqD1yezJwyP0BloG7hOqNsq5S39RWpSRR3aqdIOroiByAR/Omt1/ZOyrz
         mW1I/ft/dnn1LhTc83DTVW9NsKX31bDBnLx2zrim6usb6jscIsDpWpWZI37r7XEAXU
         is7hYpxAfEtVGcJ+Q55e/FtwuIRw6YpjYXtXXpRMS0Za1/d0iLuIFtN4jxAYZEFNt+
         0zJu5NxlIbM7e1x+b6EJZLwgZJjb+cKMMqYCtgBIwhnnqeHT7WIlTxbV6l7u/MfYeu
         gy9KtmU5w6NXw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com,
        peterpenkov96@gmail.com, maheshb@google.com
Subject: [PATCH net] net: tun: unlink NAPI from device on destruction
Date:   Wed, 22 Jun 2022 21:20:39 -0700
Message-Id: <20220623042039.2274708-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a race between tun file and device destruction.
NAPIs live in struct tun_file which can get destroyed before
the netdev so we have to del them explicitly. The current
code is missing deleting the NAPI if the queue was detached
first.

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Reported-by: syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: peterpenkov96@gmail.com
CC: maheshb@google.com
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 87a635aac008..7fd0288c3789 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -727,6 +727,7 @@ static void tun_detach_all(struct net_device *dev)
 		sock_put(&tfile->sk);
 	}
 	list_for_each_entry_safe(tfile, tmp, &tun->disabled, next) {
+		tun_napi_del(tfile);
 		tun_enable_queue(tfile);
 		tun_queue_purge(tfile);
 		xdp_rxq_info_unreg(&tfile->xdp_rxq);
-- 
2.36.1

