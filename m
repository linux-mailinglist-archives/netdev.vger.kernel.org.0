Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC9F3A090B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhFIBdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:33:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3804 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFIBdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 21:33:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G08bD5sKqzWtJn;
        Wed,  9 Jun 2021 09:26:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 09:31:40 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 09:31:40 +0800
Subject: Re: Re: [PATCH net-next v2 0/3] Some optimization for lockless qdisc
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andriin@fb.com>, <edumazet@google.com>, <weiwan@google.com>,
        <cong.wang@bytedance.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
References: <1622684880-39895-1-git-send-email-linyunsheng@huawei.com>
 <20210603113548.2d71b4d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20210608125349.7azp7zeae3oq3izc@skbuf>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <64aaa011-41a3-1e06-af02-909ff329ef7a@huawei.com>
Date:   Wed, 9 Jun 2021 09:31:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210608125349.7azp7zeae3oq3izc@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/8 20:53, Vladimir Oltean wrote:
> On Thu, Jun 03, 2021 at 11:35:48AM -0700, Jakub Kicinski wrote:
>> On Thu, 3 Jun 2021 09:47:57 +0800 Yunsheng Lin wrote:
>>> Patch 1: remove unnecessary seqcount operation.
>>> Patch 2: implement TCQ_F_CAN_BYPASS.
>>> Patch 3: remove qdisc->empty.
>>>
>>> Performance data for pktgen in queue_xmit mode + dummy netdev
>>> with pfifo_fast:
>>>
>>>  threads    unpatched           patched             delta
>>>     1       2.60Mpps            3.21Mpps             +23%
>>>     2       3.84Mpps            5.56Mpps             +44%
>>>     4       5.52Mpps            5.58Mpps             +1%
>>>     8       2.77Mpps            2.76Mpps             -0.3%
>>>    16       2.24Mpps            2.23Mpps             +0.4%
>>>
>>> Performance for IP forward testing: 1.05Mpps increases to
>>> 1.16Mpps, about 10% improvement.
>>
>> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Any idea why these patches are deferred in patchwork?
> https://patchwork.kernel.org/project/netdevbpf/cover/1622684880-39895-1-git-send-email-linyunsheng@huawei.com/

I suppose it is a controversial change, which need more time
hanging to be reviewed and tested.

By the way, I did not pick up your "Tested-by" from previous
RFC version because there is some change between those version
that deserves a retesting. So it would be good to have a
"Tested-by" from you after confirming no out of order happening
for this version, thanks.



