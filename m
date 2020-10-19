Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0ED2920FF
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgJSB73 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 18 Oct 2020 21:59:29 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3986 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728728AbgJSB72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 21:59:28 -0400
Received: from dggemi403-hub.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 97A8B86CA83516FD153C;
        Mon, 19 Oct 2020 09:59:26 +0800 (CST)
Received: from DGGEMI422-HUB.china.huawei.com (10.1.199.151) by
 dggemi403-hub.china.huawei.com (10.3.17.136) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 19 Oct 2020 09:59:26 +0800
Received: from DGGEMI532-MBX.china.huawei.com ([169.254.7.245]) by
 dggemi422-hub.china.huawei.com ([10.1.199.151]) with mapi id 14.03.0487.000;
 Mon, 19 Oct 2020 09:59:20 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Thread-Topic: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Thread-Index: AdalumDsZ0EdCN34R/q22534c2vcJQ==
Date:   Mon, 19 Oct 2020 01:59:19 +0000
Message-ID: <0DCA8173C37AD8458D6BA40EB0C660918CA689@DGGEMI532-MBX.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sat, 17 Oct 2020 14:34:11 +0200 Michal Kubecek wrote:
> > On Fri, Oct 16, 2020 at 10:02:38AM +0800, zhudi wrote:
> > > "ip addr show" command execute error when we have a physical
> network
> > > card with number of VFs larger than 247.
> > >
> > > The return value of if_nlmsg_size() in rtnl_calcit() will exceed
> > > range of u16 data type when any network cards has a larger number of
> > > VFs. rtnl_vfinfo_size() will significant increase needed dump size
> > > when the value of num_vfs is larger.
> > >
> > > Eventually we get a wrong value of min_ifinfo_dump_size because of
> > > overflow which decides the memory size needed by netlink dump and
> > > netlink_dump() will return -EMSGSIZE because of not enough memory
> was allocated.
> > >
> > > So fix it by promoting  min_dump_alloc data type to u32 to avoid
> > > data overflow and it's also align with the data type of struct
> > > netlink_callback{}.min_dump_alloc which is assigned by return value
> > > of rtnl_calcit()
> >
> > Unfortunately this is only part of the problem. For a NIC with so many
> > VFs (not sure if exactly 247 but it's close to that), IFLA_VFINFO_LIST
> > nested attribute itself would be over 64KB long which is not possible
> > as attribute size is u16.
> >
> > So we should rather fail in such case (except when IFLA_VFINFO_LIST
> > itself fits into 64KB but the whole netlink message would not) and
> > provide an alternative way to get information about all VFs.
> 
> Right, we should probably move to devlink as much as possible.
> 
> zhudi, why not use size_t? Seems like the most natural fit for counting size.

Thanks for your replying.
min_dump_alloc original type used is u16 and it's eventually assigned to 
struct netlink_callback{}. min_dump_alloc which data type is u32. So I just simply
promote to u32.
Should be used size_t instead of u32?
