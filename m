Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC522EBDA3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbhAFMYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbhAFMYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 07:24:47 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9320DC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 04:24:06 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id a12so6087277lfl.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 04:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ADeSGOTFgYQq708CfDZlmoQoQzMLbuH24kuiT1lc0fE=;
        b=QYi8xYr94jnZxo8zB9id8L5X9/1yVVXNxngKxOoco+wsuO93K7V1mRnIZ14O+HAdV0
         ghB8SajLMAt6MwKxKhyE276dBRB/+JnDx/eFi0VtxRwp9lFx4mhwPy3bMpsu62CbH4OJ
         OGeIai/ajlnwubnH6KpRIITW1XeAlyREPomdTxJPPOCaIjrXO5YAJ7je1WimRSOF9yQ+
         ALyGc85w5v1/K3OWv44k7YNmGy8Ej+PIGFLa+9redEfj7VJJstT0f52K+Q83SXZk6U4g
         QKGv/Zy2aoiVqighwxDTAIGKw6SWDO1EkNqvppvh/uN8evDqvS5zwYlPTO3BBI3oG6wq
         JPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ADeSGOTFgYQq708CfDZlmoQoQzMLbuH24kuiT1lc0fE=;
        b=sw/l5XhozsmAF9x4wyFdkP+kmUCBtgPfUrwGSk0zUxhP6vGjW4uljoaHWvExoXzOOW
         8xQcex+v4uQdDh9KMGXyOGzmLTEbuYjxzrwqafBRF3Itkx3uj/W89Y3l1Us2URHCy426
         ME/9w46MWKe6UHQlWpeG9KSNO1Jv2GjvzYb+FcAvSDQTo+iF1TJPH161402VNMWHVwwx
         1j+Iewif59BmcIkLM1r9FqMW2GGoe8xDU0a1ntQPXvb38j6i1cqI8Bq02J+500YjLiSX
         /TfqKOEJVPi5fSXm4WqCvGq1MO8Uf6MWQct93bj8PnSwgmRDFr3CroNTm+YnsabEIPcQ
         n61w==
X-Gm-Message-State: AOAM531dy9WKZnFshNr3nFZkrcfqJkqNsPJfn6iaP4WsHVRfq9lUVzCb
        7Cc27tXbprQZuzGnG2kpeO9jJd950f0=
X-Google-Smtp-Source: ABdhPJy1srAag+Ff5SPHuig8xh6D3r2I8qBo8zGOCXdgqZld5zuoHo7ksbPGkw5g2GKiWlHWGE6Xew==
X-Received: by 2002:ac2:5145:: with SMTP id q5mr1695491lfd.626.1609935845129;
        Wed, 06 Jan 2021 04:24:05 -0800 (PST)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id g4sm324205lfc.85.2021.01.06.04.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 04:24:04 -0800 (PST)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netdev@vger.kernel.org, bjorn@mork.no
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH net-next] qmi_wwan: Increase headroom for QMAP SKBs
Date:   Wed,  6 Jan 2021 13:24:03 +0100
Message-Id: <20210106122403.1321180-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When measuring the throughput (iperf3 + TCP) while routing on a
not-so-powerful device (Mediatek MT7621, 880MHz CPU), I noticed that I
achieved significantly lower speeds with QMI-based modems than for
example a USB LAN dongle. The CPU was saturated in all of my tests.

With the dongle I got ~300 Mbit/s, while I only measured ~200 Mbit/s
with the modems. All offloads, etc.  were switched off for the dongle,
and I configured the modems to use QMAP (16k aggregation). The tests
with the dongle were performed in my local (gigabit) network, while the
LTE network the modems were connected to delivers 700-800 Mbit/s.

Profiling the kernel revealed the cause of the performance difference.
In qmimux_rx_fixup(), an SKB is allocated for each packet contained in
the URB. This SKB has too little headroom, causing the check in
skb_cow() (called from ip_forward()) to fail. pskb_expand_head() is then
called and the SKB is reallocated. In the output from perf, I see that a
significant amount of time is spent in pskb_expand_head() + support
functions.

In order to ensure that the SKB has enough headroom, this commit
increases the amount of memory allocated in qmimux_rx_fixup() by
LL_MAX_HEADER. The reason for using LL_MAX_HEADER and not a more
accurate value, is that we do not know the type of the outgoing network
interface. After making this change, I achieve the same throughput with
the modems as with the dongle.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index af19513a9..7ea113f51 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -186,7 +186,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		net = qmimux_find_dev(dev, hdr->mux_id);
 		if (!net)
 			goto skip;
-		skbn = netdev_alloc_skb(net, pkt_len);
+		skbn = netdev_alloc_skb(net, pkt_len + LL_MAX_HEADER);
 		if (!skbn)
 			return 0;
 		skbn->dev = net;
@@ -203,6 +203,7 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			goto skip;
 		}
 
+		skb_reserve(skbn, LL_MAX_HEADER);
 		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, pkt_len);
 		if (netif_rx(skbn) != NET_RX_SUCCESS) {
 			net->stats.rx_errors++;
-- 
2.25.1

