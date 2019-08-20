Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305FC95467
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 04:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfHTC2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 22:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbfHTC2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 22:28:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9BF6F3082B67;
        Tue, 20 Aug 2019 02:28:53 +0000 (UTC)
Received: from [10.72.12.194] (ovpn-12-194.pek2.redhat.com [10.72.12.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 710576092F;
        Tue, 20 Aug 2019 02:28:51 +0000 (UTC)
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
To:     David Miller <davem@davemloft.net>, yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        xiyou.wangcong@gmail.com, weiyongjun1@huawei.com
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
 <20190819.182522.414877916903078544.davem@davemloft.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ceeafaf2-6aa4-b815-0b5f-ecc663216f43@redhat.com>
Date:   Tue, 20 Aug 2019 10:28:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190819.182522.414877916903078544.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 20 Aug 2019 02:28:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/20 上午9:25, David Miller wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> Date: Mon, 19 Aug 2019 21:31:19 +0800
>
>> Call tun_attach() after register_netdevice() to make sure tfile->tun
>> is not published until the netdevice is registered. So the read/write
>> thread can not use the tun pointer that may freed by free_netdev().
>> (The tun and dev pointer are allocated by alloc_netdev_mqs(), they can
>> be freed by netdev_freemem().)
> register_netdevice() must always be the last operation in the order of
> network device setup.
>
> At the point register_netdevice() is called, the device is visible globally
> and therefore all of it's software state must be fully initialized and
> ready for us.
>
> You're going to have to find another solution to these problems.


The device is loosely coupled with sockets/queues. Each side is allowed 
to be go away without caring the other side. So in this case, there's a 
small window that network stack think the device has one queue but 
actually not, the code can then safely drop them. Maybe it's ok here 
with some comments?

Or if not, we can try to hold the device before tun_attach and drop it 
after register_netdevice().

Thanks

