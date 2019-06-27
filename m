Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392CE58923
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfF0Rp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:45:57 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44897 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfF0Rpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:45:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so1673580plr.11;
        Thu, 27 Jun 2019 10:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=drjgftEWAZg3/oKZde2zMkT36C0ZEqDQk/rQk2ecHqE=;
        b=XjfUBn3mJbrbGfnwsW7qoISdtv6h21GLg/ORcHgYgxh0ZNbGJvRJm8p7NUx83k8CXF
         UE9f/pywfKSF3lbE6Z9b9N2B1hbKKM0S8YiLgbKkZhiKTe8xjRneYdFvNHs8HVWBx67n
         JhBdsjs0sFx7N+B/9O/lkx75hKe+oLyunRlmmkgbR7EotaRQSX4Odn6J012YHLNnzZB/
         b2UIpsrlefZYyexOoe5sUfgGdsgrpB0xqB/I7Rmrqdov2RW4iXd6aynhTO9mSlrjrbjx
         T3pvu5kE66+EDc+N2M7BJOSALqSKbcyWGEFKK53Q6vlKd1d0eJ1fPtdqCwZQOhXF7Nrc
         C0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=drjgftEWAZg3/oKZde2zMkT36C0ZEqDQk/rQk2ecHqE=;
        b=bE9rdc75do/KtENCg/yfyzO4dXw/Mp5sN1NUwEl593p4YwdP7eodl4MSj6ud47xIgV
         ay7M5NHPIO6qiY9CVy34UD4C8i3HxhBD1FrNOo/uc9WyGKlTBsJ0r3N6UAgr5oby/X5c
         MXwSpXS+1B0MmRlX7ip+GLTLdCB/QVns4dHmtUqqc8PgFehcVtYtfC6emdU1K5/v0lAL
         53B85Vih1ZJcO9GmJat2rNry/woZ3CcAu38XLRo9T5X9HRIz+593Mo18nP1ScZna/k+e
         V6IvCv37tB4RTpR5bRLclBtgqwJv5JdaR7rkG6FQ8oujsQ+Kf0uzKw1oOsw7WtTgkkGl
         SDgg==
X-Gm-Message-State: APjAAAXjirSFEXw6+Bg8JMhipPsInUPzmzDxiP7dVsF69FqI0u5hX1vl
        f7ugmGTpeKxt+5DyyRiMgX7AfsWOt5h3vg==
X-Google-Smtp-Source: APXvYqwrFX/Sk4b/bSSq48Wz4qHMklsVR8zrsDYcV8VDNsPA4F3Z9IARxomaPfDpugHllO0j07+RFw==
X-Received: by 2002:a17:902:7887:: with SMTP id q7mr6105676pll.129.1561657554912;
        Thu, 27 Jun 2019 10:45:54 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id h26sm4116937pfq.64.2019.06.27.10.45.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:45:54 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Hans de Goede <hdegoede@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 77/87] wireless: broadcom: remove memset after dma_alloc_coherent
Date:   Fri, 28 Jun 2019 01:45:43 +0800
Message-Id: <20190627174544.6145-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 83e4938527f4..3fc08fe7c3a2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1033,8 +1033,6 @@ brcmf_pcie_init_dmabuffer_for_device(struct brcmf_pciedev_info *devinfo,
 			       address & 0xffffffff);
 	brcmf_pcie_write_tcm32(devinfo, tcm_dma_phys_addr + 4, address >> 32);
 
-	memset(ring, 0, size);
-
 	return (ring);
 }
 
-- 
2.11.0

