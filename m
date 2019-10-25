Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC371E5653
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfJYV7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:59:37 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44863 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYV7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:59:37 -0400
Received: by mail-qk1-f196.google.com with SMTP id g21so3147568qkm.11;
        Fri, 25 Oct 2019 14:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=diVVDRLsiGaS8JrOzp3ioJRMj0sbhJfnpLdNNy/AZcM=;
        b=BnG9jQKYdLn5H6R6C/QHkiX2I+WZDSCWYXk5h2vkKjdcj38MJjy8FYBNmSSx3DrEWX
         ELH45zl9WJAyv+K8ajmaLb4lolLA28/tqnhJkicj0B30+AykGfbX8PfbHDpcuJYZ4WAN
         HTrK0N2JtW1go8Bg+DRg+aIeiYerPKgzB+27xk6PokwkojPAm7kTPqOsxIbbh++M/BkB
         HOWFg2nsl7FYjU3yVOcIYlqMV3LGkEj3OU5IsSlGrs68oIT9VrCwEm+1hj8tSOGXKk4I
         4JHE6RtInCT+nrPrQ1VRU2wINr7CV/JWJIL5DnEGwyXgn3v2fr6lwH6lYq3ZiI/tQH0t
         TMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=diVVDRLsiGaS8JrOzp3ioJRMj0sbhJfnpLdNNy/AZcM=;
        b=FrAF/3SBUdYHd11YY6BOJAorVwuxMOqV7mrvQoENiY9oCrNiF93zp3nRkf0Ch46wDO
         ySHIcHEseGhwMmw65/zqB1KtH6QBy/YSjuxyNYG7vgnLrQ9ZoYNP2DlJUrhDStk4EjBW
         hHRSZkoh4wYnkfkYl5gs/+OTCNWpYe/PtHTOsqV/HeWCwK1hCvSkvHpWh0PYW8ymreQd
         uMWT9oH3MmJ3inzn47NPXAfrN+yKdIog2HqM5J6cXgi+RydqVG3Dge2HcO05zv4Ocv5I
         6GGoDtgpAhcRmuKpT/gSA3RIoIdBbCnTTaA4RfewzG7WmJ6qFxr98rVuAXKp0D5zd9Yq
         3R4A==
X-Gm-Message-State: APjAAAWuQ4tgiCf9Y1j71kab1cP97DI08ClXy8NgMvOKjXT2Y+kAjdKo
        9hL4r7c+/soJtIkTnx6s/o76nnY4nLPLqsi1nJw=
X-Google-Smtp-Source: APXvYqxzMfutjNHO8g22h4S8AvD36rvyV7JP/6wJ0sO86TarLKPImcxWAA37yn4OUL6oqeF07i9rpx4ZGD4Qj7ab7OM=
X-Received: by 2002:a37:520a:: with SMTP id g10mr4966027qkb.39.1572040774872;
 Fri, 25 Oct 2019 14:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <51b9752121c1c06197291ea6b395d163313ac6ea.1572010897.git.daniel@iogearbox.net>
In-Reply-To: <51b9752121c1c06197291ea6b395d163313ac6ea.1572010897.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 14:59:23 -0700
Message-ID: <CAEf4Bza1Pt4CbpSYrr1VsOCeJR=4p7es8UycpPXrnZwqn+XyKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpf: Make use of probe_user_write in probe
 write helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Convert the bpf_probe_write_user() helper to probe_user_write() such that
> writes are not attempted under KERNEL_DS anymore which is buggy as kernel
> and user space pointers can have overlapping addresses. Also, given we have
> the access_ok() check inside probe_user_write(), the helper doesn't need
> to do it twice.
>
> Fixes: 96ae52279594 ("bpf: Add bpf_probe_write_user BPF helper to be called in tracers")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
