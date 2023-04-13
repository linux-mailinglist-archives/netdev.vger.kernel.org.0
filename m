Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2AB6E13DB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 20:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDMSEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 14:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDMSEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 14:04:23 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547C21735
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:04:22 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id y21so1619335ual.3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681409061; x=1684001061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQjodhHiRz4RRveqYRmbcis+dyut9awKbSg8GzGBTmg=;
        b=oBfEeQkryk9F68rZfWFPshHCbYtZGdXM8zE3YKhg4fObfldChE+WmS6Ry6EYN3Xupf
         +FoNS/EqYKB0NXB/tWa02oJee5FsNoakWNotrZnRU9bAfzsxiNBaxEXNrKzihoMevcEe
         Ev/9s7xBf4+6kOnPdZojbn+H7Qy2ts8Umqn9B64JxmKrrBGUUucMGrWcc7mdScXhPslP
         iL5OP8mJSzqWHvHZrIRts9pq+AENvuKKGCO82MThJ00wup9BI5Se/2DKhmURXUCi0oib
         B8xzU0ToKZuFVKjuydOHt/4s0/b4Rp0g+JvoIMWURu9V1+8UBW6rz+3IiKV/uqgMXYlz
         kQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681409061; x=1684001061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQjodhHiRz4RRveqYRmbcis+dyut9awKbSg8GzGBTmg=;
        b=P82D1WKeNs/ecPj6LXFuRO3XI6LmI1xr//8DqlM/ED0X16CezpeSRnNi9d3/ziyimp
         gEVRaBWLPVeqC99+oZnCKL+Kzwk4HrdcMg1Xke9KVjgGzJAsXIaCSiYGfRWV3WCz/O1E
         0FcJY8awHdA1dOh5qloU9lU3dS9y4qTdi5rBsuNGmdWy//lotuA+5qCIaeTVkByKT44q
         iofLtaGOSrT10EOJgrrg7XjOP6bXYJ8jnkUowt0nHcMWV2f4Yt7sJumVJ6DxjOsUFr4V
         W1ojTF5/ubgvRxvrYUMTu6fKqyiTFyDhggAbkXI00AOZ8g73nsgKrCdOiZyZv5n9WSKJ
         WJiA==
X-Gm-Message-State: AAQBX9f+++WXWz8FWbbC9VGX/xTE41x9C6PalK+BjlO9x/Od++L9d5pQ
        72QBqTEMAXBVXdk3zj+KquMPojHl3aM9w2nBR41jKg==
X-Google-Smtp-Source: AKy350aprpWf7I7J413khN2cILqsBBIWZiL732amzSUm84HQvkLn0fNe34rgR3lmvv4sVM64pJVfttvFsySbp6bZ9y0=
X-Received: by 2002:a1f:2941:0:b0:43b:af47:ba56 with SMTP id
 p62-20020a1f2941000000b0043baf47ba56mr1553889vkp.2.1681409061222; Thu, 13 Apr
 2023 11:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230412085615.124791-1-martin@strongswan.org>
In-Reply-To: <20230412085615.124791-1-martin@strongswan.org>
From:   Benedict Wong <benedictwong@google.com>
Date:   Thu, 13 Apr 2023 11:04:05 -0700
Message-ID: <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
Subject: Re: [PATCH ipsec v2] xfrm: Preserve xfrm interface secpath for
 packets forwarded
To:     Martin Willi <martin@strongswan.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not directly related to this change, but in testing these on a broader
swath of Android tests, we've found that my original change also
happens to break Transport-in-Tunnel mode (which attempts to match the
outer tunnel mode policy twice.). I wonder if it's worth just
reverting first, and going back to a previous iteration of the nested
policy checks that allows multiple lookups of the same
template/secpath pair.


On Wed, Apr 12, 2023 at 1:56=E2=80=AFAM Martin Willi <martin@strongswan.org=
> wrote:
>
> The commit referenced below clears the secpath on packets received via
> xfrm interfaces to support nested IPsec tunnels. This breaks Netfilter
> policy matching using xt_policy in the FORWARD chain, as the secpath
> is missing during forwarding. INPUT matching is not affected, as it is
> done before secpath reset.
>
> A work-around could use XFRM input interface matching for such rules,
> but this does not work if the XFRM interface is part of a VRF; the
> Netfilter input interface is replaced by the VRF interface, making a
> sufficient match for IPsec-protected packets difficult.
>
> So instead, limit the secpath reset to packets that are not using a
> XFRM forward policy. This should allow nested tunnels, but keeps the
> secpath intact on packets that are passed to Netfilter chains with
> potential IPsec policy matches.
>
> Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
> Suggested-by: Eyal Birger <eyal.birger@gmail.com>
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
> v1 -> v2: Use policy dir instead of flowi outif to check for forwarding
>
>  net/xfrm/xfrm_policy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 5c61ec04b839..669c3c0880a6 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -3745,7 +3745,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, s=
truct sk_buff *skb,
>                         goto reject;
>                 }
>
> -               if (if_id)
> +               if (if_id && dir !=3D XFRM_POLICY_FWD)
>                         secpath_reset(skb);
>
>                 xfrm_pols_put(pols, npols);
> --
> 2.34.1
>
