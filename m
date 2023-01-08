Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC0661728
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 17:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjAHQ7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 11:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjAHQ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 11:59:25 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C186268
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 08:59:22 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id g4so6583721ybg.7
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 08:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xbBPJGq78sgOhjfoFMzeNJ/l3u1dpUB8P+um7SA9Dn8=;
        b=jgOgg+SOGJlDwGPd4/FWlVfVdetYzR8AbVBh4oVtTcWU+V8v/RM0WNunTASvEMZWVP
         lckk+KA4CNMCB6Yi0gS23Gwr7E48qJvFek219gQ87/qpw/uLGkJ2UAnOXvPXn2tkoyFr
         hIkEbErg69A9pvM4i5gbDNvj5ZAm/RYHffQjH2GFaQKgHSl1gQxHCyh5ZYx4YOT8WPQ0
         R1b8JuscLeta9Bsf0L43VRmnv1LvN1JTc0F/tTH1ByCwZ68djS1PMyfUt7Z+v5vmIEWn
         7j6Y4Ful4xBPeLRjS1W1a5FMQ7mX10aLhKIhgQk8Ga7ZZoo76SklOadtZb0iPXs66vqg
         3caw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xbBPJGq78sgOhjfoFMzeNJ/l3u1dpUB8P+um7SA9Dn8=;
        b=lA/glR6yApxJT5agGI2crP9BhZ7kDrpNBvg1+HT7Ur137dt0N++EfqIoLiHnZF31ae
         Z+PYO5T6tfGCU/ZApHKpkPHS5UtHYcNjzZkXqbq8SlJdh2uRn6tplxpIDW0CjmQNA0F1
         2O6cztCGefjHHGfWSfAOI8G60Wc2iJLVW5nrnTgmozHQ3O/mKBVcLqjEfB+OJhqNCtGx
         cS+R2sN351ArXrI3seI9S4pCy59TJJ0gXbccfMOqZ+2hvoSCXDWa3s210YOGcrCGPL2b
         qsQ0kF8WtbpYj8eu0pZ24XCQP+j/Kiw9zIquNU45x5rlrotKfVRzYJvktXGpzP9AtgKd
         sDOg==
X-Gm-Message-State: AFqh2kqRU3aiTaZReheGQK2o9i6/Y9+Z56D39oxt9zqUaSpess1HKa8H
        bCqgMQSUHRDj1hSfyZUmL+BqOk5Jri7kx3i/mo4=
X-Google-Smtp-Source: AMrXdXvs1The/z0BH9kBTPVmpuW2z3dG/vRLqHvAlzAZtkUu+aYJGjM2mTzosi+r5mVWpsFrJM4Yrfq/4UNcWy5LecU=
X-Received: by 2002:a25:bbd1:0:b0:70b:87c6:4fe with SMTP id
 c17-20020a25bbd1000000b0070b87c604femr6712818ybk.550.1673197161268; Sun, 08
 Jan 2023 08:59:21 -0800 (PST)
MIME-Version: 1.0
References: <ab8f8ce5b99b658483214f3a9887c0c32efcca80.1673023907.git.lucien.xin@gmail.com>
 <7ab910df-c864-7f11-0c1a-acb863dd1539@kernel.org>
In-Reply-To: <7ab910df-c864-7f11-0c1a-acb863dd1539@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 8 Jan 2023 11:58:08 -0500
Message-ID: <CADvbK_eCRoH2JqKV=8J2Yuj_yC3ueFz4je8VhXOgerQ_rhtB2A@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: prevent only DAD and RS sending for IFF_NO_ADDRCONF
To:     David Ahern <dsahern@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        LiLiang <liali@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jianghaoran <jianghaoran@kylinos.cn>,
        Jay Vosburgh <fubar@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 7, 2023 at 9:04 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 1/6/23 9:51 AM, Xin Long wrote:
> > Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
> > slave ports of team, bonding and failover devices and it means no ipv6
> > packets can be sent out through these slave ports. However, for team
> > device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
> > link will be marked failure.
> >
> > The orginal issue fixed by IFF_NO_ADDRCONF was caused by DAD and RS
> > packets sent by slave ports in commit c2edacf80e15 ("bonding / ipv6: no
> > addrconf for slaves separately from master") where it's using IFF_SLAVE
> > and later changed to IFF_NO_ADDRCONF in commit 8a321cf7becc ("net: add
> > IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf").
>
> That patch is less than a month old, and you are making changes again.
Hi, David,

That patch will not change anything, and it's an improvement. the
problem is the commit:

0aa64df30b38 ("net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf")

So it affects the team driver only, and I should've done more team driver tests.
Sorry for having to touch the IPv6 code for this problem in the team driver.

>
> I think you should add some test cases that cover the permutations you
> want along with any possible alternative / negative use cases.
IFF_NO_ADDRCONF are used by team/bonding/failover, I will try to add
a kselftest for this with team/bonding.

Thanks for the suggestion.
