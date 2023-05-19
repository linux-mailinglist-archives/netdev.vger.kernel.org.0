Return-Path: <netdev+bounces-3859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B04D6709338
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8B91C21234
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3183612C;
	Fri, 19 May 2023 09:32:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36486610A
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C46CC4339B;
	Fri, 19 May 2023 09:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684488775;
	bh=wGKJyQlBy4S9Q6vaML8h068iGf1xJ8aPt0xeOhV7lkE=;
	h=From:To:Cc:Subject:Date:From;
	b=JRY03y+kPjBs3+pNdyS3dr3enxOCHF/Z0w0g/El9B6THPmic1qZfEf4prdMnQvZ1f
	 FAzsYoTYlrp/8mnOZWxzentNUkYVnEua00zRHrn+SOXtT5grVjeg0+zPRSS22sgzWU
	 dkI123s6ZiRrtDFTtpCzigQXhDxIt7EkhFHJnvae5pXaizwrw7yz3kkah53g05FBlk
	 TiPRZBSya8obTsXj1x+zcncI0dRS6J8zPkQk7rXr6HbcnGlmy/FY+P8pxHDwL3w/8N
	 CL8N6ho1xLyobc/2WDp2XV7/H52BoxPk3/oomN6UOf0WT+YUZYMdV1MmecHFor0tVo
	 c3d64YH4j96oQ==
From: Arnd Bergmann <arnd@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Martin Wetterwald <martin@wetterwald.eu>
Cc: Arnd Bergmann <arnd@arndb.de>,
	XueBing Chen <chenxuebing@jari.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Saravana Kannan <saravanak@google.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] net: ipconfig: move ic_nameservers_fallback into #ifdef block
Date: Fri, 19 May 2023 11:32:38 +0200
Message-Id: <20230519093250.4011881-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The new variable is only used when IPCONFIG_BOOTP is defined and otherwise
causes a warning:

net/ipv4/ipconfig.c:177:12: error: 'ic_nameservers_fallback' defined but not used [-Werror=unused-variable]

Move it next to the user.

Fixes: 81ac2722fa19 ("net: ipconfig: Allow DNS to be overwritten by DHCPACK")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/ipv4/ipconfig.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 202fa1943ccd..c56b6fe6f0d7 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -173,9 +173,6 @@ static int ic_proto_have_if __initdata;
 /* MTU for boot device */
 static int ic_dev_mtu __initdata;
 
-/* DHCPACK can overwrite DNS if fallback was set upon first BOOTP reply */
-static int ic_nameservers_fallback __initdata;
-
 #ifdef IPCONFIG_DYNAMIC
 static DEFINE_SPINLOCK(ic_recv_lock);
 static volatile int ic_got_reply __initdata;    /* Proto(s) that replied */
@@ -668,6 +665,9 @@ static struct packet_type bootp_packet_type __initdata = {
 	.func =	ic_bootp_recv,
 };
 
+/* DHCPACK can overwrite DNS if fallback was set upon first BOOTP reply */
+static int ic_nameservers_fallback __initdata;
+
 /*
  *  Initialize DHCP/BOOTP extension fields in the request.
  */
-- 
2.39.2


