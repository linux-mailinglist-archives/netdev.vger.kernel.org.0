Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9321CEA04
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfJGRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:02:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35144 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGRCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:02:21 -0400
Received: by mail-io1-f66.google.com with SMTP id q10so30267308iop.2;
        Mon, 07 Oct 2019 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6A4rIUjcqGcThTcraJEF4GgxX4VhVAP8ORGNSx+WSeU=;
        b=t8xl8m3dFqfl+nwGVBAgaXTXzMY7VAwFh7x79Jii2SiVGz8cM78abhKWq81YL4zJYC
         Wo0hSD3B9QLLzEcwcpvTjO3VEHCYatyO2sl3a6SCvXi1vgTdAbzVIMQRdoKaRjuRWUS6
         R9l1baAxytuK7awtgDHx0x9A735It9GgDptGwPIFHEJ3DAe807vfCjgu87HUA4nrhrUj
         hlNsqonHVjgh0NCHpFMt9FfVOM6OuUr3rFjc3Rv/tM8mzhGTFs/L5YCxLHok5cID/1vf
         xf/cFmgU1mdMo60rk4GHGxvvRYaC80bPMIODCgB5P4ofd3lf03gYGUW6MTBS9gIE4QF5
         zyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6A4rIUjcqGcThTcraJEF4GgxX4VhVAP8ORGNSx+WSeU=;
        b=J0wV3ilZawKQccMDIfH3C56K9UGq+C910wtQPXCJ894mA+Dl8/1h3g6L7OlmL4TT9y
         ckfnyBr1i6/tItxSfcdyqTUPNgpw4VHkwZDiK8pfPdVtrhd8Bq/yyJz2IWDqlrMpY8Ja
         pgwG8JcfOk6RaqJjT4lIxF7jVXfp9Rx3s1LjBGxEKYGUN1jZu9K3kCp2NVWVki3ofIld
         H/6ICqWeMKAKXRC1K1HlsyjQV8UovOl/qT2E0EgCvFkWmtnQL7w9fJ6Zof/nkk95ve0B
         FrVw1arvKsBjAD8An+MUYEoZ3UHy/6/n+euV+VXnxFQWUggNKSAr3xrSoOWdmrKuk/W5
         CsRg==
X-Gm-Message-State: APjAAAVAnMotx1XcC8//2X2d+0eZl0wgE9iGt9A+ze/hXH5Ln2hxMM3a
        yJ7MFLz9jDSN6SVG/XchyWZ2kLDmPJgfh8v63U5hrAjnvN4=
X-Google-Smtp-Source: APXvYqzaH0lC5Ph8t3EsceUcseVjaditLHPO0o8A2nTOuouDjJdA5idRDEfF8wwdJbG6iixWv+/WD1T0PaCVR5bZXBU=
X-Received: by 2002:a92:6a0c:: with SMTP id f12mr29492215ilc.64.1570467739448;
 Mon, 07 Oct 2019 10:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <1570208647.1250.55.camel@oc5348122405> <20191004233052.28865.1609.stgit@localhost.localdomain>
 <1570241926.10511.7.camel@oc5348122405> <CAKgT0Ud7SupVd3RQmTEJ8e0fixiptS-1wFg+8V4EqpHEuAC3wQ@mail.gmail.com>
 <1570463459.1510.5.camel@oc5348122405>
In-Reply-To: <1570463459.1510.5.camel@oc5348122405>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Oct 2019 10:02:03 -0700
Message-ID: <CAKgT0Ue6+JJqcoFO1AcP8GCShmMPiUm1SNkbq9BxxWA-b5=Oow@mail.gmail.com>
Subject: Re: [RFC PATCH] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
To:     "David Z. Dai" <zdai@linux.vnet.ibm.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, zdai@us.ibm.com,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 8:51 AM David Z. Dai <zdai@linux.vnet.ibm.com> wrote:
>

<snip>

> We have tested on one of the test box.
> With this patch, it doesn't crash kernel anymore, which is good!
>
> However we see this warning message from the log file for irq number 0:
> [10206.317270] Trying to free already-free IRQ 0
>
> With this stack:
> [10206.317344] NIP [c00000000018cbf8] __free_irq+0x308/0x370
> [10206.317346] LR [c00000000018cbf4] __free_irq+0x304/0x370
> [10206.317347] Call Trace:
> [10206.317348] [c00000008b92b970] [c00000000018cbf4] __free_irq
> +0x304/0x370 (unreliable)
> [10206.317351] [c00000008b92ba00] [c00000000018cd84] free_irq+0x84/0xf0
> [10206.317358] [c00000008b92ba30] [d000000007449e60] e1000_free_irq
> +0x98/0xc0 [e1000e]
> [10206.317365] [c00000008b92ba60] [d000000007458a70] e1000e_pm_freeze
> +0xb8/0x100 [e1000e]
> [10206.317372] [c00000008b92baa0] [d000000007458b6c]
> e1000_io_error_detected+0x34/0x70 [e1000e]
> [10206.317375] [c00000008b92bad0] [c000000000040358] eeh_report_failure
> +0xc8/0x190
> [10206.317377] [c00000008b92bb20] [c00000000003eb2c] eeh_pe_dev_traverse
> +0x9c/0x170
> [10206.317379] [c00000008b92bbb0] [c000000000040d84]
> eeh_handle_normal_event+0xe4/0x580
> [10206.317382] [c00000008b92bc60] [c000000000041330] eeh_handle_event
> +0x30/0x340
> [10206.317384] [c00000008b92bd10] [c000000000041780] eeh_event_handler
> +0x140/0x200
> [10206.317386] [c00000008b92bdc0] [c0000000001397c8] kthread+0x1a8/0x1b0
> [10206.317389] [c00000008b92be30] [c00000000000b560]
> ret_from_kernel_thread+0x5c/0x7c
>
> Thanks! - David

Hmm. I wonder if it is possibly calling the report
e1000_io_error_detected multiple times. If so then the secondary calls
to e1000_pm_freeze would cause issues.

I will add a check so that we only down the interface and free the
IRQs if the interface is in the present and running state.

I'll submit an update patch shortly.

Thanks.

- Alex
