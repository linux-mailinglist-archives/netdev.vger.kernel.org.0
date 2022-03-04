Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A984CCDEF
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbiCDGi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiCDGiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:38:25 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4118EAE7F
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 22:37:37 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2dc585dbb02so16995747b3.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 22:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3fLrVxBtlxhn0wrp2tAt5sglfBK5RcrlC4xzm6Ry66U=;
        b=H/IrSNshqB0YpMztLKTG2p5rZGIvmjuZYGGfgMh9857kj0Atg40FNjYypfTDnMg/ow
         Qhh05JF33zHlosZMfOsOBz2FdQVlWs23Rmw74iFmf+HapqUMN7O5nvCC37Z6bOW14YI4
         Dkz9FpjW6qmr5STY4MAhRfstQNeNSUWVUChn5/cTw+SHTE+4cNNDsmy9ey39pF1o+Gu9
         gpjrSDl3kpgcxqtdQNB/qgOtSyK84AHgc8lZfAD5zA3/80HvWJm6kMztvC+1DjME/qZV
         9jprdKIatVYAHIuwNczyZdEdhWY7i6CVSPm+NmlQzKXTyOCqD9mKQv4TMH5fqmD2pubk
         m+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fLrVxBtlxhn0wrp2tAt5sglfBK5RcrlC4xzm6Ry66U=;
        b=OOZMGhh0wWC+eUadO1B8pUvAHd98mZf3Jdrg9xwxlAvFXosRNYs84toNnpY5TP15/d
         mK3GUghUJcHlMQQZpUi0S9BEWn/zSa/VtIsvSJffbTDPMZlk3pvTvHLvjBYKIPQQ8S+s
         d9S4SVWlW/eIOXXRev7RkwpEJSuRyxxZoy1IvlcTqYl0B4Yvb3FJKav+4DJCC6GhGpyU
         3IzDzFDsZiB4e8huk0wl/pW1IiVt5erC6NjjaNCSy3EwtIYqnAKIFOeaBuQ1kFAZ43+w
         Z++IyZawNB9lQIX5yWbPqdZMJYIBNmbsNNlJSv+tBOhtcEdZ0f9sggHIp/Ym63lqRMg8
         AJoA==
X-Gm-Message-State: AOAM533r/4V5P4dEU6VnsN54u5ZAHkHB+QQSCyt4OtQtJAXls1EzjP/Y
        jtgA3eqtQ1N6Co9OfmamZenlwSMA4QsCN+jm2xoUfw==
X-Google-Smtp-Source: ABdhPJzovtFWt7BjKksgwSY16S446P0AHfMtWnFFY99KZRcNokgi3VmYf2UbOwNAvxIAm4jluc6nLw4RlmmuroJPFtY=
X-Received: by 2002:a81:af57:0:b0:2dc:40d0:1380 with SMTP id
 x23-20020a81af57000000b002dc40d01380mr5354981ywj.255.1646375855747; Thu, 03
 Mar 2022 22:37:35 -0800 (PST)
MIME-Version: 1.0
References: <20220304045353.1534702-1-kuba@kernel.org> <20220303212236.5193923d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303212236.5193923d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Mar 2022 22:37:24 -0800
Message-ID: <CANn89iJ_06Tz8qA26JsgG14XdHCcDbK91MCYqneygSuTRdzsDg@mail.gmail.com>
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Menglong Dong <menglong8.dong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 9:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  3 Mar 2022 20:53:53 -0800 Jakub Kicinski wrote:
> > -     return false;
> > +     return __SKB_OKAY;
>
> s/__//
>
> I'll send a v2 if I get acks / positive feedback.


I am not a big fan of SKB_OKAY ?

Maybe SKB_NOT_DROPPED_YET, or SKB_VALID_SO_FAR.

Oh well, I am not good at names.
