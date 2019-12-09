Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00C117351
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLISBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:01:22 -0500
Received: from mx.sdf.org ([205.166.94.20]:52615 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfLISBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 13:01:21 -0500
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id xB9I19fN013269
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits) verified NO);
        Mon, 9 Dec 2019 18:01:10 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id xB9I192b025088;
        Mon, 9 Dec 2019 18:01:09 GMT
Date:   Mon, 9 Dec 2019 18:01:09 GMT
From:   George Spelvin <lkml@sdf.org>
Message-Id: <201912091801.xB9I192b025088@sdf.org>
To:     lkml@sdf.org, michael.chan@broadcom.com
Subject: Re: [RFC PATCH 2/4] b44: Fix off-by-one error in acceptable address range
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org
In-Reply-To: <CACKFLinCFmEPHzaQRy0Wq_pjWtA+n_Uu9D63t1oEjtQM=1yMHQ@mail.gmail.com>
References: <201912080836.xB88amHd015549@sdf.org>,
    <CACKFLinCFmEPHzaQRy0Wq_pjWtA+n_Uu9D63t1oEjtQM=1yMHQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From michael.chan@broadcom.com Mon Dec  9 17:30:02 2019
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
        b=IFhkqkqmkV1immJLIPu0fZ4IWzVHMsSFers4GqLqTxLaiKuXyQfvRhQSRM37NYwaON
         IE/0JjtXxZyECNyF1M2sFl/VVo4nVQG28mHeuJK1GG8WtToN+bF40KU+3eGhDWFgJYGK
         XfZjSIrHORSGYlKRWdpfv+jJizDt0/zB1RvMipk9BSW3mp5MLNHB8gnWmqFpptDdkqYX
         4R906dAil3MORLKrH33jpnHlWdZeTPc++n4+b+YhAggBzLCifmfcNP5Gsi9MVV6+hzot
         8RxP7p+m1839v84KhyhUAeuJ64QLKaQA9jAMF9IOU/N1DJCFLFE6rPmh0JM5jkl82cDp
         4qew==
X-Gm-Message-State: APjAAAWuTa/gVp+rOdJT+15VVbVrsYIOYBlX4a4u8GUmZNE3mGqVmIfL
	8BYFLElwhyjGzOgl3smgAsybRD66b+oZQTZLOuyTSOxH
X-Google-Smtp-Source: APXvYqz4AY07BzHgic5er69wv22sNZkWuNoimJ4dj0xiy8faF2rZTCRbn2c2dvhbKtnKoCqZ27uqaKVyNe2AUdEl/0o=
X-Received: by 2002:a05:6830:1e75:: with SMTP id m21mr21646882otr.36.1575912597048;
 Mon, 09 Dec 2019 09:29:57 -0800 (PST)
MIME-Version: 1.0
References: <201912080836.xB88amHd015549@sdf.org>
In-Reply-To: <201912080836.xB88amHd015549@sdf.org>
From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 9 Dec 2019 09:29:46 -0800
Subject: Re: [RFC PATCH 2/4] b44: Fix off-by-one error in acceptable address range
To: George Spelvin <lkml@sdf.org>
Cc: Netdev <netdev@vger.kernel.org>, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Dec 2019 at 09:29:46 Michael Chan wrote:
> The patchset looks ok to me.  The only minor suggestion is to define
> this (DMA_BIT_MASK(30) + 1) as B44_DMA_ADDR_LIMIT or something like
> that so you don't have to repeat it so many times.

Thank you for the prompt reply.  Yes, that's a sensible thing to do.
There's an existing constant I can use: SSB_PCI_DMA_SZ.

Do you have any idea about the WARN_ON_ONCE in report_addr()?  That's
a someone more invasive issue.  E.g. should it be changed to also
honour the NO_WARN flag?

Looking at the 440x datasheet, one significantly more ambitious
thing I wonder about is if it would be possible to map the swiotlb
using SBToPCITranslation[01] and let that layer do the heavy lifting.
The translation registers are set up, but I don't see them ever actually
used for anything on these chips.  (But I havnn't grokked all the
drivers/ssb code yet, so I might have missed something.)
