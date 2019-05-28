Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353312C8AD
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfE1OZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:25:21 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:39122 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbfE1OYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:24:43 -0400
Received: from ramsan ([84.194.111.163])
        by albert.telenet-ops.be with bizsmtp
        id HqQS2000E3XaVaC06qQSub; Tue, 28 May 2019 16:24:41 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00058P-7H; Tue, 28 May 2019 16:24:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00057Z-4f; Tue, 28 May 2019 16:24:26 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] [RFC] devlink: Fix uninitialized error code in devlink_fmsg_prepare_skb()
Date:   Tue, 28 May 2019 16:24:24 +0200
Message-Id: <20190528142424.19626-6-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528142424.19626-1-geert@linux-m68k.org>
References: <20190528142424.19626-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With gcc 4.1:

    net/core/devlink.c: In function ‘devlink_fmsg_prepare_skb’:
    net/core/devlink.c:4325: warning: ‘err’ may be used uninitialized in this function

Indeed, if the list has less than *start entries, an uninitialized error
code will be returned.

Fix this by preinitializing err to zero.

Fixes: 1db64e8733f65381 ("devlink: Add devlink formatted message (fmsg) API")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I don't know if this can really happen, and if this is the right fix.
Perhaps err should be initialized to some valid error code instead?
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d43bc52b8840d76b..91377e4eae9a43c1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4321,8 +4321,8 @@ devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 {
 	struct devlink_fmsg_item *item;
 	struct nlattr *fmsg_nlattr;
+	int err = 0;
 	int i = 0;
-	int err;
 
 	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
 	if (!fmsg_nlattr)
-- 
2.17.1

