Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C57230AB8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgG1Mzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:55:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:36674 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgG1Mzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:55:43 -0400
Received: from [10.193.177.153] (moorthi.asicdesigners.com [10.193.177.153] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06SCtJdc009908;
        Tue, 28 Jul 2020 05:55:20 -0700
Subject: Re: [PATCH net V2] Crypto/chcr: Registering cxgb4 to xfrmdev_ops
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     ayush.sawal@asicdesigners.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, secdev@chelsio.com, lkp@intel.com
References: <20200724084124.21651-1-ayush.sawal@chelsio.com>
 <20200724.170108.362782113011946610.davem@davemloft.net>
 <20200725062034.GA19493@gondor.apana.org.au>
 <20200727091627.GX20687@gauss3.secunet.de>
 <f1f8ed22-9821-08cb-995c-7500355f2680@chelsio.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <edacaaea-1a39-6d47-6e33-b70abf478425@chelsio.com>
Date:   Tue, 28 Jul 2020 18:31:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f1f8ed22-9821-08cb-995c-7500355f2680@chelsio.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert, David

On 7/27/2020 3:29 PM, Ayush Sawal wrote:
> 
> On 7/27/2020 2:46 PM, Steffen Klassert wrote:
>> On Sat, Jul 25, 2020 at 04:20:34PM +1000, Herbert Xu wrote:
>>> On Fri, Jul 24, 2020 at 05:01:08PM -0700, David Miller wrote:
>>>> Please start submitting chcr patches to the crypto subsystem, where it
>>>> belongs, instead of the networking GIT trees.
>>> Hi Dave:
>>>
>>> I think this patch belongs to the networking tree.  The reason is
>>> that it's related to xfrm offload which has nothing to do with the
>>> Crypto API.
>> Hm, I think some of this code is just misplaced under drivers/crypto.
>> All functions in 'drivers/crypto/chelsio/chcr_ipsec.c' implement
>> networking (IPsec). So it should be under drivers/net, then it
>> can be merged via the net or net-next tree as usual for network
>> drivers.
> 
> Ok,
> We have started the work towards shifting inline ipsec, nic tls & chtls 
> code present in drivers/crypto/chelsio/ into 
> drivers/net/ethernet/chelsio/. Only co-processor code will exist in the 
> drivers/crypto/chelsio directory.
> 
> Thanks,
> Ayush
> 

In the process of moving inline tls stuff from crypto to net, we have
directory structure change.
Can you please suggest correct tree to submit changes to avoid merge 
conflicts ?

Here is the file diff stats:

MAINTAINERS                                   |  9 ++
drivers/crypto/chelsio/Kconfig                | 11 ---
drivers/crypto/chelsio/Makefile               |  1 -
drivers/crypto/chelsio/chcr_algo.h            | 33 -------
drivers/crypto/chelsio/chcr_core.h            | 53 ------------
drivers/net/ethernet/chelsio/Kconfig          | 11 +++
drivers/net/ethernet/chelsio/Makefile         |  1 +
.../ethernet}/chelsio/chtls/Makefile          |  0
.../ethernet}/chelsio/chtls/chtls.h           | 86 +++++++++++++++++++
.../ethernet}/chelsio/chtls/chtls_cm.c        |  0
.../ethernet}/chelsio/chtls/chtls_cm.h        |  0
.../ethernet}/chelsio/chtls/chtls_hw.c        |  0
.../ethernet}/chelsio/chtls/chtls_io.c        |  0
.../ethernet}/chelsio/chtls/chtls_main.c      |  0
14 files changed, 107 insertions(+), 98 deletions(-)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/Makefile (100%)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/chtls.h (81%)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/chtls_cm.c (100%)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/chtls_cm.h (100%)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/chtls_hw.c (100%)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/chtls_io.c (100%)
rename drivers/{crypto => net/ethernet}/chelsio/chtls/chtls_main.c (100%)


>>> Do xfrm offload drivers usually go through the networking tree or
>>> would it be better directed through the xfrm tree?
>> The drivers go through the networking trees, and I think it should
>> stay like this. Otherwise we would create needless merge conflicts.
>>
