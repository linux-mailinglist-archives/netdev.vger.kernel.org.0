Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14584333715
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhCJIN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:13:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhCJINf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 03:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B400F64FCE;
        Wed, 10 Mar 2021 08:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615364007;
        bh=7nUcNZr12utVPnw8WOSH71VwFcj/vspELHCKCeOftsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kspCqylVJqSTeOBQQfYHRbJdcAXl4qzRD/UnCQx6mtsBwKVprHIAeDANgYgyUkttx
         ukHd/K4uPaf6wkLHwYnbl6SJYELWVo+MF4aGmWaY0Jc72GGX3ojg7CU61igoeTcVCT
         pAtidaaNazquN7C1EzCWk7MLHVg+JigQXNk0b8A8=
Date:   Wed, 10 Mar 2021 09:13:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        Gage Eads <gage.eads@intel.com>
Subject: Re: [PATCH v10 03/20] dlb: add resource and device initialization
Message-ID: <YEh/pKVV36r2rbAr@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-4-mike.ximing.chen@intel.com>
 <YEc+uL3SSf/T+EuG@kroah.com>
 <BYAPR11MB3095C06792321F64E98394FCD9919@BYAPR11MB3095.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB3095C06792321F64E98394FCD9919@BYAPR11MB3095.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:33:24AM +0000, Chen, Mike Ximing wrote:
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > On Wed, Feb 10, 2021 at 11:54:06AM -0600, Mike Ximing Chen wrote:
> > > +
> > > +#include "dlb_bitmap.h"
> > > +
> > > +#define BITS_SET(x, val, mask)	(x = ((x) & ~(mask))     \
> > > +				 | (((val) << (mask##_LOC)) & (mask)))
> > > +#define BITS_GET(x, mask)       (((x) & (mask)) >> (mask##_LOC))
> > 
> > Why not use the built-in kernel functions for this?  Why are you
> > creating your own?
> >
> FIELD_GET(_mask, _val) and FIELD_PREP(_mask, _val) in include/linux/bitfield.h
> are similar to our BITS_GET() and BITS_SET().  However in our case, mask##_LOC
> is a known constant defined in dlb_regs.h,  so we don't need to use 
> _buildin_ffs(mask) to calculate the location of mask as FIELD_GET() and FIELD_PREP()
> do.  We can still use FIELD_GET and FIELD_PREP, but our macros are a little more 
> efficient. Would it be OK to keep them?

No, please use the kernel-wide proper functions, there's no need for
single tiny driver to be "special" in this regard.  If somehow the
in-kernel functions are not sufficient, it's always better to fix them
up than to go your own way here.

thanks,

greg k-h
