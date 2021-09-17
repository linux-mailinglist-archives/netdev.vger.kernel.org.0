Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01808410090
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344122AbhIQVH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235643AbhIQVHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 17:07:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B2F61074;
        Fri, 17 Sep 2021 21:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631912793;
        bh=P3c41VOJZ6JDSdnd/x8fHbM/jl7Yj8P3ntHUiUoXEz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WuautOl1pX6YeK1UTe4ov2U1xZq94tqM+Lw0jODGuLbT4GOzMaphH16YrpcAt9ROw
         Kov95yuv4OPqts2keL3F46oXS1YSVXrFYMYCRJNgtyFOmCwkXpa5VwPjwBf1Lq35Jt
         fcHW4ey/a13H5nYrsJ3KBVuaOdy+6KGVi55f+avezkjoCzLEvXIDcnSxkUzcL4Nx57
         Ty7yWL/RrqX4MKrdmcHUs74NYdbMXtjuUF4pzY/9dI+AiY1fIFbiiR/nnDi/Q2ci0A
         20dV6b0hvI0Pzd9qd0dOjPp6nOYiADkytkqj3r5fqTf+i9zQ5JYZeznpmolhJhQKKp
         sz2dNpzeqw+5A==
Date:   Fri, 17 Sep 2021 14:06:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
        <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
        <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 20:19:08 +0000 Min Li wrote:
> >   
> > > @@ -29,6 +29,14 @@ module_param(phase_snap_threshold, uint, 0);
> > > MODULE_PARM_DESC(phase_snap_threshold,
> > >  "threshold (1000ns by default) below which adjtime would ignore");
> > >
> > > +static bool delayed_accurate_adjtime = false;
> > > +module_param(delayed_accurate_adjtime, bool, false);
> > > +MODULE_PARM_DESC(delayed_accurate_adjtime,
> > > +"set to true to use more accurate adjtime that is delayed to next
> > > +1PPS signal");  
> > 
> > Module parameters are discouraged. If you have multiple devices on the
> > system module parameters don't allow setting different options depending
> > on device. Unless Richard or someone else suggests a better API for this
> > please use something like devlink params instead (and remember to
> > document them).
> >   
> > > +static char *firmware;
> > > +module_param(firmware, charp, 0);  
> 
> Yes, this was suggested by Richard back then

  > On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
  > > How would you suggest to implement the change that make the new driver behavior optional?
  > I would say, module parameter or debugfs knob.

Aright, in which case devlink or debugfs, please.

> > What's the point of this? Just rename the file in the filesystem.  
> 
> We use this parameter to specify firmware so that module can be autoloaded
> /etc/modprobe.d/modname.conf

Sorry, I don't understand. The firmware is in /lib/firmware.
Previously you used a card coded name (whatever FW_FILENAME
is, "idt82p33xxx.bin"?). This patch adds the ability to change 
the firmware file name by a module param.

Now let me repeat the question - what's the point of user changing
the requested firmware name if they can simply rename the file?
