Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C4C1BB1DA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgD0XJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:09:44 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:34175 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgD0XJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 19:09:43 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b92b5ff4
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 22:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=Rz7dwSvq6L+O
        cMK963akA4gOfPs=; b=X/8coleTom+JdkF1wyNizLSiZXaVBZ/pn5OzwmogB5Zu
        gtpEigRI4NSmHNqekt03XtPz9E+hy/0VRLTUuXzpFvXtzRc4p4AWw57esIDGs6+x
        WZoWdqLrrHUCkzrXKrz0YMc6n9j6bywrKgoyIguofeVIFUBMEdkat5XIb6U1l418
        2TmZCsIcwl1edH6I60C6WDua3sfxW57eJpxSP4RiPfCAK0hAkEIeTHG3OX+Nb5yU
        UpyRwE1jm6iy9Lj66mGGhdG+0xpx0eAX83XegrdJDiNkMZuktoTDqZpxvPK8Qb0f
        E9DteUUOL4BzWJxcUDRR124cNzAL5ggguHo89bkj6Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cd65ceff (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 22:58:07 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id x2so18478502ilp.13
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:09:41 -0700 (PDT)
X-Gm-Message-State: AGi0PuYDZpOSKe5dtzdHl1rFRoURdY4Jve0ba6V6nATyZQadBnUdW/xn
        0I0CLw6A3iwjRiGU5ammhb6JDtbQTN2coZB0iMQ=
X-Google-Smtp-Source: APiQypIqdOjl06mq+ZG1C3Fyyk7+1A833zwE0Cgf3y6NDSLZZUGtUCZd2MmqxFYnGZ4hxQspB/YdrNQOsCn64Z86CL0=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr24398414ilg.231.1588028980593;
 Mon, 27 Apr 2020 16:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <87d07sy81p.fsf@toke.dk> <20200427211619.603544-1-toke@redhat.com>
In-Reply-To: <20200427211619.603544-1-toke@redhat.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 17:09:29 -0600
X-Gmail-Original-Message-ID: <CAHmME9rUCYuBCFbw=yhNPqDDJWD3ZUQ_R9xjQ-yp6DXA9_iScA@mail.gmail.com>
Message-ID: <CAHmME9rUCYuBCFbw=yhNPqDDJWD3ZUQ_R9xjQ-yp6DXA9_iScA@mail.gmail.com>
Subject: Re: [PATCH net v2] wireguard: use tunnel helpers for decapsulating
 ECN markings
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 3:16 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> WireGuard currently only propagates ECN markings on tunnel decap accordin=
g
> to the old RFC3168 specification. However, the spec has since been update=
d
> in RFC6040 to recommend slightly different decapsulation semantics. This
> was implemented in the kernel as a set of common helpers for ECN
> decapsulation, so let's just switch over WireGuard to using those, so it
> can benefit from this enhancement and any future tweaks.
>
> RFC6040 also recommends dropping packets on certain combinations of
> erroneous code points on the inner and outer packet headers which shouldn=
't
> appear in normal operation. The helper signals this by a return value > 1=
,
> so also add a handler for this case.

Thanks for the details in your other email and for this v2. I've
applied this to the wireguard tree and will send things up to net
later this week with a few other things brewing there.

By the way, the original code came out of a discussion I had with Dave
Taht while I was coding this on an airplane many years ago. I read
some old RFCs, made some changes, he tested them with cake, and told
me that the behavior looked correct. And that's about as far as I've
forayed into ECN land with WireGuard. It seems like it might be
helpful (at some point) to add something to the netns.sh test to make
sure that all this machinery is actually working and continues to work
properly as things change in the future.
