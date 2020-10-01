Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9213427F66B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731489AbgJAAF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731106AbgJAAF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:28 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC116207C3;
        Thu,  1 Oct 2020 00:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510728;
        bh=O8/ZmGtRhj1Dur1Cw9TL83nREPX86LbPsySP1YEXtuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asgKuMIHbBAh6icWnkoTxkDPqmRrvy43Xh8XJ4n15B7ZL+ASsbBZSbvrHzlA8kg1S
         5Jhbu+eqBZI4RtDFOo0fMq+7AXeFWM/lo3xlvyNQ401nK6WgJz5fmfmGkZzXHAw54h
         OC1Vrxi15ykyJ8ck0j7Weu+k0incVmJWVjK2q3mE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 2/9] genetlink: reorg struct genl_family
Date:   Wed, 30 Sep 2020 17:05:11 -0700
Message-Id: <20201001000518.685243-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are holes and oversized members in struct genl_family.

Before: /* size: 104, cachelines: 2, members: 16 */
After:  /* size:  88, cachelines: 2, members: 16 */

The command field in struct genlmsghdr is a u8, so no point
in the operation count being 32 bit. Also operation 0 is
usually undefined, so we only need 255 entries.

netnsok and parallel_ops are only ever initialized to true.

We can grow the fields as needed, compiler should warn us
if someone tries to assign larger constants.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index a3484fd736d6..0033c76ff094 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -48,8 +48,11 @@ struct genl_family {
 	char			name[GENL_NAMSIZ];
 	unsigned int		version;
 	unsigned int		maxattr;
-	bool			netnsok;
-	bool			parallel_ops;
+	unsigned int		mcgrp_offset;	/* private */
+	u8			netnsok:1;
+	u8			parallel_ops:1;
+	u8			n_ops;
+	u8			n_mcgrps;
 	const struct nla_policy *policy;
 	int			(*pre_doit)(const struct genl_ops *ops,
 					    struct sk_buff *skb,
@@ -59,9 +62,6 @@ struct genl_family {
 					     struct genl_info *info);
 	const struct genl_ops *	ops;
 	const struct genl_multicast_group *mcgrps;
-	unsigned int		n_ops;
-	unsigned int		n_mcgrps;
-	unsigned int		mcgrp_offset;	/* private */
 	struct module		*module;
 };
 
-- 
2.26.2

