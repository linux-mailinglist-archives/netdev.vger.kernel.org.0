Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6212A673D43
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjASPQM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Jan 2023 10:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjASPQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:16:11 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF916676DD
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:16:05 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-qKO8TiLtPfCZE6v-b5yWOg-1; Thu, 19 Jan 2023 10:15:46 -0500
X-MC-Unique: qKO8TiLtPfCZE6v-b5yWOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CA9A3C38FFD;
        Thu, 19 Jan 2023 15:15:46 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CA602166B2A;
        Thu, 19 Jan 2023 15:15:44 +0000 (UTC)
Date:   Thu, 19 Jan 2023 16:14:14 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Frantisek Krenzelok <fkrenzel@redhat.com>
Subject: Re: [PATCH net-next 3/5] tls: implement rekey for TLS1.3
Message-ID: <Y8leRmSlHJK0zfCR@hog>
References: <cover.1673952268.git.sd@queasysnail.net>
 <34e782b6d4f2e611ac8ba380bcf7ca56c40fc52f.1673952268.git.sd@queasysnail.net>
 <39c2c143-e37c-f77a-0802-a187257d5053@novek.ru>
MIME-Version: 1.0
In-Reply-To: <39c2c143-e37c-f77a-0802-a187257d5053@novek.ru>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-18, 23:10:18 +0000, Vadim Fedorenko wrote:
> On 17.01.2023 13:45, Sabrina Dubroca wrote:
> > @@ -687,9 +690,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> >   		alt_crypto_info = &ctx->crypto_send.info;
> >   	}
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
> > +		update = true;
> > +		old_crypto_info = crypto_info;
> > +		crypto_info = &tmp.info;
> > +	}
> >   	rc = copy_from_sockptr(crypto_info, optval, sizeof(*crypto_info));
> >   	if (rc) {
> > @@ -704,6 +715,15 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
> >   		goto err_crypto_info;
> >   	}
> > +	if (update) {
> > +		/* Ensure that TLS version and ciphers are not modified */
> > +		if (crypto_info->version != old_crypto_info->version ||
> > +		    crypto_info->cipher_type != old_crypto_info->cipher_type) {
> > +			rc = -EINVAL;
> > +			goto err_crypto_info;
> > +		}
> > +	}
> > +
> 
> looks like these checks can be moved up to TLS_CRYPTO_INFO_READY scope and
> there will be no need for extra variables.

I don't see how to do that cleanly. I'd have to duplicate the
copy_from_sockptr, which IMHO looks a lot worse. Is there another way?

> >   	/* Ensure that TLS version and ciphers are same in both directions */
> >   	if (TLS_CRYPTO_INFO_READY(alt_crypto_info)) {
> >   		if (alt_crypto_info->version != crypto_info->version ||

[...]
> > @@ -2794,12 +2852,14 @@ int tls_set_sw_offload(struct sock *sk, int tx)
> >   	kfree(cctx->iv);
> >   	cctx->iv = NULL;
> >   free_priv:
> > -	if (tx) {
> > -		kfree(ctx->priv_ctx_tx);
> > -		ctx->priv_ctx_tx = NULL;
> > -	} else {
> > -		kfree(ctx->priv_ctx_rx);
> > -		ctx->priv_ctx_rx = NULL;
> > +	if (!new_crypto_info) {
> > +		if (tx) {
> > +			kfree(ctx->priv_ctx_tx);
> > +			ctx->priv_ctx_tx = NULL;
> > +		} else {
> > +			kfree(ctx->priv_ctx_rx);
> > +			ctx->priv_ctx_rx = NULL;
> > +		}
> >   	}
> >   out:
> >   	return rc;
> 
> I think we can avoid extra parameter and extra level of if{} constructions
> by checking if iv and rec_seq is already allocated and adjust init part the
> same way. I don't think we have to have separate error path because in case
> of any error during rekey procedure the connection becomes useless and
> application should indicate error to the other end. The code copies new
> crypto info to the current storage, so it assumes that all fields a properly
> filled and that means that this copy can be done earlier and use the same
> code path as first init code.

Rekey could fail because of memory allocation failures during
crypto_aead_setkey. Userspace could choose to retry the key update,
and we shouldn't necessarily kill off the connection in that case.

I think we need to keep the init/update distinction in the error paths
for tls_set_sw_offload and do_tls_setsockopt_conf, otherwise we clear
the crypto_info from the context and a new attempt to do the rekey
will run through the full init path instead of the rekey path.

We could set crypto_info in tls_context before calling
tls_set_sw_offload, but do_tls_setsockopt_conf would still have some
differences since we need to validate that the version/cipher hasn't
changed. I'll give that a try and see how much that improves
things. It should reduce the churn a bit.

Thanks

-- 
Sabrina

