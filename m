Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562442EB720
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbhAFAx2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jan 2021 19:53:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56964 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAFAx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:53:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A281B4CBCE120;
        Tue,  5 Jan 2021 16:52:47 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:52:47 -0800 (PST)
Message-Id: <20210105.165247.1975563309057158543.davem@davemloft.net>
To:     jks@iki.fi
Cc:     bjorn@mork.no, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, lkp@intel.com, mrkiko.rs@gmail.com,
        netdev@vger.kernel.org, oliver@neukum.org
Subject: Re: [PATCH net,stable v3] net: cdc_ncm: correct overhead in
 delayed_ndp_size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210105045249.5590-1-jks@iki.fi>
References: <20210103202309.1201-1-jks@iki.fi>
        <20210105045249.5590-1-jks@iki.fi>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:52:48 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Sepp�nen <jks@iki.fi>
Date: Tue,  5 Jan 2021 06:52:49 +0200

> From: Jouni K. Sepp�nen <jks@iki.fi>
> 
> Aligning to tx_ndp_modulus is not sufficient because the next align
> call can be cdc_ncm_align_tail, which can add up to ctx->tx_modulus +
> ctx->tx_remainder - 1 bytes. This used to lead to occasional crashes
> on a Huawei 909s-120 LTE module as follows:
> 
> - the condition marked /* if there is a remaining skb [...] */ is true
>   so the swaps happen
> - skb_out is set from ctx->tx_curr_skb
> - skb_out->len is exactly 0x3f52
> - ctx->tx_curr_size is 0x4000 and delayed_ndp_size is 0xac
>   (note that the sum of skb_out->len and delayed_ndp_size is 0x3ffe)
> - the for loop over n is executed once
> - the cdc_ncm_align_tail call marked /* align beginning of next frame */
>   increases skb_out->len to 0x3f56 (the sum is now 0x4002)
> - the condition marked /* check if we had enough room left [...] */ is
>   false so we break out of the loop
> - the condition marked /* If requested, put NDP at end of frame. */ is
>   true so the NDP is written into skb_out
> - now skb_out->len is 0x4002, so padding_count is minus two interpreted
>   as an unsigned number, which is used as the length argument to memset,
>   leading to a crash with various symptoms but usually including
> 
>> Call Trace:
>>  <IRQ>
>>  cdc_ncm_fill_tx_frame+0x83a/0x970 [cdc_ncm]
>>  cdc_mbim_tx_fixup+0x1d9/0x240 [cdc_mbim]
>>  usbnet_start_xmit+0x5d/0x720 [usbnet]
> 
> The cdc_ncm_align_tail call first aligns on a ctx->tx_modulus
> boundary (adding at most ctx->tx_modulus-1 bytes), then adds
> ctx->tx_remainder bytes. Alternatively, the next alignment call can
> occur in cdc_ncm_ndp16 or cdc_ncm_ndp32, in which case at most
> ctx->tx_ndp_modulus-1 bytes are added.
> 
> A similar problem has occurred before, and the code is nontrivial to
> reason about, so add a guard before the crashing call. By that time it
> is too late to prevent any memory corruption (we'll have written past
> the end of the buffer already) but we can at least try to get a warning
> written into an on-disk log by avoiding the hard crash caused by padding
> past the buffer with a huge number of zeros.
> 
> Signed-off-by: Jouni K. Sepp�nen <jks@iki.fi>
> Fixes: 4a0e3e989d66 ("cdc_ncm: Add support for moving NDP to end of NCM frame")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=209407
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Bj�rn Mork <bjorn@mork.no>

Applied and queued up for -stable, thanks.
