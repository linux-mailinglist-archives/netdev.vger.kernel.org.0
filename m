Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF14A28F0
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfH2Vae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:30:34 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45911 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfH2Vae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:30:34 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so4317369qki.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 14:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2O543tXDx8ERwMLUKj03uOFxK9pdJydRfg/rWv+dzAI=;
        b=L3eEjThKFt8GemYWjLZbezJ2OkeJZOxeLV25cvg/+1SxDtHjqj1SeZ4JlS4O8qR+/O
         10urs8tJ1BrDnojMf0hGIUz2CMr/U8YO3qYBMNUfxtxIOLLocOKWeNL/j00cAW52iw82
         RJnEgNm9BQTrqbU5NTxsbDqKxbccWvoY9kakJXoYHiHnSTrvvSi9gRldMVZroaOoXtqc
         iSClqclERzChq92b5Jx1yYCCwuvGqjPP24aK2kO9pX8CbZS643A0OXofUuAbWHG4P7in
         oK1HmsAsShLqF8Q+u0ob1YZyurpDv5On/ouMEmY4+bpB4B0a2L3RwvbM7kd5gwy71thr
         UUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2O543tXDx8ERwMLUKj03uOFxK9pdJydRfg/rWv+dzAI=;
        b=UdlK+HvhWzK23KZw1G3GdIpNO7b+QPCwFi1UqrDSN1tKR3yyTa+bEFvyrIB1wuKOkt
         DGI6aBcc6BICpLZEW2fbf83hTnZP3BPtnIjqlcTGI/mCyuyJKdEyrcTPgZb/ufhDf76u
         6edM0aggI8+gZ4svaAdg+RVsWXLAagDg716IbGDthNFfvDtN5df0/X7cfCFofPEfiLIs
         mHnOz/3p1x0iwgAzHKsH8ma2CEVAIDlWTk35brVIogENTD12bOEus9B6ZkV+hVLyCA1f
         Vjq0DdRDMQ/h1grF3mg3c0zGwANAnoq2J8D8xKBhSQdiruYGd5iFlZ+4kNQxP2zrBxZz
         VV6Q==
X-Gm-Message-State: APjAAAWBhDcGIak00L7Y8hFLtLFu1TfV34//yi46qDV9q0O/xjZvz8LR
        rkNpUPJgcyxBdt9ARwJ6fZst5XTZ4H1SWSeavDk=
X-Google-Smtp-Source: APXvYqw7OTolOvPl232RteRfzr91wR/NldvDab2paSOm4g+iU+rTUOzEbyZ/B1k426ZMaB5KH0ifSbnLcpT/e9g2WHU=
X-Received: by 2002:a05:620a:705:: with SMTP id 5mr12168769qkc.330.1567114233362;
 Thu, 29 Aug 2019 14:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190828053629.28658-1-jakub.kicinski@netronome.com> <20190828053629.28658-2-jakub.kicinski@netronome.com>
In-Reply-To: <20190828053629.28658-2-jakub.kicinski@netronome.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 29 Aug 2019 14:30:22 -0700
Message-ID: <CAPhsuW6LyqyBgrHJ9aMOTDMK=nE7AGOUOBarPiGwZ8fmVyHYgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] nfp: bpf: rework MTU checking
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, oss-drivers@netronome.com,
        jaco.gericke@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 10:38 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> If control channel MTU is too low to support map operations a warning
> will be printed. This is not enough, we want to make sure probe fails
> in such scenario, as this would clearly be a faulty configuration.
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Acked-by: Song Liu <songliubraving@fb.com>
