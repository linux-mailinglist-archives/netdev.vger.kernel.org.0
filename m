Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B21D9E1C
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgESRpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESRpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 13:45:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42ABE20708;
        Tue, 19 May 2020 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589910301;
        bh=dk0GMnKwHWHD8WPCX9zD8aKuiqpSbLozIhxzMKjU+jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nE3SLYSdp/G+yES8T1xHLddtRbdGhNfyBn3l0/Bv2Bov5OpjQYTOJkSazMSkWS39C
         fA9HQMjc8p0pYeJ8AgxD8aAMZtgFtxYCEvC1BGJH8dfidtimDtcU405ez9u+d6Pbop
         2b5CjVbQsAtZZj/nHE2dfXiCj6OsGj+Pwh2MLVq0=
Date:   Tue, 19 May 2020 10:44:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519104459.56a9dff2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519052400.GB4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200518110152.GB2193@nanopsycho>
        <20200518164309.2065f489@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200519052400.GB4655@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 07:24:00 +0200 Jiri Pirko wrote:
> Tue, May 19, 2020 at 01:43:09AM CEST, kuba@kernel.org wrote:
> >On Mon, 18 May 2020 13:01:52 +0200 Jiri Pirko wrote:  
> >> Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:  
> >> >This patchset adds support for a "enable_hot_fw_reset" generic devlink
> >> >parameter and use it in bnxt_en driver.
> >> >
> >> >Also, firmware spec. is updated to 1.10.1.40.    
> >> 
> >> Hi.
> >> 
> >> We've been discussing this internally for some time.
> >> I don't like to use params for this purpose.
> >> We already have "devlink dev flash" and "devlink dev reload" commands.
> >> Combination of these two with appropriate attributes should provide what
> >> you want. The "param" you are introducing is related to either "flash"
> >> or "reload", so I don't think it is good to have separate param, when we
> >> can extend the command attributes.
> >> 
> >> How does flash&reload work for mlxsw now:
> >> 
> >> # devlink flash
> >> Now new version is pending, old FW is running
> >> # devlink reload
> >> Driver resets the device, new FW is loaded
> >> 
> >> I propose to extend reload like this:
> >> 
> >>  devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
> >>    driver-default - means one of following to, according to what is
> >>                     default for the driver
> >>    fw-reset - does FW reset and driver entities re-instantiation
> >>    driver-only - does driver entities re-instantiation only
> >>    fw-live-patch - does only FW live patching - no effect on kernel
> >> 
> >> Could be an enum or bitfield. Does not matter. The point is to use
> >> reload with attribute to achieve what user wants. In your usecase, user
> >> would do:
> >> 
> >> # devlink flash
> >> # devlink reload level fw-live-patch  
> >
> >Unfortunately for SmartNICs and MultiHost systems the reset may not be
> >initiated locally. I agree it'd be great to have a normal netlink knob  
> 
> I don't follow. Locally initiated or not, why what I suggested is not
> enough to cover that?

Hopefully clear now after Michael's explanation :)

> >for this instead of a param. But it has to be some form of a policy of
> >allowing the reset to happen, rather than an action/trigger kind of
> >thing.  
> 
> The "host" allows to reset himself by the "smartnic", right? For that, I
> can imagine a param. But that is not the case of this patchset.
> 
> >Also user space notification should be generated when reset happens,
> >IMO. devlink dev info contents will likely change after reset, if
> >nothing else.  
> 
> I agree.
> 
> >Plus this functionality will need proper documentation.  
> 
> Also agreed.
> 
> >FWIW - I am unconvinced that applications will be happy to experience
> >network black outs, rather than being fully killed and re-spawned. For
> >a micro-service worker shutdown + re-spawn should be bread and butter.
> >But we already have ionic doing this, so seems like vendors are
> >convinced otherwise, so a common interface is probably a good step.  
> 
> Hmm, not sure I follow what you mean by this para in context of this
> patchset. Could you please explain? Thanks!

I'm saying I'm dubious users will actually enable the async remote
reset.
