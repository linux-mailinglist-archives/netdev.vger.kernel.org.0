Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DCA1F61BA
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 08:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgFKG0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 02:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgFKG0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 02:26:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1254B207C3;
        Thu, 11 Jun 2020 06:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591856811;
        bh=0/pvtFISGXWR/yF7DaOfCvGCGI4UYkIET66t0WEuF/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wb4+Ay7mYfdyuww63fbICOkyEHGLxu6pD7ZnQR+qXTOgZcklh41O1JYlThBAGUXxR
         ArCTn8BFU6hNzvNt/tPAIrEHNGpoINlhldC5PNWcZPEGpJkDpdy8YADOWHnVKcn+cD
         THG3ryrd/Mkj/slsbY3ILY8y+FCD0e6X0H69+tW4=
Date:   Thu, 11 Jun 2020 08:26:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
Message-ID: <20200611062648.GA2529349@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com>
 <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
 <20200610133717.GB1906670@kroah.com>
 <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
 <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 01:23:56PM -0700, Joe Perches wrote:
> On Wed, 2020-06-10 at 12:49 -0700, Joe Perches wrote:
> > On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> > > Please work with the infrastructure we have, we have spent a lot of time
> > > and effort to make it uniform to make it easier for users and
> > > developers.
> > 
> > Not quite.
> > 
> > This lack of debug grouping by type has been a
> > _long_ standing issue with drivers.
> > 
> > > Don't regress and try to make driver-specific ways of doing
> > > things, that way lies madness...
> > 
> > It's not driver specific, it allows driver developers to
> > better isolate various debug states instead of keeping
> > lists of specific debug messages and enabling them
> > individually.
> 
> For instance, look at the homebrew content in
> drivers/gpu/drm/drm_print.c that does _not_ use
> dynamic_debug.
> 
> MODULE_PARM_DESC(debug, "Enable debug output, where each bit enables a debug category.\n"
> "\t\tBit 0 (0x01)  will enable CORE messages (drm core code)\n"
> "\t\tBit 1 (0x02)  will enable DRIVER messages (drm controller code)\n"
> "\t\tBit 2 (0x04)  will enable KMS messages (modesetting code)\n"
> "\t\tBit 3 (0x08)  will enable PRIME messages (prime code)\n"
> "\t\tBit 4 (0x10)  will enable ATOMIC messages (atomic code)\n"
> "\t\tBit 5 (0x20)  will enable VBL messages (vblank code)\n"
> "\t\tBit 7 (0x80)  will enable LEASE messages (leasing code)\n"
> "\t\tBit 8 (0x100) will enable DP messages (displayport code)");
> module_param_named(debug, __drm_debug, int, 0600);
> 
> void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
> 		 const char *format, ...)
> {
> 	struct va_format vaf;
> 	va_list args;
> 
> 	if (!drm_debug_enabled(category))
> 		return;
> 
> 

Ok, and will this proposal be able to handle stuff like this?  If not,
then it is yet another way for driver authors to think that they need to
come up with something unique to themselves. :(

greg k-h
