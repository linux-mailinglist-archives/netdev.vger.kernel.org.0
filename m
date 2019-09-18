Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBCCB59D6
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 04:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfIRCoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 22:44:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfIRCoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 22:44:08 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 68AE4E6E50814466AB12;
        Wed, 18 Sep 2019 10:44:06 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Sep 2019
 10:44:00 +0800
Message-ID: <5D8199EF.8050402@huawei.com>
Date:   Wed, 18 Sep 2019 10:43:59 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     zhong jiang <zhongjiang@huawei.com>
CC:     <jakub.kicinski@netronome.com>, <davem@davemloft.net>,
        <anna.schumaker@netapp.com>, <trond.myklebust@hammerspace.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ixgbe: Use memzero_explicit directly in crypto
 cases
References: <1568774195-8677-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1568774195-8677-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/18 10:36, zhong jiang wrote:
> In general, Use kzfree() to replace memset() + kfree() is feasible and
> resonable.  But It's btter to use memzero_explicit() to replace memset()
> in crypto cases.
s/btter/better/,  will repost.   sorry for that.

Thanks,
zhong jiang
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index 113f608..7e4f32f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -960,9 +960,11 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>  	return 0;
>  
>  err_aead:
> -	kzfree(xs->aead);
> +	memzero_explicit(xs->aead, sizeof(*xs->aead));
> +	kfree(xs->aead);
>  err_xs:
> -	kzfree(xs);
> +	memzero_explicit(xs, sizeof(*xs));
> +	kfree(xs);
>  err_out:
>  	msgbuf[1] = err;
>  	return err;
> @@ -1047,7 +1049,8 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>  	ixgbe_ipsec_del_sa(xs);
>  
>  	/* remove the xs that was made-up in the add request */
> -	kzfree(xs);
> +	memzero_explicit(xs, sizeof(*xs));
> +	kfree(xs);
>  
>  	return 0;
>  }


