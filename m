Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28873387E64
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351125AbhERRcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346293AbhERRcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 13:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9137A611AC;
        Tue, 18 May 2021 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621359058;
        bh=7Dy8zzNY+4sKyTL/Ac1KDNwYiAMPfo+uyZSJmDyblX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Is5+vcRYsFcPMbPhcgeJ5G5ILv4eEZZ9SYhvB+dFYIwxzqVlQ4QKpEnf64jmSQTvA
         dggXD2F33Aock/vfUWjHcRSXYISpBA4r/7Og37K/I1mdvKT8fvr9oXbqVMQl1Lw+5V
         3wcRPCBoPkug5UTg9YomWuKsz0V+eJ9SmyxKwDVPq7QLp023fSOPOBXlIhxu+n1Qoo
         G9slCDQjqjo2RW7X+jaRx0hGtSiBwhmTFSTOFZiKez+kB4IU4XeMJaPqmrGZyKXwiB
         0F0TdI8g99gEgwAlBjlqLUX7ua3Jd57E9pYPFTqybzLVPBEd6BIr/RAk0l103ryfl4
         c8zgFedTfSNiw==
Date:   Tue, 18 May 2021 10:30:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <michael.chan@broadcom.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <f.fainelli@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <ariela@nvidia.com>
Subject: Re: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
Message-ID: <20210518103056.4e8a8a6f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <b5bb362e-a430-2cc8-291e-b407e306fd49@huawei.com>
References: <20210415225318.2726095-1-kuba@kernel.org>
        <b5bb362e-a430-2cc8-291e-b407e306fd49@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 May 2021 14:48:13 +0800 huangguangbin (A) wrote:
> On 2021/4/16 6:53, Jakub Kicinski wrote:
> > This set adds uAPI for reporting standard FEC statistics, and
> > implements it in a handful of drivers.
> > 
> > The statistics are taken from the IEEE standard, with one
> > extra seemingly popular but not standard statistics added.
> > 
> > The implementation is similar to that of the pause frame
> > statistics, user requests the stats by setting a bit
> > (ETHTOOL_FLAG_STATS) in the common ethtool header of
> > ETHTOOL_MSG_FEC_GET.
> > 
> > Since standard defines the statistics per lane what's
> > reported is both total and per-lane counters:
> > 
> >   # ethtool -I --show-fec eth0
> >   FEC parameters for eth0:
> >   Configured FEC encodings: None
> >   Active FEC encoding: None
> >   Statistics:
> >    corrected_blocks: 256
> >      Lane 0: 255
> >      Lane 1: 1
> >    uncorrectable_blocks: 145
> >      Lane 0: 128
> >      Lane 1: 17
> 
> Hi, I have a doubt that why active FEC encoding is None here? 
> Should it actually be BaseR or RS if FEC statistics are reported?

Hi! Good point. The values in the example are collected from a netdevsim
based mock up which I used for testing the interface, not real hardware.
In reality seeing None and corrected/uncorrectable blocks is not valid.
That said please keep in mind that the statistics should not be reset
when settings are changed, so OFF + stats may happen.
