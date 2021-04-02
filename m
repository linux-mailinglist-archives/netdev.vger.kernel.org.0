Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F208F352AD0
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhDBMuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234448AbhDBMuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 08:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4E9D6112F;
        Fri,  2 Apr 2021 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617367822;
        bh=2+BhoKtezNY/UCp9UYfsS2JcottO+J8/RbhvSq3TYUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WxA5LZi8F+4xciWdwX6M6nUr1+sDP8sFu7T/cPuZgIvNC416rQKtNOQ77tKeQmzWW
         EFeYbdi5nGGfMaso8GMTW/xocBSP49MFflVP07Tlzb2JvkkbrJhZmY74eSQVUG4fcV
         /itjI8q8fWXgkBhTCIaOXWjO7gTtdOt8Jg2AXtAA=
Date:   Fri, 2 Apr 2021 14:50:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next v6 1/2] net: Add a WWAN subsystem
Message-ID: <YGcTC+iUNWEtRXb+@kroah.com>
References: <1617187150-13727-1-git-send-email-loic.poulain@linaro.org>
 <YGRSdQxTuxIy0Qsc@kroah.com>
 <CAMZdPi-f4wDiFSuib5h17SaFWgORv8q7jKdh8fS_C=iihc0a_A@mail.gmail.com>
 <YGSNFS5wl13L4OoU@kroah.com>
 <CAMZdPi8LkEw=6zTBaW-HBjYxWGNw+_uqq6fb_vG1BfD+UjTwig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi8LkEw=6zTBaW-HBjYxWGNw+_uqq6fb_vG1BfD+UjTwig@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 05:30:50PM +0200, Loic Poulain wrote:
> > As it is, the code you have here just implements the misc device layer,
> > but with a new major number?  why???
> 
> Right, Instead of creating yet another specific character driver for
> WWAN (like usb wdm_class), the goal would be to have at least the WWAN
> control ports being exposed the same way via this WWAN class and cdev.
> Then extend the framework with additional features (e.g. ports ioctls,
> network interface attaching). I agree that for now, it's similar to
> what misc already doing.
> 
> From this discussion, I see two options:
> - Move fops implementation to WWAN core.
> - Simply get rid of this generic WWAN layer and just rely on misc for
> exposing the MHI WWAN control ports.

You can use misc, but how many of these are you going to want to have?

You still need a set of fops and handling of the device node in a common
place to ensure that all individual drivers that want to implement a
wwan protocol do it all identically.  You can not rely on the individual
drivers to do this, that's exactly what you are trying to prevent here.

So split this up by wwan type and handle that in the "core" you are
creating properly, and then have your hardware driver tie into that.
Just like all other common class api interfaces, nothing new here...

thanks,

greg k-h
