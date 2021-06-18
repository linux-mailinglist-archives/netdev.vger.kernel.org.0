Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4DD3AC07D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 03:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhFRBUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 21:20:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7480 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbhFRBUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 21:20:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5gvx33H9zZj4x;
        Fri, 18 Jun 2021 09:15:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:18:22 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 18 Jun
 2021 09:18:21 +0800
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
To:     Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
 <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
 <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com>
 <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <9107b490-d74c-7ff2-de40-eb77770f0a64@huawei.com>
Date:   Fri, 18 Jun 2021 09:18:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi  Jakub，


在 2021/3/18 9:28, Jakub Kicinski 写道:
> On Thu, 18 Mar 2021 09:02:54 +0800 Huazhong Tan wrote:
>> On 2021/3/16 4:04, Jakub Kicinski wrote:
>>> On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote:
>>>> From: Jian Shen <shenjian15@huawei.com>
>>>>
>>>> For device version V3, it supports queue bonding, which can
>>>> identify the tuple information of TCP stream, and create flow
>>>> director rules automatically, in order to keep the tx and rx
>>>> packets are in the same queue pair. The driver set FD_ADD
>>>> field of TX BD for TCP SYN packet, and set FD_DEL filed for
>>>> TCP FIN or RST packet. The hardware create or remove a fd rule
>>>> according to the TX BD, and it also support to age-out a rule
>>>> if not hit for a long time.
>>>>
>>>> The queue bonding mode is default to be disabled, and can be
>>>> enabled/disabled with ethtool priv-flags command.
>>> This seems like fairly well defined behavior, IMHO we should have a full
>>> device feature for it, rather than a private flag.
>> Should we add a NETIF_F_NTUPLE_HW feature for it?
> It'd be better to keep the configuration close to the existing RFS
> config, no? Perhaps a new file under
>
>    /sys/class/net/$dev/queues/rx-$id/
>
> to enable the feature would be more appropriate?
>
> Otherwise I'd call it something like NETIF_F_RFS_AUTO ?
I noticed that the enum NETIF_F_XXX_BIT has already used 64 bits since

NETIF_F_HW_HSR_DUP_BIT being added, while the prototype of 
netdev_features_t

is u64.   So there is no useable bit for new feature if I understand 
correct.


Is there any solution or plan for it ?

>
> Alex, any thoughts? IIRC Intel HW had a similar feature?
>
>>> Does the device need to be able to parse the frame fully for this
>>> mechanism to work? Will it work even if the TCP segment is encapsulated
>>> in a custom tunnel?
>> no, custom tunnel is not supported.
> Hm, okay, it's just queue mapping, if device gets it wrong not the end
> of the world (provided security boundaries are preserved).
> .
>

