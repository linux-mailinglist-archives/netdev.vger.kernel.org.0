Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F1F41F1DC
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhJAQKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231675AbhJAQKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 12:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4651961452;
        Fri,  1 Oct 2021 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633104515;
        bh=7CRJ2vFylAq8uVkY++RDETUKk8nEfEIuz0JrlkfB8sI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oD7R+2XiopeULBOwycPhpvnbEoal/ni+kws6ZyAXytNkOWn9N0mQODpFiE/JMO+XO
         mYG5gSJJDy9Qth2f+LYHxojz1HhNJBBrMNzudSSGNkcnx0iKZA7QiG3/CapjLlBprN
         nPrXAl6I9Ii22Qpj4oWNidjl3C4Z5WZBrm+oV9xmzQ9uEPPXoG8upS35eJAO08I5ag
         iJ9fgwDIqzN8gYEce+JLUgYuj+DOdj+cBHi8GRqsSL11JNHGnYLbjnktpFAoXsF8nc
         XiScFG52br5SvcdG+skf6rWLax7d9hTc0x1EDuJzMIfgVKxgRMv4XVubKGQJwmoedf
         4p3AjS+hdLMFQ==
Received: by pali.im (Postfix)
        id 0B989821; Fri,  1 Oct 2021 18:08:32 +0200 (CEST)
Date:   Fri, 1 Oct 2021 18:08:32 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
Message-ID: <20211001160832.ozxc7bhlwlmjeqbo@pali>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-11-Jerome.Pouiller@silabs.com>
 <87sfxlj6s1.fsf@codeaurora.org>
 <2174509.SLDT7moDbM@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2174509.SLDT7moDbM@pc-42>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 01 October 2021 17:09:41 Jérôme Pouiller wrote:
> On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > 
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > 
> > [...]
> > 
> > > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
> > > +                     const struct firmware **fw, int *file_offset)
> > > +{
> > > +     int keyset_file;
> > > +     char filename[256];
> > > +     const char *data;
> > > +     int ret;
> > > +
> > > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
> > > +              wdev->pdata.file_fw, keyset_chip);
> > > +     ret = firmware_request_nowarn(fw, filename, wdev->dev);
> > > +     if (ret) {
> > > +             dev_info(wdev->dev, "can't load %s, falling back to %s.sec\n",
> > > +                      filename, wdev->pdata.file_fw);
> > > +             snprintf(filename, sizeof(filename), "%s.sec",
> > > +                      wdev->pdata.file_fw);
> > > +             ret = request_firmware(fw, filename, wdev->dev);
> > > +             if (ret) {
> > > +                     dev_err(wdev->dev, "can't load %s\n", filename);
> > > +                     *fw = NULL;
> > > +                     return ret;
> > > +             }
> > > +     }
> > 
> > How is this firmware file loading supposed to work? If I'm reading the
> > code right, the driver tries to load file "wfm_wf200_??.sec" but in
> > linux-firmware the file is silabs/wfm_wf200_C0.sec:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/silabs
> > 
> > That can't work automatically, unless I'm missing something of course.
> 
> The firmware are signed. "C0" is the key used to sign this firmware. This
> key must match with the key burned into the chip. Fortunately, the driver
> is able to read the key accepted by the chip and automatically choose the
> right firmware.
> 
> We could imagine to add a attribute in the DT to choose the firmware to
> load. However, it would be a pity to have to specify it manually whereas
> the driver is able to detect it automatically.
> 
> Currently, the only possible key is C0. However, it exists some internal
> parts with other keys. In addition, it is theoretically possible to ask
> to Silabs to burn parts with a specific key in order to improve security
> of a product. 
> 
> Obviously, for now, this feature mainly exists for the Silabs firmware
> developers who have to work with other keys.
>  
> > Also I would prefer to use directory name as the driver name wfx, but I
> > guess silabs is also doable.
> 
> I have no opinion.
> 
> 
> > Also I'm not seeing the PDS files in linux-firmware. The idea is that
> > when user installs an upstream kernel and the linux-firmware everything
> > will work automatically, without any manual file installations.
> 
> WF200 is just a chip. Someone has to design an antenna before to be able
> to use.
> 
> However, we have evaluation boards that have antennas and corresponding
> PDS files[1]. Maybe linux-firmware should include the PDS for these boards

So chip vendor provides firmware and card vendor provides PDS files. In
my opinion all files should go into linux-firmware repository. If Silabs
has PDS files for its devel boards (which are basically cards) then I
think these files should go also into linux-firmware repository.

And based on some parameter, driver should load correct PDS file. Seems
like DT can be a place where to put something which indicates which PDS
file should be used.

But should be in DT directly name of PDS file? Or should be in DT just
additional compatible string with card vendor name and then in driver
itself should be mapping table from compatible string to filename? I do
not know what is better.

> and the DT should contains the name of the design. eg:
> 
>     compatible = "silabs,brd4001a", "silabs,wf200";
> 
> So the driver will know which PDS it should use. 
> 
> In fact, I am sure I had this idea in mind when I have started to write
> the wfx driver. But with the time I have forgotten it. 
> 
> If you agree with that idea, I can work on it next week.
> 
> 
> [1]: https://github.com/SiliconLabs/wfx-pds
> 
> -- 
> Jérôme Pouiller
> 
> 
