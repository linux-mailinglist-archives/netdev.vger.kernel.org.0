Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B893555EB1E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbiF1Ree (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiF1Rea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:34:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F092B2EA31;
        Tue, 28 Jun 2022 10:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 336F5CE219D;
        Tue, 28 Jun 2022 17:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59800C3411D;
        Tue, 28 Jun 2022 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656437665;
        bh=1I14GwZlkvsDwqxGdHKL86BeboBHg+1vK2sNeEKNQt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ALAfeximJtD54eY7m0R/7aWybGoeM9LmbjoRLyAnUdBMUZcy41kXrMMdAl4wMHZR0
         V6x0Ht1uk1tm7UXqo+JF+51jkhDfNuS7/mxNgqqYjL0FL/6IM/C6DCPWQNpMezjtOR
         w++oSfd1aKyfeGTG46N1eLCNNvGVOsvBjRRRKNU4iCuZSGve0lO1yF/ydeeHGDsWxO
         g2wCFMQXXRLb5032dyP0oIzbzJtICVJa1fhoQVuPLbe2enFnWbTLSGa8VGZbq8KczZ
         n/5NTsxNsGD7HXN9H7eLjOqmsEanpf5nBzo66kjL7bTKpWbddV3fujKhc2CNGa6MsA
         sBlA6wrV793XA==
Date:   Tue, 28 Jun 2022 10:34:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julien Salleyron <julien.salleyron@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Marc Vertes <mvertes@free.fr>
Subject: Re: [PATCH] net: tls: fix tls with sk_redirect using a BPF verdict.
Message-ID: <20220628103424.5330e046@kernel.org>
In-Reply-To: <20220628152505.298790-1-julien.salleyron@gmail.com>
References: <20220628152505.298790-1-julien.salleyron@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 17:25:05 +0200 Julien Salleyron wrote:
> This patch allows to use KTLS on a socket where we apply sk_redirect using a BPF
> verdict program.
> 
> Without this patch, we see that the data received after the redirection are
> decrypted but with an incorrect offset and length. It seems to us that the
> offset and length are correct in the stream-parser data, but finally not applied
> in the skb. We have simply applied those values to the skb.
> 
> In the case of regular sockets, we saw a big performance improvement from
> applying redirect. This is not the case now with KTLS, may be related to the
> following point.

It's because kTLS does a very expensive reallocation and copy for the
non-zerocopy case (which currently means all of TLS 1.3). I have
code almost ready to fix that (just needs to be reshuffled into
upstreamable patches). Brings us up from 5.9 Gbps to 8.4 Gbps per CPU
on my test box with 16k records. Probably much more than that with
smaller records.

> It is still necessary to perform a read operation (never triggered) from user
> space despite the redirection. It makes no sense, since this read operation is
> not necessary on regular sockets without KTLS.
> 
> We do not see how to fix this problem without a change of architecture, for
> example by performing TLS decrypt directly inside the BPF verdict program.
> 
> An example program can be found at
> https://github.com/juliens/ktls-bpf_redirect-example/
> 
> Co-authored-by: Marc Vertes <mvertes@free.fr>
> ---
>  net/tls/tls_sw.c                           | 6 ++++++
>  tools/testing/selftests/bpf/test_sockmap.c | 8 +++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 0513f82b8537..a409f8a251db 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1839,8 +1839,14 @@ int tls_sw_recvmsg(struct sock *sk,
>  			if (bpf_strp_enabled) {
>  				/* BPF may try to queue the skb */
>  				__skb_unlink(skb, &ctx->rx_list);
> +
>  				err = sk_psock_tls_strp_read(psock, skb);
> +
>  				if (err != __SK_PASS) {
> +                    if (err == __SK_REDIRECT) {
> +                        skb->data += rxm->offset;
> +                        skb->len = rxm->full_len;
> +                    }

IDK what this is trying to do but I certainly depends on the fact 
we run skb_cow_data() and is not "generally correct" :S
