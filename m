Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FC23549D3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 02:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhDFAzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 20:55:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3390 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbhDFAzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 20:55:51 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FDpsk12p2z5lg1;
        Tue,  6 Apr 2021 08:52:58 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 6 Apr 2021 08:55:41 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 6 Apr 2021
 08:55:41 +0800
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Jiri Kosina <jikos@kernel.org>, Hillf Danton <hdanton@sina.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        "David Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200825032312.11776-1-hdanton@sina.com>
 <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com>
 <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <eaff25bc-9b64-037e-b9bc-c06fc4a5a9fb@huawei.com>
Date:   Tue, 6 Apr 2021 08:55:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/3 20:23, Jiri Kosina wrote:
> On Sat, 3 Apr 2021, Hillf Danton wrote:
> 
>>>>> Sure. Seems they crept in over time. I had some plans to write a
>>>>> lockless HTB implementation. But with fq+EDT with BPF it seems that
>>>>> it is no longer needed, we have a more generic/better solution.  So
>>>>> I dropped it. Also most folks should really be using fq, fq_codel,
>>>>> etc. by default anyways. Using pfifo_fast alone is not ideal IMO.
>>>>
>>>> Half a year later, we still have the NOLOCK implementation
>>>> present, and pfifo_fast still does set the TCQ_F_NOLOCK flag on itself.
>>>>
>>>> And we've just been bitten by this very same race which appears to be
>>>> still unfixed, with single packet being stuck in pfifo_fast qdisc
>>>> basically indefinitely due to this very race that this whole thread began
>>>> with back in 2019.
>>>>
>>>> Unless there are
>>>>
>>>> 	(a) any nice ideas how to solve this in an elegant way without
>>>> 	    (re-)introducing extra spinlock (Cong's fix) or
>>>>
>>>> 	(b) any objections to revert as per the argumentation above
>>>>
>>>> I'll be happy to send a revert of the whole NOLOCK implementation next
>>>> week.
>>>>
>>> Jiri
>>>
>>
>> Feel free to revert it as the scorch wont end without a deluge.
> 
> I am still planning to have Yunsheng Lin's (CCing) fix [1] tested in the 
> coming days. If it works, then we can consider proceeding with it, 
> otherwise I am all for reverting the whole NOLOCK stuff.

Hi, Jiri
Do you have a reproducer that can be shared here?
With reproducer, I can debug and test it myself too.

Thanks.

> 
> [1] https://lore.kernel.org/linux-can/1616641991-14847-1-git-send-email-linyunsheng@huawei.com/T/#u
> 

