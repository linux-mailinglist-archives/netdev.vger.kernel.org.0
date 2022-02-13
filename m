Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559D94B3951
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 05:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiBMEXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 23:23:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBMEXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 23:23:37 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7271F5DE76
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 20:23:31 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id j2so36835549ybu.0
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 20:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwSxdQ1qwWvBe5ziEHQxXnDzDMEHIQ1dj6zvmIZF8gI=;
        b=GqTn7g76DD1rxhhkaJhOCi3Cgw3RBB/ArXzTgorEFC1q7mfsU+1V3+YKYiXTD6y/Gk
         5Cjj7wGTVNFStjLiJJFB9TduWhQ1K4ldBU6Po4lr9rcvxWDYlR7Co8M6++J9gK9XydHh
         IUMtBZ407cVPmNDXLB8cqzSMpg8xjKiNotXl84e/IQJyd01wvZzxCulWlI2sBKIbyULm
         UJnMaVCtuUKMQKEsmMFLD42Ma1U/+bXtj5fYJ0YC6IKbETM1xXEN3JMg/+zRIIGwBCjp
         +Aox/5KizDjbtvIOiSYlHqF266BI0qUN9on6/ob0jnt9bB6uVyG3IEajtQcNBBptcRjV
         t+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwSxdQ1qwWvBe5ziEHQxXnDzDMEHIQ1dj6zvmIZF8gI=;
        b=UsQHy+lY9/Q2cQ/OoYfIw58rZfEhedqWLar1xlW6Q2Qzk0rPbNK+xZopdSk7BhKoAT
         Nie23lqud32t/xSDy6pInarGFeaibfTI1qu0xlfUs0qsDLugq2Zdnyj0jVALSZVHPAM5
         93bvxpGQwpET0sB7qChQd1VhZx+iUlsvcXXtejoeRoth1jnd4S1kZsu7PL3YyaBK2aFg
         vfM9qPR9iQU2cXzyGnnZiVlHjUPeL+p6eTW/WepcfGmVleVvDObD0TZz2jrUHcq2uflW
         V4qGaouKLAHl2a/Nhy+POeeEbr+mW5+7tyJk+81pNSK1LARYEovmPTdbN16ELXlV60sr
         3wmg==
X-Gm-Message-State: AOAM530G1rSWHpIaf9i7bOLBlIcdvDY/FRXQ55j7KlqvYXCiK5wh791U
        QfHKrpn9wwzfP+oEMtslIR4kmbiXa/SCcroGDdrAs3p4qI/CDlNv
X-Google-Smtp-Source: ABdhPJxU3ADgiVK1ZhvlPUkl3zEZKjRiDgGw/uy4lVwibljpXiWOUxwXbG72ONc+delUwTYUBEU29H6kK234P4kA7qI=
X-Received: by 2002:a25:b907:: with SMTP id x7mr7716391ybj.5.1644726210248;
 Sat, 12 Feb 2022 20:23:30 -0800 (PST)
MIME-Version: 1.0
References: <20220213040545.365600-1-tilan7663@gmail.com>
In-Reply-To: <20220213040545.365600-1-tilan7663@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 12 Feb 2022 20:23:19 -0800
Message-ID: <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
Subject: Re: [PATCH] tcp: allow the initial receive window to be greater than 64KiB
To:     Tian Lan <tilan7663@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew.Chester@twosigma.com,
        Tian Lan <Tian.Lan@twosigma.com>
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

On Sat, Feb 12, 2022 at 8:06 PM Tian Lan <tilan7663@gmail.com> wrote:
>
> From: Tian Lan <Tian.Lan@twosigma.com>
>
> Commit 13d3b1ebe287 ("bpf: Support for setting initial receive window")
> introduced a BPF_SOCK_OPS option which allows setting a larger value
> for the initial advertised receive window up to the receive buffer space
> for both active and passive TCP connections.
>
> However, the commit a337531b942b ("tcp: up initial rmem to 128KB and SYN
> rwin to around 64KB") would limit the initial receive window to be at most
> 64KiB which partially negates the change made previously.
>
> With this patch, the initial receive window will be set to the
> min(64KiB, space) if there is no init_rcv_wnd provided. Else set the
> initial receive window to be the min(init_rcv_wnd * mss, space).


I do not see how pretending to have a large rcvwin is going to help
for passive connections,
given the WIN in SYN and SYNACK packet is not scaled.

So this patch I think is misleading. Get over it, TCP has not been
designed to announce more than 64KB
in the 3WHS.

The only way a sender could use your bigger window would be to violate
TCP specs and send more than 64KB in the first RTT,
assuming the receiver has in fact a RWIN bigger than 64K ????
