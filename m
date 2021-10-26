Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCAA43B47B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhJZOny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:43:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29941 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbhJZOnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:43:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HdvXW63DbzbnPZ;
        Tue, 26 Oct 2021 22:36:43 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 22:41:22 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 26 Oct
 2021 22:41:20 +0800
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-5-huangguangbin2@huawei.com>
 <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
 <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
 <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211025190114.zbqgzsfiv7zav7aq@pengutronix.de>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <8ce654b8-4a31-2d43-df7e-607528ba44d5@huawei.com>
Date:   Tue, 26 Oct 2021 22:41:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211025190114.zbqgzsfiv7zav7aq@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/26 3:01, Marc Kleine-Budde wrote:
> On 25.10.2021 10:45:05, Jakub Kicinski wrote:
>>> The approach Andrew suggested is two-fold. First introduce a "struct
>>> ethtool_kringparam" that's only used inside the kernel, as "struct
>>> ethtool_ringparam" is ABI. Then extend "struct ethtool_kringparam" as
>>> needed.
>>
>> Indeed, there are different ways to extend the API for drivers,
>> I think it comes down to personal taste. I find the "inheritance"
>> models in C (kstruct usually contains the old struct as some "base")
>> awkward.
>>
>> I don't think we have agreed-on best practice in the area.
> 
>  From my point of view, if there already is an extension mainline:
> 
> | https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f3ccfda19319
> 
> I'm more in the flavor for modeling other extensions the same way. Would
> be more consistent to name the new struct "kernel_"ethtool_ringparam,
> following the coalescing example:
> 
> | struct kernel_ethtool_ringparam {
> |        __u32   rx_buf_len;
> | };
> 
> regards,
> Marc
> 
We think ethtool_ringparam_ext is more easy to understand it is extension of
struct ethtool_ringparam. However, we don't mind to keep the same way and modify
to the name kernel_ethtool_ringparam if everyone agrees.

Does anyone have other opinions?
