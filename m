Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D257E1EC73F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCCUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:20:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35926 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbgFCCUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 22:20:35 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DFD1A856B65A4062CCA4;
        Wed,  3 Jun 2020 10:20:31 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 3 Jun 2020
 10:20:27 +0800
Subject: Re: [PATCH] net: genetlink: Fix memleak in
 genl_family_rcv_msg_dumpit()
To:     Cong Wang <xiyou.wangcong@gmail.com>
References: <20200602064545.50288-1-yuehaibing@huawei.com>
 <CAM_iQpXtsvewiN3bmfJqwuURN--aCkaR7N6zfYWf82KmFUZnLQ@mail.gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <da1d3625-f2a1-bd38-21e0-1e64139f6893@huawei.com>
Date:   Wed, 3 Jun 2020 10:20:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXtsvewiN3bmfJqwuURN--aCkaR7N6zfYWf82KmFUZnLQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/3 2:04, Cong Wang wrote:
> On Mon, Jun 1, 2020 at 11:47 PM YueHaibing <yuehaibing@huawei.com> wrote:
>> @@ -630,6 +625,9 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
>>                 err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
>>         }
>>
>> +       genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
>> +       genl_dumpit_info_free(info);
>> +
>>         return err;
>>  }
> 
> I do not think you can just move it after __netlink_dump_start(),
> because cb->done() can be called, for example, in netlink_sock_destruct()
> too.

netlink_sock_destruct() call cb->done() while nlk->cb_running is true,

if nlk->cb_running is not set to true in __netlink_dump_start() before return,

the memleak still occurs.

> 
> 

