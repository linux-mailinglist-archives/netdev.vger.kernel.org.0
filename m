Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153B3443650
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 20:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhKBTQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:16:03 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:55262 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230333AbhKBTQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 15:16:03 -0400
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id B2C022E0A31;
        Tue,  2 Nov 2021 22:13:26 +0300 (MSK)
Received: from 2a02:6b8:c12:3e23:0:640:132c:43df (2a02:6b8:c12:3e23:0:640:132c:43df [2a02:6b8:c12:3e23:0:640:132c:43df])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with HTTP id 5DTeCP0tsiE1-DOt494NH;
        Tue, 02 Nov 2021 22:13:26 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635880406; bh=Qq8ATDHGj8KgmpFHH/C7yKm52x8qjKo1Z3uIrZcjJck=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=eWCt6l8oL6QeuadPJuPGlaA2/kR0HvF5EBU7Hzgk6GD2lsWl8GXx/i9zYwYYWdCbW
         Jti24OfUIKcWoCO6DS1e/IlH64a2Ky+fc3Cz2AJwhwV7iZLUEuply8n2+E6l5E8QMR
         yXS/7nUZM0LDSDk0o+QnWSQe5g+xrBmHD5qf7qZA=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: by myt5-132c43df2a33.qloud-c.yandex.net with HTTP;
        Tue, 02 Nov 2021 22:13:24 +0300
From:   =?utf-8?B?0JDRhdC80LDRgiDQmtCw0YDQsNC60L7RgtC+0LI=?= 
        <hmukos@yandex-team.ru>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        zeil@yandex-team.ru
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Tue, 02 Nov 2021 22:13:24 +0300
Message-Id: <5C1E4FAF-7A28-40F2-8E67-4B352ED5F45E@yandex-team.ru>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Nov 2, 2021, at 21:57, Yuchung Cheng <ycheng@google.com> wrote:
>
>> static inline struct request_sock *inet_reqsk(const struct sock *sk)
>> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
>> sk_node_init(&req_to_sk(req)->sk_node);
>> sk_tx_queue_clear(req_to_sk(req));
>> req->saved_syn = NULL;
>> + req->timeout = 0;
>
> why not just set to TCP_TIMEOUT_INIT to avoid setting it again in
> inet_reqsk_alloc?
>

I tried, however net/request_sock.h does not include net/tcp.h and
after trying to include it I got lots of errors. So I thought that
request_sock is not supposed to know anything about TCP. If I'm
wrong than what would be the best way to reference this constant?
Should I just redefine it in net/request_sock.h?
