Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A473E7BA3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbhHJPE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241246AbhHJPE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 11:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E4E60F02;
        Tue, 10 Aug 2021 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628607845;
        bh=sNykzSjaSqUPIEKONEYDwBt3Ifzsb7c+/IK7dJ46EfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c347+/hpS6EKF7miPoO5MxBTjFj5/YQ1T080OIvM/23lsQLp13GSFp5R6zRWzEDII
         NlHHAk7fpTDFj5QM7DdtX8/rCn+edFrAbAMtv5VDfCDqP4OCVETpPDOES+WSdRNVMj
         4tlT2rdOVbWJ+Ch7qw3mHQXH/iFJWsHBEaw7hfl6QjfGHIaM3wZawp4HQIhg1Cur2o
         cMOioAgdO5l18kt6qIGNXLbFpHkjfTWBrOl+2va9MF10mRy20nnemd6xODaZ/zSC1G
         /Oj4Bnpox6X8JJuT/Ty/qLCYap/83YSwc70t2HeyuwvW017WJdyDlK+7c8iUv18cag
         2e7jeA953zqyw==
Date:   Tue, 10 Aug 2021 08:04:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tuo Li <islituo@gmail.com>
Cc:     sridhar.samudrala@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH] net: core: Fix possible null-pointer dereference in
 failover_slave_register()
Message-ID: <20210810080404.1d1ae0b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810091800.291272-1-islituo@gmail.com>
References: <20210810091800.291272-1-islituo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 02:18:00 -0700 Tuo Li wrote:
> The variable fops is checked in:
>   if (fops && fops->slave_pre_register &&
>     fops->slave_pre_register(slave_dev, failover_dev))
> 
> This indicates that it can be NULL.
> However, it is dereferenced when calling netdev_rx_handler_register():
>   err = netdev_rx_handler_register(slave_dev, fops->slave_handle_frame,
>                     failover_dev);
> 
> To fix this possible null-pointer dereference, check fops first, and if 
> it is NULL, assign -EINVAL to err.

The other fops checks look like defensive programming. I don't see
anywhere where fops would be cleared, and all callers pass it to
register().
