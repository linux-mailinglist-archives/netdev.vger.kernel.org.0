Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAFA2E8CAD
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 15:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhACOm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 09:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbhACOm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 09:42:56 -0500
X-Greylist: delayed 351 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Jan 2021 06:42:16 PST
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8385DC061573;
        Sun,  3 Jan 2021 06:42:16 -0800 (PST)
Received: from localhost.localdomain (85-76-69-38-nat.elisa-mobile.fi [85.76.69.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jks)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 6C07D1B00447;
        Sun,  3 Jan 2021 16:36:22 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1609684582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2D7sv07CaCANRKUEJ7jSGB4NI45E+OpFL+ReXHcGRkA=;
        b=Z86JueFnIdLdvbFBIzXH8KznVY3kd+wLIeV61jfafwPkZeMZrRuGaQln0s4HHm690q3/cb
        mkEVOd5dRUOIuHtLl8aa7nd8uopM0sxrHTHi8higglktutbH5HkAwbCBCP8z/9LR/DfOL1
        KpKXeDAB6345oT43UZOD6zsG3uVWdFQj9KPZcEvtRBbZ55A72akgfWfoj0K9ceSTFpObVo
        O4IlTOMVGCB970tXTEiDbfBZ1efo8F5tjcsKGr2JNRpkeVdF6x69YsozL0hp/oI1hqkJv/
        xwdpPI+Qivehg+3Qj4YDz7ezgVvrM5ARw19NHnLOvKKiZrncsXKUV5BtPIQ1yA==
From:   =?UTF-8?q?Jouni=20Sepp=C3=A4nen?= <jks@iki.fi>
To:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org
Cc:     jks@iki.fi, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net,stable] net: cdc_ncm: correct overhead in delayed_ndp_size
Date:   Sun,  3 Jan 2021 16:36:02 +0200
Message-Id: <20210103143602.95343-1-jks@iki.fi>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1609684582; a=rsa-sha256;
        cv=none;
        b=VJ7fKwKN1NeiVBHWK1d5OctF2gcF/NQEf1uiwL73eZyiSffw+NgKhkqV6qK4eoXfQXOFR2
        oTH37AaSbrUyn9kMp2kKDDE5LJFBPYMnZHrOeqYSonmXjQBFW/676phAic3d3DhIA7pQ+O
        TpRtyxAiromH/rJ+FmdWZrEmu1bYqsCjw8bo2KNlKzReCc9Ur+hO6SZP9uVtLzwaTLO6bS
        iBivVF07+MgbGNdmxSs8RMWQrD0QdVz70PknVtOReK+TaNOQ+VTpMLWBeUu7kX/TYc9R9b
        FoAMrcYPAVNMw2bple2+KQn7SdkDQTtwfCnCKsonnZmj5VDaGmgnCCRQkw9nDQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jks smtp.mailfrom=jks@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1609684582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2D7sv07CaCANRKUEJ7jSGB4NI45E+OpFL+ReXHcGRkA=;
        b=B7cBdfqRm93jIxXrsBwjkTs8IUeX2mO1Mm7fSOmEMGT5CLqm414PsmGGzxWxiKb4Pe9RmP
        eIa7cnYaf8QClMOz4nEAATfsUWKpowCBV5JgquhhbeldYySee1/njGalpyXRAZe43Bsfm0
        DArpsbQpjphtXVfEpMyN/CXi3Re8R/C0Z2/LUz14RLBh1wPo8seMf9RFRYn1sJraEiZRxD
        iCT0Pei5+WN3+yvUt3Aje6A+v9qtkNm5+tCkZh0mWhbKxb1No99onmBLFhso1Nm7m/jgfB
        vZUyDn5o4ScrW3toMizlsVJfAj9x55fTYOEVCXt+pQCfTXTa6zQavybxtfFY0g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni K. Seppänen <jks@iki.fi>

Aligning to tx_ndp_modulus is not sufficient because the next align
call can be cdc_ncm_align_tail, which can add up to ctx->tx_modulus +
ctx->tx_remainder - 1 bytes. This used to lead to occasional crashes
on a Huawei 909s-120 LTE module as follows:

- the condition marked /* if there is a remaining skb [...] */ is true
  so the swaps happen
- skb_out is set from ctx->tx_curr_skb
- skb_out->len is exactly 0x3f52
- ctx->tx_curr_size is 0x4000 and delayed_ndp_size is 0xac
  (note that the sum of skb_out->len and delayed_ndp_size is 0x3ffe)
- the for loop over n is executed once
- the cdc_ncm_align_tail call marked /* align beginning of next frame */
  increases skb_out->len to 0x3f56 (the sum is now 0x4002)
- the condition marked /* check if we had enough room left [...] */ is
  false so we break out of the loop
- the condition marked /* If requested, put NDP at end of frame. */ is
  true so the NDP is written into skb_out
- now skb_out->len is 0x4002, so padding_count is minus two interpreted
  as an unsigned number, which is used as the length argument to memset,
  leading to a crash with various symptoms but usually including

> Call Trace:
>  <IRQ>
>  cdc_ncm_fill_tx_frame+0x83a/0x970 [cdc_ncm]
>  cdc_mbim_tx_fixup+0x1d9/0x240 [cdc_mbim]
>  usbnet_start_xmit+0x5d/0x720 [usbnet]

The cdc_ncm_align_tail call first aligns on a ctx->tx_modulus
boundary (adding at most ctx->tx_modulus-1 bytes), then adds
ctx->tx_remainder bytes. Alternatively, the next alignment call can
occur in cdc_ncm_ndp16 or cdc_ncm_ndp32, in which case at most
ctx->tx_ndp_modulus-1 bytes are added.

A similar problem has occurred before, and the code is nontrivial to
reason about, so add a guard before the crashing call. By that time it
is too late to prevent any memory corruption (we'll have written past
the end of the buffer already) but we can at least try to get a warning
written into an on-disk log by avoiding the hard crash caused by padding
past the buffer with a huge number of zeros.

Signed-off-by: Jouni K. Seppänen <jks@iki.fi>
Fixes: 4a0e3e989d66 ("cdc_ncm: Add support for moving NDP to end of NCM frame")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209407
---
 drivers/net/usb/cdc_ncm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f588538cc..59f0711b1b63 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1199,7 +1199,9 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	 * accordingly. Otherwise, we should check here.
 	 */
 	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END)
-		delayed_ndp_size = ALIGN(ctx->max_ndp_size, ctx->tx_ndp_modulus);
+		delayed_ndp_size = ctx->max_ndp_size +
+			max(ctx->tx_ndp_modulus,
+			    ctx->tx_modulus + ctx->tx_remainder) - 1;
 	else
 		delayed_ndp_size = 0;
 
@@ -1410,7 +1412,8 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	if (!(dev->driver_info->flags & FLAG_SEND_ZLP) &&
 	    skb_out->len > ctx->min_tx_pkt) {
 		padding_count = ctx->tx_curr_size - skb_out->len;
-		skb_put_zero(skb_out, padding_count);
+		if (!WARN_ON(padding_count > ctx->tx_curr_size))
+			skb_put_zero(skb_out, padding_count);
 	} else if (skb_out->len < ctx->tx_curr_size &&
 		   (skb_out->len % dev->maxpacket) == 0) {
 		skb_put_u8(skb_out, 0);	/* force short packet */
-- 
2.20.1

