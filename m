Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E269B0A8
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405434AbfHWNU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 09:20:27 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34425 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404322AbfHWNU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 09:20:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id q4so11144879qtp.1;
        Fri, 23 Aug 2019 06:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1LfnWFWs0YWvUwvqhsL90T++L1EYbaF8DCL5i8TnlTQ=;
        b=IGcqT2L9Wkft5cAwK651j3W3eBHxve8x0C4MyikQws9NcZLM190a7/AA3JZ1HtXWpy
         GdGzRMoVVUREaXD/dkNg6XQgREa2yhuygZpG1qGG7MEL2Hf2V3TlohAf1wgBYw4asGVS
         iZG2a+U7LL18sOQP9/LmObdflOitwFE4afnCDwhPo9LKKZdkGqSxdF18BsijKXc4C+qU
         I04eNIzpKktFUyypNR34I9HyQBVBufsb9RUKdTcB7yETG7bHE7Od/XvFgGtMSbaUy7Un
         8iRj4oNsHd+pb7mswL7+8gOIzrxF05qPOBd0o5ksLHEvQCipM/Q8OP9zEV82Cs3yc5oF
         LzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1LfnWFWs0YWvUwvqhsL90T++L1EYbaF8DCL5i8TnlTQ=;
        b=brEH7N+bW7HHW94T6SUYRun/EZFF2317VKNtaId2V02F+V7777R17OrQ+7CF9+goTb
         JQn3cjTbAP32H9vFiaHgr9d/0ESvU/9PStuCln4Z3m7u7G6lkgudrA27+A0gRurCWo+L
         uc79PCeKgSrCa3kHxXrFSpH1HXDa66Frzh5m2fcL2OdmYZFk+mnkugI3Ywg1X1LTI0xV
         quJK/8bJigr+p0i4FQrfJZ1TvvJM0JHX+iKhqtZJng58N/siUrJCX9jZkya2TO7kSLhb
         5GP56Kifp9riAXEkMtjXTUUtkJg4y2osjK08tvARsEcGvtM8vYCKB/G7leSOHd0+aycI
         7LDw==
X-Gm-Message-State: APjAAAWBPRGcR4BiFweSxcMlA76mwU4N19eUnYjmXwuOVZDpR55vzx4a
        IjNo+f6J+StNbWJNUbbv3KhfxlZ0iRWYXNTl6Zg=
X-Google-Smtp-Source: APXvYqzwV94dsSIn/VkYPZoc4KCCI+cdmF8oVTo1U8feC63LjNcIddNEQlDaT+/Y6KbvgkLYv+gJ6MnwAOt5WD+BwGo=
X-Received: by 2002:a0c:abca:: with SMTP id k10mr3794577qvb.177.1566566425657;
 Fri, 23 Aug 2019 06:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
 <20190822171237.20798-1-i.maximets@samsung.com> <CAKgT0UepBGqx=FiqrdC-r3kvkMxVAHonkfc6rDt_HVQuzahZPQ@mail.gmail.com>
 <CALDO+SYhU4krmBO8d4hsDGm+BuUAR4qMv=WzVa=jAx27+g9KnA@mail.gmail.com> <217e90f5-206a-bb80-6699-f6dd750b57d9@intel.com>
In-Reply-To: <217e90f5-206a-bb80-6699-f6dd750b57d9@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 23 Aug 2019 06:19:49 -0700
Message-ID: <CALDO+SZGXKW_PMrL_AarT3i8WPcM0X=RkEhTnKCDnUkS1cOH0Q@mail.gmail.com>
Subject: Re: [PATCH net v3] ixgbe: fix double clean of tx descriptors with xdp
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ilya Maximets <i.maximets@samsung.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 11:10 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.c=
om> wrote:
>
> On 2019-08-22 19:32, William Tu wrote:
> > On Thu, Aug 22, 2019 at 10:21 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> >>
> >> On Thu, Aug 22, 2019 at 10:12 AM Ilya Maximets <i.maximets@samsung.com=
> wrote:
> >>>
> >>> Tx code doesn't clear the descriptors' status after cleaning.
> >>> So, if the budget is larger than number of used elems in a ring, some
> >>> descriptors will be accounted twice and xsk_umem_complete_tx will mov=
e
> >>> prod_tail far beyond the prod_head breaking the completion queue ring=
.
> >>>
> >>> Fix that by limiting the number of descriptors to clean by the number
> >>> of used descriptors in the tx ring.
> >>>
> >>> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
> >>> 'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
> >>> 'next_to_clean' and 'next_to_use' indexes.
> >>>
> >>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> >>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> >>> ---
> >>>
> >>> Version 3:
> >>>    * Reverted some refactoring made for v2.
> >>>    * Eliminated 'budget' for tx clean.
> >>>    * prefetch returned.
> >>>
> >>> Version 2:
> >>>    * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
> >>>      'ixgbe_xsk_clean_tx_ring()'.
> >>>
> >>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++---------=
---
> >>>   1 file changed, 11 insertions(+), 18 deletions(-)
> >>
> >> Thanks for addressing my concerns.
> >>
> >> Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > Thanks.
> >
> > Tested-by: William Tu <u9012063@gmail.com>
> >
>
> Will, thanks for testing! For this patch, did you notice any performance
> degradation?
>

No noticeable performance degradation seen this time.
Thanks,
William
