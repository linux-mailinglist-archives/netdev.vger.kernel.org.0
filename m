Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68A817979A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbgCDSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgCDSLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:11:14 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCB5E2166E;
        Wed,  4 Mar 2020 18:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583345473;
        bh=6pWCVbY+j1fGPLiJpPHKz0tzuXWz6It1jY3rbn74lsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U0ZhNnWar5QE38R5v22MqL5VF9pOHTXeaSvqS3S89g45AcMZzJeD9t9HbOYxO7ItS
         PL74B6DoQ++QhRFyOpHzcMcEopPXd1AVLV4EWU+Puiw+GFwIlBug0yGevxdX8xWrKp
         k+zP5MVVuKb1oe/gcn0Mr1lVRGWaAO6Rz1dsru1g=
Date:   Wed, 4 Mar 2020 10:11:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH net-next 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304101110.1272454d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304152249.GD3553@lunn.ch>
References: <20200304035501.628139-1-kuba@kernel.org>
        <20200304035501.628139-2-kuba@kernel.org>
        <20200304145439.GC3553@lunn.ch>
        <20200304151958.GI4264@unicorn.suse.cz>
        <20200304152249.GD3553@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 16:22:49 +0100 Andrew Lunn wrote:
> On Wed, Mar 04, 2020 at 04:19:58PM +0100, Michal Kubecek wrote:
> > On Wed, Mar 04, 2020 at 03:54:39PM +0100, Andrew Lunn wrote:  
> > > On Tue, Mar 03, 2020 at 07:54:50PM -0800, Jakub Kicinski wrote:  
> > > > @@ -2336,6 +2394,11 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
> > > >  			goto roll_back;
> > > >  		}
> > > >  
> > > > +		if (!ethtool_set_coalesce_supported(dev, &coalesce)) {
> > > > +			ret = -EINVAL;
> > > > +			goto roll_back;
> > > > +		}  
> > > 
> > > Hi Jakub
> > > 
> > > EOPNOTSUPP?   
> > 
> > Out of the 11 drivers patched in the rest of the series, 4 used
> > EOPNOTSUPP, 3 EINVAL and 4 just ignored unsupported parameters so there
> > doesn't seem to be a clear consensus. Personally I find EOPNOTSUPP more
> > appropriate but it's quite common that drivers return EINVAL for
> > parameters they don't understand or support.  
> 
> Hi Michel
> 
> Yes, as i looked through the later patches, it became clear there is
> no consensus. I personally prefer EOPNOTSUPP, but don't care too much.

Yeah, looking through the entire tree the tally seems to be:

EOPNOTSUPP  9
EINVAL      7
ENOTSUPP    2

I think EINVAL is traditionally the black box "can't do" for the stack.
But also - no strong feelings, I can switch to EOPNOTSUPP in v3.
