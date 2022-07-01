Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B58156380D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiGAQgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiGAQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:36:35 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAA642EC2
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:36:34 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-31780ad7535so28808997b3.8
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 09:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DS7cq1cdzrrQQEAt94J8B3xMEYVFewbYF7KESn0Pceg=;
        b=AEyyq63SS1Cb1J3C2t9FRtDGD8/riijAltz+cEbX2CWfZAR0GAOysI4tl2PUlhKsrS
         1cmTnXZ/hoApevizcx84v7L5/Gb3lMPhKceJa7v6MT6jeFzWXSOU3zPPyKJrPul1tHVi
         tRpVDn2QNOYl/qIET5B1XAXF+iJRjYZwFkL7HIlGSlvU2dU45jeR2efwJz+q5saRo8tA
         XfXS1R7acQ8g1y+X/jJ3eY6Or4WzIfIzOqHlq9ApUAcFemveAiVGy+nP4gGFvCDq1OES
         hxPM894FfkH98D/O4D53KNQp1RGg1bzX69ORSqzPm3d2JY4Xfol5Ft9fCX55AVYRwkin
         jOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DS7cq1cdzrrQQEAt94J8B3xMEYVFewbYF7KESn0Pceg=;
        b=fkixtQP3GwUI4PD8gQ3Z0orpKc1LvDLLYxkvAGZvjh9JswifFgtuiV2O5wdUNp3JdZ
         d9dgBSdfbc+SRK8t6L5WhXnYOp0R806XiElfdH9Xdkq0oa6ntWAzJl8YWGRgoKBk5SzD
         JH0wVztC3IgGf4pUpjSBKAUTypXg6LL6J0nkURIs7Wyt1mEXV+bOGL/x4rfMdki1nMTA
         JMW83KJ0FJHRGbTKEFPy4bf4bWr6DNnwJRW3qD7AvDVe0oXQyPQcHFfbAeyS26apQLXg
         16/KMHOK9eNC/1PzAOawLZxi65tIXXgrXW4OJZqHtXcAPwPa2pQg8cDIm6nTnBLoQtia
         zfCQ==
X-Gm-Message-State: AJIora/GssiE1Q1IS5KrzpZKA91t/cZ8qbSnlYUlSgWwFp0NYijlRZO9
        +D+o4ITzSptMWJAUSy8yqX3Bued4ZlkozgFYwGiTOA==
X-Google-Smtp-Source: AGRyM1uxyGqpHKPmKGGHAdf2anNIn7s4WWXeibsCN61rtwwHauh3NC51dYwa5zWzvap+3/IHb7OIwFw3deFFjjEKE08=
X-Received: by 2002:a81:1c4b:0:b0:31c:5f22:6bd3 with SMTP id
 c72-20020a811c4b000000b0031c5f226bd3mr3952320ywc.47.1656693392925; Fri, 01
 Jul 2022 09:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220701072519.96097-1-kuniyu@amazon.com>
In-Reply-To: <20220701072519.96097-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 Jul 2022 18:36:21 +0200
Message-ID: <CANn89iKk65P3FDiR0sfGuJdgeE53dCADi6WwiCLsEYF+ttHRdg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next] af_unix: Put a named socket in the global
 hash table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
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

On Fri, Jul 1, 2022 at 9:25 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Commit cf2f225e2653 ("af_unix: Put a socket into a per-netns hash
> table.") accidentally broke user API for named sockets.  A named
> socket was able to connect() to a peer in the same mount namespace
> even if they were in different network namespaces.
>
> The commit put all sockets into each per-netns hash table.  As a
> result, connect() to a socket in a different netns failed to find
> the peer and returned -ECONNREFUSED even when they had the same
> mount namespace.
>
> We can reproduce this issue by
>
>   Console A:
>
>     # python3
>     >>> from socket import *
>     >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
>     >>> s.bind('test')
>     >>> s.listen(32)
>
>   Console B:
>
>     # ip netns add test
>     # ip netns exec test sh
>     # python3
>     >>> from socket import *
>     >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
>     >>> s.connect('test')
>

I think this deserves a new test perhaps...
