Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB9406731
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 08:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhIJG3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 02:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhIJG3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 02:29:21 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C98C061574;
        Thu,  9 Sep 2021 23:28:10 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x6so1012185wrv.13;
        Thu, 09 Sep 2021 23:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u3zmKxjyEOJYPS9SmOYf4AyL2ftl92VU0j3IVWq2EsQ=;
        b=keUOb0zmKQpvnkuqvN6cdLjxbAuLWTs3i/G0FYIrj9QcV0k0cD70JY6A6RMvUyjrzi
         kPnhyHoaSI/6MOp+j+LSxn6JATI1IRnf09f/pq+eLSutFdAOKxF3S79KyieuBMyM3ZOK
         YNHfrSZwJ9A8ImX0UW/5oUycaBNduu5Oe+R5IEOqAYPCSqH7f5zZhgZo4uwGgo/CQ0za
         +1WhoFzz/4AaUS0wN4Lf/6NvCpYh6/ekpPuluRSvljd2YfVTwSl26k3gMHpLyfjuibRl
         4QnsA4Db4JoEAFEjKjNlXU13U7kQoq9dIV8lZ+LmVdoBh6DM5+5PiF4PqH5bRt9p/QZZ
         NWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u3zmKxjyEOJYPS9SmOYf4AyL2ftl92VU0j3IVWq2EsQ=;
        b=ZOtP6nWrhpUQ9ddb+pokRkXdJOlzEuYqBJyXCXb2+CY68iEd+hMUGgS8aXsLeA4vAb
         yBN8ubXs+Y3h10E33aLuJ1HcnEoI1HwSVa8Cd26EN1sixIRZjPO/YbfEzqwYCvCQNAf5
         wg3WzKy1DnQHC0A69StAr9bDldU8YYH04khMpAtrZj25umECeoT2AWXm6SDCCeoN7EwU
         HOks6QvbydKeD3Fg6kh6tnZGlIIjUGLiQj17WfRm1ifsu2aaaO+LiPUXhcoUiBkRYyuD
         vf5OA4lIVHc/McwEhzOjv/KwH2Ed6QHlGC5t4+9wdjUdo8qdlrGDXPBQgTgbtzgtb0Ou
         o+tg==
X-Gm-Message-State: AOAM53077CgqczoQlY52ZrvsBIBdzUgtFIMqKRv7zf8ofUaIc38hKk7D
        AXTYJ3/RaXLfRtmHtf0OduIckGLStH4=
X-Google-Smtp-Source: ABdhPJwfcI+3IV3Pu6oVC7YZ+/UypQtZ06cU1n1FaZglyS7f5Yu1bM9nuEY5tzutE5WPCcXlMuQ8ig==
X-Received: by 2002:adf:fdd2:: with SMTP id i18mr7686897wrs.406.1631255288922;
        Thu, 09 Sep 2021 23:28:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c9c:396a:4a57:ee58? (p200300ea8f0845000c9c396a4a57ee58.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c9c:396a:4a57:ee58])
        by smtp.googlemail.com with ESMTPSA id t23sm3912274wrb.71.2021.09.09.23.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 23:28:08 -0700 (PDT)
Subject: [PATCH 2/5] PCI/VPD: Use pci_read_vpd_any() in pci_vpd_size()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Message-ID: <049fa71c-c7af-9c69-51c0-05c1bc2bf660@gmail.com>
Date:   Fri, 10 Sep 2021 08:22:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new function pci_read_vpd_any() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/vpd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index 286cad2a6..517789205 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -57,10 +57,7 @@ static size_t pci_vpd_size(struct pci_dev *dev)
 	size_t off = 0, size;
 	unsigned char tag, header[1+2];	/* 1 byte tag, 2 bytes length */
 
-	/* Otherwise the following reads would fail. */
-	dev->vpd.len = PCI_VPD_MAX_SIZE;
-
-	while (pci_read_vpd(dev, off, 1, header) == 1) {
+	while (pci_read_vpd_any(dev, off, 1, header) == 1) {
 		size = 0;
 
 		if (off == 0 && (header[0] == 0x00 || header[0] == 0xff))
@@ -68,7 +65,7 @@ static size_t pci_vpd_size(struct pci_dev *dev)
 
 		if (header[0] & PCI_VPD_LRDT) {
 			/* Large Resource Data Type Tag */
-			if (pci_read_vpd(dev, off + 1, 2, &header[1]) != 2) {
+			if (pci_read_vpd_any(dev, off + 1, 2, &header[1]) != 2) {
 				pci_warn(dev, "failed VPD read at offset %zu\n",
 					 off + 1);
 				return off ?: PCI_VPD_SZ_INVALID;
-- 
2.33.0


