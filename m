Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AD344005C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhJ2Qc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhJ2Qc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:32:27 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB75DC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 09:29:58 -0700 (PDT)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id B4EB62E0D99;
        Fri, 29 Oct 2021 19:29:56 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id luKGVJ0BdW-TusK38F4;
        Fri, 29 Oct 2021 19:29:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635524996; bh=9I1bkMejxpuR+/PHMNNgfhDkzjMxUDTDzYyT/m+avhQ=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=IHCKo0x/Z4aXC53rDwEC9fMR7hqyV/c/m/8I/x9TiHKwXUVW7aNmGDBTKj7uBUCAD
         6aiCBoGLs1HW62bfTl1Fze0wF5AT6CH6foF07r+R46yyoqrl7BcgPs5lgTwACGbw0+
         X/W8+C9KPIJYRvx4kBPIYFzKhVW6bNcSspXIdrw0=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8931::1:8])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id fdauHw74GR-Ttxu3cUp;
        Fri, 29 Oct 2021 19:29:56 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <2A707577-CBEA-42C9-A234-2C2AB7E7F7BB@yandex-team.ru>
Date:   Fri, 29 Oct 2021 19:29:55 +0300
Cc:     Alexander Azimov <mitradir@yandex-team.ru>, zeil@yandex-team.ru,
        Lawrence Brakmo <brakmo@fb.com>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F99F587B-C53F-4784-8F6E-A026D859E995@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
 <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
 <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
 <2A707577-CBEA-42C9-A234-2C2AB7E7F7BB@yandex-team.ru>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Excuse me for lots of duplicate messages. I couldn't get default client
to consistently send plain text messages and delivery system kept =
rejecting
them. I forgot to remove everyone from cc when tried again.

> On Oct 29, 2021, at 19:19, Akhmat Karakotov <hmukos@yandex-team.ru> =
wrote:
>=20
>=20
>> On Oct 25, 2021, at 23:48, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>>=20
>> Also, have you checked if TCP syn cookies would still work
>> if tcp_timeout_init() returns a small value like 5ms ?
>>=20
>> tcp_check_req()
>> ...
>> tmp_opt.ts_recent_stamp =3D ktime_get_seconds() - =
((tcp_timeout_init((struct sock *)req)/HZ)<<req->num_timeout);
>>=20
>> -> tmp_opt.ts_recent_stamp =3D ktime_get_seconds()
>>=20
>>=20
>=20
> I may have overlooked this. As long as I remember TCP SYN cookies =
worked
> but I will recheck this place again. Also could you please tell in =
what way exactly
> does this relate to syn cookies? I may have misunderstood what the =
code does.

