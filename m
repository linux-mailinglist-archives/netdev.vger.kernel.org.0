Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11C17DF59
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfHAPrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:47:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37330 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731954AbfHAPrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 11:47:16 -0400
Received: by mail-lj1-f195.google.com with SMTP id z28so15657005ljn.4;
        Thu, 01 Aug 2019 08:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCj6BU5/ZMgt4jyMNQkUOtitc9bUzmVkTnQAmv8I740=;
        b=V1xxENASM3HEAUHtcf7tehcJ3DnGklpRr1RYXS90FrxbuifcGm2QPlXO9/sPwFhnt5
         c6tb7vADWDN2ZJuw4ZlToi67EaFnW750EYHiC7yku6tH34OS3oAlnmdMoxTy4nfSco5p
         tf/HdZZ9B3Pt56uxcW9mJN9WB66iW/sFhpsRCvIOsVNpNLx/JG+zQ2KyHibddLZFKKYv
         OGQfKJ0qSZpkT65ejW37kMO5Oyowv9O0J2bI67iA/qxpn/HqfCdoWHBIdE2Ks56nDr5H
         A83kURWiD/ALAcvGJshVrGMW1FYYeMMKjdihHdxj5ioCYAaJQvWGr+czW9kCPPYmi0gz
         ufPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCj6BU5/ZMgt4jyMNQkUOtitc9bUzmVkTnQAmv8I740=;
        b=chtbxlFKTBMvtR0+dmGjdH5lZ9tfHl/dbsAAHKl1UEfr+1yJzqXCJm1NbRYeVr0u7j
         MyV6posUBGKA9vQT36sWb5HltW6oovKcAUYpCMjXhVN11HWVgf8ID4TNTJ+drtZ0MorK
         Q37B09ePIeB39i6NBEuiZb28FwneM6ESxkLoFY9wxPEb3WqQ4wQTTWjXKxXJo2kwdtOY
         53KyIW1vw8bnahoLmkK4VKPmnM3fEpQaUn1ilnbHhvgmgKnWhunJLpmrYxHyA9yOIWhj
         szVrcWxPygcLiGz1hYOYDM9c01CoGlGscm9ZWZUxC4z0pT/fp2LU9ypl+2ItTbbnK0+v
         8E/g==
X-Gm-Message-State: APjAAAV+il8/nUcJMu/B40bKWhkyz+fv7pH48zd5OZ4hAY4I/8shweDa
        cl28bAt6ZOFs85du2GjCPu75mDJnCXGdkQvpvmKNhg==
X-Google-Smtp-Source: APXvYqzN1BM/sG57ipVFj5YxWtMYpv5T90sMkiV6iO5k4kngRd5yZQgXIshPwS7Ol7Wo05X0bW+dVozNfopVr3QSEGs=
X-Received: by 2002:a2e:9e81:: with SMTP id f1mr69237153ljk.29.1564674434724;
 Thu, 01 Aug 2019 08:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190801072405.2835116-1-andriin@fb.com>
In-Reply-To: <20190801072405.2835116-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Aug 2019 08:47:03 -0700
Message-ID: <CAADnVQKG40B5XcjViNK5_XbJmm-26T7+iBtgD4p2Uif85Xorjg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: set BTF FD for prog only when there is
 supported .BTF.ext data
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 12:41 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> 5d01ab7bac46 ("libbpf: fix erroneous multi-closing of BTF FD")
> introduced backwards-compatibility issue, manifesting itself as -E2BIG
> error returned on program load due to unknown non-zero btf_fd attribute
> value for BPF_PROG_LOAD sys_bpf() sub-command.
>
> This patch fixes bug by ensuring that we only ever associate BTF FD with
> program if there is a BTF.ext data that was successfully loaded into
> kernel, which automatically means kernel supports func_info/line_info
> and associated BTF FD for progs (checked and ensured also by BTF
> sanitization code).
>
> Fixes: 5d01ab7bac46 ("libbpf: fix erroneous multi-closing of BTF FD")
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
