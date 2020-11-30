Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33A12C7C2D
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgK3A72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:59:28 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8471 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK3A71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:59:27 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Ckn0f6CFTzhkT4;
        Mon, 30 Nov 2020 08:58:26 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 08:58:38 +0800
Subject: Re: [PATCH] powerpc: fix the allyesconfig build
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Daniel Axtens" <dja@axtens.net>, Joel Stanley <joel@jms.id.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-renesas-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
References: <20201128122819.32187696@canb.auug.org.au>
 <20201127175642.45502b20@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201128162054.575aea29@canb.auug.org.au>
 <20201128113654.4f2dcabe@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cfdea690-9866-7eda-904c-c097ea89a0ed@huawei.com>
Date:   Mon, 30 Nov 2020 08:58:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201128113654.4f2dcabe@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/29 3:36, Jakub Kicinski wrote:
> On Sat, 28 Nov 2020 16:20:54 +1100 Stephen Rothwell wrote:
>> On Fri, 27 Nov 2020 17:56:42 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> What's the offending structure in hisilicon? I'd rather have a look
>>> packing structs with pointers in 'em sounds questionable.
>>>
>>> I only see these two:
>>>
>>> $ git grep packed drivers/net/ethernet/hisilicon/
>>> drivers/net/ethernet/hisilicon/hns/hnae.h:struct __packed hnae_desc {
>>> drivers/net/ethernet/hisilicon/hns3/hns3_enet.h:struct __packed hns3_desc {  
>>
>> struct hclge_dbg_reg_type_info which is 28 bytes long due to the
>> included struct struct hclge_dbg_reg_common_msg (which is 12 bytes
>> long).  They are surrounded by #pragma pack(1)/pack().
>>
>> This forces the 2 pointers in each second array element of
>> hclge_dbg_reg_info[] to be 4 byte aligned (where pointers are 8 bytes
>> long on PPC64).
> 
> Ah! Thanks, I don't see a reason for these to be packed. 
> Looks  like an accident, there is no reason to pack anything 
> past struct hclge_dbg_reg_common_msg AFAICT.
> 
> Huawei folks, would you mind sending a fix if the analysis is correct?

Yes, will send a patch to fix that. Thanks for the analysis.

> .
> 
