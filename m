Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C4312F999
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 16:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgACPNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 10:13:06 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:22439 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgACPNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 10:13:06 -0500
Date:   Fri, 03 Jan 2020 15:13:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578064383;
        bh=r3U5E0KDpP5rjy60OBATMvyBfOhi2UJ93Ai47jMfGGY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=gL5EKaFV2oCZmzrA2yMqZNwcPj+EJ6/jNNvnvaFFHmqXkas4JSmS9HUnyNzmHukLl
         TKbmKb6feu+NJMDonNJ6b2bBFb0uc92vl7n9U6KJGWjbNcnkedsgG8p2Fz793isq4Z
         RAGdNSvZw/lZrz/HwQ+d89YAuJXkzB8NRiY40rhA=
To:     Eric Dumazet <edumazet@google.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <PbX3K1VwmnXGjijzAWo4F8xM4ZXJGtJCToVeCPBMoSYUBt_fJsoRB4a0pbyzVmr5OVe8sixuCcfBidoJLsW3kLXNonFrjABvMOXSTjmV_y4=@protonmail.com>
In-Reply-To: <CANn89i+zxbXv2O4C8B+AW5BNbTsQtn6RP7BRx7UQYfRcbWTsTw@mail.gmail.com>
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
 <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
 <5gI82sir9U2gaHqvZgEXtxtdFJnbS_9geSflUCqgXjNKjtQfHmBWsfqaNuauMKKpefp5yrcgF7rs7O65ZBGFXL8mLFODpfc_bmB2ZBUgyQM=@protonmail.com>
 <CANn89i+zxbXv2O4C8B+AW5BNbTsQtn6RP7BRx7UQYfRcbWTsTw@mail.gmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There is a difference though....
>
> Set sysctl_max_syn_backlog to 1, and start a reasonable test (not a synfl=
ood)
>
> As soon as one SYN_RECV request socket is inserted in the hash, other
> SYN packets will generate a syncookie, even if the backlog of the
> listener is 100,000
>
> I think the intent of the code is to allow a heavy duty server to use
> a huge backlog (say 1,000,000) to avoid syncookies if it has enough
> RAM.
>
> In this mode, people never had to tweak sysctl_max_syn_backlog.

Your scenario is the same as what I said in the previous email, big backlog=
, small sysctl_max_syn_backlog.

The question now is whether sysctl_max_syn_backlog should still work after =
syn cookies are turned on. Does the backlog want to be exhausted or kept un=
used? Whether to use as much memory as possible or keep it as low as possib=
le.

This is also where I was most confused at first. This is totally inconsiste=
nt with ip-sysctl.txt. In some scenarios, sysctl_max_syn_backlog is invalid=
.

Unless we can find the person who wrote this code, we may not find answers =
to these questions.

This is, uh ... a problem left over by history, it seems that it can only r=
emain the same.
