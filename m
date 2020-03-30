Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48630197DD2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgC3OFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:05:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50000 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgC3OFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 10:05:47 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C7801625750368B4B8CA;
        Mon, 30 Mar 2020 22:05:34 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 22:05:32 +0800
Subject: Re: [PATCH net-next] xfrm: policy: Remove obsolete WARN while xfrm
 policy inserting
To:     Steffen Klassert <steffen.klassert@secunet.com>
References: <20200327123443.12408-1-yuehaibing@huawei.com>
 <20200328112302.GA13121@gauss3.secunet.de>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <1d3596fb-c7e3-16c9-f48f-fe58e9a2569a@huawei.com>
Date:   Mon, 30 Mar 2020 22:05:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200328112302.GA13121@gauss3.secunet.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/3/28 19:23, Steffen Klassert wrote:
> On Fri, Mar 27, 2020 at 08:34:43PM +0800, YueHaibing wrote:
>> Since commit 7cb8a93968e3 ("xfrm: Allow inserting policies with matching
>> mark and different priorities"), we allow duplicate policies with
>> different priority, this WARN is not needed any more.
> 
> Can you please describe a bit more detailed why this warning
> can't trigger anymore?

No, this warning is triggered while detect a duplicate entry in the policy list

regardless of the priority. If we insert policy like this:

policy A (mark.v = 3475289, mark.m = 0, priority = 1)	//A is inserted
policy B (mark.v = 0, mark.m = 0, priority = 0) 	//B is inserted
policy C (mark.v = 3475289, mark.m = 0, priority = 0)	//C is inserted and B is deleted
policy D (mark.v = 3475289, mark.m = 0, priority = 1)	

while finding delpol in xfrm_policy_insert_list,
first round delpol is matched C, whose priority is less than D, so contiue the loop,
then A is matched， WARN_ON is triggered.  It seems the WARN is useless.

> 
> Thanks!
> 
> 

