Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189C1182128
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgCKSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:48:15 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42745 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730780AbgCKSsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:48:15 -0400
Received: by mail-qt1-f194.google.com with SMTP id g16so2365590qtp.9;
        Wed, 11 Mar 2020 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VL0/QIgFV/TQJg/uDW5O01TQ4UTQA+jR1k5TpH13mB0=;
        b=spqbp/1sEC2oBHy+lxErElsVMiMB1MEJW/sZH41FyLEwHwLqYp/8pfkrsApXXeOp6v
         Kds0GfHS0uESruvqWyf49XQI+D9xVr/MD1bVWXKFYaYHX0HeI4/s3EB5jKRKfrpdFGGW
         eDpcFhNMtlLyIaWXlzotdGQ/GOhWVib2OmzvqWWC7W7SzurXf9Z/tJbf+hmEipieJVOS
         X+9qZN4ouv3H7OAgmqdlCBRu3A1jpgzjRVnJK2xgYKrBY+71QlvGtAVML/lMCe4rAf4h
         07Qpk4rQlnjnDAisA/O4KkglIR9XlaxwWSC4o+KBWfZIZZgY7JDkRTKGwitY4ED81Brh
         DHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VL0/QIgFV/TQJg/uDW5O01TQ4UTQA+jR1k5TpH13mB0=;
        b=PrK/D9bFuHtHsreQjhG86Bg8PkLZ/qSSfJFL7Qf3rWCA9OEvA2Ooer/ToKEYx+WyLz
         RD3IdGH7UPAafkZz0fthjwrzpxVmy9dhyVzOsRnGRogPhdkvwOhTfe6qL8bzPYUvYfu8
         Ei3F13YA2tWXOjcmIxKJr+DhA2JhC5RTpZN0CLBBtfyD8f+mqzMylo8rO8kVLGaybfLw
         UmCTL7FH/ZDR0TRLr6mHcFbA/rgWEHqQto3h/1T5q1ZQKa6zsiwKsbMbSWKrzEgDps52
         YnrakS62TBjkWooXsoQYy/xWY5PtsCAuKqbHZfe1fm9k8ITXdDwSG+yakHAR6FJ6xC81
         fNXg==
X-Gm-Message-State: ANhLgQ2rIoy7nDWMAsB9fiLIEfzMr2vG8JUb5snhqxGeBOh+AElLM33i
        hDinZtNEmuRtteW7RKhwUyjrFOqoAdbGY3lv/VzFgsCu4jU=
X-Google-Smtp-Source: ADFU+vv6HXIO1TBJYRYhd8up2V+wemkxMPiHwO7VlmKCb5zStnPkot/ror23Bb44iD+lFLaxWNPk47BW6qRuO+xTyS4=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr3926845qtk.171.1583952494276;
 Wed, 11 Mar 2020 11:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200127125534.137492-1-jakub@cloudflare.com> <20200127125534.137492-13-jakub@cloudflare.com>
In-Reply-To: <20200127125534.137492-13-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Mar 2020 11:48:02 -0700
Message-ID: <CAEf4Bzadh2T43bYbLO0EuKceUKr3SkfXK8Tj_fXFNj8BWtot1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 12/12] selftests/bpf: Tests for SOCKMAP
 holding listening sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 4:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Now that SOCKMAP can store listening sockets, user-space and BPF API is
> open to a new set of potential pitfalls. Exercise the map operations (with
> extra attention to code paths susceptible to races between map ops and
> socket cloning), and BPF helpers that work with SOCKMAP to gain confidence
> that all works as expected.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
>  .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
>  2 files changed, 1532 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
>

Hey Jakub!

I'm frequently getting spurious failures for sockmap_listen selftest.
We also see that in libbpf's Github CI testing as well. Do you mind
taking a look? Usually it's the following kinds of error:

./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
connect_accept_thread:FAIL:733

Thanks!
