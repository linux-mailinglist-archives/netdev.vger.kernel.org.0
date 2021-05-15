Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB1381B6F
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhEOWRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235364AbhEOWQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFDD4613C5;
        Sat, 15 May 2021 22:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116909;
        bh=CQuQkxjLga6hdKtVMH2QaxhuQmxzd8lFqkjXs46pFbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhJNM70uQlXOiKfCi7Ec/iOCPcYylUrRbjgJNwfTCNSG55oOBvGwERxnEGJ12pjHC
         98HeNop749NfxAxdHL5Xxm9fvFNLer46jZNmOa2NGCYGEax/VGRfjbvuV1WEr2hCyh
         BkOFpdQue2IB/I1NDf7Ocs8Aabd4VMdvgSo1/OCBnDZ9T+RAw1A+IRMSeoQNJ/kxn/
         FvA+tM5c32i12mR3phMUOLX5j4jXEr907G4mVh4j61Jv4xAgtqSPKrEdaa/wiSy9nl
         ADwmjMDCCO5UUcLGROhhTFD/SKqxbdW0HfRM8xWsBR2ZTGJAmZTVvn2qYXrhDoTiBs
         /WCCnsc7jBPCg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 11/13] [net-next] wan: hostess_sv11: use module_init/module_exit helpers
Date:   Sun, 16 May 2021 00:13:18 +0200
Message-Id: <20210515221320.1255291-12-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This is one of very few drivers using the old init_module/cleanup_module
function names. Change it over to the modern method.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/hostess_sv11.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 6c05c4c8914a..59808fba23c2 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -338,15 +338,17 @@ MODULE_DESCRIPTION("Modular driver for the Comtrol Hostess SV11");
 
 static struct z8530_dev *sv11_unit;
 
-int init_module(void)
+static int sv11_module_init(void)
 {
 	if ((sv11_unit = sv11_init(io, irq)) == NULL)
 		return -ENODEV;
 	return 0;
 }
+module_init(sv11_module_init);
 
-void cleanup_module(void)
+static void sv11_module_cleanup(void)
 {
 	if (sv11_unit)
 		sv11_shutdown(sv11_unit);
 }
+module_exit(sv11_module_cleanup);
-- 
2.29.2

