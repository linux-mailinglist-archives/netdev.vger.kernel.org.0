Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36777901B4
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfHPMfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:35:43 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44504 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfHPMfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:35:43 -0400
Received: by mail-ed1-f65.google.com with SMTP id a21so4970466edt.11;
        Fri, 16 Aug 2019 05:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aopwDoWmGMmSqryhB3TtenNCf2ffEFD0Q7hDjwb+d9I=;
        b=oc2RnDRwEX58ApA+IPs6AwXrLlraAXBAFiBhEQkR+vMPPswi1KHmrlIBZ5Bus3GaRw
         r1ns5pZmPWiH8Zi7nKaAxvFaqXEg/X3sDuQxV0Unv3vy99d91StdatATDuTdNglRPS2o
         wMHYLzG8UM/JFAOLZPdOY6zF/7wB28SJ1vfwdWWISoDrDIyzPaEvN0Q9mpx5VQoNd6vO
         i0uhO1UaGn6aN7C6JNnbAr3KqEWZSCV6ISCtxjMUdrEWS1d3skivNbhtg03EYSI2+XiZ
         +Kbbfyxkl+wulZeoRq6lgzDOztsy7OUxxuYTwH0tPcGBlsg1kxmlvTYcSrwtAYQM/9A+
         npXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aopwDoWmGMmSqryhB3TtenNCf2ffEFD0Q7hDjwb+d9I=;
        b=WOh06djX87coaYfp2CWX2bXUbHk6cAdbAP352QwmsxNlXWoz93BJ3a0QrNm3IYXaFr
         0r+KfCHOJRgnuE62mwrZs9YZNgBIpTKogS+TQOTQ8glmz7XM0SrkyCso7pJx8UBnVq/h
         HzhoYq/e/Ytzv0+R2uCt/oUuh+mzUKTg9gm61pxrdo9uvQefj/Zu78mhG+d3cwsb+/yH
         7AxGZQAw3sBwWqT6DwmzZfbXDSfaPKYaP0YnpqXosayGCTBK8Sv+4et2zl4zCBDQpwEH
         9xwAUN8m3RSv4de9u75cWPcrn0GULLkdQFBC7nTGjzfDFga7suG8yyQy171uth4WeoHt
         vmDw==
X-Gm-Message-State: APjAAAWxsPJHXcwwOn2Jc50UYIgZ2wkPeHE+lryCMEycuz7NR53tEIcf
        ITGaRQNmn+7qpYkL8SSf1OdzXw+alkRosVKplNU=
X-Google-Smtp-Source: APXvYqzyOHKvO7geFWMkb7zQnrojx1lyottfgcoRJmX6ObUBtlXG9tt7k03kTrXvbgOEQXFoU+9TxH5OeO+SRL7oAnY=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr8954773ejb.90.1565958941334;
 Fri, 16 Aug 2019 05:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190816004449.10100-1-olteanv@gmail.com> <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk>
In-Reply-To: <20190816121837.GD4039@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 16 Aug 2019 15:35:30 +0300
Message-ID: <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to the
 transfer structure
To:     Mark Brown <broonie@kernel.org>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Fri, 16 Aug 2019 at 15:18, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Aug 16, 2019 at 03:44:41AM +0300, Vladimir Oltean wrote:
>
> > @@ -842,6 +843,9 @@ struct spi_transfer {
> >
> >       u32             effective_speed_hz;
> >
> > +     struct ptp_system_timestamp *ptp_sts;
> > +     unsigned int    ptp_sts_word_offset;
> > +
>
> You've not documented these fields at all so it's not clear what the
> intended usage is.

Thanks for looking into this.
Indeed I didn't document them as the patch is part of a RFC and I
thought the purpose was more clear from the context (cover letter
etc).
If I do ever send a patchset for submission I will document the newly
introduced fields properly.
So let me clarify:
The SPI slave device driver is populating these fields to indicate to
the controller driver that it wants word number @ptp_sts_word_offset
from the tx buffer snapshotted. The controller driver is supposed to
put the snapshot into the @ptp_sts field, which is a pointer to a
memory location under the control of the SPI slave device driver.
It is ok if the ptp_sts pointer is NULL (no need to check), because
the API for taking snapshots already checks for that.
At the moment there is yet no proposed mechanism for the SPI slave
driver to ensure that the controller will really act upon this
request. That would be really nice to have, since some SPI slave
devices are time-sensitive and warning early is a good way to prevent
unnecessary troubleshooting.

Regards,
-Vladimir
