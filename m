Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100BC3EBB40
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhHMRUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhHMRUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D798760F51;
        Fri, 13 Aug 2021 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875185;
        bh=Th7mLcEdgD9MZb91A/vTDuBPjRrjvhIZqBlMQc2naVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxLfDI3kHCArf+F17HsythtMwhXtIhD5PXZn4BGoWcMLVm8chNs9MEd/TliZthI6q
         lVDmYpRh+RfRRNCgDxLTwXchg/+LtX3JCkZQ8K8eBhlRtJr/LpacJjA3jt7wUtYsmL
         hrOPAq0yKszrQ+Q7HD/E4+uxO1q9ex2ikpoHcz9Vy4n83dSugvIfJExolatY8XSV3j
         yhek3uUYM/gSPUmfbiOG9hwZ/bQS9GlWte8syR/oOhrGwJpXYq0jlGk4IlzQ7xavde
         xeOzq+gBMtQsvJ/Ei7IYH+KI1BV6pblaG39qDo7jcahJ5TKw7ZOq0KuumPQ5l9C/mZ
         RxqZ2CiTZkdYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dcavalca@fb.com, filbranden@fb.com,
        michel@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool 1/3] ethtool: remove questionable goto
Date:   Fri, 13 Aug 2021 10:19:36 -0700
Message-Id: <20210813171938.1127891-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813171938.1127891-1-kuba@kernel.org>
References: <20210813171938.1127891-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

goto opt_found can be trivially replaced by an else branch.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 33a0a492cb15..8cf1b13e4176 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6352,15 +6352,14 @@ int main(int argc, char **argp)
 		nlfunc = args[k].nlfunc;
 		nlchk = args[k].nlchk;
 		no_dev = args[k].no_dev;
-		goto opt_found;
+	} else {
+		if ((*argp)[0] == '-')
+			exit_bad_args();
+		nlfunc = nl_gset;
+		func = do_gset;
+		no_dev = false;
 	}
-	if ((*argp)[0] == '-')
-		exit_bad_args();
-	nlfunc = nl_gset;
-	func = do_gset;
-	no_dev = false;
 
-opt_found:
 	if (!no_dev) {
 		ctx.devname = *argp++;
 		argc--;
-- 
2.31.1

