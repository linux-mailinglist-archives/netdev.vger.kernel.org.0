Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821004C2D58
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiBXNkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiBXNj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:39:58 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0D026498B;
        Thu, 24 Feb 2022 05:39:28 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d17so3080565wrc.9;
        Thu, 24 Feb 2022 05:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fg9Z1d1QJr4kWXwu6ZawrpWf/liiKlrQxb9aDLZhGEo=;
        b=QtL5hnJCovp2S7rYTfFtAQkZ2LgE5v2VPHy6Va7aHBOa0MZROrSs4G242H/xlQGAMj
         u1TEXv2zNRJsUYRXx/teJnGdCdB95xcQMtDlV3K2QfG5SlkNEsYig5n+JnsFNL2VZ0qD
         vhcjXqxfYBL48a0SFbhzMa5QYek8VT5aqe/YCqfWMpMr+m0F5p9zQtv/seiwgBj4jtY0
         0bRxz17mEcmjo7ObuwHXptS1lm5OIXTwA2XQQ45/I1Seg4q8V4QbMkqf/xwLH+kofxvM
         tCSnECctj4fcpUilRjMGYJEzchdRnnlwIYaKxwTENq7uW8s5dRXAyI2cfzxM+FlFQa5t
         hn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fg9Z1d1QJr4kWXwu6ZawrpWf/liiKlrQxb9aDLZhGEo=;
        b=ih2d19rd6Gjk23fvWuZQ8eq5ggBIbYqC1ali3rabHHmn660KtUi+HUqpAf9A2Wgzk/
         glWhjGuh4F1M+deARHfbQp/bdRSy/ysmz1is/uAie5i8mwE5CH7K7Dix7O+n9FjKin6D
         2wPjU/bV4yhzh4jTwRHH8opGYFjaDw3Q1AT4ys5UToABHpy/lIZe3E7J1+IET4AhrJwU
         EEGIgMrGrBXRQlagAnNrf0QGC+NeTVTpH0Gr423LFlINiySyn8kut8JhsPc8h0Kq5RuL
         8NiVeM31Hp451e7RW7aQzBqoqcP4WAoNlWmvFDpvTsOpvT+SUuA9As+tK5he2vpVJqGz
         NOtA==
X-Gm-Message-State: AOAM532IUEdPklGTsdkLRvc7KQkB5lJRRIWQfx5729v5YCgBJ5K37LxJ
        7cEQPu9RWzzNFuwWR8YVPAIhgE7ZfneXIMC9pIU=
X-Google-Smtp-Source: ABdhPJxuEueuEwIv1AR2zerawwqa4rRNVGWKI9vJ1Yqspog3+vKZ7BgDUgTTFTBfDsIshTXQhk+C2BaqXzYD2hFqJe4=
X-Received: by 2002:a5d:694b:0:b0:1ed:9d4d:671e with SMTP id
 r11-20020a5d694b000000b001ed9d4d671emr2199733wrw.557.1645709967429; Thu, 24
 Feb 2022 05:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20220222094347.6010-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220222094347.6010-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 24 Feb 2022 14:39:15 +0100
Message-ID: <CAJ+HfNhGWA2TNPcrsFUKT7V=_68z4r4e0AaUQxbppn0S40rtsw@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix race at socket teardown
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Elza Mathew <elza.mathew@intel.com>
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

On Tue, 22 Feb 2022 at 10:44, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a race in the xsk socket teardown code that can lead to a null
> pointer dereference splat. The current xsk unbind code in
> xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
> xs->dev to NULL and then waits for any NAPI processing to terminate
> using synchronize_net(). After that, the release code starts to tear
> down the socket state and free allocated memory.
>
[...]
>
> Fixes: 42fddcc7c64b ("xsk: use state member for socket synchronization")
> Reported-by: Elza Mathew <elza.mathew@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Thanks for fixing this!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
