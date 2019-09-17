Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358E8B45F5
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 05:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbfIQDUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 23:20:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbfIQDUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 23:20:03 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 84CB24867C721C163196;
        Tue, 17 Sep 2019 11:20:01 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 11:19:57 +0800
Message-ID: <5D8050DC.4010909@huawei.com>
Date:   Tue, 17 Sep 2019 11:19:56 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ixgbe: Use kzfree() rather than its implementation.
References: <1567564752-6430-1-git-send-email-zhongjiang@huawei.com> <1567564752-6430-2-git-send-email-zhongjiang@huawei.com> <20190916194319.712d81cc@cakuba.netronome.com>
In-Reply-To: <20190916194319.712d81cc@cakuba.netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/17 10:43, Jakub Kicinski wrote:
> On Wed, 4 Sep 2019 10:39:10 +0800, zhong jiang wrote:
>> Use kzfree() instead of memset() + kfree().
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> index 31629fc..113f608 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> @@ -960,11 +960,9 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>>  	return 0;
>>  
>>  err_aead:
>> -	memset(xs->aead, 0, sizeof(*xs->aead));
>> -	kfree(xs->aead);
>> +	kzfree(xs->aead);
>>  err_xs:
>> -	memset(xs, 0, sizeof(*xs));
>> -	kfree(xs);
>> +	kzfree(xs);
>>  err_out:
>>  	msgbuf[1] = err;
>>  	return err;
>> @@ -1049,8 +1047,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>>  	ixgbe_ipsec_del_sa(xs);
>>  
>>  	/* remove the xs that was made-up in the add request */
>> -	memset(xs, 0, sizeof(*xs));
>> -	kfree(xs);
>> +	kzfree(xs);
>>  
>>  	return 0;
>>  }
> All the crypto cases should really be converted to memzero_explicit().
It's better to do that.  I will repost it in v2.

Thanks,
zhong jiang

