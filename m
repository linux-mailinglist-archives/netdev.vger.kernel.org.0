Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121322EA490
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 05:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbhAEEyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 23:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbhAEEyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 23:54:13 -0500
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3755C061574;
        Mon,  4 Jan 2021 20:53:32 -0800 (PST)
Received: from localhost.localdomain (85-76-36-208-nat.elisa-mobile.fi [85.76.36.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jks)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 1E35B1B00090;
        Tue,  5 Jan 2021 06:53:29 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1609822409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJmQVKZidstKn8rB7Q+DLaX3ps83JrdfT+OPwM/xZX8=;
        b=Dddmz4hvDmnXj89oB5gAi08qfvp6HZNaGqZw4yW+wgkIZbX/lrk8CymADAxy/l4B17HrT4
        20yyHiMTrtnVJkdvKAKtL7pN84LRDAtneqOW4828bf2lswuqgqTtpmPwj/Cwzm8Kpyv57V
        tWfTy/rIXaNgjG+62XgzmN0gyZL+dqRVe1XxcQLMOSYSDFm7lzRVpiG22UVQeAfLRFB5im
        m4YT37Ou8nfd82AF5XbkgSAf9TDdHeSFO/LBgDVQ4o2NlOyVi/tp0l5zsuFco8L2g4VR39
        DBc2Nq8nYg0FruPtHS0Oj7QKtpPcNT+dR8ZtTExoR0WqGqHf2AqdAhP76l3TTQ==
From:   =?UTF-8?q?Jouni=20Sepp=C3=A4nen?= <jks@iki.fi>
To:     jks@iki.fi
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lkp@intel.com, mrkiko.rs@gmail.com, netdev@vger.kernel.org,
        oliver@neukum.org
Subject: [PATCH net,stable v3] net: cdc_ncm: correct overhead in delayed_ndp_size
Date:   Tue,  5 Jan 2021 06:52:49 +0200
Message-Id: <20210105045249.5590-1-jks@iki.fi>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103202309.1201-1-jks@iki.fi>
References: <20210103202309.1201-1-jks@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1609822409; a=rsa-sha256;
        cv=none;
        b=vQOEX8oxeJXSQkwHur1v+3AWFMR33hAf/6u83+3GPFWB+106mXQNQk0bLKd1C00lfrWmqH
        12snZoxz3DQDT9uGT7vsjWV4vjr9fQ4ZoHuQgdJ8+sgT8jWHp8fIk42HhVlBWBIjh4urRV
        jcOHCSOMP9TGTRLjjAgSzO/Sno/jBhzG4d8HIHP0XR4DQvtjurGdXZ+fsnzkOxUcAZkjaH
        M90UIh8OgchTIbsGEpcJaL73NtsWN5wCDU8JjLddehjen1QnE9Ya4jzCyUJnXa7XFhheif
        mM80x+7LDY6KT71TUKATH/7NxAOf7BCuOKH+EwabtZ9jFwGexcEpBJOj3CAjtQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jks smtp.mailfrom=jks@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1609822409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJmQVKZidstKn8rB7Q+DLaX3ps83JrdfT+OPwM/xZX8=;
        b=H4DezfyxfYawTQhmuKfGurIsoOR6R9u6ddR1cHsnr2JYA3iomdOlNhEOvmAvep2J+tyR+W
        +te3fU8H9R163wdKD+u+Uzo3Zwu2LhGmmD0vbs0JErBpzzuDSA8I7HvvzU4PeDPqi81QBZ
        ydVOodXulU1CB0Jl10om458urnVvhUUrWcFTAQuvMJCXLnJafcBLQMEBpgpvylYAy2ngiE
        Dsx87jm/yMH8N+v2b6BFe9uYX4hU5NDnxabyfyHZe9Cvxe+qD+o8Z3Lfen2ummt3FKBo9S
        4YhAPytkDNJqEHofBfQxSIGBMLNpKLutPC6+EffvecSj0qfXRiDX/lZvAK4GYw==
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
Reviewed-by: Bjørn Mork <bjorn@mork.no>
---
v2: cast arguments to max() to same type, because otherwise integer
    promotion can result in different types
v3: use max_t

 drivers/net/usb/cdc_ncm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f588538cc..d1346c50d237 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1199,7 +1199,10 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	 * accordingly. Otherwise, we should check here.
 	 */
 	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END)
-		delayed_ndp_size = ALIGN(ctx->max_ndp_size, ctx->tx_ndp_modulus);
+		delayed_ndp_size = ctx->max_ndp_size +
+			max_t(u32,
+			      ctx->tx_ndp_modulus,
+			      ctx->tx_modulus + ctx->tx_remainder) - 1;
 	else
 		delayed_ndp_size = 0;
 
@@ -1410,7 +1413,8 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
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

