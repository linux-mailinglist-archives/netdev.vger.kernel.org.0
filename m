Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B327A493D5C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355827AbiASPjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355749AbiASPjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBEBC061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 07:39:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67AD5B81A0D
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 15:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43A8C004E1;
        Wed, 19 Jan 2022 15:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642606744;
        bh=zgAF4KTL7COd2hW8GftK3G8macsvxcWSZtugkQyBiEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iZ90jTHu2duJZ3aZbrttkFtfQyT2esqRHpzEhtcst0G4AD+IpHBgy5E351ums1yYI
         lrbl9DLN4e+AWvzvCkFTuQNTiKPGmIkQ44b6u/pAUwgs5Ir6IgYU8vvU3GGKYQeF8p
         TiMpLwCeQ53YHDgQSzbHlLth/Pqy5ZYhLc44r46GkCNon3clMug/x752Nw6W51Sjsd
         XwukQ2P8NhdqMNqyiUytU8MwlcAgOCUcRC6SCRNssCWaIzRxpXitNYOjr6MfzZn/sK
         py7m6GEx/tEL5V9oKejnNLve/h3DsL3cqmjMI/OtI3PulSu01K8EPf0Oj4Nnd7zmZC
         O2al758Ie0HbQ==
Date:   Wed, 19 Jan 2022 07:39:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <20220119073902.507f568c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <YefdxW/V/rjiiw2x@shredder>
References: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <YefdxW/V/rjiiw2x@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 11:45:41 +0200 Ido Schimmel wrote:
> On Tue, Jan 18, 2022 at 02:51:59PM -0800, Jakub Kicinski wrote:
> > Hi Michal!
> > 
> > Sorry to hasten but I'm wondering if there is a plan to cut the 5.16
> > ethtool release? Looks like there is a problem in SFP EEPROM parsing
> > code, at least with QSFP28s, user space always requests page 3 now.
> > This ends in an -EINVAL (at least for drivers not supporting the paged
> > mode).  
> 
> Jakub, are you sure you are dealing with QSFP and not SFP? I'm asking
> because I assume the driver in question is mlx5 that has this code in
> its implementation of get_module_eeprom_by_page():
> 
> ```
> switch (module_id) {
> case MLX5_MODULE_ID_SFP:
> 	if (params->page > 0)
> 		return -EINVAL;
> 	break;
> ```

Yup, it's a QSFP28 / SFF-8636, the report was with a different NIC.

> And indeed, ethtool(8) commit fc47fdb7c364 ("ethtool: Refactor
> human-readable module EEPROM output for new API") always asks for Upper
> Page 03h, regardless of the module type.
> 
> It is not optimal for ethtool(8) to ask for unsupported pages and I made
> sure it's not doing it anymore, but I believe it's wrong for the kernel
> to return an error. All the specifications that I'm aware of mandate
> that when an unsupported page is requested, the Page Select byte will
> revert to 0. That is why Upper Page 00h is always read-only.
> 
> For reference, see section 10.3 in SFF-8472, section 6.2.11 in SFF-8636
> and section 8.2.13 in CMIS.
> 
> Also, the entire point of the netlink interface is that the kernel can
> remain ignorant of the EEPROM layout and keep all the logic in user
> space.

The EINVAL came from fallback_set_params().

As far as I can see user space will call sff8636_show_dom() regardless
of what we return from the kernel, so returning first page again should
not confuse anything.. as long as the fields read from page 3 happen to
be 0 in page 0?

What about drivers which do implement get_module_eeprom_by_page? Can we
somehow ensure they DTRT and are consistent with the legacy / flat API?

> > By the looks of it - Ido fixed this in 6e2b32a0d0ea ("sff-8636: Request
> > specific pages for parsing in netlink path") but it may be too much code 
> > to backport so I'm thinking it's easiest for distros to move to v5.16.  
> 
> I did target fixes at 'ethtool' and features at 'ethtool-next', but I
> wasn't aware of this bug.

