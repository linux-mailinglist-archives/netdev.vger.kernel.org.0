Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA54179867
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbgCDSvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:51:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:13652 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgCDSvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:51:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 10:50:57 -0800
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="240551018"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 10:50:57 -0800
Message-ID: <443c085ff3bcc06ad15c34f44f0407a0861dadeb.camel@linux.intel.com>
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 04 Mar 2020 10:50:57 -0800
In-Reply-To: <20200304102705.192d3b0a@kicinski-fedora-PC1C0HJN>
References: <20200304043354.716290-1-kuba@kernel.org>
         <20200304043354.716290-2-kuba@kernel.org>
         <20200304075926.GH4264@unicorn.suse.cz>
         <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
         <45b3c493c3ce4aa79f882a8170f3420d348bb61e.camel@linux.intel.com>
         <20200304102705.192d3b0a@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-04 at 10:27 -0800, Jakub Kicinski wrote:
> On Wed, 04 Mar 2020 10:12:30 -0800 Alexander Duyck wrote:
> > On Wed, 2020-03-04 at 10:00 -0800, Jakub Kicinski wrote:
> > > On Wed, 4 Mar 2020 08:59:26 +0100 Michal Kubecek wrote:  
> > > > Just an idea: perhaps we could use the fact that struct ethtool_coalesce
> > > > is de facto an array so that this block could be replaced by a loop like
> > > > 
> > > > 	u32 supported_types = dev->ethtool_ops->coalesce_types;
> > > > 	const u32 *values = &coalesce->rx_coalesce_usecs;
> > > > 
> > > > 	for (i = 0; i < __ETHTOOL_COALESCE_COUNT; i++)
> > > > 		if (values[i] && !(supported_types & BIT(i)))
> > > > 			return false;
> > > > 
> > > > and to be sure, BUILD_BUG_ON() or static_assert() check that the offset
> > > > of ->rate_sample_interval matches ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL.  
> > > 
> > > I kind of prefer the greppability over the saved 40 lines :(
> > > But I'm happy to change if we get more votes for the more concise
> > > version. Or perhaps the Intel version with the warnings printed.  
> > 
> > I agree that it would make more sense to replace the types with an enum
> > definition, and then use the enum to define bits to be used by the
> > drivers.
> 
> The only use for the enum would then be to automate the bit assignment?
> Sounds like we would save some lines for the code and added some for
> the definition. Maybe I'm missing the advantage the enum brings 🤔

Well if you wanted to you could probably also update ethtool_coalesce to
support a unioned __u32 array if you wanted to be more explicit about it. 

I just figured that by making in an enum it becomes less error prone since
you can't accidentally leave a gap or end up renumbering things
unintentionally. Combine that with some logic to take care of the bit
shifting and it wouldn't differ much from how we handle the netdev feature
flags and the like.

> > > > > +	return !dev->ethtool_ops->coalesce_types ||
> > > > > +		(dev->ethtool_ops->coalesce_types & used_types) == used_types;
> > > > > +}    
> > > > 
> > > > I suggest to move the check for !dev->ethtool_ops->coalesce_types to the
> > > > beginning of the function so that we avoid calculating the bitmap if we
> > > > are not going to check it anyway.  
> > > 
> > > Good point!  
> > 
> > So one thing I just wanted to point out. The used_types won't necessarily
> > be correct because it is only actually checking for non-zero types. There
> > are some of these values where a zero is a valid input and the driver will
> > accept it, such as rx_coalesce_usecs for ixgbe. As such we might want to
> > rename the value to nonzero_types instead of used_types.
> 
> Okay, I'll rename. I was also wondering if it should be "params" not
> "types". Initially I was hoping there are categories of coalescing that
> drivers implement, each with set of params. But it seems each vendor is
> just picking fields they like. I think I'll do s/types/params/ as well.

Makes sense to me.

