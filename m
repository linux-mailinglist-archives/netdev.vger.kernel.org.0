Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AABF207E12
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388763AbgFXVGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:06:12 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55127 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387853AbgFXVGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 17:06:10 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b68c71cc;
        Wed, 24 Jun 2020 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=XO6Q6GrJbI1v85reC8HtPS6cVqo=; b=QvbmWrG
        e2VM3MG/tsvnOvOZc/bFhccLnV5iS+24BMhVYdHI1JLK97eP/dPNkq+XIb3bUpFx
        SgF5jzedxu6g3DRB+D03hJN4M+3SkDJiXRaqx89QXGeUvaWyZQrVdyRi7HNYT20n
        nHgxGDNobQsBKa8lFh8tgp2ZB4GkZ0J64H7dnefE3RccBX758gS0aY9KB63JT5du
        aH2+ljjmDBN6MLBaIzdyTv8EwZb/ive6Yvkszyx0HoMR+88S35Wex4NKuDypru1B
        T+Rr57Z5gkuDCtoLZXuX9wF9a2g4LfuGQLCa1objJqp7MNTfUFG0RrQUjIRpAXS7
        PzCRjUG6hRscXOA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d236ac31 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 20:47:05 +0000 (UTC)
Date:   Wed, 24 Jun 2020 15:06:06 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Message-ID: <20200624210606.GA1362687@zx2c4.com>
References: <20191014080033.12407-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191014080033.12407-1-alobakin@dlink.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

This patch introduced a behavior change around GRO_DROP:

napi_skb_finish used to sometimes return GRO_DROP:

> -static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
> +static gro_result_t napi_skb_finish(struct napi_struct *napi,
> +				    struct sk_buff *skb,
> +				    gro_result_t ret)
>  {
>  	switch (ret) {
>  	case GRO_NORMAL:
> -		if (netif_receive_skb_internal(skb))
> -			ret = GRO_DROP;
> +		gro_normal_one(napi, skb);
>

But under your change, gro_normal_one and the various calls that makes
never propagates its return value, and so GRO_DROP is never returned to
the caller, even if something drops it.

Was this intentional? Or should I start looking into how to restore it?

Thanks,
Jason
