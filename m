Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EDF6F00FE
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbjD0Gpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjD0Gpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:45:34 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029E41A6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:45:34 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-316d901b2ecso386385ab.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682577933; x=1685169933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=82Dmgq6q5ZZs2W4MZ9iyCPP1hPWz2Ptbb8JGnYXCZaE=;
        b=gDqy6hPQFRVCQmftEYp5IHOiI4dRBblfzbM+9X2Ac0XRQ9lEzKK9sZ4Yk2DagCEYoz
         5gUItttq7ZCntjGvqg3acdfTW42cO79ldZCqACDfZr3oxiVOdbqRv4h5H/bSDJHoYrzm
         ZhvQoic5BN/OMXwSN3tbIJnORMQGurllxwWqJdFKbJS0A5pMZYvZSHh1+O7SzdEfI3uE
         wlXnU86b2cLwz97cqjwja69rbeq1DDaaaEWswu49pkNWZ5pp+dBGPRZUknhCjnegtWWF
         s125/0R+886UMOptfVWald7E1QdgEUUABJpYaRIqk0Ynm5VaT1ixrpmsJbBWjJUo4r99
         zZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682577933; x=1685169933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82Dmgq6q5ZZs2W4MZ9iyCPP1hPWz2Ptbb8JGnYXCZaE=;
        b=C3d17zX1L7/djdn9L5yMFShDyCACL30LxwnRtTgT88KZLfF/g2aysGMC2KChOmPMiq
         AAY51F2RzQoPiwBofgWDDm8MooLoPgmNS798s+YeMb0SETl1YPOvGZ5BU9zOycLQlupc
         JXYM2S2laNTV8II3tbJxrgu6wkP1qQG55ruw0P5rq5ryk/6QpNMUauf3oBRENvb8kIcJ
         tpiyhJA5xOrEtIk051+8cFBWVLZNgw6cYvEzm7ky30w4bBlKC8sQowRoDhF3/BWpBKyb
         YdF3TOQ6FNeY8L+yt3ciAfe25x+5UZNniULiks6E7xeyYjzrYToi+2JEaDAlYc7FtIQg
         AE9g==
X-Gm-Message-State: AC+VfDz0xYTM5Ehj9AKsPYj968yztOTmmpjImt3dFXQZ9r53qeOIhxnO
        481v/yKh5BU7T0c66+L99ROo3pYI3P0cHjstd6IsCw==
X-Google-Smtp-Source: ACHHUZ4yaoY1eHGsRhIWoRuvAz1ao+klPaksPZ0FX/nEShTvtjULgFSLI6qIXuyFh4Qa9HooN8HqPqb1gvbf/ILSO+k=
X-Received: by 2002:a05:6e02:160b:b0:32a:6ff7:bbbd with SMTP id
 t11-20020a056e02160b00b0032a6ff7bbbdmr93928ilu.13.1682577933216; Wed, 26 Apr
 2023 23:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Apr 2023 08:45:21 +0200
Message-ID: <CANn89i+vDHTMLaQLYKCJFMJ__H=Rd0ogFLcHbxFMKpW0iEr8dw@mail.gmail.com>
Subject: Re: [Patch net v2] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Palash Oswal <oswalpalash@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
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

On Thu, Apr 27, 2023 at 8:00=E2=80=AFAM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> When a tunnel device is bound with the underlying device, its
> dev->needed_headroom needs to be updated properly. IPv4 tunnels
> already do the same in ip_tunnel_bind_dev(). Otherwise we may
> not have enough header room for skb, especially after commit
> b17f709a2401 ("gue: TX support for using remote checksum offload option")=
.
>
> Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
> Reported-by: Palash Oswal <oswalpalash@gmail.com>
> Link: https://lore.kernel.org/netdev/CAGyP=3D7fDcSPKu6nttbGwt7RXzE3uyYxLj=
CSE97J64pRxJP8jPA@mail.gmail.com/
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
> v2: follow reverse Christmas tree style
>
> Note, this is targeting for -net and -table, so I'd keep the fix
> small. We can refactor and reuse ip_tunnel_bind_dev() for -net-next.
>
>  net/ipv6/sit.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
