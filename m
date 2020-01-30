Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE8414E3EA
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 21:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgA3U0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 15:26:15 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:43740 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgA3U0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 15:26:14 -0500
Received: by mail-il1-f195.google.com with SMTP id o13so4201934ilg.10
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 12:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMmbTPRv5n9fcnTR4JD/Hiobk7HR6X/mODzSmDElFRk=;
        b=UJG07q0ZvllEgVwuAoevdh4W2PsMLK8OB4w5jNu08HE+oqaV0dPCzf6G0s28627iHX
         MAeM0+1hO7Q2rcZRlzA757D7sD7JXrirx/PgZPiMwHhbj9oInkKx0RKNdrD7wlxxP3HN
         8H8GRgU6guwk3DDN9gxR7XFi8L9Fu+IuylCY9CCcIViFiuQnch7A4mOtzRzlLvDD64xC
         5EM4anhFUfbutFIJc+/Kq+JL6zrAp6xok25sEwrImK0K1jVsjqykH1fnKHssrE6VaZ74
         ujMrhqsKK0AHG3KYqLz2HkDkWvBm5V4I3H+jqJzqGlGiLwL5z60horRKkm5RSuYM1SLV
         IzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMmbTPRv5n9fcnTR4JD/Hiobk7HR6X/mODzSmDElFRk=;
        b=XT+PDE3r1TkAZu++/NJqbr+fJ5EWAHyqCInaW4ky4Bhj3v0Ub/wDJhpUxhI5gDFVBm
         T2LfZePZPe8GGoh+nuWrPnakABN38OK7K4xDGo3xVytAZ5UzHrhBV4diendorPJLlpD3
         LzptgeeRRsji9Y/Yg8FkE/1TPv0173BXlCl7Bw/WR8+YmibFzZGkPkWhVSpMDo7CpoL6
         nV4bKpk4174DVF+ozuYyazkl4JLa6FaF3h89c2MUePea5TCJR0/lSvAbqTulD5XVzc16
         nzOxbqN8RPj1/bsCoM7eszNvNPmxlbve5QWmXP+W+6B7I7fxdQYVv1YYPquo0hyUsPMo
         0vJg==
X-Gm-Message-State: APjAAAURBna9v+RT80FIhEiRygnQiNje0+DwJWKEfZrrtiQU6U/w+Ufp
        9xTrIC0MrdAtrTTHtp5uQPyIldvgXBcQU/LZXln1cA==
X-Google-Smtp-Source: APXvYqyLkAz/Xj41rF8RDGjF+NXQgzOwtixw6VtvNiEJGbHaCdRsXwh3NpcbcJY/YLZlte51umpHDg/clYxyTtxmrpU=
X-Received: by 2002:a92:3a8d:: with SMTP id i13mr6549486ilf.112.1580415971935;
 Thu, 30 Jan 2020 12:26:11 -0800 (PST)
MIME-Version: 1.0
References: <20200129223609.9327-1-rjones@gateworks.com> <20200130091055.159d63ed@cakuba>
In-Reply-To: <20200130091055.159d63ed@cakuba>
From:   Bobby Jones <rjones@gateworks.com>
Date:   Thu, 30 Jan 2020 12:26:01 -0800
Message-ID: <CALAE=UBu=9ieHytFqD7PPMSr3hv+aCC7naLN5Bh6pB4ODEDCsw@mail.gmail.com>
Subject: Re: [PATCH net] net: thunderx: workaround BGX TX Underflow issue
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        David Miller <davem@davemloft.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Harvey <tharvey@gateworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 9:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 29 Jan 2020 14:36:09 -0800, Robert Jones wrote:
> > From: Tim Harvey <tharvey@gateworks.com>
> >
> > While it is not yet understood why a TX underflow can easily occur
> > for SGMII interfaces resulting in a TX wedge. It has been found that
> > disabling/re-enabling the LMAC resolves the issue.
> >
> > Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> > Reviewed-by: Robert Jones <rjones@gateworks.com>
>
> Sunil or Robert (i.e. one of the maintainers) will have to review this
> patch (as indicated by Dave by marking it with "Needs Review / ACK" in
> patchwork).
>
> At a quick look there are some things which jump out at me:
>
> > +static int bgx_register_intr(struct pci_dev *pdev)
> > +{
> > +     struct bgx *bgx = pci_get_drvdata(pdev);
> > +     struct device *dev = &pdev->dev;
> > +     int num_vec, ret;
> > +
> > +     /* Enable MSI-X */
> > +     num_vec = pci_msix_vec_count(pdev);
> > +     ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
> > +     if (ret < 0) {
> > +             dev_err(dev, "Req for #%d msix vectors failed\n", num_vec);
> > +             return 1;
>
> Please propagate real error codes, or make this function void as the
> caller never actually checks the return value.
>
> > +     }
> > +     sprintf(bgx->irq_name, "BGX%d", bgx->bgx_id);
> > +     ret = request_irq(pci_irq_vector(pdev, GMPX_GMI_TX_INT),
>
> There is a alloc_irq and request_irq call added in this patch but there
> is never any freeing. Are you sure this is fine? Devices can be
> reprobed (unbound and bound to drivers via sysfs).

I agree there needs to be accompanying free calls. I'm referencing
drivers/net/ethernet/cavium/thunder/nic_main.c and see instances of
both pci_free_irq_vectors() and free_irq(). My initial thought was
that I should use pci_free_irq_vectors() in the error check
conditional of the above request irq and also in the bgx_remove()
function. Would that be appropriate in this case?

I'd also plan on using a conditional like this for the free calls:

if (bgx->irq_name)
    pci_free_irq_vectors(pdev);

I'm new to kernel development so suggestions are welcome.

>
> > +             bgx_intr_handler, 0, bgx->irq_name, bgx);
>
> Please align the continuation line with the opening bracket (checkpatch
> --strict should help catch this).
>
> > +     if (ret)
> > +             return 1;
> > +
> > +     return 0;
> > +}
