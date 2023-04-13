Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2F6E0F1D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDMNq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjDMNqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:46:22 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFF98A74
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:46:10 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id y16so290937ybb.2
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681393570; x=1683985570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C137QiYBMX92Ecjt0ox/zWw4fb49/E1TroIjKs5h7Zs=;
        b=wX0Gkser8T2uKaBDJ5IoWIR9M0r/8cWaX/huN+YA/ZKxnsogiTY1P8jBjAoY1Gm84s
         350KZvoZpACmUcUgX0lFn7LVeQPH0MExmZwauwXGiXieVHyuiRmA7blK1DVS+9c5vYrD
         cd6udN1SQVp1MP+CPccVPM0mGMnFonergDbJcOK4KV5cot1zil6PZWHa9sxa0uvi2k9+
         sBvIqs1cCk0ZYymoqyXzdknQOidXvbczyHUg6FaywoQaaL9SF+/EUQ7vvyuJi8UeN7jO
         ChgLXitareGrah+nPdIFEiuPRBVCnFE29TUZi0do3FucyWnf+w2rYZlC6/rNIs1nge2c
         3kEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681393570; x=1683985570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C137QiYBMX92Ecjt0ox/zWw4fb49/E1TroIjKs5h7Zs=;
        b=XK0HAxvoxkeRRJk9PZUbbh4Lir6IXMPev2iUCSWNjGUuO3OD2cB6ZyShxxYqvQLknq
         oDxHRIZN/vCEX+uFzwvmwu0TWEua4cbNbprch+gXwQiutQAuNmBvputlOAUUkhOe5uvZ
         c8a0KzeQt+g7MWNgNTCYx5u9EqLn9ngH3x46SlPL6FQ0WTIdDEVw7lmn4M4ZeOWElTO2
         t6vmgZ4WYJsn5dePPi1axJCb8cXuqWmGKNcL/oo7Qvkr/MqfQd0SrsabyoNjoBefJrEZ
         mw4jc85zbW/LKlr9nEoDBmbyQNs+MISaF8l+S4w/BEPLP4t6iuFsIyTaK7S9QN2Xr8i9
         7N7g==
X-Gm-Message-State: AAQBX9fezJIRSb2z+v93cQCm4WEl+FtjEupreVx/iBdrPBhMKKvcn9sK
        HEeKfZ8E43bcnabq12EuP1jY813uskKEGynuXEBeMA==
X-Google-Smtp-Source: AKy350Y3lv/NwZDiNjmrqHtva4TZi/dFsMpqar6JkSEtZbaMvhValmC+gLNzIbXwy/DFJsMv22xLnrNVwIIfQEIcbaw=
X-Received: by 2002:a25:d151:0:b0:b8e:d126:c64 with SMTP id
 i78-20020a25d151000000b00b8ed1260c64mr1424618ybg.4.1681393569644; Thu, 13 Apr
 2023 06:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230413090353.14448-1-liangchen.linux@gmail.com> <d7cd5acd-141f-32c4-6d7b-3563d67318e9@huawei.com>
In-Reply-To: <d7cd5acd-141f-32c4-6d7b-3563d67318e9@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Apr 2023 15:45:58 +0200
Message-ID: <CANn89iKqYawM9ren=_Tus3NMOKBM3f-5pXaHcZiMsK7rDgYXZg@mail.gmail.com>
Subject: Re: [PATCH v5] skbuff: Fix a race between coalescing and releasing SKBs
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Liang Chen <liangchen.linux@gmail.com>, kuba@kernel.org,
        ilias.apalodimas@linaro.org, hawk@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        alexander.duyck@gmail.com
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

On Thu, Apr 13, 2023 at 1:42=E2=80=AFPM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/4/13 17:03, Liang Chen wrote:

> > Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in pag=
e pool")
>
> I am not quite sure the above is right Fixes tag.
> As 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment recycling=
") has tried
> to fix it, and it missed the case this patch is fixing, so we need anothe=
r fix here.

The Fixes: tag is more about pointing to stable teams how to deal with
backports.
There is no point giving the full chain, because this 'blamed' commit is en=
ough.

If an old kernel does not contain this commit, there is no point trying har=
der.
