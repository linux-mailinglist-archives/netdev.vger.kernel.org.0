Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC1C135FED
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbgAIR6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:58:32 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54957 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728653AbgAIR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:58:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DC0C821FC2;
        Thu,  9 Jan 2020 12:58:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 09 Jan 2020 12:58:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/XKjs328VqalJ+dMk
        PuGedAcfhYuppGZ8iygSOXULag=; b=wppODpLEEnADHeLTQ3PM5JvDGhbZMEHOo
        l5FHwX4ixdOxCd8qsDDVIIYPX89SkHDmfG4tfe8igkIeB5vzngjbjafG21s/4Que
        gjiZPBt3FOAUD0Kgbcaej1jTP8YPubxwGxZi6AnSSDSmqoCfnEWHxGptUqXCRgaG
        9gYzJJoNZ8U09wmwVudceewAGgkfcur9dprjBvyPCLY3f5VeP3+eIpL6K5v0ASgT
        6r8xOH/zdRUNz09vO6x53D2A0RSBZzpaAuBBsBP3ojpBoRAOultKIxXb/TnHo4P/
        +PLwjvajmXHBvCJ0umIjaY2UFH9D0XcKGY9Sqx8dXvNTAZVn+Jnnw==
X-ME-Sender: <xms:x2kXXpce0qz0htsz-KqPbtUa9x9UZU7rTYWt8GtRWo0B9Hx_mPq1Ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeiuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhushhpvggtthffohhmrghinhculdegledmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfutghh
    ihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinheprg
    hpphhsphhothdrtghomhenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:x2kXXnjeA73Qcz-SRvViSwIfQT7Nzjp3S2nFVCtCuT20k4T509Ogng>
    <xmx:x2kXXqJssBhAcPWyctnqgPzM5EpildfLn9luRcf3BqWc-prDRZxDGQ>
    <xmx:x2kXXtl-QXAstA0jnfILsp8L5UDIV65aAKuhzW6NwZ4cbpDG7lrOUg>
    <xmx:x2kXXpR0YVmz58rDnQ3AvG32WEe_CNv6Qs7zYKWDBS0KzsCErxM_iQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 375E230602DE;
        Thu,  9 Jan 2020 12:58:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dvyukov@google.com,
        alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] devlink: Wait longer before warning about unset port type
Date:   Thu,  9 Jan 2020 19:57:41 +0200
Message-Id: <20200109175741.293670-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The commit cited below causes devlink to emit a warning if a type was
not set on a devlink port for longer than 30 seconds to "prevent
misbehavior of drivers". This proved to be problematic when
unregistering the backing netdev. The flow is always:

devlink_port_type_clear()	// schedules the warning
unregister_netdev()		// blocking
devlink_port_unregister()	// cancels the warning

The call to unregister_netdev() can block for long periods of time for
various reasons: RTNL lock is contended, large amounts of configuration
to unroll following dismantle of the netdev, etc. This results in
devlink emitting a warning despite the driver behaving correctly.

In emulated environments (of future hardware) which are usually very
slow, the warning can also be emitted during port creation as more than
30 seconds can pass between the time the devlink port is registered and
when its type is set.

In addition, syzbot has hit this warning [1] 1974 times since 07/11/19
without being able to produce a reproducer. Probably because
reproduction depends on the load or other bugs (e.g., RTNL not being
released).

To prevent bogus warnings, increase the timeout to 1 hour.

[1] https://syzkaller.appspot.com/bug?id=e99b59e9c024a666c9f7450dc162a4b74d09d9cb

Fixes: 136bf27fc0e9 ("devlink: add warning in case driver does not set port type")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: syzbot+b0a18ed7b08b735d2f41@syzkaller.appspotmail.com
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4c63c9a4c09e..b8d698a2bf57 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6406,7 +6406,7 @@ static bool devlink_port_type_should_warn(struct devlink_port *devlink_port)
 	       devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA;
 }
 
-#define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 30)
+#define DEVLINK_PORT_TYPE_WARN_TIMEOUT (HZ * 3600)
 
 static void devlink_port_type_warn_schedule(struct devlink_port *devlink_port)
 {
-- 
2.24.1

