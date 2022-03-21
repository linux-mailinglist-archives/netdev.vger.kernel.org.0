Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242934E208A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 07:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242717AbiCUGSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 02:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiCUGSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 02:18:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628808A331
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 23:17:24 -0700 (PDT)
Received: from kwepemi100010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KMPWB2ZtmzfZG3;
        Mon, 21 Mar 2022 14:15:50 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100010.china.huawei.com (7.221.188.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Mar 2022 14:17:22 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 21 Mar
 2022 14:17:17 +0800
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
To:     Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
References: <20220315032108.57228-1-wangjie125@huawei.com>
 <20220315032108.57228-2-wangjie125@huawei.com>
 <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220315195606.ggc3eea6itdiu6y7@lion.mk-sys.cz>
 <20220315184526.3e15e3ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <moyufeng@huawei.com>,
        <linyunsheng@huawei.com>, <tanhuazhong@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <d7fce582-4eb7-9b66-8a19-dd7633154a72@huawei.com>
Date:   Mon, 21 Mar 2022 14:17:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220315184526.3e15e3ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/16 9:45, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 20:56:06 +0100 Michal Kubecek wrote:
>> On Tue, Mar 15, 2022 at 12:15:29PM -0700, Jakub Kicinski wrote:
>>> On Tue, 15 Mar 2022 11:21:07 +0800 Jie Wang wrote:
>>>> As tx push is a standard feature for NICs, but netdev_feature which is
>>>> controlled by ethtool -K has reached the maximum specification.
>>>>
>>>> so this patch adds a pair of new ethtool messages：'ETHTOOL_GDEVFEAT' and
>>>> 'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely to
>>>> drivers. The message processing functions and function hooks in struct
>>>> ethtool_ops are also added.
>>>>
>>>> set-devfeatures/show-devfeatures option(s) are designed to provide set
>>>> and get function.
>>>> set cmd:
>>>> root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
>>>> get cmd:
>>>> root@wj: ethtool --show-devfeatures eth4
>>>
>>> I'd be curious to hear more opinions on whether we want to create a new
>>> command or use another method for setting this bit, and on the concept
>>> of "devfeatures" in general.
>>
>> IMHO it depends a lot on what exactly "belong entirely to the driver"
>> means. If it means driver specific features, using a private flag would
>> seem more appropriate for this particular feature and then we can
>> discuss if we want some generalization of private flags for other types
>> of driver/device specific parameters (integers etc.). Personally, I'm
>> afraid that it would encourage driver developers to go this easier way
>> instead of trying to come with universal and future proof interfaces.
>
> The "belong entirely to the driver" meant that the stack does not need
> to be aware of it. That's the justification for not putting it in
> netdev features, which the stack also peeks at, at times.
>
>> If this is supposed to gather universal features supported by multiple
>> drivers and devices, I suggest grouping it with existing parameters
>> handled as tunables in ioctl API. Or perhaps we could keep using the
>> name "tunables" and just handle them like any other command parameters
>> encoded as netlink attributes in the API.
>
> Let's throw tunables into the hell fire where they belong, lest they
> spawn a monster in the image of devlink params.
>
> How about we put it in SET_RINGS? It's a ring param after all
> (the feature controls use of a fast path descriptor push which
> skips the usual in-memory ring).
>
I think SET_RINGS is OK for tx push, but next new device feature would
still have this problem. As far as I know, features such as promisc,
tx push are driver features. So should I still work on the new devfeature
command netlink version for these standard driver features?

It would be nice to have clear rules about which command does new feature
need to be added to.
> .
>

