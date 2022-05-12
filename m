Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6E952535C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356722AbiELROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356911AbiELROg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:14:36 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE6926A70C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:14:35 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2f863469afbso64926517b3.0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xT5a/I0cxR9Jf9/vuNNWYbKwVDl4cBhbZvh4/qXTA+U=;
        b=jNQCetTu2M1NnWioumR67a6Fbigi/AYq/zP4mW+TKDYTUPpVsU4z1U4eBq3B0RJvaE
         +zcUkGyuKkDuwMnh12b/vmSx3jbjY83nrWrspg7l9uLoOA/C6razMtX+6GnPbWtYuFK8
         rf567CNomp/jNKuU2zvm4/lu31cRatA/v6QzONVM5ZyNmd1rDKQWjD6Ip2i2YSFHEtRC
         yDfHZaxBZR1gOMl430JjHSPgAakngXhMUQ1RGLqCkRpjOHDT61X48YVgygXQQMnXVUCR
         q8UNlVd5lIRKwiZVww0+tLXw1HoYB9rNv6Lj/4FNSHKUW19yEnEOfN/gJ34Iybb1ffdN
         pHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xT5a/I0cxR9Jf9/vuNNWYbKwVDl4cBhbZvh4/qXTA+U=;
        b=aoAAlCzr3WnIYVzKyGDVjMyveJcs+wBuBLdNtSrs9Ud/iYuBwrUXfSXGuZwK81CgF7
         08o7i/zvc5/AylZC95S4isi4zYTAo43wch24lGwpnUlPqCl+0ziwo/RfjFYGu/x8svVt
         gDNhCMD7v4L3jw/zKi23ZqfYwORrZVr5K/APUD28eKoVtVZcyYfm9NOD5zHblnc9waKw
         eP+jkdy+PP/+2Ve2qvODlgwmNY3O3i4iG6STp3hkxOP1RzYA5fdP9txVCRtHNfUn6Z8Z
         QD15oOsKFUlGkb9M+XmLzPleluFeGKCe79uAuifsunc8AaKf3lSWteqgioRn0Po5RqAi
         BrmA==
X-Gm-Message-State: AOAM5312LZ1YNHAy/7ZT89pBatYFGMitv8LBu2Ez2+ipBOfUbCqrpAJc
        svvVTO+yMY48KQQ0xDMGPK943h2urc1s57WrtiZTDA==
X-Google-Smtp-Source: ABdhPJyapEZOR+amb5dANr9MAvusdP1GS33OPr5tRS/3gjWbIA5xeq2Zvdgf/9FufsNhYNAF+MSJYl3//cJO7fA8OCI=
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr1147160ywj.47.1652375674449; Thu, 12
 May 2022 10:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220512165601.2326659-1-eric.dumazet@gmail.com> <09dae83a-b716-3a0c-cc18-39e6e9afa6cc@hartkopp.net>
In-Reply-To: <09dae83a-b716-3a0c-cc18-39e6e9afa6cc@hartkopp.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 10:14:23 -0700
Message-ID: <CANn89i+V+ZW3qjb=OycX5vsEdcymdsn9-HF379QFqL3T2_a0Ag@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, May 12, 2022 at 10:02 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> When you convert the #define into an inline function, wouldn't it be
> more natural to name it lower caps?
>
> static inline bool inet_match(struct net *net, ... )

Sure, it is only a matter for us to remember all the past/present
names, based on implementation details, especially at backport times.
