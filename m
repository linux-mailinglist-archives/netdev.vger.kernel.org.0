Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99272317027
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhBJTaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbhBJTaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 14:30:21 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E2CC061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 11:29:40 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id s24so3145573iob.6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 11:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqlwuM0nqOM3PYeoYsohQJYr4JJ43HhwvUkpDIXOjfA=;
        b=JX8PbSOApVOpduFj9mNKI71V7XIPcQn/KwCoDgzy41IVBlwuARHz+snW1GwsaHHGQ/
         WOx2tkO1/gpaNGcRrnLsnf7QD853RFLGQ/pAjQ1paYxxROkH4wvw2iuaONlQyifg1Pe2
         ALo0zbodRPRfWlNdt+iqxLQWZINDP053mt69of1N6rW/agssVcooxvrq1nqr02n8dIym
         NbtCD7XNozcSofyW/ZWSaXEEieen0fW2JVqujTPurKeFdwNUP+MbxSpAHWTu9XMySCxv
         ct56RGctKtvGll0P2uZLIFg4I2LVqHJsioZXSlIMaQqEdeftqlSBNxb5YhhNv+ssq1sR
         YsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqlwuM0nqOM3PYeoYsohQJYr4JJ43HhwvUkpDIXOjfA=;
        b=LdYtmRK66UfDsHWqpQxkDdIS3X22jagZCB2mivu3bfcidbuOdLPcJ2aRBEBgzf3MJE
         L/OLUjxBMG9BSwd2+TFxsYCBhvFQr2BgdceiI26BHVgFG5b4OyQxf/pxPCMC+aXYhewT
         QHGWGU0dQqXIAeqeswDwgG/Co1/+7lTIw19LYNwoS7b98GKmz0ren85SurGRG3E5i56i
         HQpolNywIPhZtDVttLPZTFc+u7ATlSRj7BZAl6kjAte9SidQRMJg5EuzuyzZeG5eIn4a
         hFNwumF0rLuhmuXZOzTyE6goAPq3fbOuaCDdQmqR0BskjPw9Mn4vtePx12AmWqE6sSQU
         /R9g==
X-Gm-Message-State: AOAM531Rt/M0iTyMVqZuEx1SrLm2BdE6GowIRgyFLDRq8UyKM6QiznhL
        eo9XThfuWWBIpT++4IcZVp/foAlWMwDGLMdn+GxMjOhBmbs=
X-Google-Smtp-Source: ABdhPJwOWsQ2tiFNzggH7Ep19o0nGkIUvfgKjBUMYHE5zvO/0YR8afIpJTKC32vSC0HWXEtfHmKwZ2NeWiKxgj63Q1Q=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr2243900iov.5.1612985380384;
 Wed, 10 Feb 2021 11:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20210209101516.7536-1-haokexin@gmail.com>
In-Reply-To: <20210209101516.7536-1-haokexin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Feb 2021 11:29:28 -0800
Message-ID: <CAKgT0Ueb-RbnBy2XxPPM7EuAvghHxFJupipWT=5A33nD_KhGdg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: octeontx2: Fix the confusion in buffer
 alloc failure path
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, Netdev <netdev@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 2:23 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> Pavel pointed that the return of dma_addr_t in
> otx2_alloc_rbuf/__otx2_alloc_rbuf() seem suspicious because a negative
> error code may be returned in some cases. For a dma_addr_t, the error
> code such as -ENOMEM does seem a valid value, so we can't judge if the
> buffer allocation fail or not based on that value. Add a parameter for
> otx2_alloc_rbuf/__otx2_alloc_rbuf() to store the dma address and make
> the return value to indicate if the buffer allocation really fail or
> not.
>
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Tested-by: Subbaraya Sundeep <sbhatta@marvell.com>

Actually in most cases -ENOMEM wouldn't be a valid value. The issue is
that you wouldn't have enough space to store anything since you are
only 12 bytes from overflowing the DMA value. That is why ~0 is used
as the DMA_MAPPING_ERROR value as there is only enough space to
possibly store 1 byte before it overflows.

I wonder if it wouldn't make sense to look at coming up with a set of
macros to convert the error values into a dma_addr_t value and to test
for those errors being present similar to what we already have for
pointers. It should work for most cases as I think the error values
are only up to something like -133 and I don't think we have too many
cases where something like an Rx buffer will be that small.

Anyway that is future work for another time.

The code itself looks fine.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
