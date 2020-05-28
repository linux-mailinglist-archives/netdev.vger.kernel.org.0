Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BCF1E6A07
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406134AbgE1TFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406029AbgE1TFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 15:05:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5036A206A1;
        Thu, 28 May 2020 19:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590692753;
        bh=hmvasG3ZDen48P9C9jGsPayN9wwppV+tfA13dzrpO1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PyJpljNmnSkRf/pwWnd9Bk+nLbmETEHEWLrsItNZFcFsTZJ6rkwXgm4ycT5GQdvzB
         4TrdVOJbqxlfg2RyMNoAa9WE18FVHPnA4j03WsuikflB6UC6BHfnxYqhVizLoqXhqZ
         Jdc6JAzVWYVmtWRvn/U/41MJfLSWT0Kbx66ymnc4=
Date:   Thu, 28 May 2020 12:05:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Netdev <netdev@vger.kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200528120551.689251bf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAACQVJqs9=PJ5UBrW9R9UmVYX1jqkJvZWj3j6FmVB9S5mOn+mg@mail.gmail.com>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200524045335.GA22938@nanopsycho>
        <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
        <20200525172602.GA14161@nanopsycho>
        <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
        <20200526044727.GB14161@nanopsycho>
        <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
        <20200526134032.GD14161@nanopsycho>
        <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
        <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
        <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
        <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAACQVJqs9=PJ5UBrW9R9UmVYX1jqkJvZWj3j6FmVB9S5mOn+mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 07:20:00 +0530 Vasundhara Volam wrote:
> > > The permanent value should be the NVRAM value.  If the NVRAM value is
> > > false, the feature is always and unconditionally disabled.  If the
> > > permanent value is true, the feature will only be available when all
> > > loaded drivers indicate support for it and set the runtime value to
> > > true.  If an old driver is loaded afterwards, it wouldn't indicate
> > > support for this feature and it wouldn't set the runtime value to
> > > true.  So the feature will not be available until the old driver is
> > > unloaded or upgraded.  
> >
> > Setting this permanent value to false makes the FW's life easier?  
> 
> It just disables the feature.
> 
> > Otherwise why not always have it enabled and just depend on hosts
> > not opting in?  
> 
> We are providing permanent value as a flexibility to user. We can
> remove it, if it makes things easy and clear.

I'd think less knobs means less to understand for the user and less
to test for the vendor. If disabling the feature doesn't buy FW
anything then perhaps it can just serve the purpose of setting the
default?

> > > > > 3. Now enable the capability in the device and reboot for device to
> > > > > enable the capability. Firmware does not get reset just by setting the
> > > > > param to true.
> > > > >
> > > > > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> > > > > value true cmode permanent
> > > > >
> > > > > 4. After reboot, values of param.  
> > > >
> > > > Is the reboot required here?  
> > >
> > > In general, our new NVRAM permanent parameters will take effect after
> > > reset (or reboot).
> > >  
> > > > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > > > > pci/0000:3b:00.1:
> > > > >   name allow_fw_live_reset type generic
> > > > >     values:
> > > > >       cmode runtime value true  
> > > >
> > > > Why is runtime value true now?
> > > >  
> > >
> > > If the permanent (NVRAM) parameter is true, all loaded new drivers
> > > will indicate support for this feature and set the runtime value to
> > > true by default.  The runtime value would not be true if any loaded
> > > driver is too old or has set the runtime value to false.  
> >
> > Okay, the parameter has a bit of a dual role as it controls whether the
> > feature is available (false -> true transition requiring a reset/reboot)
> > and the default setting of the runtime parameter. Let's document that
> > more clearly.  
> Please look at the 3/4 patch for more documentation in the bnxt.rst
> file. We can add more documentation, if needed, in the bnxt.rst file.

Ack, I read that, but it wasn't nearly clear enough. The command
examples helped much more.  I think the doc should be expanded.
