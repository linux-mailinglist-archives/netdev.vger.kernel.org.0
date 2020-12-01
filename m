Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5AE2CA443
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 14:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391301AbgLANry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:47:54 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8547 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391297AbgLANrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:47:53 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Clk0j4WBrzhlDf;
        Tue,  1 Dec 2020 21:46:45 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Dec 2020 21:47:05 +0800
Subject: Re: [PATCH net v2 1/2] wireguard: device: don't call free_netdev() in
 priv_destructor()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <toshiaki.makita1@gmail.com>,
        <rkovhaev@gmail.com>
References: <20201201092903.3269202-1-yangyingliang@huawei.com>
 <CAHmME9rH7iBZN3tMuWuRU_n_dZ1An0FMLpwXWgDJFWjoUFp0fQ@mail.gmail.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <8b49292d-6176-fc10-0a91-3a6d78558d7d@huawei.com>
Date:   Tue, 1 Dec 2020 21:47:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9rH7iBZN3tMuWuRU_n_dZ1An0FMLpwXWgDJFWjoUFp0fQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/1 17:46, Jason A. Donenfeld wrote:
> Hi Yang,
>
> On Tue, Dec 1, 2020 at 10:31 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>> After commit cf124db566e6 ("net: Fix inconsistent teardown and..."),
>> priv_destruct() doesn't call free_netdev() in driver, we use
>> dev->needs_free_netdev to indicate whether free_netdev() should be
>> called on release path.
>> This patch remove free_netdev() from priv_destructor() and set
>> dev->needs_free_netdev to true.
> For now, nack.
>
> I remember when cf124db566e6 came out and carefully looking at the
> construction of device.c in WireGuard. priv_destructor is only
> assigned after register_device, with the various error paths in
> wg_newlink responsible for cleaning up other earlier failures, and
> trying to move to needs_free_netdev would have introduced more
> complexity in this particular case, if my memory serves. I do not
> think there's a memory leak here, and I worry about too hastily
> changing the state machine "just because".
>
> In other words, could you point out how to generate a memory leak? If
> you're correct, then we can start dissecting and refactoring this. But
> off the bat, I'm not sure I'm exactly seeing whatever you're seeing.

Yes, I missed that priv_destructor is only assigned after 
register_netdevice(),

so, it will not lead a double free in my patch#2, so this patch can be 
dropped and

send v3.

>
> Jason
> .
