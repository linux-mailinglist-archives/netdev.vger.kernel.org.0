Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955D13A0D1A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 09:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhFIHG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 03:06:29 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42669 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbhFIHG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 03:06:28 -0400
Received: by mail-wr1-f53.google.com with SMTP id c5so24159040wrq.9
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 00:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j++2FBMiYBi82J8WpozJKI2i0YC/mJJCF2pcaAZdwU4=;
        b=crM4DD5Z7o92SvAiAGDFmIOhDpo5q4whTV+lOm20Kghu9hagAn3eoakcLyfyttKlkY
         MmxWTBXhRu7aGCIT/rRxkEhyeOeDw0y4YZJqfgvXEe8QoBpghslmnwHI0jIa3DhDITG2
         fUBUz+OZTmGcrBApYIsoU3xuHX2a3dgphwe0MZPyBBPqbeBesO4KQK20TqbGBK7Ei6Gz
         RUHR7Jeq4Yj3yc3u8GlAhSKcOshowoqjNfeBMsBgVFbCWeNnPXDwSPS45Tt6Mb0kIxiQ
         3ZS7N4EHUqInH7OTpqFQup8RaPg1DnW58bUG87L/6gHW+xZGZMNkBg+XjMnyMM0E0dgU
         vbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j++2FBMiYBi82J8WpozJKI2i0YC/mJJCF2pcaAZdwU4=;
        b=DsFxgVeMEgcs8aIjNZka20ef10/uAFPsP2MHqv0qqNrx523veqSEKof/hAY8aN8oGB
         NNEQ2q3CebT7lEXKobwHkzSdFoyW5sdtsSG6Fp3/k5sgImvNejvtoVNx3jV0NyFZWOdq
         wneDTYDgEeLWUe3+TcndoZTokQmpaJppNmjepdbgOAycgKOz7bLrnSIit74hImAqOgfX
         O47ZAeuRNZQevX62fkfxbqp3RvdbBmKL2va3nQlDNKkQ/RFQHLHhwLKB9i51Y/86WDui
         P6wq8dLnEEHvbh9szO5qPb+jbYHctpnnl4WQUoZXzPuiljrlyAFwuO/bRZc9Aq13SXc8
         bgoQ==
X-Gm-Message-State: AOAM533KI9PIC/qMCTxfWuRWKgeIgnGg/ivuvRijtlAkCODfg6HBnyxO
        JxyPMxK/E7f0HCKC1IT5uVPwJf1kSmF1UuOHE1v3wpY0IDE=
X-Google-Smtp-Source: ABdhPJz+vWOGi8ri7GziYq8APXvJ3POmzLJ6QIrlWSSpQ5B+l1Qm1379XlVCg5JgqRKwkdD3vvWxjjL0aAFBz3EPgBQ=
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr26456293wrs.397.1623222211576;
 Wed, 09 Jun 2021 00:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210607154534.57034-1-dust.li@linux.alibaba.com>
 <CANn89i+dDy6ev50mBMwoK7f0NN+0xHf8V-Jas8zAmew02hJV4w@mail.gmail.com>
 <20210608030903.GN53857@linux.alibaba.com> <CANn89i+VEA4rc3T_oC7tJXYvA7OAmDc=Vk_wyxYwzYz23nENPg@mail.gmail.com>
 <20210609002542.GO53857@linux.alibaba.com>
In-Reply-To: <20210609002542.GO53857@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Jun 2021 09:03:14 +0200
Message-ID: <CANn89i+vBRxKFy_Bb2_tKTh1ttLanZj99UNZcmjSQ=oq4-j6og@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: avoid spurious loopback retransmit
To:     "dust.li" <dust.li@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 2:25 AM dust.li <dust.li@linux.alibaba.com> wrote:
>

> Normal RTO and fast retransmits are rarely triggerred.
> But for TLP timers, it is easy since its timeout is usally only 2ms.
>

OK, by definition rtx timers can fire too early, so I think we will
leave the code as it is.
(ie not try to do special things for 'special' interfaces like loopback)

We want to be generic as much as possible.

Thanks
