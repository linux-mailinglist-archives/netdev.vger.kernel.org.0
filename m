Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE5A6DF7F2
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjDLOFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDLOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:05:13 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E7610EB
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:05:11 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q5so14638160ybk.7
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681308311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFjCio1SMkjC3GGn+rz/NhJQfbUxSjSUHscFzuxXyMI=;
        b=gnes7f+P2h0U2KW2LIq5aq5lt8OOzRzVYh5yVool/oSq1/rqkzj8HrQOGWVmjydIZA
         SUqfWjxd1PIO9mLn5Ed5MDLomWssJyBVHIRezYSNQBvdmnAHda86ZX06KPaRR+LN5SzU
         V7y8BzBHphPUQcE1csurOKwduELnCJ57xLsRxQ6OO9ITaOS8blITvJRh59UU6XIPDW7t
         FTxmUljChXNO7AHUixguqPTdGckolLB6AQHr3e9f5dZQ5Ss+UOS+oWHGeIyq5Gf3VIZr
         +0kLLyZpzFLW7qDCPwa3MPFk3bhQZnp+1Mn53M+J2AKiZrhudSdZd1vGB13eragDMiSy
         aeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681308311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cFjCio1SMkjC3GGn+rz/NhJQfbUxSjSUHscFzuxXyMI=;
        b=q8GTsJSo2gv5Nhi9pyhM+KVA9DeVHAx+8C/un+IX+++l0Ofkj/rL2nGNN50QrNAAJa
         li+zAQCrfayh+fk8wwNZQq7D4/el3MuI6X0romK4Mv15Xtr5Z4m798cD/BJIND6WLfWG
         9jRWttYVzodrf+Lm9hEIdezg5Jipm8qQrx99FCr3R9rZLBM8TBd9Wm6yjMsWTDGu4OmY
         0LCGFCb8JN6veie32KPvTwUWwwWW4fxDaf5bQN090lnfZrhzkj8YyJcWEqCqqT127f0c
         EdGhMY64ufVcK9maeLTMrDMZlNXFaViaBnKhk/JU2k4Gv0C5WDdpdZSqlgippXLX6Ft0
         bSxw==
X-Gm-Message-State: AAQBX9cd3eXRKp7NmOCACgXAd6OxyjIyaCUmDTbQdTYJ3+Gpj+WOaqLT
        VyudTue/vdRu+38ejaqVPyW5+gv9y7MBAX7BpoLTdw==
X-Google-Smtp-Source: AKy350a4Mig5tyYnPu+tLPpb6khDV7oFSg2EjCWnKvNSZCZfmuEt/i7W893cD10h29qqiIxcKjOx7l4uxElbLCAsZjc=
X-Received: by 2002:a25:76c7:0:b0:b75:8ac3:d5d2 with SMTP id
 r190-20020a2576c7000000b00b758ac3d5d2mr1757778ybc.4.1681308310683; Wed, 12
 Apr 2023 07:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230411022640.8453-1-liangchen.linux@gmail.com>
In-Reply-To: <20230411022640.8453-1-liangchen.linux@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Apr 2023 16:04:59 +0200
Message-ID: <CANn89iLeVKPz05daEPCH+Z5WkPGhJAafFu8z-dSsKW725LtEUA@mail.gmail.com>
Subject: Re: [PATCH v3] skbuff: Fix a race between coalescing and releasing SKBs
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     kuba@kernel.org, ilias.apalodimas@linaro.org, hawk@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        alexander.duyck@gmail.com, linyunsheng@huawei.com
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

On Tue, Apr 11, 2023 at 4:27=E2=80=AFAM Liang Chen <liangchen.linux@gmail.c=
om> wrote:
>
> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> recycling") allowed coalescing to proceed with non page pool page and pag=
e
> pool page when @from is cloned, i.e.
>
> to->pp_recycle    --> false
> from->pp_recycle  --> true
> skb_cloned(from)  --> true
>
> However, it actually requires skb_cloned(@from) to hold true until
> coalescing finishes in this situation. If the other cloned SKB is
> released while the merging is in process, from_shinfo->nr_frags will be
> set to 0 toward the end of the function, causing the increment of frag
> page _refcount to be unexpectedly skipped resulting in inconsistent
> reference counts. Later when SKB(@to) is released, it frees the page
> directly even though the page pool page is still in use, leading to
> use-after-free or double-free errors. So it should be prohibited.
>
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
> Changes from v2:
> - switch back to the way v1 works and fix some style issues.
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
