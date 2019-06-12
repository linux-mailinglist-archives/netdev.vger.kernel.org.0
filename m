Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7843062
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfFLTqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:46:08 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37637 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbfFLTqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:46:07 -0400
Received: by mail-vs1-f66.google.com with SMTP id v6so11068912vsq.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 12:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=DdS68VhoUad0DraxYuovb10RwvmZbIGxKt3Y2AstAqY=;
        b=kAjuSjfdSHGM434nMYlrfCq8XkJOEWNQdlqVoveLixVpFCzTpFhhPJ7NvdpgA+q2K3
         vMNxN12ZrOWT/b1uKfxGlcwlj3FwzYlVfpDV3u5oP71EKA6nAzagrW6gaEFyewapZ6RP
         AUJ7woUfnOW0hKRhah7ISU0n0mBOvDF5sd5qyYfVtPrLsNSMK+0Sl00iYKSEoM98CuXn
         z2TCHJrTUgKRA6Fv81OuCjfGDlxkIwnsgT3m9lL9PfDfeYbq/rFKC+tP3DjD8oxczTRr
         vYddvokBzGlX3HxND8GvLDcIWL2g+UDjP0TUc4yOGvZnm6yCPhNdzz1xiQo7tXX3zw+f
         Zhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DdS68VhoUad0DraxYuovb10RwvmZbIGxKt3Y2AstAqY=;
        b=ONpLI/XBZ8U4sBdlIM6gtxDl0zCMMow5gzvLs57uBZ43aJIk0sUSbL3AmCXOI7xpX3
         Uu7YbJKpaZ+Ie9C4vS7uAbXyFfjKRA2dhGM1nrzBGSawC+ETtyCo/kyWSFuu7UfFxES9
         ZTBDMrBiRjjbxAq1a689BvO24X7+8VCZD76HM3J2wyRU9Xuzhy1/YC+eJdb4qXZRGwR2
         tJBPzcvDxEbZVIjYuRi++ZZQErVjKpPiWjcDH8LUSJbixhqaKo7UL/WPUIhkhPmejaG0
         gh3eXo1g+lVkgTBYZN9pDPCaTJudixM3p51pm9SAvUn20NxWEUJCmaHlJ3x9TgVP0z14
         ZfOQ==
X-Gm-Message-State: APjAAAVjjWAsLu5+iAH1Jh4P+M2KM586xPXBauYCrr5SYSTrGF5xKQFW
        GKn5XEWIibZh2frWBebbQ2NALg==
X-Google-Smtp-Source: APXvYqy6SCFS6Sxo5YQOzimlfjb+odzTokZp+hEuG+Vc6j3QSc4Y37+5Lx9IeqL19emwSwQWWr2VAw==
X-Received: by 2002:a67:df8a:: with SMTP id x10mr37344622vsk.220.1560368766809;
        Wed, 12 Jun 2019 12:46:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v133sm576622vkv.5.2019.06.12.12.46.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 12:46:06 -0700 (PDT)
Date:   Wed, 12 Jun 2019 12:45:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map
 lookup in eBPF helper
Message-ID: <20190612124559.5f48e546@cakuba.netronome.com>
In-Reply-To: <87k1drf80y.fsf@toke.dk>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
        <156026784011.26748.7290735899755011809.stgit@alrua-x1>
        <20190611144818.7cf159c3@cakuba.netronome.com>
        <87k1drf80y.fsf@toke.dk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 11:49:17 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <jakub.kicinski@netronome.com> writes:
>=20
> > On Tue, 11 Jun 2019 17:44:00 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote: =20
> >> +#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS =
| XDP_TX) =20
> >
> > It feels a little strange to OR in values which are not bits, even if
> > it happens to work today (since those are values of 0, 1, 2, 3)... =20
>=20
> Yeah, I agree. But it also nicely expresses the extent in code.
> Otherwise that would need to be in a comment, like
>=20
> // we allow return codes of ABORTED/DROP/PASS/TX
> #define XDP_REDIRECT_INVALID_MASK 3
>=20
>=20
> Or do you have a better idea?

flags > XDP_TX

In the future when we add more fields in flags:

if (flags & ~XDP_REDIRECT_FLAGS_MASK)
	return -EBLA;
if ((flags & XDP_REDIRECT_RETCODE_MASK) > XDP_TX))
	return -EFOO;

?
