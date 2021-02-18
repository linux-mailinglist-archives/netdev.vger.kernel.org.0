Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0DB31E726
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 08:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhBRH5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 02:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231265AbhBRHxf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 02:53:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 177BF64DE9;
        Thu, 18 Feb 2021 07:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613634760;
        bh=rLN+7DPINUiBgTQ4NfBgonhFTc+9821s3j0bzu1XLlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oA31Cx1Y92D9jR6pfPwYTuyJImrLHb/9sCwF8VVeRoXSazC+ap56YgvGMTexUxG02
         DiMEDpMWG+2/O5AU8QMdJPzcGIO7Fedtheb0AET04sArdWactZqNT4ddNp/U9DlukF
         /4uShqyyi7OUsjWvqQMu+rAh2j/yPltkaJOuTB2U=
Date:   Thu, 18 Feb 2021 08:52:37 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: Re: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Message-ID: <YC4cxfhaBTD1Mb+2@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-2-mike.ximing.chen@intel.com>
 <BYAPR11MB309511566DBD522FE70D971FD9859@BYAPR11MB3095.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB309511566DBD522FE70D971FD9859@BYAPR11MB3095.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 07:34:31AM +0000, Chen, Mike Ximing wrote:
> 
> 
> > -----Original Message-----
> > From: Mike Ximing Chen <mike.ximing.chen@intel.com>
> > Sent: Wednesday, February 10, 2021 12:54 PM
> > To: netdev@vger.kernel.org
> > Cc: davem@davemloft.net; kuba@kernel.org; arnd@arndb.de;
> > gregkh@linuxfoundation.org; Williams, Dan J <dan.j.williams@intel.com>; pierre-
> > louis.bossart@linux.intel.com; Gage Eads <gage.eads@intel.com>
> > Subject: [PATCH v10 01/20] dlb: add skeleton for DLB driver
> > 
> > diff --git a/Documentation/misc-devices/dlb.rst b/Documentation/misc-
> > devices/dlb.rst
> > new file mode 100644
> > index 000000000000..aa79be07ee49
> > --- /dev/null
> > +++ b/Documentation/misc-devices/dlb.rst
> > @@ -0,0 +1,259 @@
> > +.. SPDX-License-Identifier: GPL-2.0-only
> > +
> > +===========================================
> > +Intel(R) Dynamic Load Balancer Overview
> > +===========================================
> > +
> > +:Authors: Gage Eads and Mike Ximing Chen
> > +
> > +Contents
> > +========
> > +
> > +- Introduction
> > +- Scheduling
> > +- Queue Entry
> > +- Port
> > +- Queue
> > +- Credits
> > +- Scheduling Domain
> > +- Interrupts
> > +- Power Management
> > +- User Interface
> > +- Reset
> > +
> > +Introduction
> > +============
> > +
> > +The Intel(r) Dynamic Load Balancer (Intel(r) DLB) is a PCIe device that
> > +provides load-balanced, prioritized scheduling of core-to-core communication.
> > +
> > +Intel DLB is an accelerator for the event-driven programming model of
> > +DPDK's Event Device Library[2]. The library is used in packet processing
> > +pipelines that arrange for multi-core scalability, dynamic load-balancing, and
> > +variety of packet distribution and synchronization schemes.
> > +
> > +Intel DLB device consists of queues and arbiters that connect producer
> > +cores and consumer cores. The device implements load-balanced queueing
> > features
> > +including:
> > +- Lock-free multi-producer/multi-consumer operation.
> > +- Multiple priority levels for varying traffic types.
> > +- 'Direct' traffic (i.e. multi-producer/single-consumer)
> > +- Simple unordered load-balanced distribution.
> > +- Atomic lock free load balancing across multiple consumers.
> > +- Queue element reordering feature allowing ordered load-balanced distribution.
> > +
> 
> Hi Jakub/Dave,
> This is a device driver for a HW core-to-core communication accelerator. It is submitted 
> to "linux-kernel" for a module under device/misc. Greg suggested (see below) that we
> also sent it to you for any potential feedback in case there is any interaction with
> networking initiatives. The device is used to handle the load balancing among CPU cores
> after the packets are received and forwarded to CPU. We don't think it interferes
> with networking operations, but would appreciate very much your review/comment on this.

It's the middle of the merge window, getting maintainers to review new
stuff until after 5.12-rc1 is out is going to be a very difficult thing
to do.

In the meantime, why don't you all help out and review submitted patches
to the mailing lists for the subsystems you all are trying to get this
patch into.  I know maintainers would appreciate the help, right?

thanks,

greg k-h
