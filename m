Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169EC3F0B6C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhHRTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhHRTHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A71C061764;
        Wed, 18 Aug 2021 12:07:01 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k29so5093401wrd.7;
        Wed, 18 Aug 2021 12:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zMnqmq7S4zAgBQO1n4C6IYMsmqGmjhbOsQkz4Cr8kT4=;
        b=ty7fq1PcmLJvMFCmbnlYR7niEzSPgBUJODekYszK0OHOpcvH/N5lQ3EAokFQ1nT13c
         OSFr8YfWzw0GnlLbWPC9cqltbY5aRNbySqnZtmNDvW5OnVqIy9OLiBCdDxMXPEcF+ZpF
         /Okae7tBsYOfokwszzg+Zk315T8yXO89ptdKsaCeP25fhz08ykrs3yfTnxatzeRYybuw
         QILvjyRynOvVQVUqDnZd+KiHyTzNlXoHP52ntxDsnVwhlfNQzLZAQGN00+vAj4vAfGR0
         nJa95ODd2mHDueyUsudjaOA5V313K3jwbI6OtnTKmwnFyrz19gbUaVyUzhmVLFtQHtUR
         czsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zMnqmq7S4zAgBQO1n4C6IYMsmqGmjhbOsQkz4Cr8kT4=;
        b=DsXsdRRojGJrptWsE7u4h5qnG0Gd/xoDyVkFgW29GeMG3aP8eeDxD63qWb8h9Ci/Sh
         Gy6CAy4CPAcPgFmgXZ2P0fSIy+L70F8LXE1eIET9t+xLjjM9eD5lRrw8GyQY0VuFcS2V
         FLtmkEGc/f4di9fDLrMVmKfWaCFP3NRwDMsAsi9j/+7U+BoN5BmEDnDWdpUy4up1F4kr
         STe0Jh3tKd8RTqQqFJneO0BouaZGMsiv0FTQuhAMPdH+nX4seTOi2yluvwT5euy0nQ88
         oUHQvpMYe9Kn8wkkDnB84I4MBH75o+NOqQlHq+pMEXtnhzeHvkWc8c/Mg9ssv7XribjX
         LHBg==
X-Gm-Message-State: AOAM531qAtpq8OhTWjYOnIZMakr5JKfUNFRZY8F30gIjkvI5U6iHH/jC
        y9wgoWQ4NI6oBRj42oOnREPpFGevFHNI1Q==
X-Google-Smtp-Source: ABdhPJwsjbscFfdd1R1vmBLczobtK9CJZZksM06H4ZzU1HHgvyNfXgkQ3EYkKhn8c+vA/tXkOvpODw==
X-Received: by 2002:a05:6000:1a86:: with SMTP id f6mr12651155wry.345.1629313619650;
        Wed, 18 Aug 2021 12:06:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id h9sm581023wmb.35.2021.08.18.12.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:06:59 -0700 (PDT)
Subject: [PATCH 1/8] PCI/VPD: Add pci_vpd_alloc
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <955ff598-0021-8446-f856-0c2c077635d7@gmail.com>
Date:   Wed, 18 Aug 2021 20:59:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several users of the VPD API use a fixed-size buffer and read the VPD
into it for further usage. This requires special handling for the case
that the buffer isn't big enough to hold the full VPD data.
Also the buffer is often allocated on the stack what's not too nice.
So let's extend the VPD API with a function that dynamically allocates
a properly sized buffer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c   | 26 ++++++++++++++++++++++++++
 include/linux/pci.h |  9 +++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 3b0425fb4..7c3a09737 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -270,6 +270,32 @@ const struct attribute_group pci_dev_vpd_attr_group = {
 	.is_bin_visible = vpd_attr_is_visible,
 };
 
+void *pci_vpd_alloc(struct pci_dev *dev, unsigned int *size)
+{
+	unsigned int len = dev->vpd.len;
+	void *buf;
+	int cnt;
+
+	if (!dev->vpd.cap)
+		return ERR_PTR(-ENODEV);
+
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	cnt = pci_read_vpd(dev, 0, len, buf);
+	if (cnt != len) {
+		kfree(buf);
+		return ERR_PTR(-EIO);
+	}
+
+	if (size)
+		*size = len;
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(pci_vpd_alloc);
+
 int pci_vpd_find_tag(const u8 *buf, unsigned int len, u8 rdt)
 {
 	int i = 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e752cc39a..3061cc943 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2330,6 +2330,15 @@ static inline u8 pci_vpd_info_field_size(const u8 *info_field)
 	return info_field[2];
 }
 
+/**
+ * pci_vpd_alloc - Allocates buffer and reads VPD into it
+ * @dev: PCI device
+ * @size: pointer to field where VPD length is returned
+ *
+ * Returns pointer to allocated buffer or an ERR_PTR in case of failure
+ */
+void *pci_vpd_alloc(struct pci_dev *dev, unsigned int *size);
+
 /**
  * pci_vpd_find_tag - Locates the Resource Data Type tag provided
  * @buf: Pointer to buffered vpd data
-- 
2.32.0


