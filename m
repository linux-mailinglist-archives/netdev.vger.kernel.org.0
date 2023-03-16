Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1A6BD271
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCPOej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjCPOei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:34:38 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DA7222C8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:34:36 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h5so1076263ile.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678977275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAXWkVDijxnw2BDTwVeUZ4B+Od1pD8xCW/YRafFMsJU=;
        b=nafsOBQrgAeDjmhzAa3RWIu67XeXwovRzAk7PkcUeHJpxz0XJLAeW8a4UDtlKpmPN1
         EhtqVsoWOZqA58hPAgG1StYx/Mbn08riarzBIp88ANPXhvicUjD+o2fWY08SIdYUMqOL
         vuEbd7H8piGSI5use8wYvfrSH/Ns9vHXjyNCNXRU7V4yAA49Py1LHxXptbFNKs93Kplk
         UOhWYxfwzdbfMZUv5l44N3wOq86YD4U34gldlV9MEk7RQE+QSh0ptNidpz7SUJx+ivpw
         7nxx3IpCs0tsaiZ8u6pDWrUDSApZsMpC2fYsM0U8bMNWSAEZ0jnSQBDYTp4slosNHJOV
         WQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678977275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAXWkVDijxnw2BDTwVeUZ4B+Od1pD8xCW/YRafFMsJU=;
        b=t5XdtjxqJEmAJQaghYekd8+jeFdiWyJWgS2/F68Lm2MGPBFvW0SjBWt7v8tkbnXHpr
         JaZXciGm9lTk0rQJyxSXtiCQPychdYOLNUw03ylfhmYWqCwUs0AWjrl/5jC53qnaTaGt
         hPEf0Pvy9ZCuBvrQGhB/TDA8lOoPWj0j88iBN0OOhzmQf589gG9GX9NBaJFlMlTPNeQP
         eWFilXB3FQoDJbLHnIct21lBm3sie/jtMUtvuZIEI2xBfOYix66/gTH6ccSk7tyHb49p
         5Lyqzdj4kGbMnfPnb8Ydg0P+7JeNt/YYyLHKwOxsGJhV+pDNAlUt564AIlSYZC3G3Fw1
         m7/w==
X-Gm-Message-State: AO0yUKWjJmOR14Xbv3ECiC3bbB3Cp9GU5iOa5EkY8AWd2lQ1WrCmiJvv
        ZtAK+ittPNRkvo+EDORsS21xqG0YCvphuIBel5X2jfhsIOv9T/IdLmBixg==
X-Google-Smtp-Source: AK7set+ZRIT9jTyEnUmdriZuyK50X2UU90r0LFKB4vGV21A7kWzGKFjMUSV742r7pSxpfK3az2/G+z57mnfWfLNZTMk=
X-Received: by 2002:a92:c542:0:b0:314:b2cd:b265 with SMTP id
 a2-20020a92c542000000b00314b2cdb265mr5097853ilj.1.1678977275331; Thu, 16 Mar
 2023 07:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com> <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Mar 2023 07:34:24 -0700
Message-ID: <CANn89i+s7TG4jqC1qanboKff=-DRmDjB-vEkoLKbEDwv195ytg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-arch@vger.kernel.org
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

On Thu, Mar 16, 2023 at 6:16=E2=80=AFAM Alexander Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIAL=
S,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.

Hi Alexander

This would add yet another conditional in af_unix fast path.

It seems that we already can use pidfd_open() (since linux-5.3), and
pass the resulting fd in af_unix SCM_RIGHTS message ?

If you think this is not suitable, it should at least be mentioned in
the changelog.

Thanks.
