Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C538212F8A0
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgACNHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:07:41 -0500
Received: from mail4.protonmail.ch ([185.70.40.27]:28636 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgACNHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:07:40 -0500
Date:   Fri, 03 Jan 2020 13:07:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578056858;
        bh=vJXcLp2HtRr6k5yDa5mMdnneaXtMZ2XLjNUSP2ZHkZ8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=JAJkxcp13qwWIWdgNF5D0jIYUHGRuMYXjs0QeH6DNkN/wK3bizHMp7r5IJzuTuLnL
         7upL3PTwasotNQU7LTk8jsa0kKQAdJLl06Ae3K5YHcM1zRKhbe+qIpgpskAyI+c18I
         8f8konvXfFF8yIC1Djp9JTcLI2Y27rQsV8mkJOG4=
To:     Eric Dumazet <edumazet@google.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <4mMYI9ZUtqiLfS8AYnjkx5odzyOSLqsOlIZ08yqsTPKUT8nz7-SEHzBuilGrAIgLuS_f_dZkdcClSmlYyREB8bprj-I_QhoV7Qu3rti7lmM=@protonmail.com>
In-Reply-To: <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
 <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
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

> I would prefer not changing this code, unless you prove there is a real p=
roblem.
>
> (sysctl_max_syn_backlog defauts to 4096, and syncookies are enabled by
> default, for a good reason)
>
> Basically, sysctl_max_syn_backlog is not used today (because
> syncookies are enabled...)
>
> Your change might break users that suddenly will get behavior changes
> if their sysctl_max_syn_backlog was set to a small value.
> Unfortunately some sysctl values are often copied/pasted from various
> web pages claiming how to get best TCP performance.
>
> It would be quite silly to change the kernel to adapt a change
> (sysctl_max_syn_backlog set to 200 ... ) done by one of these admins.
>
> Thanks.

Of course, the sysctl_max_syn_backlog is set to 200 just for the sake of ex=
ample, not the actual configuration.

I found this bug when summarizing how the kernel handles syn attacks. I'm r=
eading the kernel source code and not really encountering errors.

I also thought of another scenario where the above BUG might cause problems=
.

Imagine a machine with low performance and small memory. Set sysctl_max_syn=
_backlog to a small value to save memory (304 bytes for a connection reques=
t), and enable syn cookies to handle excessive requests.

Because the sysctl_max_syn_backlog is invalid after syn cookies are enabled=
, the entire backlog is consumed and too much memory is consumed.

Of course, the above scenario is rarely encountered in general.

I fixed this bug mainly because I thought its logic was indeed wrong, not b=
ecause it caused some serious problems, I was a bit obsessive about the cor=
rectness of the code.

So if, as you said, it can cause backward compatibility issues, just leave =
it as it is.
