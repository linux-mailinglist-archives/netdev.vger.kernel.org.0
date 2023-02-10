Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E019E6915CF
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjBJAnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBJAm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:42:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CE01714;
        Thu,  9 Feb 2023 16:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325B661C3F;
        Fri, 10 Feb 2023 00:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFAFC433D2;
        Fri, 10 Feb 2023 00:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675989777;
        bh=DrfroG57bw7I/Hug/gFPWI+CVSjf/sAQ4JTQKG9YKdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FxAt3XYXezGq3GrfQSXOup2s6vNnERStSQDTnfQZyX4on/gXFNhFER5/5HrNFwMML
         Rfc6VgRaVFBE+amuE8DG0QaNIv/dcRfvu8l5Jrd1pV6Zz5wSoLXcLWARbZAbdoTFu+
         3pdZn7Io6lKK4WmwoFP2m6rs0MhEhwN2Ipy49jO8G+u3NUV1yN3gOHlncZThFr82ZL
         oIDC978IoCKLGDahrAxTF85NCREfWYYVSh8jX0OIF+bPQhuAk/B0BajtFyTCTwX6Q+
         +H9HxL9nR6VHjYNcVSc1Y/+x1sGRShZrjGTtmQyQyiTGqQnOWe0npksVs+Dfp5PScM
         wEUai/C8opP7A==
Date:   Fri, 10 Feb 2023 02:42:55 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Subject: Re: [PATCH 3/17] fs: ecryptfs: Use crypto_wait_req
Message-ID: <Y+WTD3TrxaJOPdRg@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydd-007zgo-4c@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pOydd-007zgo-4c@formenos.hmeau.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:22:17PM +0800, Herbert Xu wrote:
> This patch replaces the custom crypto completion function with
> crypto_req_done.

nit: "Replace the custom crypto ..."

> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  fs/ecryptfs/crypto.c |   30 +++---------------------------
>  1 file changed, 3 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index e3f5d7f3c8a0..c3057539f088 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -260,22 +260,6 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
>  	return i;
>  }
>  
> -struct extent_crypt_result {
> -	struct completion completion;
> -	int rc;
> -};
> -
> -static void extent_crypt_complete(struct crypto_async_request *req, int rc)
> -{
> -	struct extent_crypt_result *ecr = req->data;
> -
> -	if (rc == -EINPROGRESS)
> -		return;
> -
> -	ecr->rc = rc;
> -	complete(&ecr->completion);
> -}
> -
>  /**
>   * crypt_scatterlist
>   * @crypt_stat: Pointer to the crypt_stat struct to initialize.
> @@ -293,7 +277,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  			     unsigned char *iv, int op)
>  {
>  	struct skcipher_request *req = NULL;
> -	struct extent_crypt_result ecr;
> +	DECLARE_CRYPTO_WAIT(ecr);
>  	int rc = 0;
>  
>  	if (unlikely(ecryptfs_verbosity > 0)) {
> @@ -303,8 +287,6 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  				  crypt_stat->key_size);
>  	}
>  
> -	init_completion(&ecr.completion);
> -
>  	mutex_lock(&crypt_stat->cs_tfm_mutex);
>  	req = skcipher_request_alloc(crypt_stat->tfm, GFP_NOFS);
>  	if (!req) {
> @@ -315,7 +297,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  
>  	skcipher_request_set_callback(req,
>  			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
> -			extent_crypt_complete, &ecr);
> +			crypto_req_done, &ecr);
>  	/* Consider doing this once, when the file is opened */
>  	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
>  		rc = crypto_skcipher_setkey(crypt_stat->tfm, crypt_stat->key,
> @@ -334,13 +316,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  	skcipher_request_set_crypt(req, src_sg, dst_sg, size, iv);
>  	rc = op == ENCRYPT ? crypto_skcipher_encrypt(req) :
>  			     crypto_skcipher_decrypt(req);
> -	if (rc == -EINPROGRESS || rc == -EBUSY) {
> -		struct extent_crypt_result *ecr = req->base.data;
> -
> -		wait_for_completion(&ecr->completion);
> -		rc = ecr->rc;
> -		reinit_completion(&ecr->completion);
> -	}
> +	rc = crypto_wait_req(rc, &ecr);
>  out:
>  	skcipher_request_free(req);
>  	return rc;


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
