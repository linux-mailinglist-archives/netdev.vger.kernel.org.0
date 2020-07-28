Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430DA2309A3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgG1MLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:11:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43489 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728840AbgG1MLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:11:34 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so20838297ljj.10;
        Tue, 28 Jul 2020 05:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hTBfJmBRO5Rb64D0GBJ0IiAqZ76bUdrzaMxwh1TXFb0=;
        b=SxtkdkwgMSjEAcuV1Dh1I50cvoCjAQVjCl6D++s/CsUzq8Z4qf+3NfcCl/eI1Q2m1G
         4jGS6LQ9YBUvW2OAaqTPtO/usjPSpS/OjWpDEDlCohJMpIa4tJe0LUZT8caKFoQDWQ2Q
         YV1R1sFhQOUblymsyM2PMkXKHq+p7v2pmVOztJMqLrXHVv6DsI6W8sdlnAYkBpT0eagR
         BFRf2ebsn2E0SzKma0GRnsmXNnL6a5B0t9GRu8lTwpfWsjqAJMxy5R3ibXqa2xbvT1zh
         tWkSrI98H2j8w6c+UM7bb4ThimPM2+UoA8WqBoey6p5A3qfRKLR2Q9C1rYtqoKt/Ip/S
         nycg==
X-Gm-Message-State: AOAM533WefW2+4CXk3+Lc3q0ZftEBgQWBk/KSAxMRZ31BSlhHtbmAE3d
        /71S/8HLtXmNfE+EY48ZP2vdBjQF
X-Google-Smtp-Source: ABdhPJzC1SMcuOdVj/5aYJlv/u9WFtJAP1KL6sA78L8BZzYm79E/lc2vkanmCzzPMo2ko/B+G5/ZlQ==
X-Received: by 2002:a05:651c:294:: with SMTP id b20mr5420677ljo.4.1595938291950;
        Tue, 28 Jul 2020 05:11:31 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id o16sm1728264ljc.66.2020.07.28.05.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:11:30 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1k0OS6-0003Dn-A8; Tue, 28 Jul 2020 14:11:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        "Woojung . Huh @ microchip . com" <Woojung.Huh@microchip.com>
Subject: [PATCH net 1/3] net: lan78xx: add missing endpoint sanity check
Date:   Tue, 28 Jul 2020 14:10:29 +0200
Message-Id: <20200728121031.12323-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728121031.12323-1-johan@kernel.org>
References: <20200728121031.12323-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing endpoint sanity check to prevent a NULL-pointer
dereference should a malicious device lack the expected endpoints.

Note that the driver has a broken endpoint-lookup helper,
lan78xx_get_endpoints(), which can end up accepting interfaces in an
altsetting without endpoints as long as *some* altsetting has a bulk-in
and a bulk-out endpoint.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: Woojung.Huh@microchip.com <Woojung.Huh@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/lan78xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index eccbf4cd7149..d7162690e3f3 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3759,6 +3759,11 @@ static int lan78xx_probe(struct usb_interface *intf,
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
+		ret = -ENODEV;
+		goto out3;
+	}
+
 	dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
 	dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
 	dev->ep_intr = (intf->cur_altsetting)->endpoint + 2;
-- 
2.26.2

