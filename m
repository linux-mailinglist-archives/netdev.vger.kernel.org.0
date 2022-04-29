Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAE9514EAE
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiD2PKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiD2PKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:10:39 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BEFD39BB
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 08:07:20 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f7d621d1caso87977157b3.11
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMPr4PrFQJ1QQw4hoZVyKC4hz+zyXfgJQw+lORDpGxg=;
        b=AiGq7rq9ltPjIzUJv4Xz6gVQx7xE2/n0D9gL0SfeVfu1AgvxnplXciGdHqDNj9nIwF
         2AN1OZeS99A1JGWAUAMeBREexj3F9uplo+JYzS2oQMV8H3131nUow4q87TRz2lLRGWWk
         lLd62oVrsT9Q5o+9DuFZerbvWWJY1rl0b4Skdx/pTmtXHZU/6mc/gVnSRwrm5Es12L4w
         Q/tGRnHspm4Z/wMxnLBj1EFR3dFfxycwSGshxCfDTmKzxvoEkcGOU2k/F2IBKGWAs0IF
         H79SHGu7gA1vXfGPlS9mKXFp5JFb2e9Xkz3rgphAPmF0xO3GmMjJqL+PlVKmsEdMM4s5
         uvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMPr4PrFQJ1QQw4hoZVyKC4hz+zyXfgJQw+lORDpGxg=;
        b=ik8YUK8f6WzVvLbocX9BSOocytym63q+WTxziKz94PIXJNDdvpOOri+c8iih6h1NDm
         JOQ4NA9vkaA0Nbn37aT5lcV75Xx5xBLo/H/bQVeZhULe5oKgBU7p6CB0M9MbbqYI6qpQ
         TZvKSgpag3Qs7ctNJEjfE77kw7A4u7CMWeirG326ny19fEUut2Pan1S5nvKZ56xZpjga
         +jQrBY63Rqnd/GSiTulrqs8c3Ayp6zQck4ty7F/hSkNo7qxCVzmzUQNd2jRnNlrQsU+w
         /GbszRvqCA4Nn46LT9Xm+klVFIFeusjgsTNXitFHu3eoSV41OzfHWuL5slOLrUO+FE/T
         KG9A==
X-Gm-Message-State: AOAM533KRJe/Mjd+B5I0JwQ01XBeBHoE8e8X3Aiexx1Y94wvoqUaLZ21
        wy80WC2BUT1o3fMrhszjszxNlEO54JmxU7XeUvXo7A==
X-Google-Smtp-Source: ABdhPJxRIwOnBFSX8tp8s/g+Dh5jzLyRpfiF8Ef9gfpSPfVktNMZN96WWrsi/Kn2MhRMUc2gq2QFkK8S6LHr5oaf5as=
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr14149137ywj.47.1651244838786; Fri, 29
 Apr 2022 08:07:18 -0700 (PDT)
MIME-Version: 1.0
References: <1651228376-10737-1-git-send-email-yangpc@wangsu.com> <CADVnQynZDunGWXp4Oe4gfbhBBqpB2HyoWs21Z6dh7CFwW-o0Fw@mail.gmail.com>
In-Reply-To: <CADVnQynZDunGWXp4Oe4gfbhBBqpB2HyoWs21Z6dh7CFwW-o0Fw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 29 Apr 2022 08:07:07 -0700
Message-ID: <CANn89iKSRVt=KVmxkUPz5Dmnqv0ED-U3O2m4G3Wr8_km0Add2Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: use tcp_skb_sent_after() instead in RACK
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Apr 29, 2022 at 7:55 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Apr 29, 2022 at 6:33 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > This patch doesn't change any functionality.
> >
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Tested-by: Neal Cardwell <ncardwell@google.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
