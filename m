Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB076F2013
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 23:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345716AbjD1VY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 17:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjD1VY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 17:24:57 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383431BFA;
        Fri, 28 Apr 2023 14:24:55 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2a8bdcf87f4so1760141fa.2;
        Fri, 28 Apr 2023 14:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682717093; x=1685309093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rljzU0VELiX9EsAkZDXnPVtLWxUnAXmWBWCF+oOAaY=;
        b=Q5MkxR2ZExbckiOE+IJDWTRSaZUEwLv8xt4VK0TOnv+3I2cmNdSM89Gki5tvc5TYDM
         xj+8Xgdzp03DWqnUbeddAFlRQzKuMUnaTdxHvQIp/sFQMfBQosV2BaAQYrPnH/Y1TB26
         8toagzZu9WS/PpsNxTcmywXhtICGQseS8IR5f4HOkQP9njFtbuEU36HcuhjHPyIdmgdF
         LX325IZNhynqJc5tcHQSkGFJdzTeg12L9r1ExhixfDswOOQERXGDK59uYjQgq0p1R9PM
         M+1IE+yq7+a1Bl0OHFIow3lsr47mNDeNuD2lR1mrxsK6fIXUhMQHJGOq1yIWPA6vpyAx
         tZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682717093; x=1685309093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rljzU0VELiX9EsAkZDXnPVtLWxUnAXmWBWCF+oOAaY=;
        b=ICH+JvPa/hU8sjuUvhPcL0s1A/d8tHtHoqazd740KavOcbWkjHYUs3jqDtvEPqMYB7
         v8EF6smHjfHJKIY8erDH6CkHHoa0nK8UmzR/by7hp3nwOEcVIjwfiEn+hoAbdfNznxQp
         E2hFeCCV9iDEjL1dGlTiOf00UC6hFtJSOr2FfozD1CNB3gadQucvrkXItwsbeP2yPync
         m/d+ATJwZqQPbMAacbRsZRQa/rq9hHmmt479ippZoXqcH86am0UOPRyLES90OIYt7xie
         2mHZLk/bLG4KeE9+7smDQeMG2EDZeqC/UVtN05aA6Ne5HWoIKyRpEqVeMQjolMfzgCwa
         yqPQ==
X-Gm-Message-State: AC+VfDwKMASQ/+5YTZQk9Ld2y1xwu9ITUxBExJQFZRg+HZMSTIrljwqZ
        oIc/C9NraUqQqRyYVFS4C+aH3H45SuGeVAPy868=
X-Google-Smtp-Source: ACHHUZ4oG4Cbik7oyvkDGFIjSV1EguFVeok4T//byGPle9kOvG6TBjmUplvTj1WAXGFRYMolQFPGXVzhKa8zO04thMM=
X-Received: by 2002:a2e:88cd:0:b0:2a8:d0f0:584e with SMTP id
 a13-20020a2e88cd000000b002a8d0f0584emr1826301ljk.16.1682717093101; Fri, 28
 Apr 2023 14:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <CADm8TemwbUWDP0R_t7axFk4=4-srnm5c+2oJSy7aeSzdKFSVCA@mail.gmail.com>
In-Reply-To: <CADm8TemwbUWDP0R_t7axFk4=4-srnm5c+2oJSy7aeSzdKFSVCA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 28 Apr 2023 14:24:40 -0700
Message-ID: <CABBYNZJCbYnxodwXAeq8F9NerzGWFva0OG6SfUWfJ_Grz=Xq6Q@mail.gmail.com>
Subject: Re: [BUG][RESEND] Bluetooth: L2CAP: possible data race in __sco_sock_close()
To:     Li Tuo <islituo@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        baijiaju1990@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Apr 28, 2023 at 3:27=E2=80=AFAM Li Tuo <islituo@gmail.com> wrote:
>
>   Hello,
>
> Our static analysis tool finds a possible data race in the l2cap protocol
> in Linux 6.3.0-rc7:
>
> In most calling contexts, the variable sk->sk_socket is accessed
> with holding the lock sk->sk_callback_lock. Here is an example:
>
>   l2cap_sock_accept() --> Line 346 in net/bluetooth/l2cap_sock.c
>       bt_accept_dequeue() --> Line 368 in net/bluetooth/l2cap_sock.c
>           sock_graft() --> Line 240 in net/bluetooth/af_bluetooth.c
>               write_lock_bh(&sk->sk_callback_lock); --> Line 2081 in incl=
ude/net/sock.h (Lock sk->sk_callback_lock)
>               sk_set_socket() --> Line 2084 in include/net/sock.h
>                   sk->sk_socket =3D sock; --> Line 2054 in include/net/so=
ck.h (Access sk->sk_socket)
>
> However, in the following calling context:
>
>   sco_sock_shutdown() --> Line 1227 in net/bluetooth/sco.c
>       __sco_sock_close() --> Line 1243 in net/bluetooth/sco.c
>           BT_DBG(..., sk->sk_socket); --> Line 431 in net/bluetooth/sco.c=
 (Access sk->sk_socket)
>
> the variable sk->sk_socket is accessed without holding the lock
> sk->sk_callback_lock, and thus a data race may occur.
>
> Reported-by: BassCheck <bass@buaa.edu.cn>

Need to check in detail what it means to hold the sk_callback_lock,
btw is this static analysis tool of yours something public that we can
use in our CI to detect these problems?


--=20
Luiz Augusto von Dentz
