Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6D26D5641
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 03:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjDDBrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 21:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjDDBrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 21:47:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A5EB8
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:47:47 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l12so31155007wrm.10
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 18:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680572866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egyYnX4YQZqdzuNxsBOruIsAu0kFeJrfgBx/+kPppzo=;
        b=j36TdaZk7VQaPAtiI1Ur4j3TPUEdsK/7cqBDAKpfgyU0XLgAKVvMocF1kT7YL1kTDg
         1eNrx659u8U6kGWyH0sBdPFaZhIEgQJKfMgI+LuGlJ6DE2XWcUX6ay9CKLYy1vQHwyko
         XqCzlMTwp8Txpix3uZcrSyRdWaOmxtN8cbJeWD/tvEHyCpthS+O/MX3hokEpRKqRP7ny
         4THbT0K4PC4v78NGuUBtzGS9qEBOJGBGnfY4aLeU+1ILhvJ2JG+D6vnuEfXX3YenBgBX
         lhyglxIgNDKWD4QkM/z2NKSvLI6cQLHKUC262bj9XF1mi+dD2dxbR0tGTS3dFgT51tyd
         A1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680572866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egyYnX4YQZqdzuNxsBOruIsAu0kFeJrfgBx/+kPppzo=;
        b=oAMW5gLG+SyNNgJ0ttlnv9SdFvJKRXV1AIxY/yTKJ7+H6a1vmyroumbo3htZuW7RPU
         jnD+Y552WrxcYv+GvuNlRJ6ha3gcqu9DQNtLBgm85NCFVTXcbFnpxg9CCRwDKDphJyl0
         2fgN7QUO4SB8yNnk7ettRjp9okfbdS5IwnzUOPqPk/ProI9XLBDvsE4MOd1lr8cqo+sV
         Rx6Hk+BOIhEWE98u+LqNa2bADhpiyYkQIgCWcENuQcPkxpOaCRwb6YUQ2cjzuWmbRlJa
         k41fXYLerufgQibGtHAW2pgcvHaopA8zysIWVcPXt13+c/Y8tjwwLm9vb/Oe7klDkm5t
         asLg==
X-Gm-Message-State: AAQBX9fA20EJ+68eQ+2OCl2ZF19oRkFbK6b73XzLD4BMWvtD+HG7ulO2
        DEl+D2bJ1ktauJuBcEklmTCD00WWqznpd7dk6EaxoQ==
X-Google-Smtp-Source: AKy350aTj79ZcgqUIZM6nE2hGQmvTyJ7hehvmBjD8TKCLewmVvgTSv3iDvJ4aYGbyUZIL+URmJ45DX6eT4IhoXV6owA=
X-Received: by 2002:a5d:564e:0:b0:2ce:ae7e:c4a3 with SMTP id
 j14-20020a5d564e000000b002ceae7ec4a3mr102900wrw.12.1680572865637; Mon, 03 Apr
 2023 18:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-3-kuniyu@amazon.com>
In-Reply-To: <20230403194959.48928-3-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 03:47:34 +0200
Message-ID: <CANn89iK47cLD-vNfRb9gt_V1nzjyLgdDCmoMcXBdaE0z5j4FEw@mail.gmail.com>
Subject: Re: [PATCH v1 net 2/2] ping: Fix potentail NULL deref for /proc/net/icmp.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
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

On Mon, Apr 3, 2023 at 9:51=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> After commit dbca1596bbb0 ("ping: convert to RCU lookups, get rid
> of rwlock"), we use RCU for ping sockets, but we should use spinlock
> for /proc/net/icmp to avoid a potential NULL deref mentioned in
> the previous patch.
>
> Let's go back to using spinlock there.
>
> Note we can convert ping sockets to use hlist instead of hlist_nulls
> because we do not use SLAB_TYPESAFE_BY_RCU for ping sockets.

Yes, this could be done later if we care enough.

>
> Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
