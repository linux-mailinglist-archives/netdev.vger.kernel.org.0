Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6D413DBC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhIUW4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhIUW4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 18:56:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9576861156;
        Tue, 21 Sep 2021 22:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632264884;
        bh=pj45vzTrtP9n0/AXSjqXDTgpXCydT3r/Ax9Yaczobsk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k1ecQPz5c7Ae8B0VyHCr4ObHnoxouJ3dDVNM+UbewfZZxkAQF8xbyNC1v8l/iu53A
         xc5z5W2Ye/MBI4mClfFmqvm06z1i03kkIay6fGlE6fmOVH8g1ca463mUQHDkHAj3AB
         PPIXpDXaHu0OtqGYdwu8zr0do8hQEhaDZZ0st19kfmvhBRysiKte0GxBxC4vQgdtxd
         APGOUY5xXXqXORR/k6CReCBaG/zaID/Q2OD2tq0w6euia6/zRFCmHPek52/GwEmM4b
         2nCbWCahpPLRWLk47k8cRT+QQZZO2T3TDzEf3kxpYEZXxP7+JLni1GK5Qv/ZRKlt4V
         xXwF8+skC/leQ==
Date:   Tue, 21 Sep 2021 15:54:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
Message-ID: <20210921155443.507a8479@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87o88l3oc4.fsf@toke.dk>
References: <87o88l3oc4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 18:06:35 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> 1. Do nothing. This would make it up to users / sysadmins to avoid
>    anything breaking by manually making sure to not enable multi-buffer
>    support while loading any XDP programs that will malfunction if
>    presented with an mb frame. This will probably break in interesting
>    ways, but it's nice and simple from an implementation PoV. With this
>    we don't need the declaration discussed above either.
>=20
> 2. Add a check at runtime and drop the frames if they are mb-enabled and
>    the program doesn't understand it. This is relatively simple to
>    implement, but it also makes for difficult-to-understand issues (why
>    are my packets suddenly being dropped?), and it will incur runtime
>    overhead.
>=20
> 3. Reject loading of programs that are not MB-aware when running in an
>    MB-enabled mode. This would make things break in more obvious ways,
>    and still allow a userspace loader to declare a program "MB-aware" to
>    force it to run if necessary. The problem then becomes at what level
>    to block this?
>=20
>    Doing this at the driver level is not enough: while a particular
>    driver knows if it's running in multi-buff mode, we can't know for
>    sure if a particular XDP program is multi-buff aware at attach time:
>    it could be tail-calling other programs, or redirecting packets to
>    another interface where it will be processed by a non-MB aware
>    program.
>=20
>    So another option is to make it a global toggle: e.g., create a new
>    sysctl to enable multi-buffer. If this is set, reject loading any XDP
>    program that doesn't support multi-buffer mode, and if it's unset,
>    disable multi-buffer mode in all drivers. This will make it explicit
>    when the multi-buffer mode is used, and prevent any accidental subtle
>    malfunction of existing XDP programs. The drawback is that it's a
>    mode switch, so more configuration complexity.

4. Add new program type, XDP_MB. Do not allow mixing of XDP vs XDP_MB
   thru tail calls.

IMHO that's very simple and covers majority of use cases.
