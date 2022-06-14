Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299C554BBBB
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiFNUcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiFNUcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:32:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428E24DF51
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 13:32:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so74659pjg.5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 13:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9BBmDP9S6Mf7Eg21p8WdZh8OhJDv1z+wOs2Kwkk8b7w=;
        b=cjqpAOBX4bIHtdnfrG81pnQJH3dKBMF5OCy5l5p1/m25zDBWCKTGZKgAMFzxvqIJ7x
         JgkH+p8WICKGsDf/Oi27hQMZZYkHQ0AxCYwGCv37uhQCBbb5w2WRC5jlCBrhzp50ll6G
         ynrvl2sTcLDheYNlQsa0bzfJpD81OhdVfcnc2Xpf5XslWw66g6UVtvJaxh28OwH5J4/P
         31okcYFss3svUDucTi6xRfvpddBbgWoh2FBDVocGfHeuOu1s383CgQXklm717ALgBejQ
         40Xja8pW02QTe0ZoNuDd/lVXjgtomDV9sUhiT4Hw8Yuo9mwQZW3A1Mhqzstu8lBmuEh4
         NqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BBmDP9S6Mf7Eg21p8WdZh8OhJDv1z+wOs2Kwkk8b7w=;
        b=AdhTVxsIS5a+41iRD/J0JsLKuVTu9Y2y0ods/ASEuZMjK3DIY82MYvlOLGPWwLh06/
         eN91w2ldqCyXBEjuvRlC56m9bL+BwwUclKQbR+Kha0VbWLyr+xJQpqD3bPBOv0fXIV46
         juJP03nQiL9TpbCO3uXzL4JL2YEoffjdYp1dgCewrv+89uMw+z4x/7v3uYsSVThCOrK9
         7qX5iid6TEzThRpdmV8zHXvs/kCKdL0fCvsUnvbRBADUEtdzV/fPY+HXo9OirIDxKSFn
         WjTjg4wB9GvLvoHsnfuZ4RJ56x2Hx1m+cgTp7tymNWJwtN08wfqPQGcW9hZEbh6muhy6
         MAsQ==
X-Gm-Message-State: AJIora/gMcyyYMwPqwpv7Pj0i4ZC2/UbkGrzIa8kS8twlDKhM6jvlg4N
        uQHoxBJU5g24uY63uSXFpyIZW4nCrTamdUOe21LISA==
X-Google-Smtp-Source: AGRyM1veTaRHKU62t+ngOj30xq8y+RYfi7xcu/30WG64A+EIOi17mXXXq0pYFH4CtC5rEoKyMmpt4GdBPDRQsjekerU=
X-Received: by 2002:a17:90b:4a4e:b0:1e6:6757:d085 with SMTP id
 lb14-20020a17090b4a4e00b001e66757d085mr6333594pjb.207.1655238727548; Tue, 14
 Jun 2022 13:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com> <20220614171734.1103875-3-eric.dumazet@gmail.com>
In-Reply-To: <20220614171734.1103875-3-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 14 Jun 2022 13:31:55 -0700
Message-ID: <CALvZod5N-teApG8s0-DDRzoE0YOTfZe4P0r2R4boe_f_PJ60GA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] tcp: fix possible freeze in tx path under
 memory pressure
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

On Tue, Jun 14, 2022 at 10:17 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Blamed commit only dealt with applications issuing small writes.
>
> Issue here is that we allow to force memory schedule for the sk_buff
> allocation, but we have no guarantee that sendmsg() is able to
> copy some payload in it.
>
> In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.
>
> For example, if we consider tcp_wmem[0] = 4096 (default on x86),
> and initial skb->truesize being 1280, tcp_sendmsg() is able to
> copy up to 2816 bytes under memory pressure.
>
> Before this patch a sendmsg() sending more than 2816 bytes
> would either block forever (if persistent memory pressure),
> or return -EAGAIN.
>
> For bigger MTU networks, it is advised to increase tcp_wmem[0]
> to avoid sending too small packets.
>
> v2: deal with zero copy paths.
>
> Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
