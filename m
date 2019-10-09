Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDCD1C34
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732381AbfJIWtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:49:51 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32895 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731140AbfJIWtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:49:51 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so2886473lfc.0;
        Wed, 09 Oct 2019 15:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQ7IRzTIdaFV+n1nK/yXcwRVj3KRTiTnBvNE62eqmyQ=;
        b=cOzzPAwzAzkmIWEMYL0RcXpWp/ZMYe1+XLb7aL45jWyMNEboKZRC7WbrRn0hfMQeij
         q2Gdw2qclJgOvZ72pWuyaSn9c4erB4UHOBOwc/+rsX2Pf8yrmTu721zU1u89VW02w8DC
         Gj8tSaNx+gtGoPz93dCqluDu5Q3YcmKwrbpp4bkXYCBW//CP51H43mN5bosyJ+S5w94H
         JmM7WQSom9KPoJp/TNMasK8vqNV1kRJc/xyQohabXLWPpnEdrTRu+OXgGTJKeCPAW96G
         dYgq5V+bNQ75eQ2dDCeCUpb12rvgJZ60i8pK2oAl5nurPa/nAt/0GT1OttCReRSHzi45
         YuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQ7IRzTIdaFV+n1nK/yXcwRVj3KRTiTnBvNE62eqmyQ=;
        b=Ci5NFWZ+vcwOlHtSdDroHuK+GxevzwnS3WK0tBuqrTtTJn+kNIePRiDsa2irHD3LyH
         l/PEPBrblHtGPis5rWaWePhAmwcgLVO5otKDMHTQh0rw5yiJ6TmiYPlqA5yeCwbKiKBZ
         CmlxYm9Fi15g3IEmaFT/rYqRhMX+9kyM8YRCsAWsgaJNFPoG4Ksu1MyXtELn3G6eomur
         q2+MhoUxRO1vPmA5jOYBtTkRPLN2wI7j+GGyBmEp3Js31bi1xRephAjsQ8Wll5baXfBS
         AH/xDtA9kXfBJ0JF8jp08ginjJ76/E3xvsh2PObZ+0WNu3faFjDJF4VlrN8VCr0hQRuK
         M9qw==
X-Gm-Message-State: APjAAAVNnIEgvw/eyY1I4ckktZHvIYk6i+uDks5b5AdAyDmzJwZg/81Z
        WwCYioEElZtDnJHqoSgquRPuFyWBayEwhKjo4ek=
X-Google-Smtp-Source: APXvYqyLAQD+m08S/pEGauXD73vDUQXux43O0PKPmkPH9K4OCqSDb5frePFQtDa3qXQae2OItATfE/AEGOrKuLhadTI=
X-Received: by 2002:a19:4b8f:: with SMTP id y137mr3609940lfa.19.1570661388383;
 Wed, 09 Oct 2019 15:49:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191009164929.17242-1-i.maximets@ovn.org>
In-Reply-To: <20191009164929.17242-1-i.maximets@ovn.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Oct 2019 15:49:37 -0700
Message-ID: <CAADnVQ++EF8oEzVvfx=0XHiv_YccHr1gCxzRs5GYGk5uB0CmuQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] libbpf: fix passing uninitialized bytes to setsockopt
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:49 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
> valgrind complain about passing uninitialized stack memory to the
> syscall:
>
>   Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>     at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>     by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>   Uninitialised value was created by a stack allocation
>     at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>
> Padding bytes appeared after introducing of a new 'flags' field.
> memset() is required to clear them.
>
> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

Applied. Thanks
