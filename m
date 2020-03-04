Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0010179761
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbgCDSAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgCDSAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:00:53 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D118124654;
        Wed,  4 Mar 2020 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583344852;
        bh=x0DTec6l/KCwAWoLLYoYuIcqS4JUXvomTN5zS9ORLks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o0qyK/Z94yl98KWmW7kQVjs3gQivluOXSt2Ih2VCbP8LwwdBakKsmfrP7FwKe7kyB
         JZp0zjMWr7OjElpsimumiJbUtBWuL/zeV8Poj/o8w5TcXN2vTGBkOjz5PODc7MSZJF
         cKcSMuDpCJub1FkzEdS+AMyiI2qhKAZ6gMRfY2q8=
Date:   Wed, 4 Mar 2020 10:00:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304075926.GH4264@unicorn.suse.cz>
References: <20200304043354.716290-1-kuba@kernel.org>
        <20200304043354.716290-2-kuba@kernel.org>
        <20200304075926.GH4264@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 08:59:26 +0100 Michal Kubecek wrote:
> Just an idea: perhaps we could use the fact that struct ethtool_coalesce
> is de facto an array so that this block could be replaced by a loop like
> 
> 	u32 supported_types = dev->ethtool_ops->coalesce_types;
> 	const u32 *values = &coalesce->rx_coalesce_usecs;
> 
> 	for (i = 0; i < __ETHTOOL_COALESCE_COUNT; i++)
> 		if (values[i] && !(supported_types & BIT(i)))
> 			return false;
> 
> and to be sure, BUILD_BUG_ON() or static_assert() check that the offset
> of ->rate_sample_interval matches ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL.

I kind of prefer the greppability over the saved 40 lines :(
But I'm happy to change if we get more votes for the more concise
version. Or perhaps the Intel version with the warnings printed.

> > +	return !dev->ethtool_ops->coalesce_types ||
> > +		(dev->ethtool_ops->coalesce_types & used_types) == used_types;
> > +}  
> 
> I suggest to move the check for !dev->ethtool_ops->coalesce_types to the
> beginning of the function so that we avoid calculating the bitmap if we
> are not going to check it anyway.

Good point!
