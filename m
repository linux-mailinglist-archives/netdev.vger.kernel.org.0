Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9BA6CF8D2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjC3Bqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjC3Bqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:46:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9824EEF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680140745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kv0JdKs3b/J2KtWtqtGbcl417IkaIZ3v3L6FuRPDYCY=;
        b=h/Uqi4yGR08up02Zp61RPKEXUyJbWh7djpHoEcS1vpEhk5cFUREN3od4Xp+SOdecmDEp++
        uRgLPTR3Yt7sFw0/BDaNmO/dn5DO0A+6D1F3gB53VMxX1BYQ7LoJ6B7eRRcmnLeH68Ig62
        AKn6DIFn+JwzjwWji6sVZEp/xxaVCdA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-2Z1y8UzaMBOtwvn0L1_TZw-1; Wed, 29 Mar 2023 21:45:44 -0400
X-MC-Unique: 2Z1y8UzaMBOtwvn0L1_TZw-1
Received: by mail-pg1-f199.google.com with SMTP id h8-20020a654688000000b0050fa9ced8e3so4828252pgr.18
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680140743;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kv0JdKs3b/J2KtWtqtGbcl417IkaIZ3v3L6FuRPDYCY=;
        b=4a7zJYq8JjVnSN94ZZvyzqqk70nW22BFt/yoEmTmuIwEOoZ4IWkLE6CMjKK0Gxn4L0
         j3FXOMZkoEELhrtD7E6SIFhWJ8Sm6ePvwHPfOu2BMaZeMSw4lU29K55n74MfwT8XfCAJ
         su5ARII8K3xoouxUh6vgYxIGVeQ6VeoJtOhBz2Rz4rZ7PLx8OYeJ281zzA6GsHWLXeCC
         vw6DDiI/h338hDZpDI5zlgWlNmFjdsTVk76fs65gbv9xkIghvGi3thgf+XEQrMCQMYAD
         +I2itvGg4qB9vAOj1PenFa3nxwQhWuLksX6r/A980SOSMLJ4bBdBtMUkexOBDLI02H2i
         IdXA==
X-Gm-Message-State: AAQBX9fbnZActRCyD1PjOugHilk/WDpx/RvKam0pFXMSbXN/EQSxTBtV
        PFnFdTLMK8drUM4pK9H/8WpMFWsbVJYnxxA4zfTJLmvyX3HhQ4OIOBWe3JILUmjBSRhGWQoNdMd
        bLVMg+pYWAbZXQhD0
X-Received: by 2002:a17:903:22d2:b0:19a:7217:32a9 with SMTP id y18-20020a17090322d200b0019a721732a9mr4636116plg.26.1680140743028;
        Wed, 29 Mar 2023 18:45:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZC7R/sqsXLmXMgRh5yYmDYt07re8Mz0pqFOB7hKr/eVqrBonJ1fWeZySGpK6QRntg/4jjpKg==
X-Received: by 2002:a17:903:22d2:b0:19a:7217:32a9 with SMTP id y18-20020a17090322d200b0019a721732a9mr4636092plg.26.1680140742679;
        Wed, 29 Mar 2023 18:45:42 -0700 (PDT)
Received: from [10.72.12.51] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jj2-20020a170903048200b0019fea4bb887sm23709042plb.157.2023.03.29.18.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 18:45:42 -0700 (PDT)
Message-ID: <7f7947d6-2a03-688b-dc5e-3887553f0106@redhat.com>
Date:   Thu, 30 Mar 2023 09:45:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v2 37/48] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather
 than sendpage()
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-38-dhowells@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230329141354.516864-38-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

BTW, will this two patch depend on the others in this patch series ?

I am planing to run a test with these two later.

Thanks

- Xiubo

On 29/03/2023 22:13, David Howells wrote:
> Use sendmsg() and MSG_SPLICE_PAGES rather than sendpage in ceph when
> transmitting data.  For the moment, this can only transmit one page at a
> time because of the architecture of net/ceph/, but if
> write_partial_message_data() can be given a bvec[] at a time by the
> iteration code, this would allow pages to be sent in a batch.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Ilya Dryomov <idryomov@gmail.com>
> cc: Xiubo Li <xiubli@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: ceph-devel@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>   net/ceph/messenger_v2.c | 89 +++++++++--------------------------------
>   1 file changed, 18 insertions(+), 71 deletions(-)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 301a991dc6a6..1637a0c21126 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -117,91 +117,38 @@ static int ceph_tcp_recv(struct ceph_connection *con)
>   	return ret;
>   }
>   
> -static int do_sendmsg(struct socket *sock, struct iov_iter *it)
> -{
> -	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
> -	int ret;
> -
> -	msg.msg_iter = *it;
> -	while (iov_iter_count(it)) {
> -		ret = sock_sendmsg(sock, &msg);
> -		if (ret <= 0) {
> -			if (ret == -EAGAIN)
> -				ret = 0;
> -			return ret;
> -		}
> -
> -		iov_iter_advance(it, ret);
> -	}
> -
> -	WARN_ON(msg_data_left(&msg));
> -	return 1;
> -}
> -
> -static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
> -{
> -	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
> -	struct bio_vec bv;
> -	int ret;
> -
> -	if (WARN_ON(!iov_iter_is_bvec(it)))
> -		return -EINVAL;
> -
> -	while (iov_iter_count(it)) {
> -		/* iov_iter_iovec() for ITER_BVEC */
> -		bvec_set_page(&bv, it->bvec->bv_page,
> -			      min(iov_iter_count(it),
> -				  it->bvec->bv_len - it->iov_offset),
> -			      it->bvec->bv_offset + it->iov_offset);
> -
> -		/*
> -		 * sendpage cannot properly handle pages with
> -		 * page_count == 0, we need to fall back to sendmsg if
> -		 * that's the case.
> -		 *
> -		 * Same goes for slab pages: skb_can_coalesce() allows
> -		 * coalescing neighboring slab objects into a single frag
> -		 * which triggers one of hardened usercopy checks.
> -		 */
> -		if (sendpage_ok(bv.bv_page)) {
> -			ret = sock->ops->sendpage(sock, bv.bv_page,
> -						  bv.bv_offset, bv.bv_len,
> -						  CEPH_MSG_FLAGS);
> -		} else {
> -			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bv, 1, bv.bv_len);
> -			ret = sock_sendmsg(sock, &msg);
> -		}
> -		if (ret <= 0) {
> -			if (ret == -EAGAIN)
> -				ret = 0;
> -			return ret;
> -		}
> -
> -		iov_iter_advance(it, ret);
> -	}
> -
> -	return 1;
> -}
> -
>   /*
>    * Write as much as possible.  The socket is expected to be corked,
>    * so we don't bother with MSG_MORE/MSG_SENDPAGE_NOTLAST here.
>    *
>    * Return:
> - *   1 - done, nothing (else) to write
> + *  >0 - done, nothing (else) to write
>    *   0 - socket is full, need to wait
>    *  <0 - error
>    */
>   static int ceph_tcp_send(struct ceph_connection *con)
>   {
> +	struct msghdr msg = {
> +		.msg_iter	= con->v2.out_iter,
> +		.msg_flags	= CEPH_MSG_FLAGS,
> +	};
>   	int ret;
>   
> +	if (WARN_ON(!iov_iter_is_bvec(&con->v2.out_iter)))
> +		return -EINVAL;
> +
> +	if (con->v2.out_iter_sendpage)
> +		msg.msg_flags |= MSG_SPLICE_PAGES;
> +
>   	dout("%s con %p have %zu try_sendpage %d\n", __func__, con,
>   	     iov_iter_count(&con->v2.out_iter), con->v2.out_iter_sendpage);
> -	if (con->v2.out_iter_sendpage)
> -		ret = do_try_sendpage(con->sock, &con->v2.out_iter);
> -	else
> -		ret = do_sendmsg(con->sock, &con->v2.out_iter);
> +
> +	ret = sock_sendmsg(con->sock, &msg);
> +	if (ret > 0)
> +		iov_iter_advance(&con->v2.out_iter, ret);
> +	else if (ret == -EAGAIN)
> +		ret = 0;
> +
>   	dout("%s con %p ret %d left %zu\n", __func__, con, ret,
>   	     iov_iter_count(&con->v2.out_iter));
>   	return ret;
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

