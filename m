Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2795A39E323
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhFGQVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232554AbhFGQTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE42361584;
        Mon,  7 Jun 2021 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082479;
        bh=jREp5d7vB2iQIHguUnniwJYIOUorirUiGVAHcE+9Nko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXLTiaGuM6uItqGbxJToq39snXdDk0M7RR8TdSW+x9VEDpDg7c3Q9vbSHWgjzl8Jl
         UUzoG0VRSntouD0gCcuGyeDwa3k5+oEzGE4nlXTid1G4QPx42Coiv4PhZ8u3QJytnI
         4rMlrdaFcqYN+j9ud2WIr1o9uBEZsD9b9c2dkJPHXE365rkgshiCQLhEhQs923dcW2
         tVvQJ58wtxm68y62H34iSmYFkUneXa/C1gWQ7i2iZvGvtUKny30IPt4/aCVVZhyjn6
         dSvkZsER94UEybqjCRRxgBqucrEKqU4xCrPFVpeXCpaHrl28kj3THYNfn2o/+dPsyU
         E7zrsuOpFF6Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/29] net: ipconfig: Don't override command-line hostnames or domains
Date:   Mon,  7 Jun 2021 12:14:04 -0400
Message-Id: <20210607161410.3584036-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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
index 9bcca08efec9..c05ad600a4ff 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -870,7 +870,7 @@ static void __init ic_bootp_send_if(struct ic_device *d, unsigned long jiffies_d
 
 
 /*
- *  Copy BOOTP-supplied string if not already set.
+ *  Copy BOOTP-supplied string
  */
 static int __init ic_bootp_string(char *dest, char *src, int len, int max)
 {
@@ -919,12 +919,15 @@ static void __init ic_do_bootp_ext(u8 *ext)
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

