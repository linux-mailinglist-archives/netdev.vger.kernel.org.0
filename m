Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8216DAA86
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbjDGJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjDGJBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:01:09 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D2F86B9
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:01:08 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-54c0dd7e2f3so79371087b3.8
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 02:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680858067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gD0fLioRJ4bazZO1d+c33FChVf79wAvXK8pl+WtkfeU=;
        b=DYWxHIJcV2w529JGlIVbdQMEkhLczL6gZM1mn89BX+zTRqRtQMReGglMWAAbvx8HF/
         ap+nYnfUDhyEUnDoFlyKtBpJMQh/J5l8v3FS9NiwT36mU0xz/eNrUq5+RegeK2KfHh/y
         Yrfb+SfhuMdO1Hau68nAvXBDWctayYdzaK2Caa+ngx31UV1n4c75Q0HoVzwQhnL2ajEb
         aSJ/3AVh9fqjIar5P1cikM+uVpeuDzIVBW5BEmDQdbKumykhIw/UldaCqIypTLr5iSKh
         UeYfm04jU50PGmTOCM24y138Sr3AL0mnvWmM5+mEyR7oNe7DmVpVtOUDl2AId4xJOBOy
         q5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680858067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gD0fLioRJ4bazZO1d+c33FChVf79wAvXK8pl+WtkfeU=;
        b=3U3Q6P5nd7O9Vh96YLsHQR/fL33+i3u8F5vy3++uy5As+dP0NpflwQBwfSA1vN8eDy
         ny9Ur3A+Zie1tinY6LhDQqhli+7NcPyjgy0WXlmj/DCKIDfbYJ1a6I9ZKzGfVusvYqMg
         D7pAlx5zo2f0zQGdRgmJwQWr+fxWQKmdSWAW+uI9HuMCqppdacNIKpnpEGz9BI53kZkU
         5eHZlG6iT/1l0hzZlwtlj7bVrArytIgfr1tN9KTxcBKFOPI8RGA/qk7SmShV3igIKcic
         4sgIhPUZ/jyYzcy0lsf9oWWv2NHVolB2oHicPdDhnz7iqrL3mSXA6POnn3HW74dNxvp/
         xsZQ==
X-Gm-Message-State: AAQBX9evlLGtvi0Cr98tdPSQuq5oiW94UBQXY+jfTrwxmAtHDIyxhwqi
        JfxASmQDpMExCuK8plZQW4ejme6FSh9Nm/SlJ5aTSA==
X-Google-Smtp-Source: AKy350Yxg2b6wSZ2snsqKErnGlzzj1eiPLnWXdgU0QkFXUYiaeMq74SlzwtZB7bYGApHKdW0uByFstVrYrDcEYR16qQ=
X-Received: by 2002:a81:ae52:0:b0:541:a17f:c77d with SMTP id
 g18-20020a81ae52000000b00541a17fc77dmr656749ywk.10.1680858066675; Fri, 07 Apr
 2023 02:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230407035058.8373-1-iccccc@hust.edu.cn>
In-Reply-To: <20230407035058.8373-1-iccccc@hust.edu.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 7 Apr 2023 11:00:55 +0200
Message-ID: <CANn89i+FFu3Rz8KgMw-hn=jPcv9AJfQKuAgUyfzVMwACLQMUSA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/ipv6: silence 'passing zero to ERR_PTR()' warning
To:     Haoyi Liu <iccccc@hust.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn,
        error27@gmail.com, Dongliang Mu <dzm91@hust.edu.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 7, 2023 at 5:54=E2=80=AFAM Haoyi Liu <iccccc@hust.edu.cn> wrote=
:
>
> Smatch complains that if xfrm_lookup() returns NULL then this does a
> weird thing with "err":
>
>     net/ ipv6/ icmp.c:411 icmpv6_route_lookup()
>     warn: passing zero to ERR_PTR()
>
> Just return "dst2" directly instead of assigning it to"dst" and then
> looking up the value of "err".  No functional change.
>
> Signed-off-by: Haoyi Liu <iccccc@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
> ---
> The issue is found by static analysis, and the patch is remains untested.
> ---
>  net/ipv6/icmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index 1f53f2a74480..a5e77acead89 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -395,7 +395,7 @@ static struct dst_entry *icmpv6_route_lookup(struct n=
et *net,
>         dst2 =3D xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk, XFRM_L=
OOKUP_ICMP);
>         if (!IS_ERR(dst2)) {
>                 dst_release(dst);
> -               dst =3D dst2;
> +               return dst2;
>         } else {
>                 err =3D PTR_ERR(dst2);
>                 if (err =3D=3D -EPERM) {
> --
> 2.25.1
>

Please cleanup this thing, this is a maze of returns, gotos, and
unnecessary 'else's

Thanks.

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 1f53f2a74480c0b8433204b567e7f98ad1216ad6..c76861f1ff6e4ee12d2686c1d13=
5b24595989dfa
100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -395,14 +395,12 @@ static struct dst_entry
*icmpv6_route_lookup(struct net *net,
        dst2 =3D xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk,
XFRM_LOOKUP_ICMP);
        if (!IS_ERR(dst2)) {
                dst_release(dst);
-               dst =3D dst2;
-       } else {
-               err =3D PTR_ERR(dst2);
-               if (err =3D=3D -EPERM) {
-                       dst_release(dst);
-                       return dst2;
-               } else
-                       goto relookup_failed;
+               return dst2;
+       }
+       err =3D PTR_ERR(dst2);
+       if (err =3D=3D -EPERM) {
+               dst_release(dst);
+               return dst2;
        }

 relookup_failed:
