Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266603DEC6B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhHCLlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235994AbhHCLlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E45B60560;
        Tue,  3 Aug 2021 11:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990895;
        bh=jm6klg8Q5nOGK5Hrg3MgztVH0NLDKnznSKcazoNeUo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qhr7qVYaGF8vEGuG8w9mcHejwPKkubE1+cA1YFCXBLuE8LaD2dMrEXifyo8DVEBNh
         dJ0vNISHqClEP7/nlXvah6/AP27tAyet+1rN1hMdrQn7YUJ0lfLFLaSgVYrM4T2fTF
         aTjHUDtWE8Qquk4qCn2I1/fwRIilvWTnK7r/2f2tYT7oJ/WZ+G3BKxgyIIsDdg7GlB
         QtxlOsOJS9rnX9kkM9RK6SMxSsTz9hukZ9yBfB4n4Lxs8yHbk5yYTnJIkcX5HR9JDX
         4IOIO1nZVgwThmyjcRlSBxaMf84ZE/T7NndBhjLsJGJt0tdAMQuayWeOdVPCB0gdfS
         RZuy4nAU09ETA==
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
Subject: [PATCH v2 07/14] [net-next] ax88796: export ax_NS8390_init() hook
Date:   Tue,  3 Aug 2021 13:40:44 +0200
Message-Id: <20210803114051.2112986-8-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

The block I/O code for the new X-Surf 100 ax88796 driver needs
ax_NS8390_init() for error fixup in its block_output function.

Export this static function through the ax_NS8390_reinit()
wrapper so we can lose the lib8380.c include in the X-Surf 100
driver.

[arnd: add the declaration in the header to avoid a
 -Wmissing-prototypes warning]
Fixes: 861928f4e60e826c ("net-next: New ax88796 platform
driver for Amiga X-Surf 100 Zorro board (m68k)")
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/8390/ax88796.c | 7 +++++++
 include/net/ax88796.h               | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 9595dd1f32ca..6c6bdd5913ec 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -101,6 +101,13 @@ static inline struct ax_device *to_ax_dev(struct net_device *dev)
 	return (struct ax_device *)(ei_local + 1);
 }
 
+void ax_NS8390_reinit(struct net_device *dev)
+{
+	ax_NS8390_init(dev, 1);
+}
+
+EXPORT_SYMBOL_GPL(ax_NS8390_reinit);
+
 /*
  * ax_initial_check
  *
diff --git a/include/net/ax88796.h b/include/net/ax88796.h
index aa52b2e8ff7b..2ed23a368602 100644
--- a/include/net/ax88796.h
+++ b/include/net/ax88796.h
@@ -38,4 +38,7 @@ struct ax_plat_data {
 	int (*check_irq)(struct platform_device *pdev);
 };
 
+/* exported from ax88796.c for xsurf100.c  */
+extern void ax_NS8390_reinit(struct net_device *dev);
+
 #endif /* __NET_AX88796_PLAT_H */
-- 
2.29.2

