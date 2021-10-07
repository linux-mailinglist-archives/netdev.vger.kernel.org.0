Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371DD4250C0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbhJGKMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232642AbhJGKL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 06:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97909610EA;
        Thu,  7 Oct 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633601405;
        bh=Dv3qgGnXN5hf3/aR7Ya39BbKuSxyHbv2DT0bSXt0WUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EU/xBtuIlE9aHhOu1bi02mIAyV71Vv0ij2ZszvgT9cOyeyl2HZCR9osGMmPqSs7TI
         QdR5zFBc2o4JyTRFcYMlHF9WUaUnF9sIXJw9Pri6tVWG8PV19AuhUDl4txxE0f3/Bs
         DTOVDZdowRBa7Fq863R9rXJPA7HIhaR6CpzpmzjMAn4ZiB+rlLQCSOoZM+1QC3GC6V
         tisoKT4jGORLgEXbQb7FPzXcWvYDzlBTNnVc/yortQ1RcOvFTpTz361L3C6UASKJP0
         Q2gtn+n9Qq/BQqRCS1+ERJHA9XE8tVRBxVMxO45IvxVARQHAcjVMcduuvc2nq0xXev
         Fvw6FuE7kpgcg==
Received: by pali.im (Postfix)
        id 499CF81A; Thu,  7 Oct 2021 12:10:03 +0200 (CEST)
Date:   Thu, 7 Oct 2021 12:10:03 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
Message-ID: <20211007101003.na5rdtildnatx432@pali>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
 <2174509.SLDT7moDbM@pc-42>
 <20211001160832.ozxc7bhlwlmjeqbo@pali>
 <19961646.Mslci0rqIs@pc-42>
 <87lf35ckn5.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lf35ckn5.fsf@codeaurora.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 07 October 2021 11:19:10 Kalle Valo wrote:
> Jérôme Pouiller <jerome.pouiller@silabs.com> writes:
> 
> > On Friday 1 October 2021 18:08:32 CEST Pali Rohár wrote:
> >> On Friday 01 October 2021 17:09:41 Jérôme Pouiller wrote:
> >> > On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
> >> > > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >> > >
> >> > > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > > >
> >> > > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> >> > >
> >> > > [...]
> >> > >
> >> > > > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
> >> > > > +                     const struct firmware **fw, int *file_offset)
> >> > > > +{
> >> > > > +     int keyset_file;
> >> > > > +     char filename[256];
> >> > > > +     const char *data;
> >> > > > +     int ret;
> >> > > > +
> >> > > > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
> >> > > > +              wdev->pdata.file_fw, keyset_chip);
> >> > > > +     ret = firmware_request_nowarn(fw, filename, wdev->dev);
> >> > > > +     if (ret) {
> >> > > > +             dev_info(wdev->dev, "can't load %s, falling back to %s.sec\n",
> >> > > > +                      filename, wdev->pdata.file_fw);
> >> > > > +             snprintf(filename, sizeof(filename), "%s.sec",
> >> > > > +                      wdev->pdata.file_fw);
> >> > > > +             ret = request_firmware(fw, filename, wdev->dev);
> >> > > > +             if (ret) {
> >> > > > +                     dev_err(wdev->dev, "can't load %s\n", filename);
> >> > > > +                     *fw = NULL;
> >> > > > +                     return ret;
> >> > > > +             }
> >> > > > +     }
> >> > >
> >> > > How is this firmware file loading supposed to work? If I'm reading the
> >> > > code right, the driver tries to load file "wfm_wf200_??.sec" but in
> >> > > linux-firmware the file is silabs/wfm_wf200_C0.sec:
> >> > >
> >> > > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/silabs
> >> > >
> >> > > That can't work automatically, unless I'm missing something of course.
> >> >
> >> > The firmware are signed. "C0" is the key used to sign this firmware. This
> >> > key must match with the key burned into the chip. Fortunately, the driver
> >> > is able to read the key accepted by the chip and automatically choose the
> >> > right firmware.
> >> >
> >> > We could imagine to add a attribute in the DT to choose the firmware to
> >> > load. However, it would be a pity to have to specify it manually whereas
> >> > the driver is able to detect it automatically.
> >> >
> >> > Currently, the only possible key is C0. However, it exists some internal
> >> > parts with other keys. In addition, it is theoretically possible to ask
> >> > to Silabs to burn parts with a specific key in order to improve security
> >> > of a product.
> >> >
> >> > Obviously, for now, this feature mainly exists for the Silabs firmware
> >> > developers who have to work with other keys.
> >> >
> >> > > Also I would prefer to use directory name as the driver name wfx, but I
> >> > > guess silabs is also doable.
> >> >
> >> > I have no opinion.
> >> >
> >> >
> >> > > Also I'm not seeing the PDS files in linux-firmware. The idea is that
> >> > > when user installs an upstream kernel and the linux-firmware everything
> >> > > will work automatically, without any manual file installations.
> >> >
> >> > WF200 is just a chip. Someone has to design an antenna before to be able
> >> > to use.
> >> >
> >> > However, we have evaluation boards that have antennas and corresponding
> >> > PDS files[1]. Maybe linux-firmware should include the PDS for these boards
> >> 
> >> So chip vendor provides firmware and card vendor provides PDS files.
> >
> > Exactly.
> >
> >> In
> >> my opinion all files should go into linux-firmware repository. If Silabs
> >> has PDS files for its devel boards (which are basically cards) then I
> >> think these files should go also into linux-firmware repository.
> >> 
> >> And based on some parameter, driver should load correct PDS file. Seems
> >> like DT can be a place where to put something which indicates which PDS
> >> file should be used.
> >> 
> >> But should be in DT directly name of PDS file? Or should be in DT just
> >> additional compatible string with card vendor name and then in driver
> >> itself should be mapping table from compatible string to filename? I do
> >> not know what is better.
> >
> > The DT already accepts the attribute silabs,antenna-config-file (see
> > patch #2).
> >
> > I think that linux-firmware repository will reject the pds files if
> > no driver in the kernel directly point to it. Else how to detect
> > orphans?
> 
> This (linux-firmware rejecting files) is news to me, do you have any
> pointers?

I understand this as, linux-firmware rejects files which are not used by
any driver yet.

But you can send both pull request for linux-firmware and pull request
for your kernel driver to mailing lists. And once driver changes are
merged into -net tree then pull request for linux-firmware can be merged
too.

> > So, I think it is slightly better to use a mapping table.
> 
> Not following you here.

I understand this part to have mapping table between DTS compatible
string and pds firmware name in driver code.

> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
