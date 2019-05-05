Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A126413DE6
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfEEGYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:24:55 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33987 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbfEEGYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:24:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id s7so3029321ljh.1;
        Sat, 04 May 2019 23:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lQq0X//jB8IPXqH9jupLcOgCahi9DxM9FiCcK9O81HQ=;
        b=WJyhxCGE6K2wGR2kkKwSaB14XB9MJuj1N9HRijnc3L3jp43ccOFR2oW/KAXvV74ZiT
         4nfjCv7nExK5zIC93g5KkW7teCUeVJbq2UnUerQ5LuDviNVJwXKHA5XOgOnpMk/BpBKe
         W8b4ouawdvM+LkM1JvvNoTbSZLAhqImbgQHUuV0v3E5uc465FzyhX6zhTO/2IrEegAbM
         akpa7TavsvdeDT2KM/Tqhv0T6JptdktEKLh+DuYn/BibO5I5oHtOE0topGaUqvHKnqrE
         D8z1zG70n92NDOjlJzg0HHkxcRU06O6px+eJOUPfb1Epuzk+5OWLcPAeiUtC8g5VqieZ
         833g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lQq0X//jB8IPXqH9jupLcOgCahi9DxM9FiCcK9O81HQ=;
        b=dzQNX3PwQxnSBKVy+3Oo6fOGTexyK7JhRvkQqTtiS0LO+A9ferzUpU0OVPnUH2/ml+
         sKxXd9Ar21UjPmjhsY8wvh+HOdnfiXu9QDo7rMwIUMac1zEA53L2B3s48FvBv2yT5rEz
         IzDmlqOrlyWJ2kz5b4N6vk/1aNSA7Lyn85AxSNXiJ+jeiR5MVnwk/q1r7XrAZHUt5xDz
         CQfFoBdEIUmJx0rDp6ifvtSIvvW7jwUzFi05/YAUht8ZUs7jMxM16UTg4WzbsIGcng82
         ic0qQE9k0Dx1Gjj/ifMqkKPnZnEi0qZ97qP+NYMCEnXL6M7G3KJr/IN2gYrU6vXtNtqY
         mD1A==
X-Gm-Message-State: APjAAAUKofWD/KCaqxzHRIXk/1bdd4xTckLv0RgYwLbXaHlz8vz6zbFs
        xQK3FmezhXkgRdxdonSyRWD+vSH19Ligd291Mzg=
X-Google-Smtp-Source: APXvYqw7Y3wDg7j72Ahc6brwLezv+DLZoSgDD+nNZGjTp16k0rt+YVx0mE3xr2YHLXSpofRMbbFD2w7I45Z/Kv8j2y0=
X-Received: by 2002:a2e:9703:: with SMTP id r3mr631570lji.37.1557037492323;
 Sat, 04 May 2019 23:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190429235938.392833-1-yhs@fb.com>
In-Reply-To: <20190429235938.392833-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 4 May 2019 23:24:40 -0700
Message-ID: <CAADnVQKCU-ir0H6yWJB1m8TpsdTBaoiL7KT=V5v-kYrNdKLPBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: set RLIMIT_MEMLOCK properly for test_libbpf_open.c
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 5:01 PM Yonghong Song <yhs@fb.com> wrote:
>
> Test test_libbpf.sh failed on my development server with failure
>   -bash-4.4$ sudo ./test_libbpf.sh
>   [0] libbpf: Error in bpf_object__probe_name():Operation not permitted(1).
>       Couldn't load basic 'r0 = 0' BPF program.
>   test_libbpf: failed at file test_l4lb.o
>   selftests: test_libbpf [FAILED]
>   -bash-4.4$
>
> The reason is because my machine has 64KB locked memory by default which
> is not enough for this program to get locked memory.
> Similar to other bpf selftests, let us increase RLIMIT_MEMLOCK
> to infinity, which fixed the issue.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
