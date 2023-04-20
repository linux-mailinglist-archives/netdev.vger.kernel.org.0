Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4426E99D0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjDTQpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDTQpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:45:09 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807B82721
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:45:08 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-32a7770f7d1so11763715ab.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682009108; x=1684601108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQL6WeAJwgjxPy2pHuavpGuNdOo+//q5ur8lAcd2S3w=;
        b=AENyB8Te1QCBJvGeupNFs0r+uFbu+MsNZsiBZ92VGJbQOuWcbgjqOiT8z/49sqSN/O
         WdegNsWx86rBehwVsrcrSzsG4Yv6j/5+DZhXKpGs0UQX1P7TdC7ILR/767X87wikabZI
         lX1VgqHHoS9jq9M7Iakhn2K79IyW4zLvediy6/vFuxlLTKJavW95JdqyBcA8YJkW/P8x
         /oR+dPXuSmFiXMJw3EIQC0WkSU7sC9xe19qllDOuq9wTYVzfyaRUcA3GoBZfe8LMnwBd
         viLNS94xKkY/4Lwkhnvnfq5YKTuNJBhmwCTAldaTLPkv4/HhO5dyFMu1px41TdayL8es
         CAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009108; x=1684601108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQL6WeAJwgjxPy2pHuavpGuNdOo+//q5ur8lAcd2S3w=;
        b=M39lk7AREw9QUil/iEheEK7ERKSG8N7/o5qRj+NCAYNAI9bGVRKRRyZ3dVfHdaiZtw
         y6JzFRXFHLGxtAfCx564ct48CoCMxZ6ePQBa2G8EvSIuYA2OActpQ/Z8/irVImh04zNw
         BqWlR1ECy+kBfo21Qy0Dm0VG3dFsEB7CLm/71xJgWc1wy+XJMWV0KIKMeKdMiZDIhuEp
         5lWU0tYtnmG8PLuWQ5XacYWjVdtlwCTWFDplsU6Jp48yfbP96L1UomxovmJRQrnpHpMX
         uCMIozWHUKsTPMgqH/SzLBhnl/SlvKA12JNLx6lH2D/rJE2JwviFj6lphKwVVtzzre5L
         RSRA==
X-Gm-Message-State: AAQBX9ft8PSgSIynF9ipjqb4C9k5ePXfgfQkDQ7iNrwY7pTN5zomcKYE
        xbghrJDm2pUSuHw8Dy8KuxZjqNNRZ6FBO3/SwoHZ/A==
X-Google-Smtp-Source: AKy350ZAMAPS650I6F95eOe3DScbYN9WTkLt+8HhdfpkTmIMTWW5HZtglgTEAyzSd5QtpNHmK00MlukipmslBVkevPs=
X-Received: by 2002:a05:6638:10cd:b0:3eb:3166:9da4 with SMTP id
 q13-20020a05663810cd00b003eb31669da4mr818698jad.2.1682009107548; Thu, 20 Apr
 2023 09:45:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681906552.git.leon@kernel.org> <dc1db7b00f7a9f18edfe4148dffacc2a5381e824.1681906552.git.leon@kernel.org>
In-Reply-To: <dc1db7b00f7a9f18edfe4148dffacc2a5381e824.1681906552.git.leon@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Apr 2023 18:44:56 +0200
Message-ID: <CANn89iJ_Eet7aPQ-sFbXr2goxwzKr+pmy9taGkZvsphn--1knw@mail.gmail.com>
Subject: Re: [PATCH xfrm 2/2] xfrm: Fix leak of dev tracker
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 2:19=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> At the stage of direction checks, the netdev reference tracker is
> already initialized, but released with wrong *_put() call.
>
> Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
