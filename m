Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB192911DE
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 14:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437953AbgJQMeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 08:34:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:54314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437935AbgJQMeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 08:34:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B70E4AD64;
        Sat, 17 Oct 2020 12:34:11 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 08B02603BD; Sat, 17 Oct 2020 14:34:11 +0200 (CEST)
Date:   Sat, 17 Oct 2020 14:34:11 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     zhudi <zhudi21@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rose.chen@huawei.com
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201017123411.fs7dktphdhw3boao@lion.mk-sys.cz>
References: <20201016020238.22445-1-zhudi21@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016020238.22445-1-zhudi21@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 10:02:38AM +0800, zhudi wrote:
> "ip addr show" command execute error when we have a physical
> network card with number of VFs larger than 247.
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
> avoid data overflow and it's also align with the data type of
> struct netlink_callback{}.min_dump_alloc which is assigned by
> return value of rtnl_calcit()

Unfortunately this is only part of the problem. For a NIC with so many
VFs (not sure if exactly 247 but it's close to that), IFLA_VFINFO_LIST
nested attribute itself would be over 64KB long which is not possible as
attribute size is u16.

So we should rather fail in such case (except when IFLA_VFINFO_LIST
itself fits into 64KB but the whole netlink message would not) and
provide an alternative way to get information about all VFs.

Michal
