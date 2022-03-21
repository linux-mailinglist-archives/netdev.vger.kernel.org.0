Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE574E30CD
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352680AbiCUTeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237280AbiCUTeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:34:12 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C45650B23
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:32:46 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2e5757b57caso167535907b3.4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z6gMtfx8QVgEf3arccAWPZViU9VmcvODeyxve9LdyUA=;
        b=WmHRokCoCb+rctM3XxDvSIk94+eN6v2iKmaXMTXbPFOstlyKQF9o24KKFV3oMFVAh1
         BxeP6TGTfK48evxxQjGLZjlQQKzNccfg/rLkzErdyWgmWUU8E7kYDayNohw1GvKIisCm
         /eY8Ic5H9oEx6hWi2ywstiMHi0COieLNTlvN5sbuOmEpXpshhlgZsqsWfn5ZtCUBxFS/
         ytSftonFFmbDnxiaJzuecE0ICVIvoJNvBsRsJOJFXD8YJgV6MTQXHKElCGlRNRcbtmE6
         yKZI/Y16d0sfrQ6Skix2R0td2jaEY4Yfxi4yehidsEl0p3zErZw/b24cDehe8QuIAnGf
         lPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z6gMtfx8QVgEf3arccAWPZViU9VmcvODeyxve9LdyUA=;
        b=wqY2VSv++T11TXkDWj3DJPIWVYU3lMMirLm7QZ6jlzro0E9EIdQ1aq8pdzq2q5smGG
         Lj2hFnIIa2iLWpW6trZKgHn/6W3095v92Vbm/TD/Cgd770eFkjg1Z5uZzu1GFu7ETDd2
         Tp1hzz3MRh/tn/RWPNn8XSBfHPX8D/okWQskJv4ANjf18Qq5pceUFwjxMCsPM5XoBxg+
         A9pbZuBqPoVoTfI9gajVq0FQ2jfU40o8xbjhV9UxLp25jOeKYopVz+8UP4IjG9XfgIrf
         12dxG3mcJuLpe6ue2XCI8d04y1zFHs8QTFjaFyE6WHAGbiSngd3ugL50B9EGNg1C7vYi
         xaZw==
X-Gm-Message-State: AOAM532gyM+waFGY6VEF51rLN+WvHhpOCVSjUB0/b+vLG9jEE/zydSRg
        qbC7yiUN8+6XmkU4OnDsZGWn93PjPsuaUGUHl9b4/Q==
X-Google-Smtp-Source: ABdhPJxeGEDcmrRR+dRFP5m9YWz8ZT3QKiXl7NqEnYICEksAXjDyR2BE6h2bPO/ZuIPbDJOrtH1Du/IXcgRDZiWaI2E=
X-Received: by 2002:a81:a743:0:b0:2dc:6eab:469a with SMTP id
 e64-20020a81a743000000b002dc6eab469amr25885613ywh.332.1647891165266; Mon, 21
 Mar 2022 12:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220321165957.1769954-1-kuba@kernel.org>
In-Reply-To: <20220321165957.1769954-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Mar 2022 12:32:34 -0700
Message-ID: <CANn89i+2WXu2dFf6sg-G1NbBnoEmQuFmek3RxjW5HL6t93zG4g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: ensure PMTU updates are processed during fastopen
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>, netdev <netdev@vger.kernel.org>,
        Neil Spring <ntspring@fb.com>
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

On Mon, Mar 21, 2022 at 10:00 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> tp->rx_opt.mss_clamp is not populated, yet, during TFO send so we
> rise it to the local MSS. tp->mss_cache is not updated, however:
>
> tcp_v6_connect():
>   tp->rx_opt.mss_clamp = IPV6_MIN_MTU - headers;
>   tcp_connect():
>      tcp_connect_init():
>        tp->mss_cache = min(mtu, tp->rx_opt.mss_clamp)
>      tcp_send_syn_data():
>        tp->rx_opt.mss_clamp = tp->advmss
>
> After recent fixes to ICMPv6 PTB handling we started dropping
> PMTU updates higher than tp->mss_cache. Because of the stale
> tp->mss_cache value PMTU updates during TFO are always dropped.
>
> Thanks to Wei for helping zero in on the problem and the fix!
>
> Fixes: c7bb4b89033b ("ipv6: tcp: drop silly ICMPv6 packet too big messages")
> Reported-by: Andre Nash <alnash@fb.com>
> Reported-by: Neil Spring <ntspring@fb.com>
> Reviewed-by: Wei Wang <weiwan@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Do you have a packetdrill test by any chance ?

Thanks!
