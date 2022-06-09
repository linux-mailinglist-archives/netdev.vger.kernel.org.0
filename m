Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDAF545055
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241973AbiFIPNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbiFIPNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:13:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8D147059
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:13:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i15so3717458plr.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DNe53S94xC+XUfNNqNVcyWfPCB1Hy5WhFvMQYjAdjxg=;
        b=MnmJv7r6ykoLBSvEmQcrEhBQ35E8XcenBpJCtME5zx7uula4ZxiBEk0z0J0OcUeSaB
         yyHoM1BAtz7sb7C1EmtWxnzCHckX2kj7Y/z53h5vnQw/7z2iZoWjw3pEpl1sWJD7RXss
         WPZ0kNHYZmLqTYjwLzWHludkzTd0fVTIg1Dd78Gnnmdyjn/dRrI752oaSetijYPsDlEN
         Md7fkzDperOZe+3SiB9hGw6miHYPfdHbQLkW6fSxtfb4nJuayvzrzavSSxzJCWUStvtU
         ExJGcqvH9RdtIpdsA0wyErVhKSqA4MUWPuvWFNDWSx5dw7DaPavO9s8cTR8mhda9hyJa
         XWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DNe53S94xC+XUfNNqNVcyWfPCB1Hy5WhFvMQYjAdjxg=;
        b=tZPzfvnu45OUPN5EI+f4nG1M53yay2CbjmuZRtgYzYb5y5w32inF7XOPbuhIOCb+Nf
         5/vxlNbAZYiOUAas2Zv3CYGOWsItcJ7vx09i1Z1xpvKMJcFr+XWLXk0h1XsNUhJzNDaY
         yJjfqeIdIrIG7QkTXpnEy8/LKEzGxH/g5T8Lvn3aL1w1+kB1H57jnsgifjiuegN0TWqt
         N/sD9bUB2HxKpgpoE6zLpdH6vxb6OMLoZasJFVH1qRXUWXoGcuOFDdIYveCvI3oQfX8s
         kRVhi2Y/eiKjytJ1x5/Od4Hs9kjVys9XsLTOLB/1sEzkqveTMJWNUbe84isjoirZ9sYK
         DNzg==
X-Gm-Message-State: AOAM532QhnN1Pr9WhVBLX9lcQo6zi2XyVzXIWU43C+0aOCZx8GknC7Zq
        hPwUKeMbA55AXtbcsXFGu2rLPRI/ZvQzuKdMpsr9QA==
X-Google-Smtp-Source: ABdhPJwbpraoRQssFMTX4GAIoWX2plM9eA2Z9YzhVW1+LwEj1m126ojeT02pdOeyDv49NiP1uyX/HvxfdTv1lzA/TRU=
X-Received: by 2002:a17:90b:1d90:b0:1e8:5a98:d591 with SMTP id
 pf16-20020a17090b1d9000b001e85a98d591mr3906541pjb.126.1654787589672; Thu, 09
 Jun 2022 08:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-5-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-5-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 08:12:58 -0700
Message-ID: <CALvZod7oB__SWvvODwqCxLNj3zDFX5MTKXwVRpYzuNcSeQ3eqw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/7] net: implement per-cpu reserves for memory_allocated
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
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

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> We plan keeping sk->sk_forward_alloc as small as possible
> in future patches.
>
> This means we are going to call sk_memory_allocated_add()
> and sk_memory_allocated_sub() more often.
>
> Implement a per-cpu cache of +1/-1 MB, to reduce number
> of changes to sk->sk_prot->memory_allocated, which
> would otherwise be cause of false sharing.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
