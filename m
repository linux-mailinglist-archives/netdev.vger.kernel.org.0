Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1412B26171C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731787AbgIHRZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:25:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731733AbgIHQQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:16:59 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id CCE28F1326CF72BA8027;
        Tue,  8 Sep 2020 23:25:41 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 8 Sep 2020 23:25:41 +0800
Subject: Re: [PATCH net] hinic: fix rewaking txq after netif_tx_disable
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200907141516.16817-1-luobin9@huawei.com>
 <20200907142834.368b9bae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <695897ce-9edd-d5cb-12c7-d0c8080bd4e6@huawei.com>
Date:   Tue, 8 Sep 2020 23:25:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200907142834.368b9bae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/8 5:28, Jakub Kicinski wrote:
> On Mon, 7 Sep 2020 22:15:16 +0800 Luo bin wrote:
>> When calling hinic_close in hinic_set_channels, all queues are
>> stopped after netif_tx_disable, but some queue may be rewaken in
>> free_tx_poll by mistake while drv is handling tx irq. If one queue
>> is rewaken core may call hinic_xmit_frame to send pkt after
>> netif_tx_disable within a short time which may results in accessing
>> memory that has been already freed in hinic_close. So we judge
>> whether the netdev is in down state before waking txq in free_tx_poll
>> to fix this bug.
> 
> The right fix is to call napi_disable() _before_ you call
> netif_tx_disable(), not after, like hinic_close() does.
> .
> 
Will fix. Thanks for your review.
