Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE849055B
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiAQJqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAQJqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:46:00 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E659EC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 01:45:59 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id j134so18433839ybj.6
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 01:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6wNPmN4PBZgAXBB9ImVT9/lr+2B02oCpCSoa8256Xg=;
        b=hV2S5dDA3C6/ZkBVuKs1EMTIr+v35AVafPyDGAZ9DhdLDo9qcJOqn5XppbzsszcRqv
         jirDuU3h+KodbSinoKZhg/LBqhgULExw0fPBBlg/Nq/pmxwUR1iEyTJva7bON6qpmz8F
         xPK/kXdtxnypjk4m3T+LexS+qmnecnhms304OmE92IgZ05EJAk2G+xvNp6u0H4vFc4Yo
         HssDTLtWNCTSoeajnz+h1pF52PhyPXczHTV1fLiwllxGpFihOIncrcmpAhXfYMYzIHub
         wkG/UDQyEkztyITRdDN8QTxp6WjL2Mv+Z0k/YYF/FQrTWDQupSYlaLWK466bpRPqZuCR
         a+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6wNPmN4PBZgAXBB9ImVT9/lr+2B02oCpCSoa8256Xg=;
        b=mbfQ/nKtYFymUcIJfDPmw/ipQ0buXP2tLpeAfrEiOvpMfC5s6GA37FMIAFprnXaBSk
         JUN2dKKiGQv8mJW8WtFsI/djsMFW79K85fgGILPrtS3jBlKIRNrp5xWa9xttnpBlVMPR
         kmhG3ndZepu1X4SxTiH/S/Y/1u20gBvj1X/1r7r5+Mk0vNdsyeYelFcD6KGQbojAVSlg
         mDJhKGsSi680ZjyTA5Ug+z6098UDjgsH6+uhDm9hzbRkuZBnV6AEPbf7RAduisNTrBVt
         Lr5Fx9n1gpq8lirSnuGy/OG/l0sJuldrE/RbL5rejnotCTkC1cLZBQf6SFDiLih+x2Np
         KmLA==
X-Gm-Message-State: AOAM533cyNblFlPxyAUZiX2BjZ8/OyndyrUmLDb/5bJASxG7tmSoj4yk
        YDGALPODLe/HZb5QWU9hqLNtc7mfYM7Z70lcSFnUv6lfc2M=
X-Google-Smtp-Source: ABdhPJyFQY2GeZOQRiUxhYOYarOw/nkYHxQuTn4zQAA0evKonRCIwddnzujTjoJPRTnTxluRTwD6u6Zn0U6DijWhICQ=
X-Received: by 2002:a25:a10a:: with SMTP id z10mr27853644ybh.753.1642412758698;
 Mon, 17 Jan 2022 01:45:58 -0800 (PST)
MIME-Version: 1.0
References: <20220116090220.2378360-1-eric.dumazet@gmail.com> <bc172b2512174b8f862c854d0d376c0c@AcuMS.aculab.com>
In-Reply-To: <bc172b2512174b8f862c854d0d376c0c@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Jan 2022 01:45:47 -0800
Message-ID: <CANn89iJ4LUmwhAfVQmRzirFCdu6971-mgcrp90XVhkA9U4vjkA@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock protection
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 1:20 AM David Laight <David.Laight@aculab.com> wrote:

> This probably ought to be a stable candidate.
>
> If an increment is lost due to the unlocked inc/dec it is
> possible for the count to wrap to -1 if all fib are deleted.
> That will cause the table size to be doubled on every
> allocate (until the count goes +ve again).
>
> Losing a decrement is less of a problem.
> You'd need to lose a lot of them for any ill effect.
>

You are rephrasing the syzbot report, and the Fixes: tag I added in
the changelog.

hint: netdev maintainers handle the stable backports based on the
Fixes: tag, and their
own judgement.
