Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878E14EC7A6
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347689AbiC3PAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244697AbiC3PAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:00:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8976434;
        Wed, 30 Mar 2022 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648652335; x=1680188335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LGbzP3xToIyBP1rsfYxryrKuymJX1Ma/5d6WvH8bQgg=;
  b=ltR2Hb3UzFADOEWfsrf8Wvr//Fuf9Dcidst4Ozfi0iRCjQG4bP64GxKY
   JmNjJEQrnDNQrLOkJv5AUFAuj6IZdyER0qLZe5m9uZsYLZWzEf/PM60ae
   wU4BYaU28zMTNJmrWGfg+MXxABGlyVp1chHq+9vN/T+TzEYUBzt3tt6Iw
   p30HWtRGSaNLviqj+vbG9chzYNuAUpDeM23YRAp8sfS7tK0QbUmx0Ysp4
   /9jTHucDfKAU5/+fDI1H03vYM6vA8+0O7JdeUEcb8R2f7zWYQG7v2zrAD
   XTwRXx3gzIJJaUIpecYMpyGO50W3H4eu2ubqjWZdGRRjrWtSzGxGD8NNi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="241717829"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="241717829"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 07:58:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="565574065"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.135])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2022 07:58:50 -0700
Date:   Wed, 30 Mar 2022 22:51:37 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Michael Walle <michael@walle.cc>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
Message-ID: <20220330145137.GA214615@yilunxu-OptiPlex-7050>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <20220330065047.GA212503@yilunxu-OptiPlex-7050>
 <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029cf18c9df4fab96af13c857d2e0ef@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 10:11:39AM +0000, David Laight wrote:
> From: Xu Yilun
> > Sent: 30 March 2022 07:51
> > 
> > On Tue, Mar 29, 2022 at 06:07:26PM +0200, Michael Walle wrote:
> > > More and more drivers will check for bad characters in the hwmon name
> > > and all are using the same code snippet. Consolidate that code by adding
> > > a new hwmon_sanitize_name() function.
> > >
> > > Signed-off-by: Michael Walle <michael@walle.cc>
> > > ---
> > >  Documentation/hwmon/hwmon-kernel-api.rst |  9 ++++-
> > >  drivers/hwmon/hwmon.c                    | 49 ++++++++++++++++++++++++
> > >  include/linux/hwmon.h                    |  3 ++
> > >  3 files changed, 60 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
> > > index c41eb6108103..12f4a9bcef04 100644
> > > --- a/Documentation/hwmon/hwmon-kernel-api.rst
> > > +++ b/Documentation/hwmon/hwmon-kernel-api.rst
> > > @@ -50,6 +50,10 @@ register/unregister functions::
> > >
> > >    void devm_hwmon_device_unregister(struct device *dev);
> > >
> > > +  char *hwmon_sanitize_name(const char *name);
> > > +
> > > +  char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
> > > +
> > >  hwmon_device_register_with_groups registers a hardware monitoring device.
> > >  The first parameter of this function is a pointer to the parent device.
> > >  The name parameter is a pointer to the hwmon device name. The registration
> > > @@ -93,7 +97,10 @@ removal would be too late.
> > >
> > >  All supported hwmon device registration functions only accept valid device
> > >  names. Device names including invalid characters (whitespace, '*', or '-')
> > > -will be rejected. The 'name' parameter is mandatory.
> > > +will be rejected. The 'name' parameter is mandatory. Before calling a
> > > +register function you should either use hwmon_sanitize_name or
> > > +devm_hwmon_sanitize_name to replace any invalid characters with an
> > 
> > I suggest                   to duplicate the name and replace ...
> 
> You are now going to get code that passed in NULL when the kmalloc() fails.
> If 'sanitizing' the name is the correct thing to do then sanitize it
> when the copy is made into the allocated structure.

Then the driver is unaware of the name change, which makes more
confusing.

> (I'm assuming that the 'const char *name' parameter doesn't have to
> be persistent - that would be another bug just waiting to happen.)

The hwmon core does require a persistent "name" parameter now. No name
copy is made when hwmon dev register.

> 
> Seems really pointless to be do a kmalloc() just to pass a string
> into a function.

Maybe we should not force a kmalloc() when the sanitizing is needed, let
the driver decide whether to duplicate the string or not.

Thanks,
Yilun

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
