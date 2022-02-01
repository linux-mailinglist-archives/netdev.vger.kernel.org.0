Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9CB4A5BE4
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbiBAMKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbiBAMKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DB7C061714;
        Tue,  1 Feb 2022 04:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5256B82D62;
        Tue,  1 Feb 2022 12:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10C0C340EE;
        Tue,  1 Feb 2022 12:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643717436;
        bh=3azHlEwFXQa4HPop+6S2a+JgDDMa2vBsSzhJ0/6FWLI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=enYSIDtYzrHSJBw3FlVmTirIlRmclLABo9R6vG3nQxnGs/AT0nM1jzt56guJtsGPK
         6M9BXJAGHOdpNXglCSRqV51O+jLVs4hjBgLNcp4kOHX69LZw/WQOWhYCwLwwRnHbhP
         8VP3JuICo3qiqI2VhXjSyGUiXGA03hN1L7FNUZ/bHT9kGuRhYNsOd3Bc8eO9ZeQNkr
         Rj+p3EE4mPzUCXgiwiD2lgMQshxkNTk3Ajj2GDzAfuMxWeTadD+OD6rpVPtkKSqNfi
         6oYw6212iOikn3cdCJ3QNbPQJ/zDv4xUOLqLOYQ0XTmraNIHHBMCS8qgHpd+/ndMw1
         MeueyCR4VAgLA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: Re: [PATCH] rsi: fix oob in rsi_prepare_skb
References: <YcnFiGzk67p0PSgd@b-10-27-92-143.dynapool.vpn.nyu.edu>
Date:   Tue, 01 Feb 2022 14:10:31 +0200
In-Reply-To: <YcnFiGzk67p0PSgd@b-10-27-92-143.dynapool.vpn.nyu.edu> (Zekun
        Shen's message of "Mon, 27 Dec 2021 08:54:16 -0500")
Message-ID: <87y22udbyg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

> We found this bug while fuzzing the rsi_usb driver.
> rsi_prepare_skb does not check for OOB memcpy. We
> add the check in the caller to fix.
>
> Although rsi_prepare_skb checks if length is larger
> than (4 * RSI_RCV_BUFFER_LEN), it really can't because
> length is 0xfff maximum. So the check in patch is sufficient.
>
> This patch is created upon ath-next branch. It is
> NOT tested with real device, but with QEMU emulator.
>
> Following is the bug report
>
> BUG: KASAN: use-after-free in rsi_read_pkt
> (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
> Read of size 3815 at addr ffff888031da736d by task RX-Thread/204
>
> CPU: 0 PID: 204 Comm: RX-Thread Not tainted 5.6.0 #5
> Call Trace:
> dump_stack (/linux/lib/dump_stack.c:120)
>  ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
>  print_address_description.constprop.6 (/linux/mm/kasan/report.c:377)
>  ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
>  ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
>  __kasan_report.cold.9 (/linux/mm/kasan/report.c:510)
>  ? syscall_return_via_sysret (/linux/arch/x86/entry/entry_64.S:253)
>  ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
>  kasan_report (/linux/arch/x86/include/asm/smap.h:69 /linux/mm/kasan/common.c:644)
>  check_memory_region (/linux/mm/kasan/generic.c:186 /linux/mm/kasan/generic.c:192)
>  memcpy (/linux/mm/kasan/common.c:130)
>  rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
>  ? skb_dequeue (/linux/net/core/skbuff.c:3042)
>  rsi_usb_rx_thread (/linux/drivers/net/wireless/rsi/rsi_91x_usb_ops.c:47) rsi_usb
>
> Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
> index 5d1490fc3..41d3c12e0 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_main.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_main.c
> @@ -193,6 +193,10 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
>  			break;
>  
>  		case RSI_WIFI_DATA_Q:
> +			if (!rcv_pkt_len && offset + length >
> +				RSI_MAX_RX_USB_PKT_SIZE)
> +				goto fail;
> +
>  			skb = rsi_prepare_skb(common,
>  					      (frame_desc + offset),
>  					      length,

Why are you doing the check here? In the beginning of the function we
have:

		frame_desc = &rx_pkt[index];
		actual_length = *(u16 *)&frame_desc[0];
		offset = *(u16 *)&frame_desc[2];
		if (!rcv_pkt_len && offset >
			RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
			goto fail;

Wouldn't it make more sense to fix that check?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
