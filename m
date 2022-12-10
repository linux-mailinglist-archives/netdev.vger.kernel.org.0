Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6020764900B
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLJRqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 12:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLJRqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 12:46:08 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A808140F5
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 09:46:08 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3e78d07ab4fso92453677b3.9
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 09:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuKFOFmRA4oqMYbunx91hqdr21f4NaaaO3FwLOEYSJ8=;
        b=V3qv6lSkRoK6ammsqr/qn0sEL+gvD11Eob7eAsotponKAyoglJ8ub/l4y2cYpZsa81
         QuJ8z3eMW+a79BSRiiz+F2MfPIyR5PGF/XSrk5laNNoLdity536+05+SUGOsNMTnH9t5
         K8RtifAxEZKpwYKypceOouDS7Yc51xTjonsLnhzDhnCIOAWOcgz4XEvD9vco3laN1CKK
         IOg0das0NIH/DYAnbT6w2+VlvH5CUYSSRK5ULvxLybqlU0DskjLKG4Y4N5JkBF/hYTh8
         cCNIViVLIEINF0qLzk1Ys7bJFK+dujkBrnjEH4f6DXhW1vdMhn0YdOSrq6OfNDe0QJSB
         WOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CuKFOFmRA4oqMYbunx91hqdr21f4NaaaO3FwLOEYSJ8=;
        b=bBGVJRMfuIXpiNaSz1yCXC5ART/Wgu3YvHdvptU0eZEaFIVrpfkCAdcoPCgezhRcLB
         vvOb68fx4INPvqHRSL/l/QCuwkVk0SxqukVTe8xxyNWgMJVClkqNfUpJ7pzK4AOgRZLo
         xil/L7YAdt444jhgFRBa1BXLR2nFYBuPefyND4WHKCrAl4NHtv3dzB41mqn/cl0pGzET
         KhEGKHGE3Hr79Nte9zkYPPxs17iq8EppRONZc2HMBZEO+3P2+qGE0SKpScqb74Pq/iWS
         ma6HVyyeW0nejxa3URl62HFxrvExeCQm+FUMXs2fODST8fosa8zdrJONjyzUGq9xNlGr
         N9Rg==
X-Gm-Message-State: ANoB5pkij1cFlYmIr23YSG4yxCXy/BzyfjNzERosnzYHyhe83Jji6hIm
        5hm7bcQV15Pr10ghTox+wcrFR4CnRfNHnjnTZ26Qvw==
X-Google-Smtp-Source: AA0mqf76d2sxdiYdZtdEx7oL2nnIW1xn72I3Ld3FE+/ipyxrLEq3ODrdMrk8fSgn/5ViX+5LqVp9BCoYRFL/+idewH8=
X-Received: by 2002:a81:1144:0:b0:3f2:e8b7:a6ec with SMTP id
 65-20020a811144000000b003f2e8b7a6ecmr13874893ywr.332.1670694367209; Sat, 10
 Dec 2022 09:46:07 -0800 (PST)
MIME-Version: 1.0
References: <Y44xdN3zH4f+BZCD@zwp-5820-Tower> <CADVnQykvAWHFOec_=DyU9GMLppK6mpeK-GqUVbktJffj1XA5rQ@mail.gmail.com>
 <87mt805181.fsf@cloudflare.com>
In-Reply-To: <87mt805181.fsf@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 10 Dec 2022 18:45:56 +0100
Message-ID: <CANn89i+nT61qvE3iChGc-bYiTCzR=x2ZhvddRD0qDUTF6JuK+g@mail.gmail.com>
Subject: Re: [RFC PATCH] tcp: correct srtt and mdev_us calculation
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Weiping Zhang <zhangweiping@didiglobal.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        zwp10758@gmail.com
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

On Tue, Dec 6, 2022 at 10:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote=
:


> Nifty. And it's documented.
>
> struct tcp_sock {
>         =E2=80=A6
>         u32     srtt_us;        /* smoothed round trip time << 3 in usecs=
 */
>
> Thanks for the hint.

The >> 3 is all over the place... So even without a formal comment,
anyone familiar with TCP stack would spot this...

include/net/tcp.h:700:  return usecs_to_jiffies((tp->srtt_us >> 3) +
tp->rttvar_us);
include/trace/events/tcp.h:286:         __entry->srtt =3D tp->srtt_us >> 3;
include/uapi/linux/bpf.h:6038:  __u32 srtt_us;          /* smoothed
round trip time << 3 in usecs */
include/uapi/linux/bpf.h:6396:  __u32 srtt_us;          /* Averaged
RTT << 3 in usecs */
et/ipv4/tcp.c:3906:    info->tcpi_rtt =3D tp->srtt_us >> 3;
net/ipv4/tcp.c:4045:    nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
net/ipv4/tcp_bbr.c:273: if (tp->srtt_us) {              /* any RTT
sample yet? */
net/ipv4/tcp_bbr.c:274:         rtt_us =3D max(tp->srtt_us >> 3, 1U);

...
