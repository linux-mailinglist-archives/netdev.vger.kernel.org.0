Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7F3183E84
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 02:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgCMBMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 21:12:10 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39883 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbgCMBMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 21:12:08 -0400
Received: by mail-lf1-f65.google.com with SMTP id j15so6499446lfk.6;
        Thu, 12 Mar 2020 18:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2N74vK0wEO6omK6gxM9S2Sfotzd+CK0plzYuRp70PI=;
        b=d1ImDOrvI7j5wv1dq4DlWah5J31JgDXL9rpReV3A+OHciNIXVVfS/5VQngN/lXMQFy
         uZKPY9ZjNva74/bD2gDKp6CYD52TVpUWxrPCQQOSx6BqAvdEjl+d5F6BhnnxB5rrMlkE
         iMaIpfvo/zaLz+kmmGk7Fh6Q3KjM0+x1fmTJO5l1Ud/LwWeOkERXx7VV/gjNIqj/6tGQ
         j+2lAtpXh7i7aYjwT+oCt7KDbbFF0hjqxuhLJVVSn4Jp/l11cwY6YKnYYGONHSHuI1ld
         G2m37CvkkTTklHu2AZocwSV6znvRZWWdeMgGGRNsw8M0L+i3KMVCtVHy8a4tkugkPzIs
         Vgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2N74vK0wEO6omK6gxM9S2Sfotzd+CK0plzYuRp70PI=;
        b=mhsU2mwjJIp37zPawuv9OFLqOypELAKpESWQE5/gYTO5BEGuaMGY5NXhjqGkXQS2li
         1CPARi8d1ZP8EfhumIUA8izrfnsBF2z/9PDetzJ6YDQL0+UI9BtnSZg67EQV1CvkJlDj
         iBqpoE8gNmWh++y3nJaDzsNlitq7pxhTAJ8MfNWFqOFE4D8d9bix9yznqmcLFusq5vr8
         fe4F/7sCCjuw34yB8cBExWqW3FEYunp6a0fjSNtk/X23HPwOzvdfKaGNU+7SfH62PdE2
         +lUa8C6d7l6ACZdYoUvbs4fZNiUxhALh1PtCthTFlqC6ZR7EuEZcpyxS0ekfWnDHQwaa
         /T0w==
X-Gm-Message-State: ANhLgQ3g0MEoLFchJ2irBppQuiDVp/o6bbII//+NPmYCJL8NB3gN8bwL
        HhHmBEkaqE9KwzyHqDglGtsDvnTcNZ2K8Dvex8E=
X-Google-Smtp-Source: ADFU+vs3trb3T6EzTOKSUJb57s68KcJHKuvMr476BOSCcjENprE8qtT80LoYZc1hbvs3xObEpuws9eDF8cqj8vEO0nU=
X-Received: by 2002:a19:6a0c:: with SMTP id u12mr1008752lfu.119.1584061925943;
 Thu, 12 Mar 2020 18:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200311021205.9755-1-quentin@isovalent.com>
In-Reply-To: <20200311021205.9755-1-quentin@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Mar 2020 18:11:54 -0700
Message-ID: <CAADnVQ+i_y89KkiGe2aZbDstvND17esMCz=uegCSGwq47vXsuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: restore message on failure to
 guess program type
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 7:12 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> In commit 4a3d6c6a6e4d ("libbpf: Reduce log level for custom section
> names"), log level for messages for libbpf_attach_type_by_name() and
> libbpf_prog_type_by_name() was downgraded from "info" to "debug". The
> latter function, in particular, is used by bpftool when attempting to
> load programs, and this change caused bpftool to exit with no hint or
> error message when it fails to detect the type of the program to load
> (unless "-d" option was provided).
>
> To help users understand why bpftool fails to load the program, let's do
> a second run of the function with log level in "debug" mode in case of
> failure.
>
> Before:
>
>     # bpftool prog load sample_ret0.o /sys/fs/bpf/sample_ret0
>     # echo $?
>     255
>
> Or really verbose with -d flag:
>
>     # bpftool -d prog load sample_ret0.o /sys/fs/bpf/sample_ret0
>     libbpf: loading sample_ret0.o
>     libbpf: section(1) .strtab, size 134, link 0, flags 0, type=3
>     libbpf: skip section(1) .strtab
>     libbpf: section(2) .text, size 16, link 0, flags 6, type=1
>     libbpf: found program .text
>     libbpf: section(3) .debug_abbrev, size 55, link 0, flags 0, type=1
>     libbpf: skip section(3) .debug_abbrev
>     libbpf: section(4) .debug_info, size 75, link 0, flags 0, type=1
>     libbpf: skip section(4) .debug_info
>     libbpf: section(5) .rel.debug_info, size 32, link 14, flags 0, type=9
>     libbpf: skip relo .rel.debug_info(5) for section(4)
>     libbpf: section(6) .debug_str, size 150, link 0, flags 30, type=1
>     libbpf: skip section(6) .debug_str
>     libbpf: section(7) .BTF, size 155, link 0, flags 0, type=1
>     libbpf: section(8) .BTF.ext, size 80, link 0, flags 0, type=1
>     libbpf: section(9) .rel.BTF.ext, size 32, link 14, flags 0, type=9
>     libbpf: skip relo .rel.BTF.ext(9) for section(8)
>     libbpf: section(10) .debug_frame, size 40, link 0, flags 0, type=1
>     libbpf: skip section(10) .debug_frame
>     libbpf: section(11) .rel.debug_frame, size 16, link 14, flags 0, type=9
>     libbpf: skip relo .rel.debug_frame(11) for section(10)
>     libbpf: section(12) .debug_line, size 74, link 0, flags 0, type=1
>     libbpf: skip section(12) .debug_line
>     libbpf: section(13) .rel.debug_line, size 16, link 14, flags 0, type=9
>     libbpf: skip relo .rel.debug_line(13) for section(12)
>     libbpf: section(14) .symtab, size 96, link 1, flags 0, type=2
>     libbpf: looking for externs among 4 symbols...
>     libbpf: collected 0 externs total
>     libbpf: failed to guess program type from ELF section '.text'
>     libbpf: supported section(type) names are: socket sk_reuseport kprobe/ [...]
>
> After:
>
>     # bpftool prog load sample_ret0.o /sys/fs/bpf/sample_ret0
>     libbpf: failed to guess program type from ELF section '.text'
>     libbpf: supported section(type) names are: socket sk_reuseport kprobe/ [...]
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Applied. Thanks
