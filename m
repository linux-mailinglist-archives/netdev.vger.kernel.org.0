Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB82FAF0F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 04:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394874AbhASDPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 22:15:37 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2863 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394867AbhASDPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 22:15:34 -0500
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4DKYdN4bypz5Gqq;
        Tue, 19 Jan 2021 11:13:28 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme751-chm.china.huawei.com
 (10.3.19.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Tue, 19
 Jan 2021 11:14:51 +0800
Subject: Re: [PATCH net-next] net: hns3: debugfs add dump tm info of nodes,
 priority and qset
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1610694569-43099-1-git-send-email-tanhuazhong@huawei.com>
 <20210116182306.65a268a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d2fc48f6-aa2f-081a-dbce-312b869b8e04@huawei.com>
 <20210118114820.4e40a6ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <970b8526-6470-ffe1-5bb9-58693ac54582@huawei.com>
Date:   Tue, 19 Jan 2021 11:14:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210118114820.4e40a6ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/19 3:48, Jakub Kicinski wrote:
> On Mon, 18 Jan 2021 19:20:23 +0800 Huazhong Tan wrote:
>> On 2021/1/17 10:23, Jakub Kicinski wrote:
>>> On Fri, 15 Jan 2021 15:09:29 +0800 Huazhong Tan wrote:
>>>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>>>
>>>> To increase methods to dump more tm info, adds three debugfs commands
>>>> to dump tm info of nodes, priority and qset. And a new tm file of debugfs
>>>> is created for only dumping tm info.
>>>>
>>>> Unlike previous debugfs commands, to dump each tm information, user needs
>>>> to enter two commands now. The first command writes parameters to tm and
>>>> the second command reads info from tm. For examples, to dump tm info of
>>>> priority 0, user needs to enter follow two commands:
>>>> 1. echo dump priority 0 > tm
>>>> 2. cat tm
>>>>
>>>> The reason for adding new tm file is because we accepted Jakub Kicinski's
>>>> opinion as link https://lkml.org/lkml/2020/9/29/2101. And in order to
>>>> avoid generating too many files, we implement write ops to allow user to
>>>> input parameters.
>>> Why are you trying to avoid generating too many files? How many files
>>> would it be? What's the size of each dump/file?
>> The maximum number of tm node, priority and qset are 8, 256,
>> 1280, if we create a file for each one, then there are 8 node
>> files, 256 priority files, 1280 qset files. It seems a little
>> bit hard for using as well.
> Would the information not fit in one file per type with multiple rows?


What you means is as below ?

estuary:/debugfs/hns3/0000:7d:00.0$ cat qset

qset id: 0
QS map pri id: 0
QS map link_vld: 1
QS schedule mode: dwrr
QS dwrr: 100

qset id: 1
QS map pri id: 0
QS map link_vld: 0
QS schedule mode: sp
QS dwrr: 0

...

For example, user want to query qset 1, then all qset info will be output,

there are too many useless info.

So we add an interface to designage the specified id for node, priority 
or qset.


> Can you show example outputs?


here is the output of this patch.

estuary:/debugfs/hns3/0000:7d:00.0$ echo dump qset 0 > tm
estuary:/debugfs/hns3/0000:7d:00.0$ cat tm
qset id: 0
QS map pri id: 0
QS map link_vld: 1
QS schedule mode: dwrr
QS dwrr: 100
estuary:/debugfs/hns3/0000:7d:00.0$ echo dump qset 1 > tm
estuary:/debugfs/hns3/0000:7d:00.0$ cat tm
qset id: 1
QS map pri id: 0
QS map link_vld: 0
QS schedule mode: sp
QS dwrr: 0
estuary:/debugfs/hns3/0000:7d:00.0$ echo dump priority 0 > tm
estuary:/debugfs/hns3/0000:7d:00.0$ cat tm
priority id: 0
PRI schedule mode: dwrr
PRI dwrr: 100
PRI_C ir_b:0 ir_u:0 ir_s:0 bs_b:5 bs_s:20
PRI_C flag: 0x0
PRI_C pri_rate: 0(Mbps)
PRI_P ir_b:150 ir_u:7 ir_s:0 bs_b:5 bs_s:20
PRI_P flag: 0x0
PRI_P pri_rate: 100000(Mbps)
estuary:/debugfs/hns3/0000:7d:00.0$
estuary:/debugfs/hns3/0000:7d:00.0$ echo dump priority 1 > tm
estuary:/debugfs/hns3/0000:7d:00.0$ cat tm
priority id: 1
PRI schedule mode: sp
PRI dwrr: 0
PRI_C ir_b:0 ir_u:0 ir_s:0 bs_b:0 bs_s:0
PRI_C flag: 0x0
PRI_C pri_rate: 0(Mbps)
PRI_P ir_b:0 ir_u:0 ir_s:0 bs_b:0 bs_s:0
PRI_P flag: 0x0
PRI_P pri_rate: 0(Mbps)


>
> For example if I'm reading right the Qset only has 5 attributes:
>
> "qset id: %u\n"		qset_id
> "QS map pri id: %u\n"		map->priority
> "QS map link_vld: %u\n"	map->link_vld);
> "QS schedule mode: %s\n"	(qs_sch_mode->sch_mode & HCLGE_TM_TX_SCHD_DWRR_MSK) ?
> 				 "dwrr" : "sp");
> "QS dwrr: %u\n"		qs_weight->dwrr
>
> .

