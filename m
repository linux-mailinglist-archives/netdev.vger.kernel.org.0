Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F382A4679EF
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245005AbhLCPHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 10:07:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40264 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhLCPHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 10:07:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5C1162BB8
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 15:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5424C53FAD;
        Fri,  3 Dec 2021 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638543851;
        bh=4PqwT0OgT0JYh7NmW2OTPuzDoIOV1auBIsRJvPa99GM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OmPvUscCv80F3FvI/y8W3pSaoxZE0pGm8YgZPwkv+qFIFEVFvihytiEhZzA2lRrPD
         A4QxSQJp98aqW5+hkJeqkGDn2lAk5f4tXM0MHs8VTihijzzROEGJyAqrCscKPY7UMI
         vYgvRmCauI1yYmE+YGixKrgSEYEsXQ3Z91c5BkoLnnVf86jd6F8Pu1E/K4nEHb3wdO
         Js7CoBbD07N3xxuu6TPO2U8Bq7taTf4RsuNV9Ye3IUo2cc3SA6G4UIogH8JrPhvVsR
         NzAuBLDrTqmIwsQ+U3pJJAMLD7dr5RBaWcDjYz52W2LFIv1Li8r2JNXiU2JCjRRZSO
         qFCseaj54mO2A==
Date:   Fri, 3 Dec 2021 07:04:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH 0/4] r8169: support dash
Message-ID: <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d3a1e1c469844aa697d6d315c9549eda@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
        <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
        <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d3a1e1c469844aa697d6d315c9549eda@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Dec 2021 07:57:08 +0000 Hayes Wang wrote:
> Jakub Kicinski <kuba@kernel.org>
> > I'm not sure how relevant it will be to you but this is the
> > documentation we have:
> > 
> > https://www.kernel.org/doc/html/latest/networking/devlink/index.html
> > https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.ht
> > ml
> > 
> > You'll need to add a generic parameter (define + a short description)
> > like 325e0d0aa683 ("devlink: Add 'enable_iwarp' generic device param")
> > 
> > In terms of driver changes I think the most relevant example to you
> > will be:
> > 
> > drivers/net/ethernet/ti/cpsw_new.c
> > 
> > You need to call devlink_alloc(), devlink_register and
> > devlink_params_register() (and the inverse functions).  
> 
> I have studied the devlink briefly.
> 
> However, I find some problems. First, our
> settings are dependent on the design of
> both the hardware and firmware. That is,
> I don't think the others need to do the
> settings as the same as us. The devlink
> seems to let everyone could use the same
> command to do the same setting. However,
> most of our settings are useless for the
> other devices.
> 
> Second, according to the design of our
> CMAC, the application has to read and
> write data with variable length from/to
> the firmware. Each custom has his own
> requests. Therefore, our customs would
> get different firmware with different
> behavior. Only the application and the
> firmware know how to communicate with
> each other. The driver only passes the
> data between them. Like the Ethernet
> driver, it doesn't need to know the
> contend of the packet. I could implement
> the CMAC through sysfs, but I don't
> know how to do by devlink.
> 
> In brief, CMAC is our major method to
> configure the firmware and get response
> from the firmware. Except for certain information,
> the other settings are not standard and useless
> for the other vendors.
> 
> Is the devlink the only method I could use?
> Actually, we use IOCTL now. We wish to
> convert it to sysfs for upstream driver.

Ah, I've only spotted the enable/disable knob in the patch. 
If you're exchanging arbitrary binary data with the FW we 
can't help you. It's not going to fly upstream.
