Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B7F65CD1A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 07:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjADGbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 01:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjADGbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 01:31:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8823D13FAF;
        Tue,  3 Jan 2023 22:31:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1FA2B811FC;
        Wed,  4 Jan 2023 06:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD17C433D2;
        Wed,  4 Jan 2023 06:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672813896;
        bh=Jq89Kt6GXbDbgoUy01U5qC9TI8NvX/meP04iOIsIWiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tsyBcvrO9BpqHYiYlcjjB3N0yH9nUsyCTkPW7A/evdYAongrrcXQX4nAzJL6wC3/K
         HA6PDhkl9YJln6ARlXdV2EPyjOJbVAJ4wEQVonw6o7o4nQV8Kkn4kCCNzXKwfotpth
         GlUZOfj/YqcjPoSj4CyL39AUxwcCdXwGQnSMyQpGnVFTJkl/7Br0xPtA2oVrv+W2Iw
         QuAixiTJuVlBl+L1WSixJ6cRESXTwJcOt0xf3L+hl6AM84HcZbHeDnIm3WAd0SouGs
         4AnHa5iixo/WzKvmVbCNof3Sb1WBmV8VnvvX7Ffl88xwqOmAaZ9Y0vaTvZvX7yKVgL
         Gqte4Rc26WGkw==
Date:   Wed, 4 Jan 2023 08:31:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        anthony.l.nguyen@intel.com, netdev@vger.kernel.org,
        rajat.khandelwal@intel.com, jesse.brandeburg@intel.com,
        linux-kernel@vger.kernel.org, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Message-ID: <Y7UdQ3aHzKejN0Aj@unreal>
References: <Y7QYxAhcUa2JtjSy@unreal>
 <20230103142104.GA996978@bhelgaas>
 <Y7RjCkanr0Ulx3TD@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RjCkanr0Ulx3TD@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 07:16:58PM +0200, Leon Romanovsky wrote:
> On Tue, Jan 03, 2023 at 08:21:04AM -0600, Bjorn Helgaas wrote:

<...>

> > > > If a quirk like this is only needed when the driver is loaded, 
> > > 
> > > This is always the case with PCI devices managed through kernel, isn't it?
> > > Users don't care/aware about "broken" devices unless they start to use them.
> > 
> > Indeed, that's usually the case.  There's a lot of stuff in quirks.c
> > that could probably be in drivers instead.
> 
> NP, so or deprecate quirks.c and prohibit any change to that file or
> don't allow drivers to mangle PCI in their probe routines.
> Everything in-between will cause to enormous mess in long run.

Another thing to consider what if you go with "probe variant", users
will see behavioral differences between drivers and subsystems on
how to control these quirks.

As an example, see proposal in this thread to add ethtool private flag
to enable/disable quirk. In other places, it will be module parameter,
sysfs or special to that subsystem tool.

Thanks

> 
> Thanks
> 
> > 
> > Bjorn
