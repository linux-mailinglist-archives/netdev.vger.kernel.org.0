Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9A9C052C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfI0Mbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 08:31:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfI0Mbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 08:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=67uQjRp7UIoVD4AD7jLUw1E41dxig3YpSnh//L4Wb9A=; b=zaL2u/ti8JqKoTUoTgh1fLK8xH
        bOJN0g8ed+ocjQF4CUv8CMTCRoJcJbsYqhC/Ct+znJARwI44EAXrs71EcJjeieZ+2+km7kUop2Mrv
        oSe9WZr7QxzSMS6br39mKdN/EM75gPv+xGRGhmIHK3MwhsrrCrTCqfLyaPe6lN4ShWoo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDpPF-0001h5-FA; Fri, 27 Sep 2019 14:31:29 +0200
Date:   Fri, 27 Sep 2019 14:31:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net] devlink: Fix error handling in param and info_get
 dumpit cb
Message-ID: <20190927123129.GB25474@lunn.ch>
References: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20190926122726.GE1864@lunn.ch>
 <CAACQVJpgZz3Fb36=x_wPb+hAaXecHj6oVuUsD-GgEhz9yfRgKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJpgZz3Fb36=x_wPb+hAaXecHj6oVuUsD-GgEhz9yfRgKg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 10:28:36AM +0530, Vasundhara Volam wrote:
> On Thu, Sep 26, 2019 at 5:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Sep 26, 2019 at 03:05:54PM +0530, Vasundhara Volam wrote:
> > > If any of the param or info_get op returns error, dumpit cb is
> > > skipping to dump remaining params or info_get ops for all the
> > > drivers.
> > >
> > > Instead skip only for the param/info_get op which returned error
> > > and continue to dump remaining information, except if the return
> > > code is EMSGSIZE.
> >
> > Hi Vasundhara
> >
> > How do we get to see something did fail? If it failed, it failed for a
> > reason, and we want to know.
> >
> > What is your real use case here? What is failing, and why are you
> > O.K. to skip this failure?
> >
> >      Andrew
> Hi Andrew,
> 
> Thank you for looking into the patch.
> 
> If any of the devlink parameter is returning error like EINVAL, then
> current code is not displaying any further parameters for all the other
> devices as well.
> 
> In bnxt_en driver case, some of the parameters are not supported in
> certain configurations like if the parameter is not part of the
> NVM configuration, driver returns EINVAL error to the stack. And devlink is
> skipping to display all the remaining parameters for that device and others
> as well.
> 
> I am trying to fix to skip only the error parameter and display the remaining
> parameters.

Hi Vasundhara

Thanks for explaining your use case. It sounds sensible. But i would
narrow this down.

Make the driver return EOPNOTSUP, not EINVAL. And then in dump, only
skip EOPNOTSUP. Any other errors cause the error to be returned, so we
get to see them.

   Andrew
