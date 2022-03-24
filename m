Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DFA4E66F9
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbiCXQ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiCXQ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:27:08 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273E26E7BE
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 09:25:35 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g9so6932526ybf.1
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mk3MOuKJsVjxN7vOMpMgb0Z3pMUNj/bOGsrAecjCYYs=;
        b=T/GWT01SPJUR96uv1nLOdB1f17Ez7GOBbaHJP3OC+J4Lz43JiuAfoxrxuNponjq9/3
         9Ah4ttyPi5jk+GuWIAukl3SgMys7v9SafLmV4VuYUT86B18o9m0br0ryNy566I2Csf/9
         nVaBOu1ToOmTHoKRE5CcbtHIspJaEbOLgrR2Km3tIZWuH5KTWiKbqzrohcX+pqMLDBMI
         lO5Gr0DJy2d2P5+LPdTkvEfiex9jPM5/EsOkZXKGfXCsmDJVkHQZriOTk83QEu16LCzu
         tFYnGY0IQgNTqsy/Uz/5MIBnbvOY0IRYGvyMCJkDIYheBgmlhQQMR8ERcoVfk+E5iRuo
         to1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mk3MOuKJsVjxN7vOMpMgb0Z3pMUNj/bOGsrAecjCYYs=;
        b=VTS5fA6oKyt/FkMjV3pMrfLm+Um5hcdyPStSDgfJaJYLuu9+qgdDvAlVuKvtK14itz
         dfKUKDYcZq75Xuh43P2NtMZDDDDhHYfNPEcJQw7NtqMGnAbdySN8bl2aKu5zPGnl6jaz
         jYuJLHyWoLjub+3WJ1UX17w5R016QRcY7iB9AhQ84/NHxRWAH/4F85k9g/0Un5UDBICd
         0eJFen9murfpnYA2dkJNWntcBhD5OcfsLQK2B/rIHnZPwBPSrl/wFuLKM5oONBoHs0bB
         TMKLiN67yAnNxwICdrlv8qBsj7ZgInA1i3SYuXqk0r5TKHpy5CA+InnaXXcW7i7JcqIv
         8M6Q==
X-Gm-Message-State: AOAM530zXhGi405ykJsrxeER/310S3wBbIuL30Krs+AgRBP3sA/vJ5sA
        RfMFeA/d91nFYeGC4qHr9hkA7KuFdwz19w4vGN20cg==
X-Google-Smtp-Source: ABdhPJxyQJQNF6aX65rAbQqRlolHS9ZRiN3trbxhkgovk8ml5L58NLYRwcg+Oo0+n9/rt0Aj6BWsD12/ddM++KY7q48=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr5289850ybq.407.1648139134851;
 Thu, 24 Mar 2022 09:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220323004147.1990845-1-eric.dumazet@gmail.com>
 <20220324062243.GA2496@kili> <CANn89iKJamk6v5gt67tE0tG0i3XS2LofJu34uT=_AVqYCs-0SQ@mail.gmail.com>
In-Reply-To: <CANn89iKJamk6v5gt67tE0tG0i3XS2LofJu34uT=_AVqYCs-0SQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 24 Mar 2022 09:25:23 -0700
Message-ID: <CANn89iKUMHrr8esnT2yMf6Pe6uLDRwemEsPhhTp+G_CRy_CCvg@mail.gmail.com>
Subject: Re: [PATCH net-next] llc: fix netdevice reference leaks in llc_ui_bind()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
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

On Thu, Mar 24, 2022 at 7:38 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 23, 2022 at 11:23 PM Dan Carpenter <dan.carpenter@oracle.com>=
 wrote:
> >
> > On Tue, Mar 22, 2022 at 05:41:47PM -0700, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Whenever llc_ui_bind() and/or llc_ui_autobind()
> > > took a reference on a netdevice but subsequently fail,
> > > they must properly release their reference
> > > or risk the infamous message from unregister_netdevice()
> > > at device dismantle.
> > >
> > > unregister_netdevice: waiting for eth0 to become free. Usage count =
=3D 3
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Reported-by: =E8=B5=B5=E5=AD=90=E8=BD=A9 <beraphin@gmail.com>
> > > Reported-by: Stoyan Manolov <smanolov@suse.de>
> > > ---
> > >
> > > This can be applied on net tree, depending on how network maintainers
> > > plan to push the fix to Linus, this is obviously a stable candidate.
> >
> > This patch is fine, but it's that function is kind of ugly and difficul=
t
> > for static analysis to parse.
>
> We usually do not mix bug fixes and code refactoring.
>
> Please feel free to send a refactor when net-next reopens in two weeks.
>
> Thanks.

I took another look at this code, and there might be an issue in llc_ui_bin=
d(),
if the "goto out;" is taken _before_ we took a reference on a device.

We might now release the reference taken by a prior (and successful bind)

So it turns out another fix is needed.
