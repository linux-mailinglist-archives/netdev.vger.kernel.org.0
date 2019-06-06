Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA5A37C5A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfFFSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:35:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55568 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfFFSft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:35:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30A8F14DE4E1A;
        Thu,  6 Jun 2019 11:35:48 -0700 (PDT)
Date:   Thu, 06 Jun 2019 11:35:47 -0700 (PDT)
Message-Id: <20190606.113547.1877303546486591185.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     info@metux.net, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: fib_semantics: fix uninitialized variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0ba84175-49be-9023-271d-516c93e2d83e@gmail.com>
References: <1559832197-22758-1-git-send-email-info@metux.net>
        <0ba84175-49be-9023-271d-516c93e2d83e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 11:35:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Thu, 6 Jun 2019 09:47:34 -0600

> On 6/6/19 8:43 AM, Enrico Weigelt, metux IT consult wrote:
>> From: Enrico Weigelt <info@metux.net>
>> 
>> fix an uninitialized variable:
>> 
>>   CC      net/ipv4/fib_semantics.o
>> net/ipv4/fib_semantics.c: In function 'fib_check_nh_v4_gw':
>> net/ipv4/fib_semantics.c:1027:12: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>    if (!tbl || err) {
>>             ^~
>> 
>> Signed-off-by: Enrico Weigelt <info@metux.net>
>> ---
>>  net/ipv4/fib_semantics.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index b804106..bfa49a8 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -964,7 +964,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
>>  {
>>  	struct net_device *dev;
>>  	struct fib_result res;
>> -	int err;
>> +	int err = 0;
>>  
>>  	if (nh->fib_nh_flags & RTNH_F_ONLINK) {
>>  		unsigned int addr_type;
>> 
> 
> what compiler version?
> 
> if tbl is set, then err is set.

It's unfortunate that it can't walk through that simple logic and set
of dependencies but we'll have to quiet this warning whether we like it
or not.
