Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E72671A7C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjARLYo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Jan 2023 06:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjARLYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:24:30 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906CD3A82
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:40:10 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-qxd-83CDNF25Ise4zAmm0g-1; Wed, 18 Jan 2023 05:40:08 -0500
X-MC-Unique: qxd-83CDNF25Ise4zAmm0g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8F4F3C0ED4C;
        Wed, 18 Jan 2023 10:40:07 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00AAA492C14;
        Wed, 18 Jan 2023 10:40:06 +0000 (UTC)
Date:   Wed, 18 Jan 2023 11:38:38 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     fkrenzel@redhat.com, netdev@vger.kernel.org, apoorvko@amazon.com
Subject: Re: [PATCH net-next 3/5] tls: implement rekey for TLS1.3
Message-ID: <Y8fMLtYmlIw2wfMM@hog>
References: <34e782b6d4f2e611ac8ba380bcf7ca56c40fc52f.1673952268.git.sd@queasysnail.net>
 <20230117231633.21410-1-kuniyu@amazon.com>
MIME-Version: 1.0
In-Reply-To: <20230117231633.21410-1-kuniyu@amazon.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-17, 15:16:33 -0800, Kuniyuki Iwashima wrote:
> Hi,
> 
> Thanks for posting this series!
> We were working on the same feature.
> CC Apoorv from s2n team.

Ah, cool. Does the behavior in those patches match what your
implementation?

[...]
> > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > index fb1da1780f50..9be82aecd13e 100644
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -669,9 +669,12 @@ static int tls_getsockopt(struct sock *sk, int level, int optname,
> >  static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> >  				  unsigned int optlen, int tx)
> >  {
> > +	union tls_crypto_context tmp = {};
> > +	struct tls_crypto_info *old_crypto_info = NULL;
> >  	struct tls_crypto_info *crypto_info;
> >  	struct tls_crypto_info *alt_crypto_info;
> >  	struct tls_context *ctx = tls_get_ctx(sk);
> > +	bool update = false;
> >  	size_t optsize;
> >  	int rc = 0;
> >  	int conf;
> > @@ -687,9 +690,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> >  		alt_crypto_info = &ctx->crypto_send.info;
> >  	}
> >  
> > -	/* Currently we don't support set crypto info more than one time */
> > -	if (TLS_CRYPTO_INFO_READY(crypto_info))
> > -		return -EBUSY;
> > +	if (TLS_CRYPTO_INFO_READY(crypto_info)) {
> > +		/* Currently we only support setting crypto info more
> > +		 * than one time for TLS 1.3
> > +		 */
> > +		if (crypto_info->version != TLS_1_3_VERSION)
> > +			return -EBUSY;
> > +
> 
> Should we check this ?
> 
>                 if (!tx && !key_update_pending)
>                         return -EBUSY;
> 
> Otherwise we can set a new RX key even if the other end has not sent
> KeyUpdateRequest.

Maybe. My thinking was "let userspace shoot itself in the foot if it
wants".

> > +		update = true;
> > +		old_crypto_info = crypto_info;
> > +		crypto_info = &tmp.info;
> > +	}
> >  
> >  	rc = copy_from_sockptr(crypto_info, optval, sizeof(*crypto_info));
> >  	if (rc) {
> > @@ -704,6 +715,15 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> >  		goto err_crypto_info;
> >  	}
> >  
> > +	if (update) {
> > +		/* Ensure that TLS version and ciphers are not modified */
> > +		if (crypto_info->version != old_crypto_info->version ||
> > +		    crypto_info->cipher_type != old_crypto_info->cipher_type) {
> > +			rc = -EINVAL;
> > +			goto err_crypto_info;
> > +		}
> > +	}
> > +
> >  	/* Ensure that TLS version and ciphers are same in both directions */
> >  	if (TLS_CRYPTO_INFO_READY(alt_crypto_info)) {
> 
> We can change this to else-if.

Ok.

> >  		if (alt_crypto_info->version != crypto_info->version ||
[...]
> > @@ -2517,9 +2525,28 @@ int tls_set_sw_offload(struct sock *sk, int tx)
> >  	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
> >  	struct crypto_tfm *tfm;
> >  	char *iv, *rec_seq, *key, *salt, *cipher_name;
> > -	size_t keysize;
> > +	size_t keysize, crypto_info_size;
> >  	int rc = 0;
> >  
> > +	if (new_crypto_info) {
> > +		/* non-NULL new_crypto_info means rekey */
> > +		src_crypto_info = new_crypto_info;
> > +		if (tx) {
> > +			sw_ctx_tx = ctx->priv_ctx_tx;
> > +			crypto_info = &ctx->crypto_send.info;
> > +			cctx = &ctx->tx;
> > +			aead = &sw_ctx_tx->aead_send;
> > +			sw_ctx_tx = NULL;
> 
> sw_ctx_tx is already initialised.

No, it was NULL at the beginning of the function, but then I used it
to set aead on the previous line, so I need to clear it again. I could
use a temp variable instead if you think it's better.

> > +		} else {
> > +			sw_ctx_rx = ctx->priv_ctx_rx;
> > +			crypto_info = &ctx->crypto_recv.info;
> > +			cctx = &ctx->rx;
> > +			aead = &sw_ctx_rx->aead_recv;
> > +			sw_ctx_rx = NULL;
> 
> Same here.
> 
> 
> > +		}
> > +		goto skip_init;
> > +	}
> > +
> >  	if (tx) {
> >  		if (!ctx->priv_ctx_tx) {
> >  			sw_ctx_tx = kzalloc(sizeof(*sw_ctx_tx), GFP_KERNEL);

Thanks for the comments.

-- 
Sabrina

