Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160B37509C
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfGYOJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:09:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37036 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGYOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:09:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so44869906wme.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 07:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXZthBltN9dYfBBjV3vT8aFxgBEk9k5P75rcZUgTS5U=;
        b=TraXsVb44nF/iZDjAxPJLdxUe3jpdUClFTmPty0xPYeeJg+bGRFWqsc8rJhBDHip+5
         ZncBzXTCKYahSsKiQNxLNxXcWv/6S+AbXjiJZzo4lLpqx0cmgLng20llJhBWHIwOlzV2
         SSDvQrygEK/Rh6U5TuJS9koE8TgKswpoG+HQ8sJC+gr7he55+DQppKKFooS9alBy8sfc
         T3b7URq7ejhoHQvnWZwDiJ026w1nRyjdQ7CUqWiesjDX8VuHfR6aKA2En/lv0r/q0UGf
         e+aswSUCEBFa/rkbe1ChM5mfvLo4N+9A1e2oyS/hFsk+/mymxKQgT+LTFBuxdJBMzePT
         AZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXZthBltN9dYfBBjV3vT8aFxgBEk9k5P75rcZUgTS5U=;
        b=FmlIr2cSU3nZwv4yJCyjhaS21VzV5iCWKVF5D+ItSBzvTAesCPnQnKWTW3Dn8Ga8os
         lV0shdzWE0hLmIofhcq9I0IAuoa0gpmFN0gFD6NYGoodo7KiQT9TxiDuihWZKcLwEtAU
         dcuKszPqxUryH4ARWM5vpLSOJqVO2ORMMbLdmoN9TJ3AiUM2jiEbf0lyTEj/ug3svn78
         FakPO0oew0e+KXZTrsh9EealFOjW4OVOZu8NTQX75zUiK90GV74FcVIekTjmjuwK6dyg
         qAUFGUspZpL2xQUcjZoG8YKvQ+FQ601N6+Pkmk1BgADq40e4CuFuJBEBdNdznDAQWNrp
         NApg==
X-Gm-Message-State: APjAAAXrp/2j90wp/voofutEhwgo3SvZrW8vCxOr5Rqb6ibbStS9iL7Y
        P1P3RxVT7BHYpJmYR4Ax/ERmmQIOZVnWeZ1rvItpRw==
X-Google-Smtp-Source: APXvYqxauw42voIB+LJLXiymWlpyWgfbc5776yXkVukzgmXe5yWvmvyr/5ufNVlpu7E+ZXbyZRuTBnwgjb2gO6HphvI=
X-Received: by 2002:a1c:b706:: with SMTP id h6mr77881539wmf.119.1564063780212;
 Thu, 25 Jul 2019 07:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <156406148519.15479.13870345028835442313.stgit@warthog.procyon.org.uk>
In-Reply-To: <156406148519.15479.13870345028835442313.stgit@warthog.procyon.org.uk>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 25 Jul 2019 17:09:28 +0300
Message-ID: <CAKv+Gu_bJfs3zc90CbmXXo17+CYMVK+bo7OyJ-RYA=AiU38Fvg@mail.gmail.com>
Subject: Re: [RFC PATCH] rxrpc: Fix -Wframe-larger-than= warnings from
 on-stack crypto
To:     David Howells <dhowells@redhat.com>
Cc:     linux-afs@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 at 16:31, David Howells <dhowells@redhat.com> wrote:
>
> rxkad sometimes triggers a warning about oversized stack frames when
> building with clang for a 32-bit architecture:
>
> net/rxrpc/rxkad.c:243:12: error: stack frame size of 1088 bytes in function 'rxkad_secure_packet' [-Werror,-Wframe-larger-than=]
> net/rxrpc/rxkad.c:501:12: error: stack frame size of 1088 bytes in function 'rxkad_verify_packet' [-Werror,-Wframe-larger-than=]
>
> The problem is the combination of SYNC_SKCIPHER_REQUEST_ON_STACK() in
> rxkad_verify_packet()/rxkad_secure_packet() with the relatively large
> scatterlist in rxkad_verify_packet_1()/rxkad_secure_packet_encrypt().
>
> The warning does not show up when using gcc, which does not inline the
> functions as aggressively, but the problem is still the same.
>
> Allocate the cipher buffers from the slab instead, caching the allocated
> packet crypto request memory used for DATA packet crypto in the rxrpc_call
> struct.
>
> Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>

Given that this part of the driver only uses synchronous crypto, and
only using a hardcoded algo and mode [pcbc(fcrypt)], of which only a
generic C implementation exists, may I suggest that we switch to a
library based approach instead?

That way, we can get rid of the crypto API overhead here, and IMO, we
can drop support for this cipher from the crypto API entirely.

I have already done something similar for arc4 and ecb(arc4), this has
been pulled into v5.3-rc1. AES and DES are next on my list (although
none of these will be dropped from the crypto API)

Note that the pcbc(des) part is different, as there are various
accelerated implementations of DES, although it seems unlikely to me
that we would lose any performance by moving to a generic C library
for that as well.






> ---
>
>  net/rxrpc/ar-internal.h |    4 ++
>  net/rxrpc/call_object.c |    4 +-
>  net/rxrpc/insecure.c    |    5 ++
>  net/rxrpc/rxkad.c       |  103 ++++++++++++++++++++++++++++++++++++++---------
>  4 files changed, 96 insertions(+), 20 deletions(-)
>
> diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
> index 80335b4ee4fd..bea2a02850af 100644
> --- a/net/rxrpc/ar-internal.h
> +++ b/net/rxrpc/ar-internal.h
> @@ -226,6 +226,9 @@ struct rxrpc_security {
>         int (*verify_packet)(struct rxrpc_call *, struct sk_buff *,
>                              unsigned int, unsigned int, rxrpc_seq_t, u16);
>
> +       /* Free crypto request on a call */
> +       void (*free_call_crypto)(struct rxrpc_call *);
> +
>         /* Locate the data in a received packet that has been verified. */
>         void (*locate_data)(struct rxrpc_call *, struct sk_buff *,
>                             unsigned int *, unsigned int *);
> @@ -557,6 +560,7 @@ struct rxrpc_call {
>         unsigned long           expect_term_by; /* When we expect call termination by */
>         u32                     next_rx_timo;   /* Timeout for next Rx packet (jif) */
>         u32                     next_req_timo;  /* Timeout for next Rx request packet (jif) */
> +       struct skcipher_request *cipher_req;    /* Packet cipher request buffer */
>         struct timer_list       timer;          /* Combined event timer */
>         struct work_struct      processor;      /* Event processor */
>         rxrpc_notify_rx_t       notify_rx;      /* kernel service Rx notification function */
> diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
> index 217b12be9e08..60cbc81dc461 100644
> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -476,8 +476,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
>
>         _debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
>
> -       if (conn)
> +       if (conn) {
>                 rxrpc_disconnect_call(call);
> +               conn->security->free_call_crypto(call);
> +       }
>
>         for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++) {
>                 rxrpc_free_skb(call->rxtx_buffer[i],
> diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
> index a29d26c273b5..f6c59f5fae9d 100644
> --- a/net/rxrpc/insecure.c
> +++ b/net/rxrpc/insecure.c
> @@ -33,6 +33,10 @@ static int none_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
>         return 0;
>  }
>
> +static void none_free_call_crypto(struct rxrpc_call *call)
> +{
> +}
> +
>  static void none_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
>                              unsigned int *_offset, unsigned int *_len)
>  {
> @@ -83,6 +87,7 @@ const struct rxrpc_security rxrpc_no_security = {
>         .exit                           = none_exit,
>         .init_connection_security       = none_init_connection_security,
>         .prime_packet_security          = none_prime_packet_security,
> +       .free_call_crypto               = none_free_call_crypto,
>         .secure_packet                  = none_secure_packet,
>         .verify_packet                  = none_verify_packet,
>         .locate_data                    = none_locate_data,
> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
> index ae8cd8926456..dbb109da1835 100644
> --- a/net/rxrpc/rxkad.c
> +++ b/net/rxrpc/rxkad.c
> @@ -43,6 +43,7 @@ struct rxkad_level2_hdr {
>   * packets
>   */
>  static struct crypto_sync_skcipher *rxkad_ci;
> +static struct skcipher_request *rxkad_ci_req;
>  static DEFINE_MUTEX(rxkad_ci_mutex);
>
>  /*
> @@ -99,8 +100,8 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn)
>   */
>  static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
>  {
> +       struct skcipher_request *req;
>         struct rxrpc_key_token *token;
> -       SYNC_SKCIPHER_REQUEST_ON_STACK(req, conn->cipher);
>         struct scatterlist sg;
>         struct rxrpc_crypt iv;
>         __be32 *tmpbuf;
> @@ -115,6 +116,12 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
>         if (!tmpbuf)
>                 return -ENOMEM;
>
> +       req = skcipher_request_alloc(&conn->cipher->base, GFP_NOFS);
> +       if (!req) {
> +               kfree(tmpbuf);
> +               return -ENOMEM;
> +       }
> +
>         token = conn->params.key->payload.data[0];
>         memcpy(&iv, token->kad->session_key, sizeof(iv));
>
> @@ -128,7 +135,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
>         skcipher_request_set_callback(req, 0, NULL, NULL);
>         skcipher_request_set_crypt(req, &sg, &sg, tmpsize, iv.x);
>         crypto_skcipher_encrypt(req);
> -       skcipher_request_zero(req);
> +       skcipher_request_free(req);
>
>         memcpy(&conn->csum_iv, tmpbuf + 2, sizeof(conn->csum_iv));
>         kfree(tmpbuf);
> @@ -136,6 +143,35 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
>         return 0;
>  }
>
> +/*
> + * Allocate and prepare the crypto request on a call.  For any particular call,
> + * this is called serially for the packets, so no lock should be necessary.
> + */
> +static struct skcipher_request *rxkad_get_call_crypto(struct rxrpc_call *call)
> +{
> +       struct crypto_skcipher *tfm = &call->conn->cipher->base;
> +       struct skcipher_request *cipher_req = call->cipher_req;
> +
> +       if (!cipher_req) {
> +               cipher_req = skcipher_request_alloc(tfm, GFP_NOFS);
> +               if (!cipher_req)
> +                       return NULL;
> +               call->cipher_req = cipher_req;
> +       }
> +
> +       return cipher_req;
> +}
> +
> +/*
> + * Clean up the crypto on a call.
> + */
> +static void rxkad_free_call_crypto(struct rxrpc_call *call)
> +{
> +       if (call->cipher_req)
> +               skcipher_request_free(call->cipher_req);
> +       call->cipher_req = NULL;
> +}
> +
>  /*
>   * partially encrypt a packet (level 1 security)
>   */
> @@ -246,7 +282,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
>                                void *sechdr)
>  {
>         struct rxrpc_skb_priv *sp;
> -       SYNC_SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
> +       struct skcipher_request *req;
>         struct rxrpc_crypt iv;
>         struct scatterlist sg;
>         u32 x, y;
> @@ -265,6 +301,10 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
>         if (ret < 0)
>                 return ret;
>
> +       req = rxkad_get_call_crypto(call);
> +       if (!req)
> +               return -ENOMEM;
> +
>         /* continue encrypting from where we left off */
>         memcpy(&iv, call->conn->csum_iv.x, sizeof(iv));
>
> @@ -502,7 +542,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
>                                unsigned int offset, unsigned int len,
>                                rxrpc_seq_t seq, u16 expected_cksum)
>  {
> -       SYNC_SKCIPHER_REQUEST_ON_STACK(req, call->conn->cipher);
> +       struct skcipher_request *req;
>         struct rxrpc_crypt iv;
>         struct scatterlist sg;
>         bool aborted;
> @@ -515,6 +555,10 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
>         if (!call->conn->cipher)
>                 return 0;
>
> +       req = rxkad_get_call_crypto(call);
> +       if (!req)
> +               return -ENOMEM;
> +
>         /* continue encrypting from where we left off */
>         memcpy(&iv, call->conn->csum_iv.x, sizeof(iv));
>
> @@ -747,14 +791,18 @@ static void rxkad_calc_response_checksum(struct rxkad_response *response)
>  /*
>   * encrypt the response packet
>   */
> -static void rxkad_encrypt_response(struct rxrpc_connection *conn,
> -                                  struct rxkad_response *resp,
> -                                  const struct rxkad_key *s2)
> +static int rxkad_encrypt_response(struct rxrpc_connection *conn,
> +                                 struct rxkad_response *resp,
> +                                 const struct rxkad_key *s2)
>  {
> -       SYNC_SKCIPHER_REQUEST_ON_STACK(req, conn->cipher);
> +       struct skcipher_request *req;
>         struct rxrpc_crypt iv;
>         struct scatterlist sg[1];
>
> +       req = skcipher_request_alloc(&conn->cipher->base, GFP_NOFS);
> +       if (!req)
> +               return -ENOMEM;
> +
>         /* continue encrypting from where we left off */
>         memcpy(&iv, s2->session_key, sizeof(iv));
>
> @@ -764,7 +812,8 @@ static void rxkad_encrypt_response(struct rxrpc_connection *conn,
>         skcipher_request_set_callback(req, 0, NULL, NULL);
>         skcipher_request_set_crypt(req, sg, sg, sizeof(resp->encrypted), iv.x);
>         crypto_skcipher_encrypt(req);
> -       skcipher_request_zero(req);
> +       skcipher_request_free(req);
> +       return 0;
>  }
>
>  /*
> @@ -839,8 +888,9 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
>
>         /* calculate the response checksum and then do the encryption */
>         rxkad_calc_response_checksum(resp);
> -       rxkad_encrypt_response(conn, resp, token->kad);
> -       ret = rxkad_send_response(conn, &sp->hdr, resp, token->kad);
> +       ret = rxkad_encrypt_response(conn, resp, token->kad);
> +       if (ret == 0)
> +               ret = rxkad_send_response(conn, &sp->hdr, resp, token->kad);
>         kfree(resp);
>         return ret;
>
> @@ -1017,18 +1067,16 @@ static void rxkad_decrypt_response(struct rxrpc_connection *conn,
>                                    struct rxkad_response *resp,
>                                    const struct rxrpc_crypt *session_key)
>  {
> -       SYNC_SKCIPHER_REQUEST_ON_STACK(req, rxkad_ci);
> +       struct skcipher_request *req = rxkad_ci_req;
>         struct scatterlist sg[1];
>         struct rxrpc_crypt iv;
>
>         _enter(",,%08x%08x",
>                ntohl(session_key->n[0]), ntohl(session_key->n[1]));
>
> -       ASSERT(rxkad_ci != NULL);
> -
>         mutex_lock(&rxkad_ci_mutex);
>         if (crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
> -                                  sizeof(*session_key)) < 0)
> +                                       sizeof(*session_key)) < 0)
>                 BUG();
>
>         memcpy(&iv, session_key, sizeof(iv));
> @@ -1222,10 +1270,26 @@ static void rxkad_clear(struct rxrpc_connection *conn)
>   */
>  static int rxkad_init(void)
>  {
> +       struct crypto_sync_skcipher *tfm;
> +       struct skcipher_request *req;
> +
>         /* pin the cipher we need so that the crypto layer doesn't invoke
>          * keventd to go get it */
> -       rxkad_ci = crypto_alloc_sync_skcipher("pcbc(fcrypt)", 0, 0);
> -       return PTR_ERR_OR_ZERO(rxkad_ci);
> +       tfm = crypto_alloc_sync_skcipher("pcbc(fcrypt)", 0, 0);
> +       if (IS_ERR(tfm))
> +               return PTR_ERR(tfm);
> +
> +       req = skcipher_request_alloc(&tfm->base, GFP_KERNEL);
> +       if (!req)
> +               goto nomem_tfm;
> +
> +       rxkad_ci_req = req;
> +       rxkad_ci = tfm;
> +       return 0;
> +
> +nomem_tfm:
> +       crypto_free_sync_skcipher(tfm);
> +       return -ENOMEM;
>  }
>
>  /*
> @@ -1233,8 +1297,8 @@ static int rxkad_init(void)
>   */
>  static void rxkad_exit(void)
>  {
> -       if (rxkad_ci)
> -               crypto_free_sync_skcipher(rxkad_ci);
> +       crypto_free_sync_skcipher(rxkad_ci);
> +       skcipher_request_free(rxkad_ci_req);
>  }
>
>  /*
> @@ -1249,6 +1313,7 @@ const struct rxrpc_security rxkad = {
>         .prime_packet_security          = rxkad_prime_packet_security,
>         .secure_packet                  = rxkad_secure_packet,
>         .verify_packet                  = rxkad_verify_packet,
> +       .free_call_crypto               = rxkad_free_call_crypto,
>         .locate_data                    = rxkad_locate_data,
>         .issue_challenge                = rxkad_issue_challenge,
>         .respond_to_challenge           = rxkad_respond_to_challenge,
>
