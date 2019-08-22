Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B64E98945
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 04:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbfHVCNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 22:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfHVCNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 22:13:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 863713DE02;
        Thu, 22 Aug 2019 02:13:17 +0000 (UTC)
Received: from [10.72.12.68] (ovpn-12-68.pek2.redhat.com [10.72.12.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73B0F5C228;
        Thu, 22 Aug 2019 02:13:14 +0000 (UTC)
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
From:   Jason Wang <jasowang@redhat.com>
To:     David Miller <davem@davemloft.net>, yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        xiyou.wangcong@gmail.com, weiyongjun1@huawei.com
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
 <20190819.182522.414877916903078544.davem@davemloft.net>
 <ceeafaf2-6aa4-b815-0b5f-ecc663216f43@redhat.com>
Message-ID: <d8eaedf9-321c-1c07-cbd1-de5e1f73b086@redhat.com>
Date:   Thu, 22 Aug 2019 10:13:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ceeafaf2-6aa4-b815-0b5f-ecc663216f43@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 22 Aug 2019 02:13:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/20 上午10:28, Jason Wang wrote:
>
> On 2019/8/20 上午9:25, David Miller wrote:
>> From: Yang Yingliang <yangyingliang@huawei.com>
>> Date: Mon, 19 Aug 2019 21:31:19 +0800
>>
>>> Call tun_attach() after register_netdevice() to make sure tfile->tun
>>> is not published until the netdevice is registered. So the read/write
>>> thread can not use the tun pointer that may freed by free_netdev().
>>> (The tun and dev pointer are allocated by alloc_netdev_mqs(), they can
>>> be freed by netdev_freemem().)
>> register_netdevice() must always be the last operation in the order of
>> network device setup.
>>
>> At the point register_netdevice() is called, the device is visible 
>> globally
>> and therefore all of it's software state must be fully initialized and
>> ready for us.
>>
>> You're going to have to find another solution to these problems.
>
>
> The device is loosely coupled with sockets/queues. Each side is 
> allowed to be go away without caring the other side. So in this case, 
> there's a small window that network stack think the device has one 
> queue but actually not, the code can then safely drop them. Maybe it's 
> ok here with some comments?
>
> Or if not, we can try to hold the device before tun_attach and drop it 
> after register_netdevice().


Hi Yang:

I think maybe we can try to hold refcnt instead of playing real num 
queues here. Do you want to post a V4?

Thanks


>
> Thanks
>
