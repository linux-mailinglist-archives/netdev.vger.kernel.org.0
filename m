Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE8E43FD89
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJ2Nsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhJ2Nsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 09:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC0661100;
        Fri, 29 Oct 2021 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635515172;
        bh=3amabRN0J9EI2ey2xTBcHBAuO/FPePPq+Bws3o8xa/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hT/9stuCw2TBWC+WQlNMsEPUyDuT82VSj9AwkcURueLyoJuaYcaA/LjPKa1zwKoDv
         ix42QS26dAHMtYYOOW+KPlbU4KBHJ4mwNTa4WN43nPQRGSXhBZSUOiiU9gKDwSgKOe
         +mkIgEDaiAQI3yzkG89/QxYVbGCo4fR25ogeldYBYpjzss0+3muVH0cwlrrR/qedd5
         b/zUaEdNq7CClthfU5UjrVwT/0SN1WOnu5PP5IfqBFhBIFPdx26R24HnmhsQFUCPWI
         MN6uLQZuXQhZg7ydYVL8azE932lAQ+DpjxBDFhh0T2QZcy040jjMCMw87UHOWB20XF
         nUTmGWw3xJ8ig==
Date:   Fri, 29 Oct 2021 06:46:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211029064610.18daa788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211029121324.GT2744544@nvidia.com>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
        <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211028114503.GM2744544@nvidia.com>
        <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b573b01c-2cc9-4722-6289-f7b9e0a43e19@huawei.com>
        <20211029121324.GT2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Oct 2021 09:13:24 -0300 Jason Gunthorpe wrote:
> Jakub's path would be to test vlan_dev->reg_state != NETREG_REGISTERED
> in the work queue, but that feels pretty hacky to me as the main point
> of the UNREGISTERING state is to keep the object alive enough that
> those with outstanding gets can compelte their work and release the
> get. Leaving a wrecked object in UNREGISTERING is a bad design.

That or we should investigate if we could hold the ref for real_dev all
the way until vlan_dev_free().
