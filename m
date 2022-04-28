Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCCD513E63
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352256AbiD1WPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 18:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245263AbiD1WPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 18:15:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1D2BE9C3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE9F6201F
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 22:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3C8C385A9;
        Thu, 28 Apr 2022 22:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651183904;
        bh=7kLbvxPiENyz5gBlFxqaBcL0+qMcSJcYms5pdXzgkxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kthqz4z+EbPv2A13nBJuhSgmZ2JxYFLyP8BVLIWEVZJWEteln5oBjS1w+V3JpbI50
         K2JIf1c08TXOcCUs7AP7ikjJ2rclBDDPwxD5KfOtIu1F4JswwPtfkjNKyYm6NNiaTT
         XhSrvRTvVlxYUF0pgZok8IKdS0mloV2THqWbqvsyIZ6CcA210K+DzWSScs4d/EFSPv
         EkycYa22z9YK99UxwFFSqFk8VM5RJbBZeAgbnnXHRzDIZXbve7dB+VxECVvw8gPLYK
         ZkjQY5FtdkueED/V2YF+3Pc4VNCWdBJE/98e7U4lqCvCSXyGzrG9lyT6W+gJ20KyjI
         lFOGH4mwaaGDA==
Date:   Thu, 28 Apr 2022 15:11:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Message-ID: <20220428151142.3f0ccd83@kernel.org>
In-Reply-To: <20220427175048.225235-1-maximmi@nvidia.com>
References: <20220427175048.225235-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index b12f81a2b44c..715401b20c8b 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -411,10 +411,16 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
>  	return 0;
>  }
>  
> +union tls_iter_offset {
> +	struct iov_iter *msg_iter;
> +	int offset;
> +};

Is this sort of atrocity used elsewhere in the kernel?
If you can't refactor the code you can pack args into 
a structure but I've not seen people cast mutually exclusive 
arguments to a union type. Is this "inspired" by some higher
level language?

>  static int tls_push_data(struct sock *sk,
> -			 struct iov_iter *msg_iter,
> +			 union tls_iter_offset iter_offset,
>  			 size_t size, int flags,
> -			 unsigned char record_type)
> +			 unsigned char record_type,
> +			 struct page *zc_page)
>  {
>  	struct tls_context *tls_ctx = tls_get_ctx(sk);
>  	struct tls_prot_info *prot = &tls_ctx->prot_info;
> @@ -480,15 +486,29 @@ static int tls_push_data(struct sock *sk,
>  		}
>  
>  		record = ctx->open_record;
> -		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
> -		copy = min_t(size_t, copy, (max_open_record_len - record->len));
> -
> -		if (copy) {
> -			rc = tls_device_copy_data(page_address(pfrag->page) +
> -						  pfrag->offset, copy, msg_iter);
> -			if (rc)
> -				goto handle_error;
> -			tls_append_frag(record, pfrag, copy);
> +
> +		if (!zc_page) {
> +			copy = min_t(size_t, size, pfrag->size - pfrag->offset);
> +			copy = min_t(size_t, copy, max_open_record_len - record->len);

Nope, refactor this please. 95% sure you don't need 4 indentation
levels here. Space left in record can be calculated before the if,
then you can do

if (zc_page) {
	..
} else if (copy) {
	..
}

> +			if (copy) {
> +				rc = tls_device_copy_data(page_address(pfrag->page) +
> +							  pfrag->offset, copy,
> +							  iter_offset.msg_iter);
> +				if (rc)
> +					goto handle_error;
> +				tls_append_frag(record, pfrag, copy);
> +			}
> +		} else {
> +			copy = min_t(size_t, size, max_open_record_len - record->len);
> +			if (copy) {
> +				struct page_frag _pfrag;

And name your variables right :/

> +				_pfrag.page = zc_page;
> +				_pfrag.offset = iter_offset.offset;
> +				_pfrag.size = copy;
> +				tls_append_frag(record, &_pfrag, copy);
> +			}
>  		}

>  		size -= copy;
> @@ -551,8 +571,8 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  			goto out;
>  	}
>  
> -	rc = tls_push_data(sk, &msg->msg_iter, size,
> -			   msg->msg_flags, record_type);
> +	rc = tls_push_data(sk, (union tls_iter_offset)&msg->msg_iter, size,
> +			   msg->msg_flags, record_type, NULL);
>  
>  out:
>  	release_sock(sk);
> @@ -564,11 +584,14 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
>  			int offset, size_t size, int flags)
>  {
>  	struct tls_context *tls_ctx = tls_get_ctx(sk);
> +	struct tls_offload_context_tx *ctx;
>  	struct iov_iter	msg_iter;
>  	char *kaddr;
>  	struct kvec iov;
>  	int rc;
>  
> +	ctx = tls_offload_ctx_tx(tls_ctx);
> +
>  	if (flags & MSG_SENDPAGE_NOTLAST)
>  		flags |= MSG_MORE;
>  
> @@ -580,12 +603,18 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
>  		goto out;
>  	}
>  
> +	if (ctx->zerocopy_sendfile) {
> +		rc = tls_push_data(sk, (union tls_iter_offset)offset, size,
> +				   flags, TLS_RECORD_TYPE_DATA, page);
> +		goto out;
> +	}
> +
>  	kaddr = kmap(page);
>  	iov.iov_base = kaddr + offset;
>  	iov.iov_len = size;
>  	iov_iter_kvec(&msg_iter, WRITE, &iov, 1, size);
> -	rc = tls_push_data(sk, &msg_iter, size,
> -			   flags, TLS_RECORD_TYPE_DATA);
> +	rc = tls_push_data(sk, (union tls_iter_offset)&msg_iter, size,
> +			   flags, TLS_RECORD_TYPE_DATA, NULL);
>  	kunmap(page);
>  
>  out:
> @@ -659,7 +688,8 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
>  	struct iov_iter	msg_iter;
>  
>  	iov_iter_kvec(&msg_iter, WRITE, NULL, 0, 0);
> -	return tls_push_data(sk, &msg_iter, 0, flags, TLS_RECORD_TYPE_DATA);
> +	return tls_push_data(sk, (union tls_iter_offset)&msg_iter, 0, flags,
> +			     TLS_RECORD_TYPE_DATA, NULL);
>  }
>  
>  void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 7b2b0e7ffee4..8ef86e04f571 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -513,6 +513,31 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
>  	return rc;
>  }
>  
> +static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
> +				   int __user *optlen)
> +{
> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
> +	struct tls_offload_context_tx *ctx;
> +	int len, value;
> +
> +	if (get_user(len, optlen))
> +		return -EFAULT;
> +
> +	if (len != sizeof(value))

the size check should match the one in setsockopt()

> +		return -EINVAL;
> +
> +	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
> +		return -EBUSY;

see setsockopt()

> +	ctx = tls_offload_ctx_tx(tls_ctx);
> +
> +	value = ctx->zerocopy_sendfile;
> +	if (copy_to_user(optval, &value, sizeof(value)))
> +		return -EFAULT;
> +
> +	return 0;
> +}

> +static int do_tls_setsockopt_tx_zc(struct sock *sk, sockptr_t optval,
> +				   unsigned int optlen)
> +{
> +	struct tls_context *tls_ctx = tls_get_ctx(sk);

Highly annoying but each file has its own scheme of naming variables,
tls_main uses ctx for tls_context.

> +	struct tls_offload_context_tx *ctx;
> +	int val;

unsigned

> +	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)

How's tls_ctx ever gonna be NULL here?

We should allow setting the option for non-HW. It's an opt-in, the app
has opted in, the fact that the kernel will not make use of the liberty
to apply the optimization is not important, no?

> +		return -EINVAL;
> +
> +	if (sockptr_is_null(optval) || optlen < sizeof(val))
> +		return -EINVAL;
> +
> +	if (copy_from_sockptr(&val, optval, sizeof(val)))
> +		return -EFAULT;
> +
> +	ctx = tls_offload_ctx_tx(tls_ctx);
> +	ctx->zerocopy_sendfile = val;

if (val > 1)
	EINVAL.

> +	return 0;
> +}
