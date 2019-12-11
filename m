Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0926C11A39A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 05:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLKEzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 23:55:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:38048 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLKEzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 23:55:41 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id xBB4tJbv010057
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 10 Dec 2019 20:55:19 -0800 (PST)
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Tue, 10 Dec
 2019 20:55:18 -0800
Subject: Re: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected()
 with rcu_replace_pointer()
To:     Tuong Lien Tong <tuong.t.lien@dektech.com.au>, <paulmck@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <davem@davemloft.net>
References: <20191210033146.GA32522@paulmck-ThinkPad-P72>
 <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
 <20191210223825.GS2889@paulmck-ThinkPad-P72>
 <54112a30-de24-f6b2-b02e-05bc7d567c57@windriver.com>
 <707801d5afc6$cac68190$605384b0$@dektech.com.au>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <db88d33f-8e25-8859-84ec-3372a108c759@windriver.com>
Date:   Wed, 11 Dec 2019 12:42:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <707801d5afc6$cac68190$605384b0$@dektech.com.au>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/19 10:00 AM, Tuong Lien Tong wrote:
>>  
>>  	/* Move passive key if any */
>>  	if (key.passive) {
>> -		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
>> +		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2,
> &rx->lock);
> The 3rd parameter should be the lockdep condition checking instead of the
> spinlock's pointer i.e. "lockdep_is_held(&rx->lock)"?
> That's why I'd prefer to use the 'tipc_aead_rcu_swap ()' macro, which is
> clear & concise at least for the context here. It might be re-used later as
> well...
> 

Right. The 3rd parameter of rcu_replace_pointer() should be
"lockdep_is_held(&rx->lock)" instead of "&rx->lock".
