Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C263968D05B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjBGHP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjBGHPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:15:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AA124C88;
        Mon,  6 Feb 2023 23:15:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA16A611E8;
        Tue,  7 Feb 2023 07:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A01EC4339B;
        Tue,  7 Feb 2023 07:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675754123;
        bh=wNQjwdK15FXh9HTrc5d8/2sCHtqiGYRQR9hC1nMBBW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ffaekIfNdCRVolL7UPKKhPAR0q8Q4s2zxVxjd8GwpTVMEUysshwPqmrV+kwCmkI6n
         ykixmXpu/HdrFMpDOOSyFucp5wv3LfOi1lIAzqLy1pTBwn7hFz0ajTCMey+NUj6s90
         xo7tzuFRR5a5nGykzC33W8+HV3mwECslyRC+wqPRuIv7rp5DYYVpIF/s10pZx+fww0
         EfR38D/2IWmf4MtjEh68oNRqzo1jMXf4ONDgO2g7CzrKUm/oShmHMbSZlOH0FaDP3i
         Li0qeV0dGAsJyZ5HPIaYN5xatDQqRcoQaeV9EncHTA2Y3D0ekY08hHmx9r0Z5jtFLj
         MDo0l9BNdaUVg==
Date:   Mon, 6 Feb 2023 23:15:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [PATCH 8/17] tls: Only use data field in crypto completion
 function
Message-ID: <20230206231521.712f53e5@kernel.org>
In-Reply-To: <E1pOydn-007zi3-LG@formenos.hmeau.com>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
        <E1pOydn-007zi3-LG@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Feb 2023 18:22:27 +0800 Herbert Xu wrote:
> -static void tls_encrypt_done(struct crypto_async_request *req, int err)
> +static void tls_encrypt_done(crypto_completion_data_t *data, int err)
>  {
> -	struct aead_request *aead_req = (struct aead_request *)req;
> -	struct sock *sk = req->data;
> -	struct tls_context *tls_ctx = tls_get_ctx(sk);
> -	struct tls_prot_info *prot = &tls_ctx->prot_info;
> -	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
> +	struct aead_request *aead_req = crypto_get_completion_data(data);

All we use aead_req for in this function now is to find rec...

> +	struct tls_sw_context_tx *ctx;
> +	struct tls_context *tls_ctx;
> +	struct tls_prot_info *prot;
>  	struct scatterlist *sge;
>  	struct sk_msg *msg_en;
>  	struct tls_rec *rec;
>  	bool ready = false;
> +	struct sock *sk;
>  	int pending;
>  
>  	rec = container_of(aead_req, struct tls_rec, aead_req);
>  	msg_en = &rec->msg_encrypted;
>  
> +	sk = rec->sk;
> +	tls_ctx = tls_get_ctx(sk);
> +	prot = &tls_ctx->prot_info;
> +	ctx = tls_sw_ctx_tx(tls_ctx);
> +
>  	sge = sk_msg_elem(msg_en, msg_en->sg.curr);
>  	sge->offset -= prot->prepend_size;
>  	sge->length += prot->prepend_size;
> @@ -520,7 +536,7 @@ static int tls_do_encryption(struct sock *sk,
>  			       data_len, rec->iv_data);
>  
>  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -				  tls_encrypt_done, sk);
> +				  tls_encrypt_done, aead_req);

... let's just pass rec instead of aead_req here, then?

>  	/* Add the record in tx_list */
>  	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
