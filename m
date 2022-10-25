Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC6860C620
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiJYIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiJYIMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:12:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35739B0B3C;
        Tue, 25 Oct 2022 01:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CE6617D6;
        Tue, 25 Oct 2022 08:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17F7C433C1;
        Tue, 25 Oct 2022 08:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666685521;
        bh=gMsCH3ELlaFlgvNUjLvXvIZQvPnywfBULPebjIz2Rl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E1ZGx/dyYZ3aW0NpboOcAMvVogBq9MSvGCAaw08dTZ0fCOR/9WBcY7W6NWNxC4VZx
         j0YFezhnSq048QFFHRMf0bfVO5NWyyFJp3BeqS5P0zdHMKK+GeunUuLCYW8ScgzU1Q
         P0Ec1xhRblD3awaUr4b+fTRr9x5PPIg6/1DgRipk=
Date:   Tue, 25 Oct 2022 10:12:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@kernel.org>,
        Felipe Balbi <balbi@kernel.org>, johannes.berg@intel.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Subject: Re: [BUG] use-after-free after removing UDC with USB Ethernet gadget
Message-ID: <Y1eahQ66OcpsECNf@kroah.com>
References: <fd36057a-e8d9-38a3-4116-db3f674ea5af@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd36057a-e8d9-38a3-4116-db3f674ea5af@pengutronix.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 08:54:58AM +0200, Ahmad Fatoum wrote:
> Hi everybody,
> 
> I am running v6.0.2 and can reliably trigger a use-after-free by allocating
> a USB gadget, binding it to the chipidea UDC and the removing the UDC.

How do you remove the UDC?

> The network interface is not removed, but the chipidea SoC glue driver will
> remove the platform_device it had allocated in the probe, which is apparently
> the parent of the network device. When rtnl_fill_ifinfo runs, it will access the
> device parent's name for IFLA_PARENT_DEV_NAME, which is now freed memory.

The gadget removal logic is almost non-existant for most of the function
code.  See Lee's patch to try to fix up the f_hid.c driver last week as
one example.  I imagine they all have this same issue as no one has ever
tried the "remove the gadget device from the running Linux system"
before as it was not an expected use case.

Is this now an expected use case of the kernel?  If so, patches are
welcome to address this in all gadget drivers.

thanks,

greg k-h
