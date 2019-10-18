Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6C0DD54E
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfJRXZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:25:38 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36462 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRXZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:25:37 -0400
Received: by mail-lf1-f65.google.com with SMTP id u16so5881895lfq.3;
        Fri, 18 Oct 2019 16:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rFiYPayfcivIbmyPJvmhsYUQTBH3urjiuUpOoo0qm0I=;
        b=TpaYyPASr9QMRXcx8zhYtzpX/P8eew9ufgkxbdfROjqtSHiRpQ7He055bT9dl3rf0E
         fGsLedD+6p/QJfsNjvHQnYDF1mQLjsbYXTphKJqF+3NrVnomLYjIawji0QkScRfNNayC
         mQ2n3YSnI9J5szXGQq35OuMP/tN9vbilKqLZ0lhbjZKytqF9PGECmzXREL/q5pAh79VR
         bGYU3WKyKdQOqu3tFFp+UZKE55fjO3kUJKYYEhTkdigalj3/DRC7OVubhJfQkWARQOag
         3CiVBnCsyBS8eBNAdD3JL8LlPbncyCB4wdTT4oAZP4vChrl4bIPkURASXkAcGwya8rtG
         9hPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rFiYPayfcivIbmyPJvmhsYUQTBH3urjiuUpOoo0qm0I=;
        b=UTnrm5dgY4j5tmLZGmpJ3tLxjNlfvdlaX7Xe7qdsrW3Lwten+0oHfThe4jnxKGjhad
         56RbX7/T1bw7VBwkXquUdxF/9HT3paEivWDDb5FaSD/gey56wu2VmOO0QLSc6HLjBv7v
         DUrw+R60PiGGrw3Oy24zfF1u0SU+hY4CTArvkXd2/Ktjf3L8nS7c7mc0ESTBUN+hAeUd
         e4LcH+x38PLTqMV8wCId9CPjuRZ87UJb56S5K3q9pkfUTkl43djIIap074bw/eS63p0x
         asMZxw+d6LY1mIATFJ3+iH6lUJ6oxaApkOvyu7qBtXRO5H9HHgVL6l6RrkIYiouJ4wA8
         giAA==
X-Gm-Message-State: APjAAAUs9cummdhDSGx+Kz2kQg/0uhZeN0hsIDX/khLpfL/6DLlsASQp
        WlQ3f4gBEKejeD0zv+O+HalOkGPbRdRxNmP191Q=
X-Google-Smtp-Source: APXvYqzlUV3L2ccv5Z7zC6mdOGEngeDFKQ6j940wSxsA0u2DxuIKOWo/jdhYEkMJ0EK4R1mA2+vQ2dNuUweU+/Op7vY=
X-Received: by 2002:a19:f80d:: with SMTP id a13mr7551957lff.6.1571441135421;
 Fri, 18 Oct 2019 16:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191017105702.2807093-1-toke@redhat.com>
In-Reply-To: <20191017105702.2807093-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 18 Oct 2019 16:25:24 -0700
Message-ID: <CAADnVQKDaMAVT6UxGy8w+CPUmzvgVWAjXmHexiz09yZJ8CbAeQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: Prevent overflow in devmap_hash cost calculation
 for 32-bit builds
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Kicinski <kubakici@wp.pl>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 8:36 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Tetsuo pointed out that without an explicit cast, the cost calculation fo=
r
> devmap_hash type maps could overflow on 32-bit builds. This adds the
> missing cast.
>
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up device=
s by hashed index")
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

gmail delivery lags by a day :(
I applied this patch along with Yonghong's ack to bpf tree
(though I don't have it in my mail box, but it's there in patchworks).

I'm not sure that cleanup Jakub is proposing is possible or better.
Not everything is array_size here and in other places
where cost is computed. u64 is imo much cleaner.
