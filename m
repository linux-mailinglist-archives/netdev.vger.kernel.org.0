Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E93FB697
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhH3M5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbhH3M5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:57:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D443C06175F;
        Mon, 30 Aug 2021 05:56:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g14so12162560pfm.1;
        Mon, 30 Aug 2021 05:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EEJTS+E/OyxRs4wRsI06Xq/M7uNegnkzWs5JdWTzYNU=;
        b=ieeV+5LUYND8yidBAcfaE8ahVxB9sjR1MNAvC2BIJjwm6QsItbDLFQIVQbN5ebuvBv
         K9H6SSOjTQ4KustKfKXNvzOHdDLKoYmh5jjLY9C+ivVO5d7EpQ7OMtSIrr9xnf6OHVNT
         tLSUn1kzLwFRGhtIuTd3TdWOhMT/v3bIanmSBMeKuuyMHdkwKmXq8AvhGsapdJrNAAtL
         pxTAIWIm4k3IDjd4kiXHewb4QnqYeRb7M8ZMoVSnfgaFtl80D9/a+FWSknnvML/A2XcC
         MSnI4OfT7I83/es2xNQMEv92sDojJo5df6wpIhv1ilVexwK458NtgFLRxlrRhnTZysFo
         ZAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EEJTS+E/OyxRs4wRsI06Xq/M7uNegnkzWs5JdWTzYNU=;
        b=JT4STS3NR4CvwweKtNcSNtzHSgfrgXY5bB5CAz3nRkR+an3GZ8yRu70Y6BI6Nh8WXu
         DOvughzg7I7QQzkVpTDct4OoXNVP4mjgnEaLXKpBZggU/OqLT+siuBaQe0EHzG6wLVis
         k86mI84TOu4uo3mdXUG8244QdHcpxkAvIRa7SvPhT4gce/GqA90QAbJxKchu9L0TxCr5
         mqg1kGZgNrH0zj3pCv1vvrdrt18WAR0uXyZiGa9gZ2qHTyfro1KcUU68q8yUKo40QNF9
         z5QuwH1ROKDqbrUmZj5RXIygLWd3dMTa4i/6kgfwOCRpk6Nu55i0E+rfmw6sbm4GDtXT
         873A==
X-Gm-Message-State: AOAM530P4fPY5eMG3qXJm9CKcAIGAasmlipi4eCMXYA/oboPDT+F7SNi
        HEt/4CX1dTIA/cQ2nbdLjOa7vnvh1T24xk9AdxHtbZKZqFw=
X-Google-Smtp-Source: ABdhPJy4ZFOF7HuUN3n2a6nEjlyFDZZ0vM6KGhbzc+FvJLheFHeA4jplOXuQqtp89AZlJ9V+v5Drtl6A57OP32PCmV4=
X-Received: by 2002:aa7:875a:0:b0:3f1:c4c8:5f0d with SMTP id
 g26-20020aa7875a000000b003f1c4c85f0dmr13526843pfo.40.1630328176961; Mon, 30
 Aug 2021 05:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-3-verdre@v0yd.nl>
 <CAHp75Vf-ekdTh=86nR7wqufFPmEb5bve0hf1Oq_k_OAJCkNvWg@mail.gmail.com>
In-Reply-To: <CAHp75Vf-ekdTh=86nR7wqufFPmEb5bve0hf1Oq_k_OAJCkNvWg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 30 Aug 2021 15:55:40 +0300
Message-ID: <CAHp75VetWJ1e-JCdoi4dSfKEvYbdFS8w9bzmYjL=GZJndNYaug@mail.gmail.com>
Subject: Re: [PATCH 2/2] mwifiex: Try waking the firmware until we get an interrupt
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 3:51 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Mon, Aug 30, 2021 at 3:39 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote=
:

...

> > +       do {
> > +               if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE=
_READY_PCIE)) {
> > +                       mwifiex_dbg(adapter, ERROR,
> > +                                   "Writing fw_status register failed\=
n");

> > +                       return -1;

Please, use proper code. -EIO or so.

> > +               }
> > +
> > +               n_tries++;
> > +
> > +               if (n_tries <=3D 15)
> > +                       usleep_range(400, 700);
> > +               else
> > +                       msleep(10);
> > +       } while (n_tries <=3D 50 && READ_ONCE(adapter->int_status) =3D=
=3D 0);

Can you use definitions for 15 and 50?

> NIH read_poll_timeout() from iopoll.h.

On the second thought it might be not optimal to use it (requires
anyway an additional function and doesn't provide an abortion on
error). Just see above.

--=20
With Best Regards,
Andy Shevchenko
