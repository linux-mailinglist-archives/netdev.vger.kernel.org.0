Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CCC58FD5D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiHKN1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 09:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbiHKN1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:27:18 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE54883D4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:27:16 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id f28so3540660qkl.7
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/4QayQrRMtdQlM6h+mGhnOYiud0cm7dS4spYCg2eLtQ=;
        b=isQ2ON9EBInOxDBXkiCfnl6pEXwdwwNW+V+NYYMheKvrO2xYIDthqQRb8QjpQ8D12z
         WPWJ4iB9U/idoM6pPK1U5AlOLEY/Ps2IqFcrX1rbeUgAhoY0kUkGdWGk32wGFA6hjG6j
         o+C8rA/luh2eszfw4CI8VbXTYS4BTRUchIJQpy8n7CTckdfENTxiRg0qPykbWqw/nmPk
         kvhx5dqZkNMFlQtaYujsY5hHvFUHPBx8aEHGPvpDI89iTwyChpj0v8BcH2XegQh8DshN
         2rPWIiq/4FkjiQqKekZYyWFTz/c5OVwjxB7FCh5xL/BnAS+forfHpEZY/xOeZzCPSOjl
         7RJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/4QayQrRMtdQlM6h+mGhnOYiud0cm7dS4spYCg2eLtQ=;
        b=cyxRmTcSaUCWupg4Z+npTf7ltBjwykAHHCg+/n9ybx6/qrWftk5M1xkRQ9h5Fe+oKG
         xGzkU2fEIy9N4TXWvsyozhOzeqvYhKngVblKwrEuk94heGL5NHZD/VwOUy2h3xEMkxGW
         eheGekx7v4T5B4dRRrKH3hpYafBah0RM1Tl5mMx7oXS1npyPBMGBJEYEtoyqAoO0236/
         mHqjMJGI45NjTw23LX5bHVp9sdDkRvifPgDR5wh2AH9O7wCe+1deLW2Zc9Isv20D0Tv3
         DbpKCGHtFmRWvfD5ZYd2KJMeEDH+QR0CDmRJ97MjtI40xfPHTsG26nG5aCWxZSKXLDoc
         GCbQ==
X-Gm-Message-State: ACgBeo3qH9LWPoA+/W8N8vufXvlaZH9ZL0fL1gR1CgAF3Wb4bcEXviX6
        ZJK/JQ5a9RMqFuRBOdgGdmVualTB2mjVWhtGFftsZg==
X-Google-Smtp-Source: AA6agR7yS/3xyAosY94/rx/m690An/b/pcTlMXyBf2GdheTgSqYmLCLFPqY1I7ARws3m4cQvDn7bkWx59SxpSMxbyAY=
X-Received: by 2002:a05:620a:25d4:b0:6ab:8b17:3724 with SMTP id
 y20-20020a05620a25d400b006ab8b173724mr24589644qko.395.1660224435868; Thu, 11
 Aug 2022 06:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <1660117763-38322-1-git-send-email-liyonglong@chinatelecom.cn>
 <CADVnQym47_uqqKWkGnu7hA+vhHjvURMmTdd0Xx6z8m_mspwFJw@mail.gmail.com> <12489b98-772f-ff2a-0ac4-cb33a06f8870@chinatelecom.cn>
In-Reply-To: <12489b98-772f-ff2a-0ac4-cb33a06f8870@chinatelecom.cn>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 11 Aug 2022 09:26:59 -0400
Message-ID: <CADVnQynuFfW5DAeHM1LwKh0YgG3A27Zn2H6MGsj_14WdXCMZsA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: adjust rcvbuff according copied rate of user space
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        ycheng@google.com, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
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

On Thu, Aug 11, 2022 at 4:15 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
>
>
> On 8/10/2022 8:43 PM, Neal Cardwell wrote:
> > On Wed, Aug 10, 2022 at 3:49 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
> >>
> >> every time data is copied to user space tcp_rcv_space_adjust is called.
> >> current It adjust rcvbuff by the length of data copied to user space.
> >> If the interval of user space copy data from socket is not stable, the
> >> length of data copied to user space will not exactly show the speed of
> >> copying data from rcvbuff.
> >> so in tcp_rcv_space_adjust it is more reasonable to adjust rcvbuff by
> >> copied rate (length of copied data/interval)instead of copied data len
> >>
> >> I tested this patch in simulation environment by Mininet:
> >> with 80~120ms RTT / 1% loss link, 100 runs
> >> of (netperf -t TCP_STREAM -l 5), and got an average throughput
> >> of 17715 Kbit instead of 17703 Kbit.
> >> with 80~120ms RTT without loss link, 100 runs of (netperf -t
> >> TCP_STREAM -l 5), and got an average throughput of 18272 Kbit
> >> instead of 18248 Kbit.
> >
> > So with 1% emulated loss that's a 0.06% throughput improvement and
> > without emulated loss that's a 0.13% improvement. That sounds like it
> > may well be statistical noise, particularly given that we would expect
> > the steady-state impact of this change to be negligible.
> >
> Hi neal,
>
> Thank you for your feedback.
> I don't think the improvement is statistical noise. Because I can get small
> improvement after patch every time I test.

Interesting. To help us all understand the dynamics, can you please
share a sender-side tcpdump binary .pcap trace of the emulated tests
without loss, with:

(a) one baseline pcap of a test without the patch, and

(b) one experimental pcap of a test with the patch showing the roughly
0.13% throughput improvement.

It will be interesting to compare the receive window and transmit
behavior in both cases.

thanks,
neal
