Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F8257191B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiGLLyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbiGLLy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:54:27 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2772E2A420
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:53:52 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e69so13519784ybh.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RtZoDSnVK4mZEldcna2DT81jLvUnse8vKV6NFr9xFJM=;
        b=jCSmAAVFt9BM+ZDr4A/l6gtiFUAsxWGmepdJ59dZ697sWobfozB3AIzjDmZ5uuPYjK
         9qkKByUX4zfQeknnYmK0n58LYpU+nszDeAdxiEuiTihP7nJKwBNXXFNaw8T9Qtpx+Yzv
         o0p77SirezlacXc5JSzhs9VTkU2478jhjICRVe8tvVTyIOY9RJpme7wI9tnlBVEo55x9
         rM4up8NJrL+r0BNZ0T9J38HKHW5MVHqyEJ8K6c+5uVnONe4YraZzvwCkLO238egyIup6
         yC16CPiXaE/mu4RZ5vk3PoLdGilsGRE9k4RFhJQKh7DTVAccmMsrb/iJxeuN0lyCNLdV
         jl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RtZoDSnVK4mZEldcna2DT81jLvUnse8vKV6NFr9xFJM=;
        b=IN2mBSXlsrP2gITkqJr6MwgQ1Y0Lwaz0/G9CfIXnTW/Mc5fRI68B51VxMPDInMvYS0
         lYueyztHU2kcJ/xfi7j+4RpokIWLZej/JPc2iXN8pe8uN/Y6tmsDdJ07U8hPM9R+UZIp
         d0mVIz22PpT04UwynBL/lCxEs/+sEwg52J4nxWZl3loDaXL0aRJdQIG9r954FuvOHmpj
         genVTUReddGklCTkhbsr24RY6iurxOQTyjx90h38y17xZnnQ02a78fnee989VCgXU+Y+
         Bs4mtZZuGPScgBrhGw5CvtlkFSqEafL1RQKXbzpFOYHyf3yjWCBJvkztnZIrecWsqzJJ
         T6fw==
X-Gm-Message-State: AJIora9L1gCHEIRZyc/zKcXcggwaxsU4RZFu8T7uvCKCjFblaUQuHbfO
        1Pn0cniroTS7d8GPskhhp6x33dsVVhWsBvXI7aFDTW5F91k=
X-Google-Smtp-Source: AGRyM1tBgMAkH+XeYYT9bTsU/P3jlC2lJ56JVjV+yaCoRCTtNb7BO5vGMJh/3F4kaKfcLyVzsQfLl2KTCTSkrWFEGUM=
X-Received: by 2002:a25:416:0:b0:66e:4ae1:299d with SMTP id
 22-20020a250416000000b0066e4ae1299dmr22116077ybe.598.1657626831057; Tue, 12
 Jul 2022 04:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1657532838-20200-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jul 2022 13:53:39 +0200
Message-ID: <CANn89iLwTA-qm++L_71SNa0k63wO2EATec7ywR2T5AAUDnbPnA@mail.gmail.com>
Subject: Re: [PATCH v4] tcp: make retransmitted SKB fit into the send window
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Mon, Jul 11, 2022 at 12:06 PM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
> in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
> If receiver has shrunk his window, and skb is out of new window,  it
> should retransmit a smaller portion of the payload.
>
> test packetdrill script:
>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
>    +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
>
>    +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
>    +0 > S 0:0(0)  win 65535 <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
>  +.05 < S. 0:0(0) ack 1 win 6000 <mss 1000,nop,nop,sackOK>
>    +0 > . 1:1(0) ack 1
>
>    +0 write(3, ..., 10000) = 10000
>
>    +0 > . 1:2001(2000) ack 1 win 65535
>    +0 > . 2001:4001(2000) ack 1 win 65535
>    +0 > . 4001:6001(2000) ack 1 win 65535
>
>  +.05 < . 1:1(0) ack 4001 win 1001
>
> and tcpdump show:
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
> 192.0.2.1.8080 > 192.168.226.67.55: Flags [.], ack 4001, win 1001, length 0
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
> 192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
>
> when cient retract window to 1001, send window is [4001,5002],
> but TLP send 5001-6001 packet which is out of send window.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks !
