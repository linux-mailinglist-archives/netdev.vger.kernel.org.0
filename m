Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03806D5737
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 05:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjDDD3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 23:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDDD33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 23:29:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AB719B9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 20:29:26 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pjXMF-00C3BC-9R; Tue, 04 Apr 2023 11:29:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Apr 2023 11:29:19 +0800
Date:   Tue, 4 Apr 2023 11:29:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com, roman.gushchin@linux.dev,
        kuba@kernel.org
Subject: Re: [RFC net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <ZCuZj9b2s3FI9tzo@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311050130.115138-1-kuba@kernel.org>
X-Newsgroups: apana.lists.os.linux.netdev
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
>
> +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)             \
> +       ({                                                              \
> +               int _res;                                               \
> +                                                                       \
> +               netif_tx_stop_queue(txq);                               \
> +                                                                       \
> +               smp_mb();                                               \

We should never have an smp_mb by itself.  It must come with a
comment indicating which other barrier (possibly implicit) it
pairs with.

I know that you're just copying old code around, but by turning
it into a helper, we should treat it as new code and apply the
current requirements.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
