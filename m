Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8463183E9F
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 02:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgCMBQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 21:16:25 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42774 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCMBQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 21:16:24 -0400
Received: by mail-lf1-f67.google.com with SMTP id t21so6467938lfe.9;
        Thu, 12 Mar 2020 18:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=siQwJBaXROUJV32p3kjtwdctFihjBGuh3SOKqpsL7nk=;
        b=dD64HqxjJuLNNWT/Rj1Dw1SO6bc4xsOMT7+3zwnC0wPhTFnEy5FmqzzjuAYrczSHvO
         Q6PUQL3RRTkopH+IQ0GxyhWIaEFjCgcc8cYzJCcRXc5AJIR3lJG/DjQI8xoJWC+W9O0L
         NvrXvNorZ2QOJ8B/vY36q7KaCoBWJUgIzR5EKSiiNTkt3sPaxgezCKOYxNChdQecsQoM
         olQ+OTyZ8rhRsYDI0QkW7/pRWZSlbCPItk8b4SrYoIWOAVTov4A6+VPoZmx03zpRioNH
         lmHWfT/MIaD2bxz7ncGBER5fuiwlGuUqFRif3eyYDDiazpCTlXrV7XpKlN1zsdYBl4Eb
         niag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=siQwJBaXROUJV32p3kjtwdctFihjBGuh3SOKqpsL7nk=;
        b=bKC/FvPEchET9o+pcFr0srcHNeXc+ctmTOCuFbYGZl/C7/MGGedgcnHlXSId4LfJrU
         Pp40LE+Fwh66hnt/qAHn4g/n8oF4Qv/V71weJviu8Xg0YcDJPpuBWWxRg/bkNXWZEoxi
         ifPw80fc2BsIfgPghSlkK86MQu/MaqneDfsa3WnGtg5BQtEnYeRXhfim/91WQ2xpNrwA
         hDuE6hnj7V1ADImiyxQx5Zg/XXEJJCWcR+/hfJlAlPXyMSQTJAMQ5CeGZqOwv2512Typ
         NK6fk6qYihkg6ozy8uh0edrKAJwEHG8wTEMHbsO1lonNedc0Ys2Ahfl6LG1zALmWITpL
         TRiw==
X-Gm-Message-State: ANhLgQ2kHM4K8Sfqp939FzBTOYi7SHJOXyZrMF36b4Ty6Io6xb29DAXZ
        u7UrNUJotkcgUHl3jMlfjJ3ontKYroBHbydqPRk=
X-Google-Smtp-Source: ADFU+vvjxfR0TdbIWub2SP4k5+WJASUEgFQMxh7xz8oXCEVon7NQqJD5CvUdFb3MSFLlrMbeux1NIJJik+p4qio6q4c=
X-Received: by 2002:a05:6512:304c:: with SMTP id b12mr6815955lfb.196.1584062182232;
 Thu, 12 Mar 2020 18:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200311185345.3874602-1-andriin@fb.com>
In-Reply-To: <20200311185345.3874602-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Mar 2020 18:16:11 -0700
Message-ID: <CAADnVQL4++s-_z_DG-1VqxWPFVzfdS8_r3=RLPwiF5XevSncgA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: guarantee that useep() calls
 nanosleep() syscall
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Julia Kartseva <hex@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 11:54 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Some implementations of C runtime library won't call nanosleep() syscall from
> usleep(). But a bunch of kprobe/tracepoint selftests rely on nanosleep being
> called to trigger them. To make this more reliable, "override" usleep
> implementation and call nanosleep explicitly.
>
> Cc: Julia Kartseva <hex@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
