Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC32CE7EE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 07:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgLDGM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 01:12:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgLDGM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 01:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607062261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K6cl8v35kD3r2OrOVTITYaEa1kSQSETMLTfEcRh66X8=;
        b=Ub5ASrhVPR5MeT92EpJqDLxfD6Fz981zH/wLAEFRSTn+5UoDq0+PnCyzRNiOnRw19Wn1Iz
        FhMSeMp8Au3bbU8KSLFnC50zRVKGDx86CeflI+LhSc908fjOKigKOyTuPeguftHcFLkl5X
        pLozQVr3qUgZTy0JtuLxRBrkncd3f+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-QxIfXreNMzOXDqnIx16k4g-1; Fri, 04 Dec 2020 01:10:59 -0500
X-MC-Unique: QxIfXreNMzOXDqnIx16k4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17ACD1005513;
        Fri,  4 Dec 2020 06:10:58 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C5A22998C;
        Fri,  4 Dec 2020 06:10:49 +0000 (UTC)
Subject: Re: [PATCH net-next] tun: fix ubuf refcount incorrectly on error path
To:     wangyunjian <wangyunjian@huawei.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jerry.lilijun@huawei.com, xudingke@huawei.com
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <094f1828-9a73-033e-b1ca-43b73588d22b@redhat.com>
Date:   Fri, 4 Dec 2020 14:10:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/3 下午4:00, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> After setting callback for ubuf_info of skb, the callback
> (vhost_net_zerocopy_callback) will be called to decrease
> the refcount when freeing skb. But when an exception occurs
> afterwards, the error handling in vhost handle_tx() will
> try to decrease the same refcount again. This is wrong and
> fix this by clearing ubuf_info when meeting errors.
>
> Fixes: 4477138fa0ae ("tun: properly test for IFF_UP")
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   drivers/net/tun.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2dc1988a8973..3614bb1b6d35 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1861,6 +1861,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   	if (unlikely(!(tun->dev->flags & IFF_UP))) {
>   		err = -EIO;
>   		rcu_read_unlock();
> +		if (zerocopy) {
> +			skb_shinfo(skb)->destructor_arg = NULL;
> +			skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
> +			skb_shinfo(skb)->tx_flags &= ~SKBTX_SHARED_FRAG;
> +		}
> +
>   		goto drop;
>   	}
>   
> @@ -1874,6 +1880,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   
>   		if (unlikely(headlen > skb_headlen(skb))) {
>   			atomic_long_inc(&tun->dev->rx_dropped);
> +			if (zerocopy) {
> +				skb_shinfo(skb)->destructor_arg = NULL;
> +				skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
> +				skb_shinfo(skb)->tx_flags &= ~SKBTX_SHARED_FRAG;
> +			}
>   			napi_free_frags(&tfile->napi);
>   			rcu_read_unlock();
>   			mutex_unlock(&tfile->napi_mutex);


It looks to me then we miss the failure feedback.

The issues comes from the inconsistent error handling in tun.

I wonder whether we can simply do uarg->callback(uarg, false) if 
necessary on every failture path on tun_get_user().

Note that, zerocopy has a lot of issues which makes it not good for 
production environment.

Thanks

