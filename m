Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA133DEC76
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhHCLmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236093AbhHCLmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74FFF60EFD;
        Tue,  3 Aug 2021 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990920;
        bh=vQwo8Eo+Z/NnYn0D/h3hKgl5/YLTXiJOj2evFBvzVyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaDd7R8FdQFpsA9M3NSI44ShvXQTjOXBKBgACMMlzZrrNaYG0tzPkkU2Y4Zb9wljM
         Zi83gUvw9FNNpAuk9EVNEtVO5wyRpi+DtWW1q73r5+gPJcSdesuEYTDhSxI1JiLC/Z
         5GGlYxmoPXP88QZ3eTy/PCbETyuANDhdugniAATdb9nkWP4lKpX5xMXbyfoE4KKjzp
         iSLcEOl9tgbQukJ2tn+nGDoB07HbnD7vKeg+WN0XEcf6fVVvM2GiuX1mviI99ngDGL
         +4xd8el33ZIQK/gAWb6GA6ZfFol/yvMeFLTR7aOdvhZq979tAR34brReaqFPBLUC+A
         Yz1SEjJgBdCxg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 13/14] [net-next] wan: hostess_sv11: use module_init/module_exit helpers
Date:   Tue,  3 Aug 2021 13:40:50 +0200
Message-Id: <20210803114051.2112986-14-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
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
index 15a754310fd7..e985e54ba75d 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -319,16 +319,18 @@ MODULE_DESCRIPTION("Modular driver for the Comtrol Hostess SV11");
 
 static struct z8530_dev *sv11_unit;
 
-int init_module(void)
+static int sv11_module_init(void)
 {
 	sv11_unit = sv11_init(io, irq);
 	if (!sv11_unit)
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

