Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85DF25E6A3
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 11:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgIEJCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 05:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgIEJCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 05:02:41 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B55C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 02:02:41 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id n18so6632599qtw.0
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 02:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFbMIbfWa7JH0J3JS7wU4IZFXMtKcQxRFdyGcw7TDbQ=;
        b=aDaaAPV39d75uXPfRTsJkaVTNTlIEfMJZTxNVHV+BrQ40y4Xft+QzaTqFQ9RIUeJ7t
         MhKDf11jBxGeDli8b82CWMBCR4s+XofIh9d+W56PSBUPhy3vFwtBxaeuGo58ruM5OmC+
         3+2KsgkeUW//mkDkun2tmqUglSXFajbcSiQpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFbMIbfWa7JH0J3JS7wU4IZFXMtKcQxRFdyGcw7TDbQ=;
        b=FtgxS5hsHOEpSlHviM/6N1yBA5pKaaImn45q/xMnq090vKl05oH7XZ9q41em9+21Q7
         mIh9yWkiZ6tRlwP59PPivH7LKx81gD2f/ll1W8K1NhyO9XMgJSa7MgeSL5vsjhPQp3/1
         KMKMQ8fEyftNF7scOQfDFccEJ8VHhhJ8jDnmi+8/iHHEKHwSKqEECBdLPvCc9wQk80z8
         nc1Vl/CIbcqJ7C6Dl4joSvU5Doa4oWMzdgEJd497fSip1hV7+FiCQ7lWTwbDYY1L41Y7
         jIW+E7/qHLp5GwTa4UutiKU/m+oD0vqE6M6GamYWKpnb/DnumtyvQ1MjQlyHJQtD2jW+
         3pHQ==
X-Gm-Message-State: AOAM532tFuHKbUM64YKmypzhfo6B31fVmfwSw+n7iENZyAaBZjX2UT2t
        IoUs5uHE1OPc+s8lGWkAHVO3IL3PhAdvcdOf/RDKyg==
X-Google-Smtp-Source: ABdhPJyETa/2L5qCPLCCWcQAJZlJKH9+78qCiLng+bH+soRKCy1GpnMzGmQEBwGcEcm4p4x5oTK3p2ZXLl8SzFre+0s=
X-Received: by 2002:ac8:12c1:: with SMTP id b1mr12721239qtj.148.1599296557887;
 Sat, 05 Sep 2020 02:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com> <CABb8VeHA8yEmi-iDs3O-eRfOucWqGM+9p6gj87NLdjeQHfJROA@mail.gmail.com>
In-Reply-To: <CABb8VeHA8yEmi-iDs3O-eRfOucWqGM+9p6gj87NLdjeQHfJROA@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sat, 5 Sep 2020 02:02:09 -0700
Message-ID: <CACKFLimoBx18uoJmXbVQTML+7eQb94nZJv2To7Wd2drJMSSeNg@mail.gmail.com>
Subject: Re: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
To:     Baptiste Covolato <baptiste@arista.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Christensen <drc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 4:20 PM Baptiste Covolato <baptiste@arista.com> wrote:

> Thank you for proposing this patch. Unfortunately, it appears to make
> things worse on my test setup. The problem is a lot easier to
> reproduce, and not related to transmit timeout anymore.

This patch specifically addresses the issue reported by David
Christensen.  When tg3_reset_task() is unsuccessful, it will bring the
device to a consistent IF_DOWN state to prevent soft lockup.
tg3_reset_task() is usually scheduled from TX timeout, or from a few
other error conditions.  In David's case, it was triggered from TX
timeout.

So if the issue you're reporting has nothing to do with TX timeout or
the other error conditions that trigger tg3_reset_task(), this patch
should have no effect.

>
> The manifestation of the problem with the new patch starts with a
> CmpltTO error on the PCI root port of the CPU:
> [11288.471126] tg3 0000:56:00.0: tg3_abort_hw timed out,
> TX_MODE_ENABLE will not clear MAC_TX_MODE=ffffffff

It is unclear how tg3_abort_hw() is called, but it is encountering an
error.  The TX mode register cannot be cleared.

> [11290.258733] tg3 0000:56:00.0 lc4: No firmware running

Most tg3 NICs have firmware running.  This message about no firmware
running usually means something is wrong.

> [11302.336601] tg3 0000:56:00.0 lc4: Link is down
> [11302.336616] pcieport 0000:00:03.0: AER: Uncorrected (Non-Fatal)
> error received: 0000:00:03.0
> [11302.336621] pcieport 0000:00:03.0: PCIe Bus Error:
> severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester
> ID)
> [11302.470089] pcieport 0000:00:03.0:   device [8086:6f08] error
> status/mask=00004000/00000000
> [11302.570218] pcieport 0000:00:03.0:    [14] CmpltTO                (First)
> [11302.651611] pcieport 0000:00:03.0: broadcast error_detected message
> [11305.119349] br1: port 4(lc4) entered disabled state
> [11305.119443] br1: port 1(lc4.42) entered disabled state
> [11305.119696] device lc4 left promiscuous mode
> [11305.119697] br1: port 4(lc4) entered disabled state
> [11305.143622] device lc4.42 left promiscuous mode
> [11305.143626] br1: port 1(lc4.42) entered disabled state
> [11305.219623] iommu: Removing device 0000:56:00.0 from group 52
> [11305.219672] tg3 0000:61:00.0 lc5: PCI I/O error detected
> [11305.345904] tg3 0000:6c:00.0 lc6: PCI I/O error detected

Now we have AER errors detected on 2 other tg3 devices, not from the
one above with tg3_abort_hw() failure.

I think this issue that you're reporting is not the same as David's
issue of TX timeout happening at about the same time as AER.

Please describe the issue in more detail, in particular how's the
tg3_abort_hw() seen above initiated and how many tg3 devices do you
have.  Also, are you injecting these AER errors?  Please also include
the complete dmesg.  Thanks.

> [11305.472089] pcieport 0000:00:03.0: AER: Device recovery failed
> [11305.472092] pcieport 0000:00:03.0: AER: Uncorrected (Non-Fatal)
> error received: 0000:00:03.0
> [11305.472096] pcieport 0000:00:03.0: PCIe Bus Error:
> severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester
> ID)
> [11305.472142] pcielw 0000:52:0d.0:pcie204: link down processing complete
> [11305.605566] pcieport 0000:00:03.0:   device [8086:6f08] error
> status/mask=00004000/00000000
> [11305.605568] pcieport 0000:00:03.0:    [14] CmpltTO                (First)
> [11305.605578] pcieport 0000:00:03.0: broadcast error_detected message
> [11305.787386] tg3 0000:61:00.0 lc5: PCI I/O error detected
>
