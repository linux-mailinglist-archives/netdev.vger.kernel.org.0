Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C612AE025
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbgKJTvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731613AbgKJTv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:51:29 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D79DC0613D1;
        Tue, 10 Nov 2020 11:51:29 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id o23so19373999ejn.11;
        Tue, 10 Nov 2020 11:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=HH3eQpgACFc0U7/w0sEUlYSVeHEP4oODaS+YLEBlqzk=;
        b=K7WBROx+NQYbR4nWTmYwYSoLBjquYRRNJUYANnNuVwBOfSGxffrEZsbRmOK4pFg+hV
         h+2ALZaHn/SjgGHYjul25syEsCXxShqAk/Hza3VuOs8lPmK25OPtx6XH/CyV/z8aIyZU
         sfc3yG2EQ9YjYcGvgsnP+LmEvtdlROiNwZ5Mck3wo+jHCeUnsKCK8e8jhnXfz6HywR9w
         CTNZ3x43OsxB7vmXt/o+1y53Ponh0LRShKzgVKb2DTdZ0+axHWLaq5pJFWktcpT6dLb6
         nOam/wXBAremig+CLzi/qYnWpbWOSz86uvvzNdjJpEnmkGtP1mATiiEbf0BQ7ZahoTHh
         e+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=HH3eQpgACFc0U7/w0sEUlYSVeHEP4oODaS+YLEBlqzk=;
        b=h8De7nWNofLLkkpbYZSDAuhj98RCtgYGHAqEZYSNQau499UprdwXdGA6/cIGrQQNZZ
         qWiLCCH32kszOjjIH8j8Dt8i8JGJJSDEFr0uUlt03eWJ9IsjyIeiHARTgBdc/InCO0Pm
         wK3APlcxcDXTQkzJRCcRi4HX5BM53HpkbU2GGnAIa+o09RSIwuEgftvDsFaSkroC+xOF
         hllm3mkZtGQV8l20iWeHP0jowrPr7ZkRc1/CwwmF+DlQXwLo4IVpkUF8/80C/PaFCBft
         wzEQ1gk+aNqSjt+EjTbn0cW2kQIU10jd6EGf+wbtAZs51CbUFXbIQ6ZN94CGT4/ImP2p
         CL7w==
X-Gm-Message-State: AOAM533hnIra35zlN5xfW8SDS3WCQwfzim7x/a0P1MloopldhTXPcOF4
        AEXFRy6GVnlun4NsEKbO0ws3TjbRXiotbA==
X-Google-Smtp-Source: ABdhPJzOpD+iG/6Kqb/nWpvnuEymcgQb7LmaE3K2QMu6lKg5LMdkfUVDy7WhCeJrttpFy6FWM4Y/Ow==
X-Received: by 2002:a17:906:f84f:: with SMTP id ks15mr20944652ejb.337.1605037887372;
        Tue, 10 Nov 2020 11:51:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:895e:e59d:3602:de4b? (p200300ea8f232800895ee59d3602de4b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:895e:e59d:3602:de4b])
        by smtp.googlemail.com with ESMTPSA id d23sm8595042edy.57.2020.11.10.11.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 11:51:26 -0800 (PST)
Subject: [PATCH net-next 5/5] net: usb: switch to dev_get_tstats64 and remove
 usbnet_get_stats64 alias
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Message-ID: <35569407-d028-ed00-bf2a-2fc572a938e9@gmail.com>
Date:   Tue, 10 Nov 2020 20:51:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace usbnet_get_stats64() with new identical core function
dev_get_tstats64() in all users and remove usbnet_get_stats64().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/usb/aqc111.c          | 2 +-
 drivers/net/usb/asix_devices.c    | 6 +++---
 drivers/net/usb/ax88172a.c        | 2 +-
 drivers/net/usb/ax88179_178a.c    | 2 +-
 drivers/net/usb/cdc_mbim.c        | 2 +-
 drivers/net/usb/cdc_ncm.c         | 2 +-
 drivers/net/usb/dm9601.c          | 2 +-
 drivers/net/usb/int51x1.c         | 2 +-
 drivers/net/usb/mcs7830.c         | 2 +-
 drivers/net/usb/qmi_wwan.c        | 2 +-
 drivers/net/usb/rndis_host.c      | 2 +-
 drivers/net/usb/sierra_net.c      | 2 +-
 drivers/net/usb/smsc75xx.c        | 2 +-
 drivers/net/usb/smsc95xx.c        | 2 +-
 drivers/net/usb/sr9700.c          | 2 +-
 drivers/net/usb/sr9800.c          | 2 +-
 drivers/net/wireless/rndis_wlan.c | 2 +-
 include/linux/usb/usbnet.h        | 2 --
 18 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 0717c1801..73b97f4cc 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -641,7 +641,7 @@ static const struct net_device_ops aqc111_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_change_mtu		= aqc111_change_mtu,
 	.ndo_set_mac_address	= aqc111_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index ef548beba..6e13d8165 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -194,7 +194,7 @@ static const struct net_device_ops ax88172_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= asix_ioctl,
@@ -580,7 +580,7 @@ static const struct net_device_ops ax88772_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= asix_ioctl,
@@ -1050,7 +1050,7 @@ static const struct net_device_ops ax88178_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= asix_set_multicast,
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index fd3a04d98..b404c9462 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -120,7 +120,7 @@ static const struct net_device_ops ax88172a_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= phy_do_ioctl_running,
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5541f3fae..d650b39b6 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1031,7 +1031,7 @@ static const struct net_device_ops ax88179_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_change_mtu		= ax88179_change_mtu,
 	.ndo_set_mac_address	= ax88179_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index eb100eb33..5db66272f 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -98,7 +98,7 @@ static const struct net_device_ops cdc_mbim_netdev_ops = {
 	.ndo_stop             = usbnet_stop,
 	.ndo_start_xmit       = usbnet_start_xmit,
 	.ndo_tx_timeout       = usbnet_tx_timeout,
-	.ndo_get_stats64      = usbnet_get_stats64,
+	.ndo_get_stats64      = dev_get_tstats64,
 	.ndo_change_mtu       = cdc_ncm_change_mtu,
 	.ndo_set_mac_address  = eth_mac_addr,
 	.ndo_validate_addr    = eth_validate_addr,
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f58853..abe1162dc 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -793,7 +793,7 @@ static const struct net_device_ops cdc_ncm_netdev_ops = {
 	.ndo_start_xmit	     = usbnet_start_xmit,
 	.ndo_tx_timeout	     = usbnet_tx_timeout,
 	.ndo_set_rx_mode     = usbnet_set_rx_mode,
-	.ndo_get_stats64     = usbnet_get_stats64,
+	.ndo_get_stats64     = dev_get_tstats64,
 	.ndo_change_mtu	     = cdc_ncm_change_mtu,
 	.ndo_set_mac_address = eth_mac_addr,
 	.ndo_validate_addr   = eth_validate_addr,
diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 915ac75b5..b5d2ac55a 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -343,7 +343,7 @@ static const struct net_device_ops dm9601_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl 		= dm9601_ioctl,
 	.ndo_set_rx_mode	= dm9601_set_multicast,
diff --git a/drivers/net/usb/int51x1.c b/drivers/net/usb/int51x1.c
index cb5bc1a7f..ed05f992c 100644
--- a/drivers/net/usb/int51x1.c
+++ b/drivers/net/usb/int51x1.c
@@ -133,7 +133,7 @@ static const struct net_device_ops int51x1_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= int51x1_set_multicast,
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 09bfa6a4d..fc512b780 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -462,7 +462,7 @@ static const struct net_device_ops mcs7830_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl 		= mcs7830_ioctl,
 	.ndo_set_rx_mode	= mcs7830_set_multicast,
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b9d74d9a7..afeb09b96 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -575,7 +575,7 @@ static const struct net_device_ops qmi_wwan_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address	= qmi_wwan_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 6fa7a009a..6609d21ef 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -279,7 +279,7 @@ static const struct net_device_ops rndis_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 0abd257b6..55a244eca 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -184,7 +184,7 @@ static const struct net_device_ops sierra_net_device_ops = {
 	.ndo_start_xmit         = usbnet_start_xmit,
 	.ndo_tx_timeout         = usbnet_tx_timeout,
 	.ndo_change_mtu         = usbnet_change_mtu,
-	.ndo_get_stats64        = usbnet_get_stats64,
+	.ndo_get_stats64        = dev_get_tstats64,
 	.ndo_set_mac_address    = eth_mac_addr,
 	.ndo_validate_addr      = eth_validate_addr,
 };
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 8689835a5..4353b3702 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1435,7 +1435,7 @@ static const struct net_device_ops smsc75xx_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_change_mtu		= smsc75xx_change_mtu,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index ea0d5f04d..4c8ee1cff 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1041,7 +1041,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl 		= smsc95xx_ioctl,
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index e04c8054c..878557ad0 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -308,7 +308,7 @@ static const struct net_device_ops sr9700_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= sr9700_ioctl,
 	.ndo_set_rx_mode	= sr9700_set_multicast,
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index 681e0def6..da56735d7 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -681,7 +681,7 @@ static const struct net_device_ops sr9800_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address	= sr_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= sr_ioctl,
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 75b5d545b..9fe775568 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3379,7 +3379,7 @@ static const struct net_device_ops rndis_wlan_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= rndis_wlan_set_multicast_list,
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 1f6dfa977..88a767389 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -284,6 +284,4 @@ extern void usbnet_status_stop(struct usbnet *dev);
 
 extern void usbnet_update_max_qlen(struct usbnet *dev);
 
-#define usbnet_get_stats64 dev_get_tstats64
-
 #endif /* __LINUX_USB_USBNET_H */
-- 
2.29.2


