Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF3F6EA5C5
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 10:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjDUIY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 04:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjDUIY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 04:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353DA10D5;
        Fri, 21 Apr 2023 01:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2CAF618D3;
        Fri, 21 Apr 2023 08:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A8EC433EF;
        Fri, 21 Apr 2023 08:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682065496;
        bh=lnx9JSZMnAAmgHMt+elXCqGcZ+NDFpyQuPzVgtDnPMs=;
        h=From:To:Cc:Subject:Date:From;
        b=gPoHk2vGt7f1AqebQOUA7qMS1VF/y2oNIFTTFuPWwRlavGOlcrE/+ziDPr4aEQELP
         4wCZHQC0yvueCGv84dWQPSNSkqkjZihMmk5qCcFAVsbqDj4lEwB4llIxQOtUJvZS7S
         3KWqbuAVCpPOr80qzB2ZbVx6BjSzocMOcsFrpCcJbCICNlateEUT/VWMdjxEYO61oU
         wvppHrkuBmoU2NrRjrxbTIWpilwya53P9wR3wlipHO+ioHKi0LvNTsbWbk3x4LMuTU
         xy3Rm/mlAIi+XKr+xAk72DZQMJ2UWDWLpE8kyGS+xeuaKCWixfWnAnEPL4Y75EsJad
         ZJ2SnrwB6COEg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/handshake: fix section mismatch error for handshake_genl_net_ops
Date:   Fri, 21 Apr 2023 10:24:44 +0200
Message-Id: <20230421082450.2572594-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The new netlink interface causes a link-time warning about the use of
a discarded symbol:

WARNING: modpost: vmlinux.o: section mismatch in reference: handshake_exit (section: .exit.text) -> (unknown) (section: .init.data)
ERROR: modpost: Section mismatches detected.

There are other instances of pernet_operations that are marked as
__net_initdata as well, so I'm not sure what the lifetime rules are,
but it's clear that any discarded symbol cannot be referenced from an
exitcall, so remove that annotation here.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/handshake/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 8ea0ff993f9f..35c9c445e0b8 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -249,7 +249,7 @@ static void __net_exit handshake_net_exit(struct net *net)
 	}
 }
 
-static struct pernet_operations __net_initdata handshake_genl_net_ops = {
+static struct pernet_operations handshake_genl_net_ops = {
 	.init		= handshake_net_init,
 	.exit		= handshake_net_exit,
 	.id		= &handshake_net_id,
-- 
2.39.2

