Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D324E513AA1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiD1RKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiD1RKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:10:01 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02EE4D263
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:06:45 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id r8so3646795qvx.10
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Q/nwGf2gvXZo3FscYTT73GRgFbplfQQgxZU6MHvJRY=;
        b=KSEAl6QDEEH2IpborJZzugQrVvb8R7fnmr0Usk6BZLglLkZDZemwM8d1RbSKiydlT2
         6zz8tq+/ZgWdmfdSvgScVuevZmixTfLVylqNS9pfrZJ7pySCMsPbWDbbSeLJIKCtIxq6
         NyFkq+Lc657LoR4KwFKKEH1RZ8LIs8IWJW5k7Fgv8anhMeBaryn+h8+6ihyL4hM7Pvj/
         CFOUzaqgUi/+A8tS1PfAXI8N+QOQJ7QU2H9DxUe/U4vR5q0/E5XjCgiwYXzqt6fuRj5F
         GwImmZwz+d1PPoAWG0VWBDveEbLt6+t7ifY/vLULDbWSSbEvmBPpqS8qFpZXtnBqIACl
         ZWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Q/nwGf2gvXZo3FscYTT73GRgFbplfQQgxZU6MHvJRY=;
        b=rNktCx8jY2ZqGSS98WFovWc86BFt/tP/5xcxsJ7AHqjCK91cpWYkftmx/xwYvusnra
         19qu1UtvO9AyIKvdZPAD5g0K2Eh13B8JnLFE11Oy4TctdtoTLv1vSwTWN124Sz2s6Sgm
         xoR1tIlSU4sRYDf1vmFuF7URLWtR+G6XUoIZ/Pfo8fUUWK2Q10sxn6434X9/KJkX4a8/
         PYqlWzaJQmARW89zdPr2ru2wF8cHnDfHa1jiPpLGP0sDW98soFa67T/coEnkduHN48Ih
         A+lITtryktVe8XosO5FBJZOu2jRm89Ge6jO0rDf9Ofv7wX6f4SYX5PrECLz7ioJvRkmX
         Ij7A==
X-Gm-Message-State: AOAM533ngG4cLmFzIdvb4/Si1anI8iB/iKOQlGbT2mXUawfJDk744+NW
        uZ/5L10i1Yn5HovBodPT361Xj3LZRmqsUPmLW7dmkA==
X-Google-Smtp-Source: ABdhPJxwv8mHwOJ220dTftHcpvSxVYR21KDYmtJNsq1E0WAwdT5ifzaUKOi6GyqSuTjWMECuoQUJzjjz/iRFxpaEsl8=
X-Received: by 2002:a0c:e906:0:b0:456:540b:4e87 with SMTP id
 a6-20020a0ce906000000b00456540b4e87mr5814240qvo.47.1651165604859; Thu, 28 Apr
 2022 10:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <1650967419-2150-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1650967419-2150-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 28 Apr 2022 13:06:26 -0400
Message-ID: <CADVnQy=0MQ-AvfJShdP9mCWHVG3cVpHXrkuw9wbzGSsXughxeg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix F-RTO may not work correctly when receiving DSACK
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Tue, Apr 26, 2022 at 6:04 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Currently DSACK is regarded as a dupack, which may cause
> F-RTO to incorrectly enter "loss was real" when receiving
> DSACK.
>
> Packetdrill to demonstrate:
>
> // Enable F-RTO and TLP
>     0 `sysctl -q net.ipv4.tcp_frto=2`
>     0 `sysctl -q net.ipv4.tcp_early_retrans=3`
>     0 `sysctl -q net.ipv4.tcp_congestion_control=cubic`
>
> // Establish a connection
>    +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
>
> // RTT 10ms, RTO 210ms
>   +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <...>
>  +.01 < . 1:1(0) ack 1 win 257
>    +0 accept(3, ..., ...) = 4
>
> // Send 2 data segments
>    +0 write(4, ..., 2000) = 2000
>    +0 > P. 1:2001(2000) ack 1
>
> // TLP
> +.022 > P. 1001:2001(1000) ack 1
>
> // Continue to send 8 data segments
>    +0 write(4, ..., 10000) = 10000
>    +0 > P. 2001:10001(8000) ack 1
>
> // RTO
> +.188 > . 1:1001(1000) ack 1
>
> // The original data is acked and new data is sent(F-RTO step 2.b)
>    +0 < . 1:1(0) ack 2001 win 257
>    +0 > P. 10001:12001(2000) ack 1
>
> // D-SACK caused by TLP is regarded as a dupack, this results in
> // the incorrect judgment of "loss was real"(F-RTO step 3.a)
> +.022 < . 1:1(0) ack 2001 win 257 <sack 1001:2001,nop,nop>
>
> // Never-retransmitted data(3001:4001) are acked and
> // expect to switch to open state(F-RTO step 3.b)
>    +0 < . 1:1(0) ack 4001 win 257
> +0 %{ assert tcpi_ca_state == 0, tcpi_ca_state }%
>
> Fixes: e33099f96d99 ("tcp: implement RFC5682 F-RTO")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---

Thanks for the fix and test! Both look good to me. The patch passes
all of our team's packetdrill tests, and this new test passes as well.

Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
