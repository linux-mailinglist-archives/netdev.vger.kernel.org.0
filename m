Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B6DB594E
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 03:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfIRBfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 21:35:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2289 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726829AbfIRBfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 21:35:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8C5E06666C79ED21B93B;
        Wed, 18 Sep 2019 09:35:02 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Sep 2019
 09:34:57 +0800
Message-ID: <5D8189C0.3070107@huawei.com>
Date:   Wed, 18 Sep 2019 09:34:56 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESENT PATCH v2] ixgbe: Use memzero_explicit directly in crypto
 cases
References: <1568731462-46758-1-git-send-email-zhongjiang@huawei.com> <20190917111107.307295c6@cakuba.netronome.com>
In-Reply-To: <20190917111107.307295c6@cakuba.netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/18 2:11, Jakub Kicinski wrote:
> On Tue, 17 Sep 2019 22:44:22 +0800, zhong jiang wrote:
>> It's better to use memzero_explicit() to replace memset() in crypto cases.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> Thank you for the follow up! Your previous patch to use kzfree() 
> has been applied on its own merit, could you rebase this one on top 
> of current net-next/master?
I will do that.

Thanks,
zhong jiang
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> index 31629fc..7e4f32f 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> @@ -960,10 +960,10 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>>  	return 0;
>>  
>>  err_aead:
>> -	memset(xs->aead, 0, sizeof(*xs->aead));
>> +	memzero_explicit(xs->aead, sizeof(*xs->aead));
>>  	kfree(xs->aead);
>>  err_xs:
>> -	memset(xs, 0, sizeof(*xs));
>> +	memzero_explicit(xs, sizeof(*xs));
>>  	kfree(xs);
>>  err_out:
>>  	msgbuf[1] = err;
>> @@ -1049,7 +1049,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>>  	ixgbe_ipsec_del_sa(xs);
>>  
>>  	/* remove the xs that was made-up in the add request */
>> -	memset(xs, 0, sizeof(*xs));
>> +	memzero_explicit(xs, sizeof(*xs));
>>  	kfree(xs);
>>  
>>  	return 0;
>
> .
>


