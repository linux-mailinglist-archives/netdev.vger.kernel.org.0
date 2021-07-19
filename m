Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298273CCC20
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhGSCMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:12:44 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12225 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233988AbhGSCMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:12:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GSlWg2skQz1CLM2;
        Mon, 19 Jul 2021 10:03:59 +0800 (CST)
Received: from dggpemm500015.china.huawei.com (7.185.36.181) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 10:09:43 +0800
Received: from [10.174.179.224] (10.174.179.224) by
 dggpemm500015.china.huawei.com (7.185.36.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 10:09:42 +0800
Subject: Re: [PATCH] Bluetooth: fix use-after-free error in lock_sock_nested()
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     <cj.chengjian@huawei.com>, Wei Yongjun <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <huawei.libin@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <20210714031733.1395549-1-bobo.shaobowang@huawei.com>
 <CABBYNZL37yLgj1LP7r=rbEcsPXCPy1y55ar816eZXka2W=7-Aw@mail.gmail.com>
 <a1c4ddcb-afbd-c0e4-2003-90590b10ea84@huawei.com>
 <32ffeb61-f8e8-2a62-e1a7-d5df9672267c@huawei.com>
 <CABBYNZKy28hfo811zMB6Z=TEXrUn_JCkpehE7n_a7Cx10qBa8g@mail.gmail.com>
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <50a139c2-6252-1881-c253-cc548bca1947@huawei.com>
Date:   Mon, 19 Jul 2021 10:09:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZKy28hfo811zMB6Z=TEXrUn_JCkpehE7n_a7Cx10qBa8g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.224]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> Hi,
>>>
>>> In my case it looks OK, this is the diff:
>>>
>>> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
>>> index f1b1edd0b697..32ef3328ab49 100644
>>> --- a/net/bluetooth/l2cap_sock.c
>>> +++ b/net/bluetooth/l2cap_sock.c
>>> @@ -1500,6 +1500,9 @@ static void l2cap_sock_close_cb(struct
>>> l2cap_chan *chan)
>>>   {
>>>          struct sock *sk = chan->data;
>>>
>>> +       if (!sk)
>>> +               return;
>>> +
>>>          l2cap_sock_kill(sk);
>>>   }
>>>
>>> @@ -1508,6 +1511,9 @@ static void l2cap_sock_teardown_cb(struct
>>> l2cap_chan *chan, int err)
>>>          struct sock *sk = chan->data;
>>>          struct sock *parent;
>>>
>>> +       if (!sk)
>>> +               return;
>>> +
>>>          BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
>>>
>>>          /* This callback can be called both for server (BT_LISTEN)
>>> @@ -1700,6 +1706,7 @@ static void l2cap_sock_destruct(struct sock *sk)
>>>          BT_DBG("sk %p", sk);
>>>
>>>          if (l2cap_pi(sk)->chan)
>>> +              l2cap_pi(sk)->chan->data = NULL;
>>>                   l2cap_chan_put(l2cap_pi(sk)->chan);
>>>
>>> But if it has potential risk if l2cap_sock_destruct() can not be
>>> excuted in time ?
>>>
>>> sk_free():
>>>
>>>          if (refcount_dec_and_test(&sk->sk_wmem_alloc)) //is possible
>>> this condition false ?
>>>
>>>                __sk_free(sk)   -> ... l2cap_sock_destruct()
>>>
>> Dear Luiz,
>>
>> Not only that, if l2cap_sock_kill() has put 'l2cap_pi(sk)->chan', how
>> does we avoid re-puting 'l2cap_pi(sk)->chan' if l2cap_sock_destruct()
>> work postponed? this will cause underflow of chan->refcount; this PATCH
>> 4e1a720d0312 ("Bluetooth: avoid killing an already killed socket") also
>> may not work in any case because only sock_orphan() has excuted can this
>> sock be killed, but if sco_sock_release() excute first, for this sock
>> has been marked as SOCK_DEAD, this sock can never be killed. So should
>> we think put chan->data = NULL in xx_sock_kill() is a better choice ?
> Not sure what do you mean by postponed? Interrupted perhaps? Even in
> that case what are trying to prevent is use after free so if the
> callback has not run yet that means the sk has not been freed. Anyway
> I think we could do it inconditionally in l2cap_sock_kill since we
> will be releasing the reference owned by l2cap_pi(sk)->chan->data that
> should be reset to NULL immediatelly.

Dear  Luiz,

yes, that's right, if sk can be accessed, it also means that chan has 
not been destroyed, thanks very much.

-- Wang ShaoBo

