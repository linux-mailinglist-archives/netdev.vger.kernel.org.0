Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616103BB9BD
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhGEJDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:03:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49361 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhGEJDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 05:03:00 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <chris.chiu@canonical.com>)
        id 1m0KSk-0006yI-Co
        for netdev@vger.kernel.org; Mon, 05 Jul 2021 09:00:22 +0000
Received: by mail-ot1-f71.google.com with SMTP id e28-20020a9d491c0000b02903daf90867beso12871043otf.11
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 02:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6wYMggQL4Kc/x8xMyA7h2j3whmdqB7IgTt34u11Uos=;
        b=XjsEolvZgxZF6+QbReCJifNuP8zT9tmdhIBORVJ1BCuj3HZTWprSkIOby9IzXwKHL6
         PqCaDq3Bpfy7PVCO1rCsjQYpG043F+Sep/xn18OwGs6zB5mipHt3aJLSBDo9pcNYxwFc
         W0pj9hdc6EuIooy34LfOQC7/nD65CG9Acpnq2WypYEK8tXFPyYlamTkdPMHk+vY3TXhv
         fdERFE9/2F7uVu1RpEKphNDYq5/AVVEtfDO4i7mIp/iWBeEmrtubtQzfDCyBk+FlsWB5
         1+hlZ0n9AdBYaulo5JMTWgVKqTxaBjUZxxCNm5DEq+GgvaVvC4D/C5+bTsOzXweghEWW
         +00w==
X-Gm-Message-State: AOAM533YLkftYvSiXw2XOZjohJRi2pBbeIfFsCEwfSLhlhXPQ6SpxxSt
        jWE0GAwQt6wEHRIcAeCRi/H3sWdlCaeGVtHVyEFf/FTSGTUoqlt8vRKvMRntUfoCE7D1r74/yz/
        yAhFiUpXlpdcb88VqMw/YchYWKer+8HcDwIHqnRrg7xHmXPsZng==
X-Received: by 2002:a05:6830:1f19:: with SMTP id u25mr6524525otg.303.1625475621315;
        Mon, 05 Jul 2021 02:00:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9roYChfxAr/TO7KIQukCmHCx/xq1CtOLOyNW4WqCG9AUmbVemwjMekcOUHAfCzMs3mnJDH06AMTJrb7zjkaM=
X-Received: by 2002:a05:6830:1f19:: with SMTP id u25mr6524509otg.303.1625475621095;
 Mon, 05 Jul 2021 02:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210701163354.118403-1-chris.chiu@canonical.com> <87v95thzu1.fsf@codeaurora.org>
In-Reply-To: <87v95thzu1.fsf@codeaurora.org>
From:   Chris Chiu <chris.chiu@canonical.com>
Date:   Mon, 5 Jul 2021 17:00:10 +0800
Message-ID: <CABTNMG2_Cb7RhguJZNKZxAna6oBaDPhomBWRreO-adFX2Erwkw@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 4:42 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> chris.chiu@canonical.com writes:
>
> > From: Chris Chiu <chris.chiu@canonical.com>
> >
> > There will be crazy numbers of interrupts triggered by 8188cu and
> > 8192cu module, around 8000~10000 interrupts per second, on the usb
> > host controller. Compare with the vendor driver source code, it's
> > mapping to the configuration CONFIG_USB_INTERRUPT_IN_PIPE and it is
> > disabled by default.
> >
> > Since the interrupt transfer is neither used for TX/RX nor H2C
> > commands. Disable it to avoid the confusing interrupts for the
> > 8188cu and 8192cu module which I only have for verification.
>
> The last paragraph is not entirely clear for me, can you elaborate it
> more? What do you mean with "confusing interrupts"? And is this fixing
> an actual user visible bug or are you just reducing the number of
> interrupts?
>
It's confusing because there are 8000~9000 interrupts per second even
though the association is not done yet and no traffic is pumped. It's
also way too many even the reception of the beacon frames triggers the
interrupt. This huge number overwhelms the normal interrupt we
expected from the register setting (only < 100/sec if runs with
rtlwif/rtl8192cu driver instead). It's difficult to judge where/why
the interrupts come from and what possible overhead it could possibly
incur.

> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
