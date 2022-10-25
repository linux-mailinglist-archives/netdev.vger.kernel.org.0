Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433CA60CA10
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJYK36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJYK33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:29:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CB5617D;
        Tue, 25 Oct 2022 03:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B1E2B819D9;
        Tue, 25 Oct 2022 10:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42459C433D6;
        Tue, 25 Oct 2022 10:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666693734;
        bh=/h7tJQC1P3N2A377J7tlXkgUMlgfjf+DToChl+3GLAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KgTpgUzP+TfsRSTr7OEns7Pe3354DLVlXelnMhZwO9YOeigtsfUqFWClPNtbXaVP7
         DSykYJEKC6MPu60OYuVIHNFWCqw5GH1i0o7odslV2fNSXSqY7gU4T8poDX4Ba7qwVq
         YtATxBgubhT+y6WdiP+KYszIx7QEfM/5gn2vWWnw=
Date:   Tue, 25 Oct 2022 12:29:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@kernel.org>,
        Felipe Balbi <balbi@kernel.org>, johannes.berg@intel.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Subject: Re: [BUG] use-after-free after removing UDC with USB Ethernet gadget
Message-ID: <Y1e6mvspXQZKtZYl@kroah.com>
References: <fd36057a-e8d9-38a3-4116-db3f674ea5af@pengutronix.de>
 <Y1eahQ66OcpsECNf@kroah.com>
 <a4732045-a8bf-cf81-6faa-0e99cabe2f4a@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4732045-a8bf-cf81-6faa-0e99cabe2f4a@pengutronix.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 11:28:24AM +0200, Ahmad Fatoum wrote:
> Hello Greg,
> 
> On 25.10.22 10:12, Greg KH wrote:
> > On Tue, Oct 25, 2022 at 08:54:58AM +0200, Ahmad Fatoum wrote:
> >> Hi everybody,
> >>
> >> I am running v6.0.2 and can reliably trigger a use-after-free by allocating
> >> a USB gadget, binding it to the chipidea UDC and the removing the UDC.
> > 
> > How do you remove the UDC?
> 
> I originally saw this while doing reboot -f on the device. The imx_usb driver's
> shutdown handler is equivalent to the remove handler and that removes the UDC.

That's odd, why isn't the network device being shutdown first?  The tree
of devices should be walked in child-first order and tear it down
correctly.

> It could also be triggered with:
> 
>   echo ci_hdrc.0 > /sys/class/udc/ci_hdrc.0/device/driver/unbind

Yes, manual removal as root can cause problems as I said.  The code was
never designed to handle this.

> >> The network interface is not removed, but the chipidea SoC glue driver will
> >> remove the platform_device it had allocated in the probe, which is apparently
> >> the parent of the network device. When rtnl_fill_ifinfo runs, it will access the
> >> device parent's name for IFLA_PARENT_DEV_NAME, which is now freed memory.
> > 
> > The gadget removal logic is almost non-existant for most of the function
> > code.  See Lee's patch to try to fix up the f_hid.c driver last week as
> > one example.  I imagine they all have this same issue as no one has ever
> > tried the "remove the gadget device from the running Linux system"
> > before as it was not an expected use case.
> 
> I see.
> 
> FTR: https://lore.kernel.org/all/20221017112737.230772-1-lee@kernel.org/
>  
> > Is this now an expected use case of the kernel?  If so, patches are
> > welcome to address this in all gadget drivers.
> 
> I don't really care for unbinding via sysfs. I want to avoid the
> use-after-free on reboot/shutdown. See the last splat in my original mail.

Maybe try to figure out what is tearing down the bus's devices in the
incorrect order?

thanks,

greg k-h
