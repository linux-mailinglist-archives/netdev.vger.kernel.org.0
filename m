Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0A4AD21
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfFRVPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:15:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34459 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbfFRVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:15:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so1049550wrl.1;
        Tue, 18 Jun 2019 14:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GFC2U217SF+O5Fp8I6sd90iiYF5kWGFryqAnl3xENJw=;
        b=E2NYCAjVizh2kbiYeRCOYgVAzGUadZbKlNdbvHNK0I/Nuu2pUHvJO+rtW7vhyyjZp5
         pF1xvOq35dSN29vmWRcmIpuiU9wUzKdCfoek26+K5F3ytTUfX2Vqgqn+Lf4S8XEoByy1
         /lMoKAMbZjgSr83VMl+r814/EePU6zOOo/2yROGAJqkqoqUFQVQvMWhySbFft9LjzoA3
         DDU5fMxK2fXoag2Nh8hyNjAJ90LI9BRnU3zfoAOXvTFcLeNFrCRwSz4llt/uA3KV9THO
         At15CgvnCLLdSqNo/lIZffE0sTAsgk7sBFsdi7K32DBpcl2i7Ia7IrFEoJTk0CxkXGEM
         5BoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GFC2U217SF+O5Fp8I6sd90iiYF5kWGFryqAnl3xENJw=;
        b=N45jPM28ywxAvAFmq2jR7kyRikGn1EdS0ggRdxCP5Z9y3PyOQ65UuafbBfh+ls9Xwl
         1l8kapWaqCq2dZ48zCOg3bQ+aSZsIxgn9e1TFmxlq+SOUjIRQDXa+UET66YWfWBjVK5X
         13e88KZj9Gw+nqLb05kyuBwvwJ/XXppoPBLa9W9MHJuHS0OLIH3cffim+t+n6tPQPJ7n
         kOsYx6XbCm861ZAAT94pk+YUCt7LHm9QlpcV3cSluIp+SOaBA6t0T8z0cMrzuAXVApDN
         sMLCtZhvh4n7ANDDJA41fPRQzGS6QSwKtt5+wwatgLXG4laLDSQJVqS7xcxqZiNNI7EJ
         RsaQ==
X-Gm-Message-State: APjAAAX6NmyxnGZWsnKagjk9u+o6iRQnhDKFWF3OC3KdGSNakt1rgbbD
        SZwLPsV1nTmdS6Y06eVS6qfg6u3S
X-Google-Smtp-Source: APXvYqwNIuNZWCOh05X2WAP3isXcePC9IyCyA+Y3zx3Zy2x4SwjrePsghwKNBm9oMAQgdSIR1U2dQw==
X-Received: by 2002:a5d:50cc:: with SMTP id f12mr5509116wrt.129.1560892501933;
        Tue, 18 Jun 2019 14:15:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:28c3:39c3:997e:395f? (p200300EA8BF3BD0028C339C3997E395F.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:28c3:39c3:997e:395f])
        by smtp.googlemail.com with ESMTPSA id t1sm22599964wra.74.2019.06.18.14.15.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 14:15:01 -0700 (PDT)
Subject: [PATCH net-next 1/2] PCI: let pci_disable_link_state propagate errors
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5ea56278-05e2-794f-5f66-23343e72164c@gmail.com>
Message-ID: <604f2954-c60c-d2aa-3849-9a2f8872001c@gmail.com>
Date:   Tue, 18 Jun 2019 23:13:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <5ea56278-05e2-794f-5f66-23343e72164c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers may rely on pci_disable_link_state() having disabled certain
ASPM link states. If OS can't control ASPM then pci_disable_link_state()
turns into a no-op w/o informing the caller. The driver therefore may
falsely assume the respective ASPM link states are disabled.
Let pci_disable_link_state() propagate errors to the caller, enabling
the caller to react accordingly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/pcie/aspm.c  | 20 +++++++++++---------
 include/linux/pci-aspm.h |  7 ++++---
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index fd4cb7508..e44af7f4d 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1062,18 +1062,18 @@ void pcie_aspm_powersave_config_link(struct pci_dev *pdev)
 	up_read(&pci_bus_sem);
 }
 
-static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
+static int __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 {
 	struct pci_dev *parent = pdev->bus->self;
 	struct pcie_link_state *link;
 
 	if (!pci_is_pcie(pdev))
-		return;
+		return 0;
 
 	if (pdev->has_secondary_link)
 		parent = pdev;
 	if (!parent || !parent->link_state)
-		return;
+		return -EINVAL;
 
 	/*
 	 * A driver requested that ASPM be disabled on this device, but
@@ -1085,7 +1085,7 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 	 */
 	if (aspm_disabled) {
 		pci_warn(pdev, "can't disable ASPM; OS doesn't have ASPM control\n");
-		return;
+		return -EPERM;
 	}
 
 	if (sem)
@@ -1105,11 +1105,13 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 	mutex_unlock(&aspm_lock);
 	if (sem)
 		up_read(&pci_bus_sem);
+
+	return 0;
 }
 
-void pci_disable_link_state_locked(struct pci_dev *pdev, int state)
+int pci_disable_link_state_locked(struct pci_dev *pdev, int state)
 {
-	__pci_disable_link_state(pdev, state, false);
+	return __pci_disable_link_state(pdev, state, false);
 }
 EXPORT_SYMBOL(pci_disable_link_state_locked);
 
@@ -1117,14 +1119,14 @@ EXPORT_SYMBOL(pci_disable_link_state_locked);
  * pci_disable_link_state - Disable device's link state, so the link will
  * never enter specific states.  Note that if the BIOS didn't grant ASPM
  * control to the OS, this does nothing because we can't touch the LNKCTL
- * register.
+ * register. Returns 0 or a negative errno.
  *
  * @pdev: PCI device
  * @state: ASPM link state to disable
  */
-void pci_disable_link_state(struct pci_dev *pdev, int state)
+int pci_disable_link_state(struct pci_dev *pdev, int state)
 {
-	__pci_disable_link_state(pdev, state, true);
+	return __pci_disable_link_state(pdev, state, true);
 }
 EXPORT_SYMBOL(pci_disable_link_state);
 
diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
index df28af5ce..67064145d 100644
--- a/include/linux/pci-aspm.h
+++ b/include/linux/pci-aspm.h
@@ -24,11 +24,12 @@
 #define PCIE_LINK_STATE_CLKPM	4
 
 #ifdef CONFIG_PCIEASPM
-void pci_disable_link_state(struct pci_dev *pdev, int state);
-void pci_disable_link_state_locked(struct pci_dev *pdev, int state);
+int pci_disable_link_state(struct pci_dev *pdev, int state);
+int pci_disable_link_state_locked(struct pci_dev *pdev, int state);
 void pcie_no_aspm(void);
 #else
-static inline void pci_disable_link_state(struct pci_dev *pdev, int state) { }
+static inline int pci_disable_link_state(struct pci_dev *pdev, int state)
+{ return 0; }
 static inline void pcie_no_aspm(void) { }
 #endif
 
-- 
2.22.0


