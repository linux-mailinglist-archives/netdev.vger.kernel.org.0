Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F952918E6
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 20:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgJRSlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 14:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgJRSlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 14:41:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36FFD22261;
        Sun, 18 Oct 2020 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603046498;
        bh=uEwh+atflMMhdsL3pfAQ8skeK6UY3/MhbUotN9qo1IQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zZXi9fOAi+vkUEsbRD2OZ4beCtol+35qoa/Bc5wiTMtoiDxNCgAsYy6J5EItCWEB8
         /SU3r2gJL0iqlwVKx4abixHxNBbBQtGeveTateenDjtn2aAYwjoM2C4RQAola3Iogr
         bi4S0gHnHzX/BSoWLh0aodEThZXwNQ2/xoJeBlng=
Date:   Sun, 18 Oct 2020 11:41:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     zhudi <zhudi21@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, rose.chen@huawei.com
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201018114136.5f02a826@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201017123411.fs7dktphdhw3boao@lion.mk-sys.cz>
References: <20201016020238.22445-1-zhudi21@huawei.com>
        <20201017123411.fs7dktphdhw3boao@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 14:34:11 +0200 Michal Kubecek wrote:
> On Fri, Oct 16, 2020 at 10:02:38AM +0800, zhudi wrote:
> > "ip addr show" command execute error when we have a physical
> > network card with number of VFs larger than 247.
> > 
> > The return value of if_nlmsg_size() in rtnl_calcit() will exceed
> > range of u16 data type when any network cards has a larger number of
> > VFs. rtnl_vfinfo_size() will significant increase needed dump size when
> > the value of num_vfs is larger.
> > 
> > Eventually we get a wrong value of min_ifinfo_dump_size because of overflow
> > which decides the memory size needed by netlink dump and netlink_dump()
> > will return -EMSGSIZE because of not enough memory was allocated.
> > 
> > So fix it by promoting  min_dump_alloc data type to u32 to
> > avoid data overflow and it's also align with the data type of
> > struct netlink_callback{}.min_dump_alloc which is assigned by
> > return value of rtnl_calcit()  
> 
> Unfortunately this is only part of the problem. For a NIC with so many
> VFs (not sure if exactly 247 but it's close to that), IFLA_VFINFO_LIST
> nested attribute itself would be over 64KB long which is not possible as
> attribute size is u16.
> 
> So we should rather fail in such case (except when IFLA_VFINFO_LIST
> itself fits into 64KB but the whole netlink message would not) and
> provide an alternative way to get information about all VFs.

Right, we should probably move to devlink as much as possible.

zhudi, why not use size_t? Seems like the most natural fit for 
counting size.
