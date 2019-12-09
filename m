Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A554C1172B9
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLIR36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:29:58 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36750 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIR36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:29:58 -0500
Received: by mail-ot1-f67.google.com with SMTP id i4so12920211otr.3
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 09:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dcgdz44q2GCvADR7a/LkLs9ynpEQVQ92g/NDbUJ9ByU=;
        b=PKOR9wiZIB18b/51jkUG/wXIFefbTZbsIoGHXMC3Wa+HrxHrvmOkKTzDzw+sXBVIlk
         WIeKjcijz8em6sM32WwxvXsG6eJYecW1+Vr8KQUTsTvwAezJa3uxBtNCwH0rvj3Hax2z
         2OapWK7fvk/DbmGvycFL+e8p61RygSe62KIF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dcgdz44q2GCvADR7a/LkLs9ynpEQVQ92g/NDbUJ9ByU=;
        b=p9OcnyMhCpNUSJU/ZGVlUVkkK/o0LjXxemy4Ah/aiq1qMhjWcg7yylrN6r1958wm3h
         7VWEJuIeEwF/JBQ2IP/WR88vnT5FhvzApQAxaSKOupVVntr8y822Wp7bIRtvbK7MGyrt
         YZvycmOeVNyH2u1XJlzhOww7T1ljiNauLsZ8rY+ETleJNNKBZXkH39OWklywQeazga01
         ivt0b1SGGtBgXmtiBSwDFvewNdHwVNpEi6n3ryz1AHl5lQQviY0Jp0AbLmVISIpJNJYV
         lZS3DKx9Ji9dYGkOUcl1HPi9u1VgY4zDrQKAXsXno0c8JY9JztuObq8jlwqtmEeLkwkj
         VPOg==
X-Gm-Message-State: APjAAAWJK5GkhInLtMSMxVeA8/9u2mg9f1ldDse+2qgM0TSVdM4KPkHr
        z/KPJaVrKR2E0K4BJdJWNqQa0OqU69wJSNo/ZY+uwShY
X-Google-Smtp-Source: APXvYqz4AY07BzHgic5er69wv22sNZkWuNoimJ4dj0xiy8faF2rZTCRbn2c2dvhbKtnKoCqZ27uqaKVyNe2AUdEl/0o=
X-Received: by 2002:a05:6830:1e75:: with SMTP id m21mr21646882otr.36.1575912597048;
 Mon, 09 Dec 2019 09:29:57 -0800 (PST)
MIME-Version: 1.0
References: <201912080836.xB88amHd015549@sdf.org>
In-Reply-To: <201912080836.xB88amHd015549@sdf.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 9 Dec 2019 09:29:46 -0800
Message-ID: <CACKFLinCFmEPHzaQRy0Wq_pjWtA+n_Uu9D63t1oEjtQM=1yMHQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] b44: Fix off-by-one error in acceptable address range
To:     George Spelvin <lkml@sdf.org>
Cc:     Netdev <netdev@vger.kernel.org>, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 8, 2019 at 12:36 AM George Spelvin <lkml@sdf.org> wrote:
>
> The requirement is dma_addr + size <= 0x40000000, not 0x3fffffff.
>
> In a logically separate but overlapping change, this patch also
> rearranges the logic for detecting failures to use a goto rather
> than testing dma_mapping_error() twice.  The latter is expensive if
> CONFIG_DMA_API_DEBUG is set, but also for bug-proofing reasons I try to
> avoid having the same condition in two places that must be kept in sync.
>
> Signed-off-by: George Spelvin <lkml@sdf.org>
> ---
>  drivers/net/ethernet/broadcom/b44.c | 42 ++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
> index 394671230c1c..e540d5646aef 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -680,12 +680,13 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
>
>         /* Hardware bug work-around, the chip is unable to do PCI DMA
>            to/from anything above 1GB :-( */
> -       if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
> -               mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)) {
> +       if (dma_mapping_error(bp->sdev->dma_dev, mapping))
> +               goto workaround;
> +       if (mapping + RX_PKT_BUF_SZ > DMA_BIT_MASK(30)+1) {

The patchset looks ok to me.  The only minor suggestion is to define
this (DMA_BIT_MASK(30) + 1) as B44_DMA_ADDR_LIMIT or something like
that so you don't have to repeat it so many times.

Thanks.
