Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64E4295615
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437488AbgJVBbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410303AbgJVBbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 21:31:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F7DE223BF;
        Thu, 22 Oct 2020 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603330290;
        bh=mzM+YWYZ+OqK3m/NDl0bi1fKHmrtKC3r0lALcjITHe4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F1lX14H7pPAfojtDeTietNZW/Ud0+Ea61M2gIW5mpVN/XkvwYZEj/H5cVUt0iQjXG
         LkFH+KhxjTip/79iChytEmN8SvWNMt7tlXG+JlJhzJtK9TFkcXxEvDOQAA6G6r3YQX
         Y9v/J4g9Qmn+aPvDgN/JmpABpgyngpuVyw4m05KE=
Date:   Wed, 21 Oct 2020 18:31:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhudi <zhudi21@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <rose.chen@huawei.com>
Subject: Re: [PATCH v3] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201021183129.42d64f14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021020053.1401-1-zhudi21@huawei.com>
References: <20201021020053.1401-1-zhudi21@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 10:00:53 +0800 zhudi wrote:
> From: Di Zhu <zhudi21@huawei.com>
> 
> "ip addr show" command execute error when we have a physical
> network card with a large number of VFs
> 
> The return value of if_nlmsg_size() in rtnl_calcit() will exceed
> range of u16 data type when any network cards has a larger number of
> VFs. rtnl_vfinfo_size() will significant increase needed dump size when
> the value of num_vfs is larger.
> 
> Eventually we get a wrong value of min_ifinfo_dump_size because of overflow
> which decides the memory size needed by netlink dump and netlink_dump()
> will return -EMSGSIZE because of not enough memory was allocated.
> 
> So fix it by promoting  min_dump_alloc data type to u32 to
> avoid whole netlink message size overflow and it's also align
> with the data type of struct netlink_callback{}.min_dump_alloc
> which is assigned by return value of rtnl_calcit()
> 
> Signed-off-by: Di Zhu <zhudi21@huawei.com>

Applied, thanks!
