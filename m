Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C95F39E3C5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhFGQ1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233976AbhFGQZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9193613D2;
        Mon,  7 Jun 2021 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082559;
        bh=PFgFgnKcebF8jjQMVTBtUDusT7F8dEi55MEb6Jc3/Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dywAb17PgMholCtVnHObCHiMJEl+FqGHhNHOOFgbAyur5aRdv7OBbUZ06Be8bVMKn
         myMqW48QoG1nzL4kfUrnmEbmfEadom/gfuKF/qEdXP+zz70iRT+gAezqT4nG8feJLr
         Qua05dsU4N19Qzaiwf4ZEbzeO5356F07w3izpsRUEwDsE4Yaj5nqapKt2fEREFxNSa
         KmMx8aqkJpaynpY/CXNqPS4SZOG9nRb5mhth6IOTL07ljD2fRm2EyLQwaiRAwZ/dyC
         aDMbclkA6H3YCOrAR1a3BZHKqg+ClV26PF6Y3KoAn7QGiIe5ea4IcbMRq/S0V5i22m
         aPyDiKDhyEcQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/15] net: ipconfig: Don't override command-line hostnames or domains
Date:   Mon,  7 Jun 2021 12:15:39 -0400
Message-Id: <20210607161543.3584778-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit b508d5fb69c2211a1b860fc058aafbefc3b3c3cd ]

If the user specifies a hostname or domain name as part of the ip=
command-line option, preserve it and don't overwrite it with one
supplied by DHCP/BOOTP.

For instance, ip=::::myhostname::dhcp will use "myhostname" rather than
ignoring and overwriting it.

Fix the comment on ic_bootp_string that suggests it only copies a string
"if not already set"; it doesn't have any such logic.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipconfig.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index d278b06459ac..79d8ea98a5b1 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -880,7 +880,7 @@ static void __init ic_bootp_send_if(struct ic_device *d, unsigned long jiffies_d
 
 
 /*
- *  Copy BOOTP-supplied string if not already set.
+ *  Copy BOOTP-supplied string
  */
 static int __init ic_bootp_string(char *dest, char *src, int len, int max)
 {
@@ -929,12 +929,15 @@ static void __init ic_do_bootp_ext(u8 *ext)
 		}
 		break;
 	case 12:	/* Host name */
-		ic_bootp_string(utsname()->nodename, ext+1, *ext,
-				__NEW_UTS_LEN);
-		ic_host_name_set = 1;
+		if (!ic_host_name_set) {
+			ic_bootp_string(utsname()->nodename, ext+1, *ext,
+					__NEW_UTS_LEN);
+			ic_host_name_set = 1;
+		}
 		break;
 	case 15:	/* Domain name (DNS) */
-		ic_bootp_string(ic_domain, ext+1, *ext, sizeof(ic_domain));
+		if (!ic_domain[0])
+			ic_bootp_string(ic_domain, ext+1, *ext, sizeof(ic_domain));
 		break;
 	case 17:	/* Root path */
 		if (!root_server_path[0])
-- 
2.30.2

