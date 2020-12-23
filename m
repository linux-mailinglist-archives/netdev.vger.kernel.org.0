Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1430E2E16D9
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgLWDDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728644AbgLWCTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4428D2256F;
        Wed, 23 Dec 2020 02:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689938;
        bh=ZQ/j5V8+OG0lWPZ+eaPhVlHhx5VfC++q5vYuWiJux3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUd7oABRfsYaz7hCdy1H245peWh7m86mO18Ir5gOLGjSc8k9A0UhdR4FBZ1RVChjE
         Cw+BezU81Ng14BC+7VSxkU/V1UqoqF6aBUiGh/dZ1zDPmvto2Da7nQ0ZsKnF1nP4dI
         CS3a1K0WRNIKEKNahOKznfsz6dS71IFrmNMmd51xs7OOmPzyy/2wiVhAjPYJACXkki
         6d4mo9wzPiD21SIjJr2q6Iw6AEz5cEPK+wGcJu2gdL0DBtLFi8TUbgKEY87tnptSzP
         Mswx+nnza1EuS/RBwqSt8g5DORkrj/1fgnHy1faSXKK5AOBwkmKK1k3LsEYtnSIkol
         +KIhxcXdy8rew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 034/130] net: ipconfig: Avoid spurious blank lines in boot log
Date:   Tue, 22 Dec 2020 21:16:37 -0500
Message-Id: <20201223021813.2791612-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit c9f64d1fc101c64ea2be1b2e562b4395127befc9 ]

When dumping the name and NTP servers advertised by DHCP, a blank line
is emitted if either of the lists is empty. This can lead to confusing
issues such as the blank line getting flagged as warning. This happens
because the blank line is the result of pr_cont("\n") and that may see
its level corrupted by some other driver concurrently writing to the
console.

Fix this by making sure that the terminating newline is only emitted
if at least one entry in the lists was printed before.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20201110073757.1284594-1-thierry.reding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipconfig.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 9bcca08efec9e..a268e056f01bd 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1438,7 +1438,7 @@ static int __init ip_auto_config(void)
 	int retries = CONF_OPEN_RETRIES;
 #endif
 	int err;
-	unsigned int i;
+	unsigned int i, count;
 
 	/* Initialise all name servers and NTP servers to NONE (but only if the
 	 * "ip=" or "nfsaddrs=" kernel command line parameters weren't decoded,
@@ -1566,7 +1566,7 @@ static int __init ip_auto_config(void)
 	if (ic_dev_mtu)
 		pr_cont(", mtu=%d", ic_dev_mtu);
 	/* Name servers (if any): */
-	for (i = 0; i < CONF_NAMESERVERS_MAX; i++) {
+	for (i = 0, count = 0; i < CONF_NAMESERVERS_MAX; i++) {
 		if (ic_nameservers[i] != NONE) {
 			if (i == 0)
 				pr_info("     nameserver%u=%pI4",
@@ -1574,12 +1574,14 @@ static int __init ip_auto_config(void)
 			else
 				pr_cont(", nameserver%u=%pI4",
 					i, &ic_nameservers[i]);
+
+			count++;
 		}
-		if (i + 1 == CONF_NAMESERVERS_MAX)
+		if ((i + 1 == CONF_NAMESERVERS_MAX) && count > 0)
 			pr_cont("\n");
 	}
 	/* NTP servers (if any): */
-	for (i = 0; i < CONF_NTP_SERVERS_MAX; i++) {
+	for (i = 0, count = 0; i < CONF_NTP_SERVERS_MAX; i++) {
 		if (ic_ntp_servers[i] != NONE) {
 			if (i == 0)
 				pr_info("     ntpserver%u=%pI4",
@@ -1587,8 +1589,10 @@ static int __init ip_auto_config(void)
 			else
 				pr_cont(", ntpserver%u=%pI4",
 					i, &ic_ntp_servers[i]);
+
+			count++;
 		}
-		if (i + 1 == CONF_NTP_SERVERS_MAX)
+		if ((i + 1 == CONF_NTP_SERVERS_MAX) && count > 0)
 			pr_cont("\n");
 	}
 #endif /* !SILENT */
-- 
2.27.0

