Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA3CF136
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 05:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfJHDVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 23:21:31 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33737 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfJHDVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 23:21:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id y127so10805238lfc.0;
        Mon, 07 Oct 2019 20:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyJcWTmjeQ7bugZJBy22/0j/6WxRNJH63fhiS0BcR5M=;
        b=bIpC8OXkIJ5aPmGTxNHyyoz/a6+DcoHsAWPnIwDGkBIDa6UC4leHe20YY4ozaxyHR/
         1NWGB1T0MVU9QkDkY5lO3mCWMWuOSyuM6WD0qOK3dVwgf1StegjCTtkPwHKcvBCbFatg
         1eZ/WLN3yvk4njbjQzwHqGQDAgMJE3mDwrJm8drmmTFJen+I3wTapbFA5lSMENX8CCAw
         iibXN8LCcWQSrV2kTOBwWaq9BQ0xj2RAcSaZJYLyUrhrz93IW1q52MvJ7Ohw74VyEciV
         sa3Hpc/NuUeW9OQogpfX10jV6mY/SJ8RvlGGdvn8mBLQUJFC8heX1fsTgwPOzBpgoLfQ
         590g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyJcWTmjeQ7bugZJBy22/0j/6WxRNJH63fhiS0BcR5M=;
        b=MzlDxB3W62HlQeglDWPul2pOnfVvBf8AI22kinUPiUteYM34X2qcF/VtRtnQ01LSk+
         6TjJXF4R0gDskY6AfZC2auhon0CGEnT0BhXsJZaXgv4JdHM3CRV7bH4Ks+iFJM+Qz0Q5
         oZAfTNKKis27whVQOU0zMNFsxnSfKr+vUQ4GaeevRx8TABWXGG7wCq8+N+9LrNcc13k1
         I/Sd6b6lpqwrR0edrCfE9uOiQbkk7R0Ukjx4HycQCyn4CS57vbFKVB1GX5fVYLbQb0Un
         glTvO9CqxVKOX9cbFEDXrgmC6D9w5RV7RGlFn8xvQKMlXYPpSLADG7ocHyZDZuvs8TQ7
         O5mQ==
X-Gm-Message-State: APjAAAXpkojw8Ntn9ZReR4to5bl9+iaD72Opa9A6ts66njMOtLkN/39R
        zDzexGeS2ZsK4Nu/9IJIJ7mXXzRiQXlyyrikLJA=
X-Google-Smtp-Source: APXvYqwPtJ4FHFnonLktEBUpJn9iN8BG5z4BUVcyMSzXDwV9aSpZUqwnQTOnJaEgsi75twngy2hacuKPiMCtcUKd+UE=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr19437205lfp.15.1570504889047;
 Mon, 07 Oct 2019 20:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191007162103.39395-1-sdf@google.com>
In-Reply-To: <20191007162103.39395-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Oct 2019 20:21:17 -0700
Message-ID: <CAADnVQLe+mrLo6oLwmQ8eeeNdomTXf-myq2kw=hyEbXFBJwYsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> While having a per-net-ns flow dissector programs is convenient for
> testing, security-wise it's better to have only one vetted global
> flow dissector implementation.
>
> Let's have a convention that when BPF flow dissector is installed
> in the root namespace, child namespaces can't override it.
>
> The intended use-case is to attach global BPF flow dissector
> early from the init scripts/systemd. Attaching global dissector
> is prohibited if some non-root namespace already has flow dissector
> attached. Also, attaching to non-root namespace is prohibited
> when there is flow dissector attached to the root namespace.
>
> v3:
> * drop extra check and empty line (Andrii Nakryiko)
>
> v2:
> * EPERM -> EEXIST (Song Liu)
> * Make sure we don't have dissector attached to non-root namespaces
>   when attaching the global one (Andrii Nakryiko)

Applied. Thanks
