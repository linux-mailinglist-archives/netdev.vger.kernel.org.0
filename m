Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB739E39C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhFGQ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233054AbhFGQXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55EA361938;
        Mon,  7 Jun 2021 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082536;
        bh=B25B92srqSsF/6Dh15xn0nPKBcW6GX2zydGaLZi44Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiqTJYiKTDNp92SAeqdYNfhVy/1+aNcsozIgcZW4d0jUOLrZvPrRfhVcB3Te4MDAP
         Uh31clFhQAykdD6rv9/gwIOOOsGUAXLC9x0jHZlgaLL2NQPGtnlwZBhlMO4lV3mpVC
         IjHyQXEgoG3Ab1YnOXZevEsthzYdInLt/ilHDE2Pxah857GPipDTJbydfrEyzZyWQR
         5WQgCegEEa/QpWeUqYPqnSVIB7ULqlyYZp+nnqEzdbGp23Gx2Hxa+hHoRVGC0Y1dbB
         QImT6PJhCNJilC3TQDTEYmD13wfQiE63CXMa+l+Ys8lmSp51C1gJGMT6qBiHnf5mJn
         wTZWmcYxZuvGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/18] net: ipconfig: Don't override command-line hostnames or domains
Date:   Mon,  7 Jun 2021 12:15:12 -0400
Message-Id: <20210607161517.3584577-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
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
index f0782c91514c..41e384834d50 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -881,7 +881,7 @@ static void __init ic_bootp_send_if(struct ic_device *d, unsigned long jiffies_d
 
 
 /*
- *  Copy BOOTP-supplied string if not already set.
+ *  Copy BOOTP-supplied string
  */
 static int __init ic_bootp_string(char *dest, char *src, int len, int max)
 {
@@ -930,12 +930,15 @@ static void __init ic_do_bootp_ext(u8 *ext)
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

