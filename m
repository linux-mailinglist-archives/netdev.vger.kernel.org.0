Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FB3397815
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFAQcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:32:20 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:60726 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233853AbhFAQcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 12:32:16 -0400
Received: from omf03.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B2E59181D3025;
        Tue,  1 Jun 2021 16:30:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id D343313D94;
        Tue,  1 Jun 2021 16:30:30 +0000 (UTC)
Message-ID: <5780056e09dbbd285d470a313939e5d3cc1a0c3e.camel@perches.com>
Subject: Re: [PATCH] nfc: mrvl: remove useless "continue" at end of loop
From:   Joe Perches <joe@perches.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 01 Jun 2021 09:30:29 -0700
In-Reply-To: <20210601160713.312622-1-krzysztof.kozlowski@canonical.com>
References: <20210601160713.312622-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.00
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: D343313D94
X-Stat-Signature: o3qkn9t5grq5md5xm1h6mtcgc4rpcoyn
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+x6Np0T0GrHquofG0cRy8+fzcy4/IsBi4=
X-HE-Tag: 1622565030-517770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-06-01 at 18:07 +0200, Krzysztof Kozlowski wrote:
> The "continue" statement at the end of a for loop does not have an
> effect.
[]
> diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
[]
> @@ -325,7 +325,6 @@ static int nfcmrvl_probe(struct usb_interface *intf,
>  		if (!drv_data->bulk_rx_ep &&
>  		    usb_endpoint_is_bulk_in(ep_desc)) {
>  			drv_data->bulk_rx_ep = ep_desc;
> -			continue;
>  		}
>  	}

I think this code would be clearer with an if/else instead of
multiple continues.

---
 drivers/nfc/nfcmrvl/usb.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bcd563cb556ce..1616b873b15e6 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -296,7 +296,6 @@ static void nfcmrvl_waker(struct work_struct *work)
 static int nfcmrvl_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
-	struct usb_endpoint_descriptor *ep_desc;
 	struct nfcmrvl_usb_drv_data *drv_data;
 	struct nfcmrvl_private *priv;
 	int i;
@@ -314,19 +313,16 @@ static int nfcmrvl_probe(struct usb_interface *intf,
 		return -ENOMEM;
 
 	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *ep_desc;
+
 		ep_desc = &intf->cur_altsetting->endpoint[i].desc;
 
 		if (!drv_data->bulk_tx_ep &&
-		    usb_endpoint_is_bulk_out(ep_desc)) {
+		    usb_endpoint_is_bulk_out(ep_desc))
 			drv_data->bulk_tx_ep = ep_desc;
-			continue;
-		}
-
-		if (!drv_data->bulk_rx_ep &&
-		    usb_endpoint_is_bulk_in(ep_desc)) {
+		else if (!drv_data->bulk_rx_ep &&
+			 usb_endpoint_is_bulk_in(ep_desc))
 			drv_data->bulk_rx_ep = ep_desc;
-			continue;
-		}
 	}
 
 	if (!drv_data->bulk_tx_ep || !drv_data->bulk_rx_ep)


