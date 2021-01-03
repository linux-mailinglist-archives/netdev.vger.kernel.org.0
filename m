Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAC62E8E11
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 21:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbhACUYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 15:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhACUYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 15:24:36 -0500
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B9AC0613CF;
        Sun,  3 Jan 2021 12:23:56 -0800 (PST)
Received: from localhost.localdomain (85-76-35-137-nat.elisa-mobile.fi [85.76.35.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jks)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id EF7FA1B00046;
        Sun,  3 Jan 2021 22:23:51 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1609705432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XuWtHAg8pQmQvAeL5ZZFdRZmioRZVXk2EYjGIzkzIz0=;
        b=vX3K9LgzVuFAM786J2H2jKoyD5xbhuiQP3UE655q+JvV5C8cQX1kauzzhprUoqiH1P6GK4
        kYS3m6LTY0nEIBjIIlmsFqQLI8OCcIVB3uaSKsf3WFoSl2ydtPuC+g2qGf5YmGw2t8vweB
        f2HhVDHIcq6+bEMzJxKcAvbmJeNhbrQegoJioQlNB9zfyg0Tn4aPB2revxQ3hWH+4dXTJX
        YhoTiAB1Wff6LxsNsSie7OJq90Q0SytBqt4vf0Y2IPdq5/oF2mO1kiNJhmEp34WYu32+qy
        G/PeKAJ3/r7+X1ppG65XqwNid7sYoYMCpLMZYNKCxepNHKfiSDGq6RhMmoKYNA==
From:   =?UTF-8?q?Jouni=20Sepp=C3=A4nen?= <jks@iki.fi>
To:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org
Cc:     jks@iki.fi, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH net,stable v2] net: cdc_ncm: correct overhead in delayed_ndp_size
Date:   Sun,  3 Jan 2021 22:23:09 +0200
Message-Id: <20210103202309.1201-1-jks@iki.fi>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103143602.95343-1-jks@iki.fi>
References: <20210103143602.95343-1-jks@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1609705432; a=rsa-sha256;
        cv=none;
        b=ViOe36nCQJCgADzBDmeuuzTb9jqLHfgkk+C2f+XM+uilYnzCehXihV37ozS2XgNW4AxUc0
        G9UO6/N2YwPreSNB1eprNE4qncRo90UDZ3IHcGnYB/yzclhKO17TXIFMIcbwdXnC3hRiEZ
        J1/Uos1lFpGNStUmQ2+wswYnacstS1DVtsiSuluDcABB2k70MPe2FeU5p0lZ3Sq86winQc
        d32jDwaJc/Det9yllhXVZx/YjUaU2UinoskRWA8mgBIx3bomzc0/o51vj8FYYBYzC9xadD
        mjtGdyM0Ns3/PeiI0aPwqH8fT0MFDqqhw5zLUDqqvjQ+RWDkyKvuWKhy2EbkNg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jks smtp.mailfrom=jks@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1609705432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XuWtHAg8pQmQvAeL5ZZFdRZmioRZVXk2EYjGIzkzIz0=;
        b=EB19L5FvFUJAGse8c2BjCfHUNvUJirEYOATsbBpP0ViNVoro2ToIskFWVXekng+IMtS/g0
        NmS0ceFQAm3jPCxyrLz5bcFm+OavqttmZTRuSb29O1Wqtyyd861MgsScFljMHFZMwyd/pw
        DJttRJLWZWh+XuGtxDbxOXGvg2lUN2IMQXuFg26hqwWI7jzlyttgZS8Ya0RpO7/X+VEsbz
        vcVa3CE1L/6wQQE0xSL7Z0GWF+6q2y8rFP6SNBak4/bTOwmhMY/o3Z5dKHhS8n2SxijMM5
        4BIlhB5XUHDWX1OD6sPejbtU470JAdMv/saoBQx7rPaiq9UAPMNf/QBmfsZgHg==
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
Reported-by: kernel test robot <lkp@intel.com>
---
v2: cast arguments to max() to the same type because integer promotion can
    result in different types; reported by the kernel test robot

 drivers/net/usb/cdc_ncm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f588538cc..4d8a1f50190c 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1199,7 +1199,9 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	 * accordingly. Otherwise, we should check here.
 	 */
 	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END)
-		delayed_ndp_size = ALIGN(ctx->max_ndp_size, ctx->tx_ndp_modulus);
+		delayed_ndp_size = ctx->max_ndp_size +
+			max((u32)ctx->tx_ndp_modulus,
+			    (u32)ctx->tx_modulus + ctx->tx_remainder) - 1;
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
