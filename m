Return-Path: <netdev+bounces-8867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C8C572624F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98EE31C20C03
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633B535B5C;
	Wed,  7 Jun 2023 14:07:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F7135B58
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:07:57 +0000 (UTC)
X-Greylist: delayed 580 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Jun 2023 07:07:24 PDT
Received: from qs51p00im-qukt01071502.me.com (qs51p00im-qukt01071502.me.com [17.57.155.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D762690
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pen.gy; s=sig1;
	t=1686146265; bh=RJKOsdchCAYMjlGQ0yDJPhRfsJKL5Y6GSfkOE7ZQozU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WKYkfppaIOYfdS9wrdRkh/MSlnJvELEJVhEyX+rQvCNXmX2CFSsaoEg1OYRYZFk+t
	 YdK+8fuwTDDUylmLSlgZWfFE91+kP1qObStP9GtgNJm7hvW+9+vyIj07/Z3AC/CVQw
	 HZqoRvSgIFZ3gzmobEBnuJYoEpovFQULHyV3vBHct1UTaSHlH4eZC2Jth3rQCkh6pA
	 FLI8CVdyIOa6PZqBW2CyiS01pkFRcOWHQa5qUnYCGmhEDd92rK1EccFvlRObT2N8q9
	 litwpsEHAP0N8wx0csnZiOLcgMR896LE6AHggdnHH7jQegaNheagUZQYl2NhZkAQIs
	 prrwizzchG9vw==
Received: from fossa.iopsys.eu (qs51p00im-dlb-asmtp-mailmevip.me.com [17.57.155.28])
	by qs51p00im-qukt01071502.me.com (Postfix) with ESMTPSA id CFFBB66803EB;
	Wed,  7 Jun 2023 13:57:43 +0000 (UTC)
From: Foster Snowhill <forst@pen.gy>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Georgi Valkov <gvalkov@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v4 2/4] usbnet: ipheth: transmit URBs without trailing padding
Date: Wed,  7 Jun 2023 15:57:00 +0200
Message-Id: <20230607135702.32679-2-forst@pen.gy>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607135702.32679-1-forst@pen.gy>
References: <20230607135702.32679-1-forst@pen.gy>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: RFdcnoZeOWCl48ZoohQ38dWzXQog5SOo
X-Proofpoint-GUID: RFdcnoZeOWCl48ZoohQ38dWzXQog5SOo
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F02:2020-02-14=5F02,2022-01-12=5F02,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1030 suspectscore=0 malwarescore=0 mlxlogscore=592 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2306070117
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The behaviour of the official iOS tethering driver on macOS is to not
transmit any trailing padding at the end of URBs. This is applicable
to both NCM and legacy modes, including older devices.

Adapt the driver to not include trailing padding in TX URBs, matching
the behaviour of the official macOS driver.

Signed-off-by: Foster Snowhill <forst@pen.gy>
Tested-by: Georgi Valkov <gvalkov@gmail.com>
---
Tested by Georgi Valkov on iPhone 3G (iOS 4.2.1), iPhone 4s (iOS 8.4),
iPhone 7 Plus (iOS 15.7.6).

Tested by Foster Snowhill on iPhone Xs Max (iOS 16.5).

Additionally both Georgi and Foster did USB traffic captures with the
devices above on macOS 13.4, this confirmed the macOS driver behaviour.

v4:
  No code change.
  Factored out from "usbnet: ipheth: add CDC NCM support".
v3: n/a
  Part of https://lore.kernel.org/netdev/20230527130309.34090-2-forst@pen.gy/
v2: n/a
  Part of https://lore.kernel.org/netdev/20230525194255.4516-2-forst@pen.gy/
v1: n/a
  Part of https://lore.kernel.org/netdev/20230516210127.35841-1-forst@pen.gy/
---
 drivers/net/usb/ipheth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 8875a3d0e..dd809e247 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -373,12 +373,10 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct net_device *net)
 	}
 
 	memcpy(dev->tx_buf, skb->data, skb->len);
-	if (skb->len < IPHETH_BUF_SIZE)
-		memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb->len);
 
 	usb_fill_bulk_urb(dev->tx_urb, udev,
 			  usb_sndbulkpipe(udev, dev->bulk_out),
-			  dev->tx_buf, IPHETH_BUF_SIZE,
+			  dev->tx_buf, skb->len,
 			  ipheth_sndbulk_callback,
 			  dev);
 	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-- 
2.40.1


