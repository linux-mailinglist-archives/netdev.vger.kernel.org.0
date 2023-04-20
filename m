Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA9C6E9AFC
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjDTRlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDTRlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:41:51 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A621133
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:41:48 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.187.55])
        by laurent.telenet-ops.be with bizsmtp
        id n5hl290011C8whw015hlzL; Thu, 20 Apr 2023 19:41:45 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1ppYCp-00HJNO-Ep;
        Thu, 20 Apr 2023 19:37:23 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1ppYDj-00Fpe1-JL;
        Thu, 20 Apr 2023 19:37:23 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/handshake: Fix section mismatch in handshake_exit
Date:   Thu, 20 Apr 2023 19:37:23 +0200
Message-Id: <20230420173723.3773434-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET_NS=n (e.g. m68k/defconfig):

    WARNING: modpost: vmlinux.o: section mismatch in reference: handshake_exit (section: .exit.text) -> handshake_genl_net_ops (section: .init.data)
    ERROR: modpost: Section mismatches detected.

Fix this by dropping the __net_initdata tag from handshake_genl_net_ops.

Fixes: 3b3009ea8abb713b ("net/handshake: Create a NETLINK service for handling handshake requests")
Reported-by: noreply@ellerman.id.au
Closes: http://kisskb.ellerman.id.au/kisskb/buildresult/14912987
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/handshake/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 8ea0ff993f9fba50..35c9c445e0b850d8 100644
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
2.34.1

