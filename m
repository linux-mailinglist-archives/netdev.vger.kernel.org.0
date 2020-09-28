Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8557F27B7EC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgI1XTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgI1XSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:18:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0387CC0604DE
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:03:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 414BF1274F42B;
        Mon, 28 Sep 2020 15:46:20 -0700 (PDT)
Date:   Mon, 28 Sep 2020 16:03:07 -0700 (PDT)
Message-Id: <20200928.160307.1327269757816527615.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] lib8390: Replace panic() call with
 BUILD_BUG_ON
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927195659.4951-1-W_Armin@gmx.de>
References: <20200927195659.4951-1-W_Armin@gmx.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:46:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Sun, 27 Sep 2020 21:56:59 +0200

> Replace panic() call in lib8390.c with BUILD_BUG_ON()
> since checking the size of struct e8390_pkt_hdr should
> happen at compile-time. Also add __packed to e8390_pkt_hdr
> to prevent padding.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
>  drivers/net/ethernet/8390/8390.h    | 2 +-
>  drivers/net/ethernet/8390/lib8390.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/8390.h
> index e52264465998..e7d6fd55f6a5 100644
> --- a/drivers/net/ethernet/8390/8390.h
> +++ b/drivers/net/ethernet/8390/8390.h
> @@ -21,7 +21,7 @@ struct e8390_pkt_hdr {
>  	unsigned char status; /* status */
>  	unsigned char next;   /* pointer to next packet. */
>  	unsigned short count; /* header + packet length in bytes */
> -};
> +} __packed;

This is completely unnecessary and hurts performance on some cpus as
__packed forces the compiler to be unable to assume the alignment of
any member of said data structure.

I'm not applying this.
