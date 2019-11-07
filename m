Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22DF2584
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbfKGCpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:45:13 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33372 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGCpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:45:13 -0500
Received: by mail-qt1-f195.google.com with SMTP id y39so798729qty.0;
        Wed, 06 Nov 2019 18:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14w2TuiSpGyDjJfkjfI5u5kU1oAiAOwA/MrfT7AAdhU=;
        b=Uq6ka+mS16XTgu+rNlt9wDikqqAmK4FH2CmnRcP85XjSGtw+nvWJ0iOcLZymPFip9k
         rSoM0M2iXjo4D1xFRAhI7E/2t+C8Wq0433GwuO4cVS54KLVLnS3rYdfUwLOexSDWHzeQ
         u7JHY2Ei94ttNT8yykb/RQLT19j6wbcFhdm+v8vnnwuBPyaOQq4xkarpD3l5mPJRW9jS
         6JJmKPx4rmMojxEPhqxUZ72sYSEWXCrPEqcigMxRaDktyLr7ztZIKF1OM6dyxVq9k+fC
         gcfq09EnfJjonenzJeNGfN7F42YvnygofIPp3aPNDuol1zunm36WkdiAMMsOg704JOAn
         3bjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14w2TuiSpGyDjJfkjfI5u5kU1oAiAOwA/MrfT7AAdhU=;
        b=WTEWrDFnDPSNAXBBHnbZ3hx33giZ5IEysOSKYInLmmwTMmPQpjcR+j8Cc8uofviYwL
         thMtFnLRYFFP6RUVBz34fLxNEtvRbxys4+kTPsqA0tevTWMvfrXBPY66fVMiQfqKsRSC
         Ov/cLYHaJHV85XYWImQAd/kMaINapp4LHFEgHYzJCOKPUMwskbTcFRsWeIJwdRj9T0NA
         Dzsx57SkqCxlFy1aMgYKfTukgmg1i7lDgthNchW1ADBG4vCNb/cwMpF9C0hrMbMkkqHV
         V6nUPvPSjw8ao/sZjgdZcSZ9rwUa4pn7pOshdq+oq7cAHN3vcKGOpCTFGYK4tL3onjOd
         XRtw==
X-Gm-Message-State: APjAAAVThMGWYfrO76UkkMDJjrhleMCo6rqwRUhGx/OOanu6EM1U2Fnb
        mbmla1w2aCvKVH5K/JZepglKAlclkOAPXsfM0oUsXw==
X-Google-Smtp-Source: APXvYqyKjY0yAlCfZcR4ePgEyIQap/msVIkczImHfSTJwXx+pdkJ3G9sZ+njrewk/tdRPF+h4FWfc7WGROmSEIxU46Y=
X-Received: by 2002:ac8:7116:: with SMTP id z22mr1454717qto.117.1573094712348;
 Wed, 06 Nov 2019 18:45:12 -0800 (PST)
MIME-Version: 1.0
References: <20191107014639.384014-1-kafai@fb.com> <20191107014640.384083-1-kafai@fb.com>
In-Reply-To: <20191107014640.384083-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Nov 2019 18:45:01 -0800
Message-ID: <CAEf4BzbzOZtoRbfPXcU8xz49vc_9XM7YFjA=+DgHex4wzJcq_w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: Account for insn->off when doing bpf_probe_read_kernel
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 5:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> In the bpf interpreter mode, bpf_probe_read_kernel is used to read
> from PTR_TO_BTF_ID's kernel object.  It currently missed considering
> the insn->off.  This patch fixes it.
>
> Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Heh :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
