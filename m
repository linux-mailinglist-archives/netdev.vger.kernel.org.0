Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7576449E0
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiLFRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiLFRCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:02:19 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5042928E11
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 09:02:18 -0800 (PST)
Received: from quatroqueijos.cascardo.eti.br (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 4C6C2423FA;
        Tue,  6 Dec 2022 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670346136;
        bh=t5ZTI+98t3tAEd/ZGbRGAp2frX9gFQQIE82itS5fp9k=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=Va8F9E4qZJUTf0xFCHxkY6kxdXaSWRQL7dW5O+F6ORT7NRpxdEUMDHDAQKm7wqp0Y
         9EdptXKR7Z/zbOw8bpffGj/DAc0zeibxVmp+nfU4dooq8gLvVCGYyLNeNvl+OEDSN3
         uL+BsyP1nY8O9u4FPXWxmge9V+rjAu/DUxqwREr1HHaP53x378fAcWbD9cxXzWUhmd
         gV7HQzj8K4YNq7483z3ANpICTDRD2oYLsyux2wHY0KM2XEJg/WGehnq3KWZmyqJZHN
         VyTtx4mVpQJbJD8n2+DvuvQbpg1lZI1g8oNmtG1DBi+3NsnB0NQvSdPLrF4km1RdT5
         yIWoYrgpmqHUA==
Date:   Tue, 6 Dec 2022 14:02:09 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Douglas Miller <dougmill@linux.ibm.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, kernel@pengutronix.de,
        gpiccoli@igalia.com
Subject: Re: Strangeness in ehea network driver's shutdown
Message-ID: <Y491kVZdw2lLB3yU@quatroqueijos.cascardo.eti.br>
References: <20221001143131.6ondbff4r7ygokf2@pengutronix.de>
 <20221003093606.75a78f22@kernel.org>
 <CALJn8nN-5DZZkwrJurtT2NOUXGdEQa-aQt+MHvsii2oC_w5+FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALJn8nN-5DZZkwrJurtT2NOUXGdEQa-aQt+MHvsii2oC_w5+FA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 01:49:01PM -0300, Guilherme G. Piccoli wrote:
> On Mon, Oct 3, 2022 at 1:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sat, 1 Oct 2022 16:31:31 +0200 Uwe Kleine-König wrote:
> > > Hello,
> > >
> > > while doing some cleanup I stumbled over a problem in the ehea network
> > > driver.
> > >
> > > In the driver's probe function (ehea_probe_adapter() via
> > > ehea_register_memory_hooks()) a reboot notifier is registered. When this
> > > notifier is triggered (ehea_reboot_notifier()) it unregisters the
> > > driver. I'm unsure what is the order of the actions triggered by that.
> > > Maybe the driver is unregistered twice if there are two bound devices?

I see how you would think it might be called for every bound device. That's
because ehea_register_memory_hooks is called by ehea_probe_adapter. However,
there is this test here that leads it the reboot_notifier to be registered only
once:

[...]
static int ehea_register_memory_hooks(void)
{
	int ret = 0;

	if (atomic_inc_return(&ehea_memory_hooks_registered) > 1)
	^^^^^^^^^^^^^^^^^^^^^^
		return 0;
[...]


> > > Or the reboot notifier is called under a lock and unregistering the
> > > driver (and so the devices) tries to unregister the notifier that is
> > > currently locked and so results in a deadlock? Maybe Greg or Rafael can
> > > tell about the details here?
> > >
> > > Whatever the effect is, it's strange. It makes me wonder why it's
> > > necessary to free all the resources of the driver on reboot?! I don't

As for why:

commit 2a6f4e4983918b18fe5d3fb364afe33db7139870
Author: Jan-Bernd Themann <ossthema@de.ibm.com>
Date:   Fri Oct 26 14:37:28 2007 +0200

    ehea: add kexec support
    
    eHEA resources that are allocated via H_CALLs have a unique identifier each.
    These identifiers are necessary to free the resources. A reboot notifier
    is used to free all eHEA resources before the indentifiers get lost, i.e
    before kexec starts a new kernel.
    
    Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

> > > know anything about the specifics of the affected machines, but I guess
> > > doing just the necessary stuff on reboot would be easier to understand,
> > > quicker to execute and doesn't have such strange side effects.
> > >
> > > With my lack of knowledge about the machine, the best I can do is report
> > > my findings. So don't expect a patch or testing from my side.
> >
> > Last meaningful commit to this driver FWIW:
> >
> > commit 29ab5a3b94c87382da06db88e96119911d557293
> > Author: Guilherme G. Piccoli <kernel@gpiccoli.net>
> > Date:   Thu Nov 3 08:16:20 2016 -0200
> >
> > Also that's the last time we heard from Douglas AFAICT..
> 
> Hey folks, thanks for CCing me.
> 
> I've worked a bit with ehea some time ago, will need to dig up a bit
> to understand things again.
> But I'm cc'ing Cascardo - which have(/had?) a more deep knowledge on
> that - in the hopes he can discuss the issue without requiring that
> much study heh
> 
> Cheers,
> 
> 
> Guilherme
