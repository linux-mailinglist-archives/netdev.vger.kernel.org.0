Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD9299A3E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395512AbgJZXN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395502AbgJZXN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:13:27 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73CE720719;
        Mon, 26 Oct 2020 23:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603754006;
        bh=M6TmwnSYX9ItNPqyO0jy4oi3nkENeh29xY8TzzevUdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vHsNgG6Jsyc4SR54/vO5jsWx+oNNH43YdSa9Sb+aehqT4ILeZPyU6d+c9giqaHNMw
         U8cL6grbAHNt2H2RlZFEBV6L8MimobcGeN+8bEayiGFvP5g+40CaEwTkJrW1gqXSRx
         pT5KfNNmlKR2LsVKJMIi/bhgMXD0aSM6IwxTHos8=
Date:   Mon, 26 Oct 2020 16:13:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>, <tanhuazhong@huawei.com>
Subject: Re: [PATCH net] net: hns3: Clear the CMDQ registers before
 unmapping BAR region
Message-ID: <20201026161325.6f33d9c8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e74f0a72-92d1-2ac9-1f4b-191477d673ef@huawei.com>
References: <20201023051550.793-1-yuzenghui@huawei.com>
        <3c5c98f9-b4a0-69a2-d58d-bfef977c68ad@huawei.com>
        <e74f0a72-92d1-2ac9-1f4b-191477d673ef@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 15:01:14 +0800 Zenghui Yu wrote:
> On 2020/10/23 14:22, Yunsheng Lin wrote:
> > On 2020/10/23 13:15, Zenghui Yu wrote:  
> >> When unbinding the hns3 driver with the HNS3 VF, I got the following
> >> kernel panic:
> >>
> >> [  265.709989] Unable to handle kernel paging request at virtual address ffff800054627000
> >> [  265.717928] Mem abort info:
> >> [  265.720740]   ESR = 0x96000047
> >> [  265.723810]   EC = 0x25: DABT (current EL), IL = 32 bits
> >> [  265.729126]   SET = 0, FnV = 0
> >> [  265.732195]   EA = 0, S1PTW = 0
> >> [  265.735351] Data abort info:
> >> [  265.738227]   ISV = 0, ISS = 0x00000047
> >> [  265.742071]   CM = 0, WnR = 1
> >> [  265.745055] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000009b54000
> >> [  265.751753] [ffff800054627000] pgd=0000202ffffff003, p4d=0000202ffffff003, pud=00002020020eb003, pmd=00000020a0dfc003, pte=0000000000000000
> >> [  265.764314] Internal error: Oops: 96000047 [#1] SMP
> >> [  265.830357] CPU: 61 PID: 20319 Comm: bash Not tainted 5.9.0+ #206
> >> [  265.836423] Hardware name: Huawei TaiShan 2280 V2/BC82AMDDA, BIOS 1.05 09/18/2019
> > 
> > Do you care to provide the testcase for above calltrace?  
> 
> I noticed it with VFIO, but it's easy to reproduce it manually. Here you
> go:
> 
>    # cat /sys/bus/pci/devices/0000\:7d\:00.2/sriov_totalvfs
> 3
>    # echo 3 > /sys/bus/pci/devices/0000\:7d\:00.2/sriov_numvfs
>    # lspci | grep "Virtual Function"
> 7d:01.6 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
> Network Controller (Virtual Function) (rev 21)
> 7d:01.7 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
> Network Controller (Virtual Function) (rev 21)
> 7d:02.0 Ethernet controller: Huawei Technologies Co., Ltd. HNS RDMA 
> Network Controller (Virtual Function) (rev 21)
>    # echo 0000:7d:01.6 > /sys/bus/pci/devices/0000:7d:01.6/driver/unbind

Do you know if the bug occurred on 5.4? Is this the correct fixes tag?

Fixes: 862d969a3a4d ("net: hns3: do VF's pci re-initialization while PF doing FLR")

