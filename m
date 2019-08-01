Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D4B7D3C5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbfHADkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:40:43 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35642 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfHADkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 23:40:43 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so67913596ljh.2
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 20:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PpkYq6fVx/ZR5aqNY84SME7LF+HpAIBvX3Cq6EussC8=;
        b=SpQ3JrEnItJevaGJsnaOr8zppSE++lXpsPrUHWiGp090JpEYxMz0PW4Rb9I0O8wnIV
         CqvdQxjUfLku+x5pRc8AYxmu2Ol9TLIrRk/tokc0Q1AyDewKSPPDdFMNi3yG2XVoYNj0
         14LkW02bioP1dv4d4qPkMOQfaIsqI+1JbYdNNBg+wtSCtq8oS1gofaMfEcLelSHDxdh5
         Vv7BmXLOULcF4WGxjUnsPUTmLEpGplTWeGuCRGrQ0I1WNtKeWM6Zx8h/2mq/yLs/wxEc
         5J2a+9OEy+y0ZgLizEGHpjClNgATaFf7RWowAxS2kfK3JQ2E2XrwgXzBUiGenfOrxgdi
         Av0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PpkYq6fVx/ZR5aqNY84SME7LF+HpAIBvX3Cq6EussC8=;
        b=E9FLJ6CkneAmCYB2xgSfXov5IArxnPyV5szDJsXBPuyTTeLzxiuAw5qrzkfrJ7wrko
         x9mfBkhJkiDozhrEpnn8E4m8IQV/V8Y7OPVoN1A+8Rvo5Yd4gJAE3/Hw12hE+bjs641G
         onw2EmlOS/18HCRMHJdWWhTBZNjBlh1BuCvdSL9f67ho/gjMW/+DkTMJGf84Xkvx6Xz1
         HFiIu5k6qo65nhFP1Pm54aMjvC5A6nFvSD4Bm8RgVAUOqjiKt5x4lzqcQS0rZZh2CjYC
         SQtvtj90pvUBZE2h4eLIY+HMsPkV4CypDOpA60DK8IH21LBuuo/kRCAl/YPbJMHiu1sW
         BhvQ==
X-Gm-Message-State: APjAAAUgZe9M52oXr3nT+akGi3hZEr1uawo5ZG5EoOgd1ix+o+t4QmG1
        6cRZzWi7QYH6LMANwKOGRX7x8ceX6LtvRZiRJB8=
X-Google-Smtp-Source: APXvYqx1moBlYQbU5iL6VhA0LZtk2SB5WElr1xM0jZSdoXybVrT3QuQMyfV4iVomNrBs5Ma3ebKNob79LiEIY4xUajo=
X-Received: by 2002:a2e:968e:: with SMTP id q14mr62027310lji.195.1564630840884;
 Wed, 31 Jul 2019 20:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190731221055.1478201-1-ctakshak@fb.com>
In-Reply-To: <20190731221055.1478201-1-ctakshak@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Jul 2019 20:40:29 -0700
Message-ID: <CAADnVQLJ0LqH-ozZ2UeY=nqTR-3-96qKkt7zL1fOg2FHh-bY8A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] libbpf : make libbpf_num_possible_cpus function
 thread safe
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>,
        hechaol@fb.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 3:11 PM Takshak Chahande <ctakshak@fb.com> wrote:
>
> Having static variable `cpus` in libbpf_num_possible_cpus function
> without guarding it with mutex makes this function thread-unsafe.
>
> If multiple threads accessing this function, in the current form; it
> leads to incrementing the static variable value `cpus` in the multiple
> of total available CPUs.
>
> Used local stack variable to calculate the number of possible CPUs and
> then updated the static variable using WRITE_ONCE().
>
> Changes since v1:
>  * added stack variable to calculate cpus
>  * serialized static variable update using WRITE_ONCE()
>  * fixed Fixes tag
>
> Fixes: 6446b3155521 ("bpf: add a new API libbpf_num_possible_cpus()")
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>

Applied. Thanks.
Thanks for keeping 'changes since v1 part' as part of git history.
