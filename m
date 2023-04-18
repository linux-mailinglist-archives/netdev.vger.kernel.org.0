Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27096E576A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjDRCRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjDRCRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:17:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233B2A7;
        Mon, 17 Apr 2023 19:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEC4B62BAA;
        Tue, 18 Apr 2023 02:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7088AC433D2;
        Tue, 18 Apr 2023 02:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681784256;
        bh=RJBV+GpQnO6E09AAkDfpwLAYfeR7ZcsdzQtUcu+2ec8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oQnjG1WG4kx0WQ3S/essGLapdxQhgOBa5eC29P93rakGeYnci1+dUW7oDKuIobB5I
         aL68s6Mb2L3xJdYnI+IN2Xye7GS9BCq96BKKnH6VyNTcCatsJl5VCkZIJTA6OysbyU
         V4t+0GmPyuDprZF/ctzObR8UGI8mIGZWH66t9hVgdQAU4mnTFMoXZYvGMUhwUqJoDl
         BGXXpffZ5qRJP8WMMW6gojHg2SW9G01e3aGSibWBKJRJNz0L1QND5P+DRXhs+4cCxB
         1754ZRObzfkzQ2Ky3VDqf81G/UY4ATI0ws8/0NoODzZgoYlFAxb3z2GH2PHJep6IPF
         YNQt0XJEm9UQA==
Date:   Mon, 17 Apr 2023 19:17:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Haoyi Liu <iccccc@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/ipv6: silence 'passing zero to
 ERR_PTR()' warning
Message-ID: <20230417191734.78c18a5f@kernel.org>
In-Reply-To: <11c76aa6-4c19-4f1d-86dd-e94e683dbd64@kili.mountain>
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
        <a3e202ed-a50f-2a0f-082b-ec0313be096e@kernel.org>
        <11c76aa6-4c19-4f1d-86dd-e94e683dbd64@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 09:32:51 +0300 Dan Carpenter wrote:
> Also it can return NULL.
> 
> net/xfrm/xfrm_policy.c
>   3229                  dst = dst_orig;
>   3230          }
>   3231  ok:
>   3232          xfrm_pols_put(pols, drop_pols);
>   3233          if (dst && dst->xfrm &&
>                     ^^^
> "dst" is NULL.

Don't take my word for it, but AFAICT it's impossible to get there with
dst == NULL. I think we can remove this check instead if that's what
makes smatch infer that dst may be NULL.

>   3234              dst->xfrm->props.mode == XFRM_MODE_TUNNEL)
>   3235                  dst->flags |= DST_XFRM_TUNNEL;
>   3236          return dst;
>                 ^^^^^^^^^^^
>   3237  
> 
> So in the original code what happened here was:
> 
> net/ipv6/icmp.c
>    395          dst2 = xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk, XFRM_LOOKUP_ICMP);
>    396          if (!IS_ERR(dst2)) {
> 
> xfrm_lookup() returns NULL.  NULL is not an error pointer.
> 
>    397                  dst_release(dst);
>    398                  dst = dst2;
> 
> We set "dst" to NULL.
> 
>    399          } else {
>    400                  err = PTR_ERR(dst2);
>    401                  if (err == -EPERM) {
>    402                          dst_release(dst);
>    403                          return dst2;
>    404                  } else
>    405                          goto relookup_failed;
>    406          }
>    407  
>    408  relookup_failed:
>    409          if (dst)
>    410                  return dst;
> 
> dst is not NULL so we don't return it.
> 
>    411          return ERR_PTR(err);
> 
> However "err" is not set so we do return NULL and Smatch complains about
> that.
> 
> Returning ERR_PTR(0); is not necessarily a bug, however 80% of the time
> in newly introduced code it is a bug.  Here, returning NULL is correct.
> So this is a false positive, but the code is just wibbly winding and so
> difficult to read.
> 
>    412  }
