Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3112F9B6
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 16:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgACP0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 10:26:49 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:56978 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgACP0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 10:26:49 -0500
Date:   Fri, 03 Jan 2020 15:26:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578065206;
        bh=sD/SQDnaCSPzM7ABXXBUmRbPFC97bF4xHLm2I/Lp7Rg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=lfPJE2YJBMgK3qe71Lw8lln8SIJccjcuFq6clQMHxe2TwXVRvr419Slh5eQY65P64
         IDznKHla4ZNrefmxBcycUKdwa2T30yz5xPQeNtxIXSIQklE5tUpWhhUL3kmHQs9Uao
         uNg8FFsDDwTfa0I3a4BAonDC++a99gQ1n9oMwJm0=
To:     Eric Dumazet <edumazet@google.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <XCQU22ONu1PiBQxqCs5h_k8ElBYsnvJAFEpGq1QdVKyFDhi0gczw4KJVEk88_V3ruDxjCWhUGaWZA_dc8vzW38E8fHOm9NXOLPTV3CQBg6A=@protonmail.com>
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

If we don't modify the kernel code, I think we should modify ip-sysctl.txt =
to add that sysctl_max_syn_backlog is invalid after syn cookies are enabled=
.

The behavior in the kernel is completely inconsistent with ip-sysctl.txt, w=
hich is completely misleading.


somaxconn - INTEGER
=09Limit of socket listen() backlog, known in userspace as SOMAXCONN.
=09Defaults to 4096. (Was 128 before linux-5.4)
=09See also tcp_max_syn_backlog for additional tuning for TCP sockets.

tcp_max_syn_backlog - INTEGER
=09Maximal number of remembered connection requests (SYN_RECV),
=09which have not received an acknowledgment from connecting client.
=09This is a per-listener limit.
=09The minimal value is 128 for low memory machines, and it will
=09increase in proportion to the memory of machine.
=09If server suffers from overload, try increasing this number.
=09Remember to also check /proc/sys/net/core/somaxconn
=09A SYN_RECV request socket consumes about 304 bytes of memory.

tcp_syncookies - BOOLEAN
=09Only valid when the kernel was compiled with CONFIG_SYN_COOKIES
=09Send out syncookies when the syn backlog queue of a socket
=09overflows. This is to prevent against the common 'SYN flood attack'
=09Default: 1

=09Note, that syncookies is fallback facility.
=09It MUST NOT be used to help highly loaded servers to stand
=09against legal connection rate. If you see SYN flood warnings
=09in your logs, but investigation=09shows that they occur
=09because of overload with legal connections, you should tune
=09another parameters until this warning disappear.
=09See: tcp_max_syn_backlog, tcp_synack_retries, tcp_abort_on_overflow.

=09syncookies seriously violate TCP protocol, do not allow
=09to use TCP extensions, can result in serious degradation
=09of some services (f.e. SMTP relaying), visible not by you,
=09but your clients and relays, contacting you. While you see
=09SYN flood warnings in logs not being really flooded, your server
=09is seriously misconfigured.

=09If you want to test which effects syncookies have to your
=09network connections you can set this knob to 2 to enable
=09unconditionally generation of syncookies.
