Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A715686D
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 03:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBIClV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 21:41:21 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40785 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbgBIClV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 21:41:21 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18so3307242ljo.7;
        Sat, 08 Feb 2020 18:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fqOT00vdEoOkzm2DYFL5BApyU6+3BEwc5eg/GKP0xe8=;
        b=kaBdIIlUA4uJhUOWXTYmnwrA2h9g8gkIYX39KdE24UZwt45XY/BXxGgSv/nLQhkCOi
         mKb1+xM4voE1rhH5soB22SNp1ZvaZH8kQ2kEKMRnUY4ebgP62V1/O4F5LeDsloJuBAid
         d2ZNfsoajmHwtYoSAxlwbtSyJwFNDkD0IWiiTFTh001Ezkqfn8RzlA//O/gA7OIiG3gJ
         dpoICIQriiiVGphkPSR11IYs8igrE5TUVVpa1FmeSM4xTkunwdap41Wb2BPA3XwJ/bHg
         7gQSB0aU7x+Q4sb/HSRiGR3lCMAjmoCl29irN97YQwNb+EACtlKTwbl/ex4xDkjLzUgB
         gVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fqOT00vdEoOkzm2DYFL5BApyU6+3BEwc5eg/GKP0xe8=;
        b=rKRmLt9WqkjbwjRJIAU/SoU5GAXBz9yHSJFyLU7QmaGgn31QCRk4oUCW4tOueO55nN
         InpYlpSX33njPDArkWNhjbThrvnOZ32jAHWBZARyO2IU09NwZYAw+cnWewAD9iBWr9/F
         0aQ2Zb0HbdluFnQIJ5Ao21s6CY2PxLHfdqJkbyMXvvoEPXRMZ2jx2a+KyWaEkVZQKvjO
         x2XiSj0O3Lgd9T25zFbvSTUY+2SL/vCMpCmUGYsaa8g3anvIZh1pG0XEaVQJgxf56eC4
         90EmkJYJs99Fm3B6inmBltSbiD9ug3Pss+xnGJy70QIISoQdAOqQBj79tS6eONjSCd8Y
         B8nw==
X-Gm-Message-State: APjAAAV75F+cqUbR1HC6USYf2EyHA8l9ROnJtsrwhEH8JkHrJD2QlMNd
        NHGIDvyPzLmSh8puXgyI2vbqmoGOTdPqBBbxFVk=
X-Google-Smtp-Source: APXvYqz+2qLSlhgrE7fPJOV32SolzWDdj3B1+XwHOnUlUQrjWX8UJk/1LahfZ4qKEJJAZIZ4AfA9MGUMrtTC3DtFTfM=
X-Received: by 2002:a2e:8145:: with SMTP id t5mr4137531ljg.144.1581216078811;
 Sat, 08 Feb 2020 18:41:18 -0800 (PST)
MIME-Version: 1.0
References: <20200206111652.694507-1-jakub@cloudflare.com> <20200206111652.694507-4-jakub@cloudflare.com>
In-Reply-To: <20200206111652.694507-4-jakub@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 8 Feb 2020 18:41:07 -0800
Message-ID: <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
Subject: Re: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with
 a socket in it
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 6, 2020 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
> down") introduced sleeping issues inside RCU critical sections and while
> holding a spinlock on sockmap/sockhash tear-down. There has to be at leas=
t
> one socket in the map for the problem to surface.
>
> This adds a test that triggers the warnings for broken locking rules. Not=
 a
> fix per se, but rather tooling to verify the accompanying fixes. Run on a
> VM with 1 vCPU to reproduce the warnings.
>
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear dow=
n")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

selftests/bpf no longer builds for me.
make
  BINARY   test_maps
  TEST-OBJ [test_progs] sockmap_basic.test.o
/data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:
In function =E2=80=98connected_socket_v4=E2=80=99:
/data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:=
20:11:
error: =E2=80=98TCP_REPAIR_ON=E2=80=99 undeclared (first use in this functi=
on); did
you mean =E2=80=98TCP_REPAIR=E2=80=99?
   20 |  repair =3D TCP_REPAIR_ON;
      |           ^~~~~~~~~~~~~
      |           TCP_REPAIR
/data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:=
20:11:
note: each undeclared identifier is reported only once for each
function it appears in
/data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:=
29:11:
error: =E2=80=98TCP_REPAIR_OFF_NO_WP=E2=80=99 undeclared (first use in this=
 function);
did you mean =E2=80=98TCP_REPAIR_OPTIONS=E2=80=99?
   29 |  repair =3D TCP_REPAIR_OFF_NO_WP;
      |           ^~~~~~~~~~~~~~~~~~~~
      |           TCP_REPAIR_OPTIONS

Clearly /usr/include/linux/tcp.h is too old.
Suggestions?
