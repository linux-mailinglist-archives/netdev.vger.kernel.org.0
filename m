Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7B1F7A3B
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKKRvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 12:51:03 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38225 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfKKRvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 12:51:03 -0500
Received: by mail-oi1-f194.google.com with SMTP id a14so12244809oid.5
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 09:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tn39DxU04+DSsZr8kND2VIZkOzQxYXWDgGYNHU/AaPM=;
        b=hRd+mz4f8xgu9UGqp+JB5w2XVjuC6AM5vJq8lX54ZYlKOZy/nB7PDAOXGqjR0F84eY
         YqAgormfY5752xJQkwv8SeEGwVgpQseunydRopDDDUgbojrTBH+WtiGpq8YsF228P8Hz
         ZwGnV06TT9wni26K8ZyoHr2ketlmDOV4AdnSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tn39DxU04+DSsZr8kND2VIZkOzQxYXWDgGYNHU/AaPM=;
        b=UG5QJDf0jv8cLJoz6FM9alsZtM/a/4nWkTNK/jAIqCHvo/e3c8A4CIMtis+L3UVOWi
         QJpz6U/MO6Wo5CNdek14dvE17fseMMuJ2n3g+e+hzqpToNhwXDF0Eg270D6qU7rVTjHT
         sNLHUVrjI4wvEdNFB6ko+Qt1i7tSKI3/6Mx37ud0BB5uQz1QHAwJFZoSDZE50reSyEvi
         gS5iapyYxjXQ/WjAtXR8yulIxNNg/wulz/ESayvdhkrg8OP7lyjFiGOyyoQlXNy4jKw4
         yLiNbIQWIIP736MPwnw/1NJrftJAO9PoQ+PxJDqvtpkP11I/MKP2eSvfBerMD/NwTXiC
         Y6gA==
X-Gm-Message-State: APjAAAU2lsT2h2ZWAPgpKBZP9X9V6BPAuG4XKvFGkGnb+SrI+If+PQpG
        7//P1KagKgdYbY8MeDKUkCd3jBtJUjMjPqimEF/Dsg==
X-Google-Smtp-Source: APXvYqytxCcqPCMEqfFAueO6g/FMl4IwXESWckL/rgEvXl+6gdqL56xWWUP+3VFZtWrCD9a4CTyjsObDDXrAZcFYYrM=
X-Received: by 2002:aca:5cd5:: with SMTP id q204mr199928oib.14.1573494661964;
 Mon, 11 Nov 2019 09:51:01 -0800 (PST)
MIME-Version: 1.0
References: <20191111020855.20775-1-olof@lixom.net>
In-Reply-To: <20191111020855.20775-1-olof@lixom.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 11 Nov 2019 09:50:51 -0800
Message-ID: <CACKFLim64Yd=yp+P5FTFmVh3w-s1rWMROO_cbn940TkzKOFUCw@mail.gmail.com>
Subject: Re: [PATCH] net: bnxt_en: Fix array overrun in bnxt_fill_l2_rewrite_fields()
To:     Olof Johansson <olof@lixom.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 6:09 PM Olof Johansson <olof@lixom.net> wrote:
>
> This is caused by what seems to be a fragile typing approach by
> the Broadcom firmware/driver:
>
> /* FW expects smac to be in u16 array format */
>
> So the driver uses eth_addr and eth_addr_mask as u16[6] instead of u8[12],
> so the math in bnxt_fill_l2_rewrite_fields does a [6] deref of the u16
> pointer, it goes out of bounds on the array.
>
> Just a few lines below, they use ETH_ALEN/2, so this must have been
> overlooked. I'm surprised original developers didn't notice the compiler
> warnings?!
>
> Fixes: 90f906243bf6 ("bnxt_en: Add support for L2 rewrite")
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 174412a55e53c..cde2b81f6fe54 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -149,29 +149,32 @@ static void bnxt_set_l2_key_mask(u32 part_key, u32 part_mask,
>
>  static int
>  bnxt_fill_l2_rewrite_fields(struct bnxt_tc_actions *actions,
> -                           u16 *eth_addr, u16 *eth_addr_mask)
> +                           u8 *eth_addr, u8 *eth_addr_mask)
>  {
>         u16 *p;
> +       u8 *am;
>         int j;
>
>         if (unlikely(bnxt_eth_addr_key_mask_invalid(eth_addr, eth_addr_mask)))
>                 return -EINVAL;
>
> -       if (!is_wildcard(&eth_addr_mask[0], ETH_ALEN)) {
> -               if (!is_exactmatch(&eth_addr_mask[0], ETH_ALEN))
> +       am = eth_addr_mask;
> +       if (!is_wildcard(am, ETH_ALEN)) {
> +               if (!is_exactmatch(am, ETH_ALEN))
>                         return -EINVAL;
>                 /* FW expects dmac to be in u16 array format */
> -               p = eth_addr;
> -               for (j = 0; j < 3; j++)
> +               p = (u16 *)am;

Wouldn't this cause unaligned access?  am may not be u16 aligned, right?

> +               for (j = 0; j < ETH_ALEN / 2; j++)
>                         actions->l2_rewrite_dmac[j] = cpu_to_be16(*(p + j));
>         }
>
