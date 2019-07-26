Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE98775C60
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 02:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGZA7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 20:59:39 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36201 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfGZA7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 20:59:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so49806188ljj.3;
        Thu, 25 Jul 2019 17:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nTkRM+tB0f6NeSuJLicKt8aHcrmel4697e0vxsUfHEs=;
        b=syoVTngKkwer+ETFmBOyDfIAy0U8WJgL9Pcm6PXVn3U9wun8vI0CCPECmA/KoOgiak
         /ugJsqKDyLYeMiDYTaEaIRujt2ZQOuJKydvAue43CZPdoZ1S/0v7ptPSLx6p8P95PR9G
         FVUxnLB2IEzElcHtGuWyR+dm1aa7vxsN+AAFyfzmQuy6IAxPtt1+wcxoF7ru6iyuYIKa
         k6JukHQ9IrhDk5mdSU3fJ2/mwlMJq8d5pYNsEZBVoRK3SKbjfOTZ1SFRYx1w7o1LZlk2
         NIUEOvJ2HiZ4Qc+Bvstj2lJLjMt0ZiT9WrW2SsaF/Ro1EA1l+AZdmdRMugd7Q2aGg/FE
         QdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nTkRM+tB0f6NeSuJLicKt8aHcrmel4697e0vxsUfHEs=;
        b=UeZZwO1bkOYvxS+1EU/24BPiWwUADLWM6BRuFHzEMSCCzCQEtcJrFVas1UI8DEAdTP
         JOWl0o3ndWcfvzRAsPVylhSTelbbfdXGY4JE6QfoI848yoNpeLSVTaVHuJVdzrVrn/bf
         BnR9y6XlMSPiQlSo62H1zFbKyBZSiBauRpQLwrTysKplINGAxMVGKLI/WRJG244B+t4P
         /lyO9ExwrQ8sChah/f2lW4PKaKp3FfvuGzpkBXUanEU1ITL4k5O26k4fgTXAlQRiPKYO
         Jmi+eUrCY3uN4sAHgrqe8vaR+T6aZSmQAQwZDfxESFwknpGHxO+T2o7XiH0NAYKASTEK
         8g0A==
X-Gm-Message-State: APjAAAULlgbElzNRCgMrgpRl6koqNQ3XFumwJAp0RZm86FxlxoARcAW6
        ic7nYBoQgHFa8B31xkMews5mi4hVKOKUPaM0ZqE=
X-Google-Smtp-Source: APXvYqw5GUvBoPy1jaBCpkQ1c/4EmjuF3yIPoGPd5Rz0rHlPSR7YQXrCFZsMY9nao2g5tQk9BOXwgQahe9fURRrDHjQ=
X-Received: by 2002:a2e:9758:: with SMTP id f24mr48149584ljj.58.1564102776489;
 Thu, 25 Jul 2019 17:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190724000725.15634-1-allanzhang@google.com>
In-Reply-To: <20190724000725.15634-1-allanzhang@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Jul 2019 17:59:24 -0700
Message-ID: <CAADnVQ+AOWLhb+62zGUHKD1q84-Jd8yR=7iReZZDTUf42z_=ug@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 0/2] bpf: Allow bpf_skb_event_output for more
 prog types
To:     Allan Zhang <allanzhang@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 5:07 PM Allan Zhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>
> More prog types are enabled to access bpf_skb_event_output in this
> patch.

Applied. Thanks
