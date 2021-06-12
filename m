Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E533A4C2A
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFLBvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 21:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhFLBvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 21:51:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A7661181;
        Sat, 12 Jun 2021 01:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623462589;
        bh=4aGCfXJUv4O0zaIVk5GoGeelKCUSZd8Tv4bFiHsM5WA=;
        h=From:To:Cc:Subject:Date:From;
        b=RrY4s9VH+p66niaNjdatF7B8aSnGDy34KaaGPB/CFGCPlTbF3WP+jtqpRNeYr4s0m
         7YqyXS0luJ0UOi8dW0GaK7RNs7XmunOlP4pShDwl06JdPaDiLNyMenNRGCIJ3gAP65
         6hK2tBvgGpbObxnEki0t/nfW6Wh6j4yoq5Zxd8MZam3PE4GdvH75GPrJi9T5BZTFBV
         xwegTEK6IWn/T9lMNg+65yiLb2h6/JeSGesXZNJoUn7v/78NpRzGjxAQLPpybY/Ky5
         JQVHqGYQ5vdmWHPWlaXyZmDW4twM3js540cwEYZfKIB35yfW54oHCvVU/gbe7emYx/
         Ad7Tji4lstHJA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com
Subject: [PATCH net] ethtool: strset: fix message length calculation
Date:   Fri, 11 Jun 2021 18:49:48 -0700
Message-Id: <20210612014948.211817-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Outer nest for ETHTOOL_A_STRSET_STRINGSETS is not accounted for.
This may result in ETHTOOL_MSG_STRSET_GET producing a warning like:

    calculated message payload length (684) not sufficient
    WARNING: CPU: 0 PID: 30967 at net/ethtool/netlink.c:369 ethnl_default_doit+0x87a/0xa20

and a splat.

As usually with such warnings three conditions must be met for the warning
to trigger:
 - there must be no skb size rounding up (e.g. reply_size of 684);
 - string set must be per-device (so that the header gets populated);
 - the device name must be at least 12 characters long.

all in all with current user space it looks like reading priv flags
is the only place this could potentially happen. Or with syzbot :)

Reported-by: syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com
Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/strset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index b3029fff715d..2d51b7ab4dc5 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -353,6 +353,8 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 	int len = 0;
 	int ret;
 
+	len += nla_total_size(0); /* ETHTOOL_A_STRSET_STRINGSETS */
+
 	for (i = 0; i < ETH_SS_COUNT; i++) {
 		const struct strset_info *set_info = &data->sets[i];
 
-- 
2.31.1

