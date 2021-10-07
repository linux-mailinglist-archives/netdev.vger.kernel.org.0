Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62A54250CC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhJGKPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhJGKPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DBD6113E;
        Thu,  7 Oct 2021 10:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633601625;
        bh=kRlcvcbFuHhJuEirwDQ5X9clFRI3p9ivKRaKD8VGIhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VYCXUey5hK0BTCSnfeqnySTGL/DG4e1RxpN1FhtP7uDqqbCmZ6D2YUqlzSTUU7kPq
         Rzd4EvMqUzLXrWeMgxLdaNumFyFv+yTpik7V6r7maZsu6Y64jCHGd9y2/qoNPGiiLa
         XWxENFVy8w3ToyFnZicsvN2WFbZSEe5u3/qLLAtZt/DmfWo86y8h/0RKU3SskeGdG4
         R2LapygCf2QDX64xjjlz8Je9CLfWrM0Vmv264NewdoDNlih+60GEnFG0sb/PVQ8qWm
         K1NwLl8VUUNI6101Y4Dp3CFMTF71hG+LtdQoslOT30Mu9aFHl3XLAc/bSLco369xJI
         QPmK2NC3FLszg==
Received: by pali.im (Postfix)
        id 8AEFD81A; Thu,  7 Oct 2021 12:13:42 +0200 (CEST)
Date:   Thu, 7 Oct 2021 12:13:42 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
Message-ID: <20211007101342.fxl74ud4xra4u3cp@pali>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <20210920161136.2398632-11-Jerome.Pouiller@silabs.com>
 <87sfxlj6s1.fsf@codeaurora.org>
 <2174509.SLDT7moDbM@pc-42>
 <20211001160832.ozxc7bhlwlmjeqbo@pali>
 <87pmshckrm.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pmshckrm.fsf@codeaurora.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob! Could you look at issue below to represent antenna (pds)
firmware file requirement for this driver in DTS file?

On Thursday 07 October 2021 11:16:29 Kalle Valo wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Friday 01 October 2021 17:09:41 Jérôme Pouiller wrote:
> >> On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
> >> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >> > 
> >> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > >
> >> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > 
> >> > [...]
> >> > 
> >> > > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
> >> > > +                     const struct firmware **fw, int *file_offset)
> >> > > +{
> >> > > +     int keyset_file;
> >> > > +     char filename[256];
> >> > > +     const char *data;
> >> > > +     int ret;
> >> > > +
> >> > > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
> >> > > +              wdev->pdata.file_fw, keyset_chip);
> >> > > +     ret = firmware_request_nowarn(fw, filename, wdev->dev);
> >> > > +     if (ret) {
> >> > > +             dev_info(wdev->dev, "can't load %s, falling back to %s.sec\n",
> >> > > +                      filename, wdev->pdata.file_fw);
> >> > > +             snprintf(filename, sizeof(filename), "%s.sec",
> >> > > +                      wdev->pdata.file_fw);
> >> > > +             ret = request_firmware(fw, filename, wdev->dev);
> >> > > +             if (ret) {
> >> > > +                     dev_err(wdev->dev, "can't load %s\n", filename);
> >> > > +                     *fw = NULL;
> >> > > +                     return ret;
> >> > > +             }
> >> > > +     }
> >> > 
> >> > How is this firmware file loading supposed to work? If I'm reading the
> >> > code right, the driver tries to load file "wfm_wf200_??.sec" but in
> >> > linux-firmware the file is silabs/wfm_wf200_C0.sec:
> >> > 
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/silabs
> >> > 
> >> > That can't work automatically, unless I'm missing something of course.
> >> 
> >> The firmware are signed. "C0" is the key used to sign this firmware. This
> >> key must match with the key burned into the chip. Fortunately, the driver
> >> is able to read the key accepted by the chip and automatically choose the
> >> right firmware.
> >> 
> >> We could imagine to add a attribute in the DT to choose the firmware to
> >> load. However, it would be a pity to have to specify it manually whereas
> >> the driver is able to detect it automatically.
> >> 
> >> Currently, the only possible key is C0. However, it exists some internal
> >> parts with other keys. In addition, it is theoretically possible to ask
> >> to Silabs to burn parts with a specific key in order to improve security
> >> of a product. 
> >> 
> >> Obviously, for now, this feature mainly exists for the Silabs firmware
> >> developers who have to work with other keys.
> >>  
> >> > Also I would prefer to use directory name as the driver name wfx, but I
> >> > guess silabs is also doable.
> >> 
> >> I have no opinion.
> >> 
> >> 
> >> > Also I'm not seeing the PDS files in linux-firmware. The idea is that
> >> > when user installs an upstream kernel and the linux-firmware everything
> >> > will work automatically, without any manual file installations.
> >> 
> >> WF200 is just a chip. Someone has to design an antenna before to be able
> >> to use.
> >> 
> >> However, we have evaluation boards that have antennas and corresponding
> >> PDS files[1]. Maybe linux-firmware should include the PDS for these boards
> >
> > So chip vendor provides firmware and card vendor provides PDS files. In
> > my opinion all files should go into linux-firmware repository. If Silabs
> > has PDS files for its devel boards (which are basically cards) then I
> > think these files should go also into linux-firmware repository.
> 
> I agree, all files required for normal functionality should be in
> linux-firmware. The upstream philosophy is that a user can just install
> the latest kernel and latest linux-firmware, and everything should work
> out of box (without any manual work).
> 
> > And based on some parameter, driver should load correct PDS file. Seems
> > like DT can be a place where to put something which indicates which PDS
> > file should be used.
> 
> Again I agree.
> 
> > But should be in DT directly name of PDS file? Or should be in DT just
> > additional compatible string with card vendor name and then in driver
> > itself should be mapping table from compatible string to filename? I do
> > not know what is better.
> 
> This is also what I was wondering, to me it sounds wrong to have a
> filename in DT. I was more thinking about calling it "antenna name" (and
> not the actually filename), but using compatible strings sounds good to
> me as well. But of course DT maintainers know this better.
> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
