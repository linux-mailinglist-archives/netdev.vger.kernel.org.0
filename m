Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5912920D7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 03:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbgJSBJY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 18 Oct 2020 21:09:24 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3985 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728329AbgJSBJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 21:09:24 -0400
Received: from dggemi403-hub.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 6502BF1412B45060C8FD;
        Mon, 19 Oct 2020 09:09:22 +0800 (CST)
Received: from DGGEMI532-MBX.china.huawei.com ([169.254.7.245]) by
 dggemi403-hub.china.huawei.com ([10.3.17.136]) with mapi id 14.03.0487.000;
 Mon, 19 Oct 2020 09:09:15 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Thread-Topic: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Thread-Index: AdaltF/2pdXbTlz+SPCCd1/pwXEigg==
Date:   Mon, 19 Oct 2020 01:09:15 +0000
Message-ID: <0DCA8173C37AD8458D6BA40EB0C660918CA659@DGGEMI532-MBX.china.huawei.com>
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

 > On Fri, Oct 16, 2020 at 10:02:38AM +0800, zhudi wrote:
> > "ip addr show" command execute error when we have a physical network
> > card with number of VFs larger than 247.
> >
> > The return value of if_nlmsg_size() in rtnl_calcit() will exceed range
> > of u16 data type when any network cards has a larger number of VFs.
> > rtnl_vfinfo_size() will significant increase needed dump size when the
> > value of num_vfs is larger.
> >
> > Eventually we get a wrong value of min_ifinfo_dump_size because of
> > overflow which decides the memory size needed by netlink dump and
> > netlink_dump() will return -EMSGSIZE because of not enough memory was
> allocated.
> >
> > So fix it by promoting  min_dump_alloc data type to u32 to avoid data
> > overflow and it's also align with the data type of struct
> > netlink_callback{}.min_dump_alloc which is assigned by return value of
> > rtnl_calcit()
> 
> Unfortunately this is only part of the problem. For a NIC with so many VFs
> (not sure if exactly 247 but it's close to that), IFLA_VFINFO_LIST nested
> attribute itself would be over 64KB long which is not possible as attribute size
> is u16.
> 
> So we should rather fail in such case (except when IFLA_VFINFO_LIST itself
> fits into 64KB but the whole netlink message would not) and provide an
> alternative way to get information about all VFs.

Thanks for your replying,  it's right. The patch only fix the situation that IFLA_VFINFO_LIST itself
fits into 64KB but the whole netlink message would not.

