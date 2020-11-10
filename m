Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4422AE029
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgKJTv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJTvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:51:24 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCF1C0613D1;
        Tue, 10 Nov 2020 11:51:23 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id w13so19330168eju.13;
        Tue, 10 Nov 2020 11:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=fqQzZPFdwUoIi61+74s2tJDUiiLXIPVm1vc/LuVT+UM=;
        b=WAzzuLpwx3lQWSi9dW5jFp6+CCEoH24YnMXivjI2nttQ8RRXW+IUZyEapY/CnRlA8m
         K6GuwxhihBBPt7hXu+fgVqtxIDX3usa+uY4lrTGJikrNEM1RFIc+wyIob7fKpdfIcJVw
         Sx5XvNxCCvx091/h/yzYJ6at7gYYdSqsgFSX8S0l/Mm2ELIETebG6YT09zxom/+6rljw
         an9jiJLE9AnZ/IVKz0chNGBrHP8D9kT+nv2GG1l7lWvfD71fANFjGPNdeS+55CrAo13j
         RMucccgPPsMbMFebxHM1NHz4hUhXSTJ4YymF821NHvMnJBxAClF+zxV7sljGubER+r9X
         D8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=fqQzZPFdwUoIi61+74s2tJDUiiLXIPVm1vc/LuVT+UM=;
        b=m/ZPIc6cqWMyTKQn4zcRYYD2BJ/h2AeHDTwJXn/YJgISAiQT7UBF+u2qg5GDOvBvXW
         5YLB+WS5i5YHMRPc+DVu4jIGsDjH8O9zqAiu9DfGAOYDM0cZ8oe9DwXGJKiuEWK2O9Zo
         g7x+oQlOSjWoJowd1oZ0w8EOGGsSgdeJb2E/dF8fnk+T9WT1HAmpQCsWcuYETaLKOahA
         vz/3YDI/KCmA7Q9xkQD6C5rX9R/FEBqtH6UrGI1rj4pDosZvQefVOkcKmqRg5KGe3dwB
         9i4dwUBDWUBaSu6nruoBDt1z/fzjplUpDIOoqNROWgWJOH6ZzQiWXBNsSNuJ/Qr4Uun9
         WqyA==
X-Gm-Message-State: AOAM533LVZNlGAX9KsfTgOEi4UjnayECPfNcuyqsYoLUagpvb4x+1d59
        L4ZY01kw6viV/jynIQqMJeBBCBpp3wIz0A==
X-Google-Smtp-Source: ABdhPJw2pUNEDKoB9g04hdsxUC1eo3fbKJVX8oizhRE8OZsS5qANAdeC6A6ODx9OSbsEDjVBTOzvBQ==
X-Received: by 2002:a17:906:138c:: with SMTP id f12mr22613982ejc.108.1605037882273;
        Tue, 10 Nov 2020 11:51:22 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:895e:e59d:3602:de4b? (p200300ea8f232800895ee59d3602de4b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:895e:e59d:3602:de4b])
        by smtp.googlemail.com with ESMTPSA id e2sm11153502edu.93.2020.11.10.11.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 11:51:21 -0800 (PST)
Subject: [PATCH net-next 2/5] qmi_wwan: switch to core handling of rx/tx
 byte/packet counters
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
Message-ID: <c3eb3707-cac8-5db2-545d-8a3b4de39dad@gmail.com>
Date:   Tue, 10 Nov 2020 20:48:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of qmimux_priv for storing
a pointer to the per-cpu counters. This allows us to use core
functionality for statistics handling.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 39 ++++++++------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 581ed51ab..b9d74d9a7 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -72,7 +72,6 @@ struct qmimux_hdr {
 struct qmimux_priv {
 	struct net_device *real_dev;
 	u8 mux_id;
-	struct pcpu_sw_netstats __percpu *stats64;
 };
 
 static int qmimux_open(struct net_device *dev)
@@ -108,34 +107,19 @@ static netdev_tx_t qmimux_start_xmit(struct sk_buff *skb, struct net_device *dev
 	skb->dev = priv->real_dev;
 	ret = dev_queue_xmit(skb);
 
-	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN)) {
-		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(priv->stats64);
-
-		u64_stats_update_begin(&stats64->syncp);
-		stats64->tx_packets++;
-		stats64->tx_bytes += len;
-		u64_stats_update_end(&stats64->syncp);
-	} else {
+	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN))
+		dev_sw_netstats_tx_add(dev, 1, len);
+	else
 		dev->stats.tx_dropped++;
-	}
 
 	return ret;
 }
 
-static void qmimux_get_stats64(struct net_device *net,
-			       struct rtnl_link_stats64 *stats)
-{
-	struct qmimux_priv *priv = netdev_priv(net);
-
-	netdev_stats_to_stats64(stats, &net->stats);
-	dev_fetch_sw_netstats(stats, priv->stats64);
-}
-
 static const struct net_device_ops qmimux_netdev_ops = {
 	.ndo_open        = qmimux_open,
 	.ndo_stop        = qmimux_stop,
 	.ndo_start_xmit  = qmimux_start_xmit,
-	.ndo_get_stats64 = qmimux_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 };
 
 static void qmimux_setup(struct net_device *dev)
@@ -224,14 +208,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			net->stats.rx_errors++;
 			return 0;
 		} else {
-			struct pcpu_sw_netstats *stats64;
-			struct qmimux_priv *priv = netdev_priv(net);
-
-			stats64 = this_cpu_ptr(priv->stats64);
-			u64_stats_update_begin(&stats64->syncp);
-			stats64->rx_packets++;
-			stats64->rx_bytes += pkt_len;
-			u64_stats_update_end(&stats64->syncp);
+			dev_sw_netstats_rx_add(net, pkt_len);
 		}
 
 skip:
@@ -256,8 +233,8 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	priv->mux_id = mux_id;
 	priv->real_dev = real_dev;
 
-	priv->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!priv->stats64) {
+	new_dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!new_dev->tstats) {
 		err = -ENOBUFS;
 		goto out_free_newdev;
 	}
@@ -292,7 +269,7 @@ static void qmimux_unregister_device(struct net_device *dev,
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
-	free_percpu(priv->stats64);
+	free_percpu(dev->tstats);
 	netdev_upper_dev_unlink(real_dev, dev);
 	unregister_netdevice_queue(dev, head);
 
-- 
2.29.2


