Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14045C798
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 05:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfGBDMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 23:12:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32930 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBDMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 23:12:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id m4so6958894pgk.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 20:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bzUtQeFEBrK0d3g1/zeukTWsknLtqFMFV4yNa3kc1/I=;
        b=rh79vwfe/yT2P4LxOnG2cRUnPn5Z1TBFiUismUKgAjLX1tKQbSIWRFkYYWWYydRC7R
         mGOBg/HDTDxC+NLdipRb1Wh/q40kWhj/QJoNZiCFn0RjBQ79cX2ZkvCUpk37SuvLsx3A
         XmfKsWDT/iXJhWlkrKPc7ahV2YyOZWgs4cXi+WaHMMxoraRuycUStkfN439SanPt9elr
         6Sn3223wMzhPqTg9y+UBaXlsL4Fs2hl+Xn+lKQskcD1U+1DfjMlfYrsF/EXTTpAoOybw
         69hjcfwvr0DD3v+p3J3+fhVdxNcG12TVriEkkW2OtPjRu542gs+pbhuKXtvTHzbtIPJh
         TCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bzUtQeFEBrK0d3g1/zeukTWsknLtqFMFV4yNa3kc1/I=;
        b=WDYSGxERMYMHg3mqBYaYwdy8NtWhe8YeR1LWew8724n66KUo39xnqIMHW6LOHLeb2C
         YfZaNDbvM9yuIJopdGoMBmLGG/AA8jDZ0yrPAh4EY0l/7xS5w+n+3ApMaOizQPuLWgbX
         6K/kSq2Dh/u0qdRA3iZAKVlIYCgyBfAWIzQqDmQvRT12kb5GtbCVQUfW51aK2RHuDK3V
         yISO+wwD4AVDNbhKcCeP7jtJNfLqLA0B7/FGyBNxD3JC7zApi11oTR3Wa/UYksOUpiDe
         iUJwPGmU3rAqFHetQuw9EHAqMvXkqGhdIAaA3dIbxMv3j82zmnQ3Gru06PYXedao0kv4
         vUDg==
X-Gm-Message-State: APjAAAXXVDtfOIXDgWlC1ms6k5xPJVGupxdl/AUU14wJ+jrNid9Y6U2f
        jj7409eC2Z81zUbCYI9qfjx9OBOrDT147jacYLaTdrny6g0=
X-Google-Smtp-Source: APXvYqyFnooSqOUPUPwWy3Tug/bMi2Mxp7q99rI4dpG7+MBoMYbPypmlripiOAw1SK2qmIG3S/LQ/+8zKKm11b63adA=
X-Received: by 2002:a63:d748:: with SMTP id w8mr27500970pgi.157.1562037150733;
 Mon, 01 Jul 2019 20:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
 <20190701.191600.1570499492484804858.davem@davemloft.net> <20190702023730.GA1729@bombadil.infradead.org>
In-Reply-To: <20190702023730.GA1729@bombadil.infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Jul 2019 20:12:18 -0700
Message-ID: <CAM_iQpXMDyTdCNujvw8nzNimVkyL9hBQyKrNyiuVp7KYg1GmOw@mail.gmail.com>
Subject: Re: [Patch net 0/3] idr: fix overflow cases on 32-bit CPU
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Chris Mi <chrism@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 7:37 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jul 01, 2019 at 07:16:00PM -0700, David Miller wrote:
> > From: Cong Wang <xiyou.wangcong@gmail.com>
> > Date: Fri, 28 Jun 2019 11:03:40 -0700
> >
> > > idr_get_next_ul() is problematic by design, it can't handle
> > > the following overflow case well on 32-bit CPU:
> > >
> > > u32 id = UINT_MAX;
> > > idr_alloc_u32(&id);
> > > while (idr_get_next_ul(&id) != NULL)
> > >  id++;
> > >
> > > when 'id' overflows and becomes 0 after UINT_MAX, the loop
> > > goes infinite.
> > >
> > > Fix this by eliminating external users of idr_get_next_ul()
> > > and migrating them to idr_for_each_entry_continue_ul(). And
> > > add an additional parameter for these iteration macros to detect
> > > overflow properly.
> > >
> > > Please merge this through networking tree, as all the users
> > > are in networking subsystem.
> >
> > Series applied, thanks Cong.
>
> Ugh, I don't even get the weekend to reply?
>
> I think this is just a bad idea.  It'd be better to apply the conversion
> patches to use XArray than fix up this crappy interface.  I didn't
> reply before because I wanted to check those patches still apply and
> post them as part of the response.  Now they're definitely broken and
> need to be redone.

You can always do refactoring for net-next/linux-next. It is never late
for it.

Thanks.
