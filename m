Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A6E17499A
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgB2W32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:28 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42674 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgB2W31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:27 -0500
Received: by mail-wr1-f65.google.com with SMTP id p18so7763660wre.9;
        Sat, 29 Feb 2020 14:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=On6Ph2Wa/oxdpxBxYF8saGAQm3IaLWIIsWy8iRxmdwQ=;
        b=GN7Qn4p/fWcOcPRqpHYleRN6R6OWLs1ts3joPiWmqUjCfAcnFya5r/AF+hxEjDvVlM
         KT5pkRNZLz6jK77mjmKrRTvJHeWG13A20eNAnWpyT8uVzGI2Xc2iCWGYc+xaW0V9zOPN
         nbM7Qx2JdyynEoFArm3B1OBvubjIMgETxFK7yhQBZQBKZ4UCXZOFDlFhFAjic8Dttmai
         6SjqAgr2YGrjoo3274vnf+35sJai91+/IFRWXyqFahbk0jrwsmYWBw/2IwmdgAm37Rke
         +QfMRnnERHHPR6z5i6Tx94L9AcSpVmnzvD3M1D9pHn4awci5We0Fy9HWL2oWNKCZjYbs
         TDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=On6Ph2Wa/oxdpxBxYF8saGAQm3IaLWIIsWy8iRxmdwQ=;
        b=DJgaPMctlfWpBE1eCNsFLZ1QpcbDcbt2bAvEkB+5+aw2SP69NCrgff3sbVYuUhLI11
         efS45l1edqAUdOoQzdkyS3mFzpVHOJ0iQ4Jj2Qa5nWAOzgtcd5FazIFplqd8aaLBmhqx
         1Kbnx+Dt3YXnx5HkooVGbjW41u3RrQfpI2UxoQvcaWcMuzM7XLS+pnjojqU7H70+YDu6
         Cqha49bmMQl3lrVz8d0rhDNvg5uX9gcP014JVDRe48Y1JtXPp8AHe8AP+K6glXoHw0tl
         L+w5uB+q8tTeH29JHT2MwnWfW7wwEvQSjXRBT7h4KvX3UEfwjkeayJRldaz/O4QRfL1s
         JPVw==
X-Gm-Message-State: APjAAAWGsGRm2QoUKoTXb5Gna/EipuPiziTT+I3cGl4iSzg8QNJmYjNM
        cjAr1Jv9SYN8y9cAt/G61ug=
X-Google-Smtp-Source: APXvYqwSlXcxniZ13ry9LyVrVt4CFktdOfbXViWq9Te4zmzKgkoUro/HE76JxXpRgoXw6acfbLj4Qw==
X-Received: by 2002:adf:de09:: with SMTP id b9mr12146765wrm.160.1583015365283;
        Sat, 29 Feb 2020 14:29:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id m21sm7852123wmi.27.2020.02.29.14.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:24 -0800 (PST)
Subject: [PATCH v4 02/10] net: skfp: add PCI_STATUS_REC_TARGET_ABORT to PCI
 status error bits
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Message-ID: <32caa349-cf26-7409-47d4-20740509c776@gmail.com>
Date:   Sat, 29 Feb 2020 23:21:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out PCI_STATUS error bit handling let drivers
use the same collection of error bits. To facilitate bisecting we do this
in a separate patch per affected driver. For the skfp driver we have to
add PCI_STATUS_REC_TARGET_ABORT to the error bits.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/fddi/skfp/h/skfbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 480795681..36e20a514 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -34,7 +34,7 @@
 #define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */ 
 
 
-#define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
+#define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
 
 
 
-- 
2.25.1


