Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994323EBBFB
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhHMSXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232896AbhHMSXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 14:23:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 278ED610E9;
        Fri, 13 Aug 2021 18:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628878993;
        bh=K+8lCjdgCzXbQJRTO6yoemzq4tEKbTjja5xnsAKAp/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B6RKmydXekNqgEXS9joVMCyxJoi5O3H2kRy6I/efVueVmHim7FLlzwDzF/S1v3YeK
         RrHnADnEKBN6WDJY3/36Pb7owYwOZVRmbixHs2mnm7jhwHt525r7t9B5hhXcfrkR5a
         WaEmjiUnaVPVn44Di544601d4RKiXbcmWXD/GjggzMerzHP4sod3bM+8MIr1op3CWp
         ejEhGI+UT+SoUi9Q/9LiNU1aVofM577wWo5ASnG1jyNqWxsT8yMJh9+TJvD92AvOiZ
         OdNO02phswFu4AJlPR6ZS2WRVPCSd6/3xOMR75DGcrmG91nHmnfz9cBOMG9+cRRGRj
         I84jh93+mABFQ==
Date:   Fri, 13 Aug 2021 11:23:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@lists.01.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 4/7] ptp_pch: Switch to use
 module_pci_driver() macro
Message-ID: <20210813112312.62f4ac42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRaSIp4ViWvMrCoP@smile.fi.intel.com>
References: <20210813122932.46152-4-andriy.shevchenko@linux.intel.com>
        <202108132237.jJSESPou-lkp@intel.com>
        <YRaMEfTvOCsi40Je@smile.fi.intel.com>
        <YRaSIp4ViWvMrCoP@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 18:39:14 +0300 Andy Shevchenko wrote:
> On Fri, Aug 13, 2021 at 06:13:21PM +0300, Andy Shevchenko wrote:
> > On Fri, Aug 13, 2021 at 10:34:17PM +0800, kernel test robot wrote:  
> > > Hi Andy,
> > > 
> > > I love your patch! Yet something to improve:
> > > 
> > > [auto build test ERROR on net-next/master]
> > > 
> > > url:    https://github.com/0day-ci/linux/commits/Andy-Shevchenko/ptp_pch-use-mac_pton/20210813-203135
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b769cf44ed55f4b277b89cf53df6092f0c9082d0
> > > config: nios2-randconfig-r023-20210813 (attached as .config)
> > > compiler: nios2-linux-gcc (GCC) 11.2.0
> > > reproduce (this is a W=1 build):
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # https://github.com/0day-ci/linux/commit/6c1fff5c80fe8f1a12c20bac2d28ebfa5960bde7
> > >         git remote add linux-review https://github.com/0day-ci/linux
> > >         git fetch --no-tags linux-review Andy-Shevchenko/ptp_pch-use-mac_pton/20210813-203135
> > >         git checkout 6c1fff5c80fe8f1a12c20bac2d28ebfa5960bde7
> > >         # save the attached .config to linux build tree
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=nios2 
> > > 
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>  
> > 
> > Thanks!
> > 
> > Definitely I have compiled it in my local branch. I'll check what is the root
> > cause of this.  
> 
> Kconfig misses PCI dependency. I will send a separate patch, there is nothing
> to do here.

That patch has to be before this one, tho. There is a static inline
stub for pci_register_driver() etc. if !PCI, but there isn't for
module_pci_driver(), meaning in builds without PCI this driver used 
to be harmlessly pointless, now it's breaking build.

Am I missing something?

Adding Bjorn in case he has a preference on adding the dependency vs
stubbing out module_pci_driver().
