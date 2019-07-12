Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9494E6759E
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 21:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfGLT54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 15:57:56 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43207 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfGLT54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 15:57:56 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so7306354qka.10;
        Fri, 12 Jul 2019 12:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTxCVF6DmY6rGlw3tqGw/t6mFmScKqRdjhV2uzssuhU=;
        b=atBIARnohXm4rO4NXWD0zCARvjEnNcs+GxMxZQNjRbX/cPGkjipBfMiEQQ3ph3/XkU
         8QC7GWx3nMN2D+N5XiN41Xsqg0uCbdYjVXwyB7VO8+UC2znj2oHp7edr69fR3aJqAANm
         80Hsi5nKdp7b4tKOI72IM0W6UcBn57GHn17U4CmV+zTWznadeR2IdHyjg5wHGOMikKfS
         Y+giifRZnPrDop5DjOIwwk+16mSqmm9xxEzxyaGJNdPR2q15jYv20793uREnuHTinndU
         B8NSOI5YbZXPa6jAnYm0uVg0W4hdgFsDjrDzcmK/PgTvE/OnasfIqGV2JB6pWtAOrGYm
         8DRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTxCVF6DmY6rGlw3tqGw/t6mFmScKqRdjhV2uzssuhU=;
        b=qsFBom4GGcRMBxlGnCMN5LHJSbOre5ntDb9LJy2X9Evq8Q0+XF0mja4RDFAeeG6nMl
         LKz1p0S206ZXHsgdnz9ymHTY8uENcwOoEJbXHTClFrT9XqQPyKM31mvOzIp6ecRfn/iQ
         ED/TmuwB6xydsa6Smtgz3AbXT/pQGrVO7tykUWsPSBiaBDu3pYcFnWhTBh0FGIHPP74U
         m1u6eYSUPYmJMk1ttt7Kh1cnTYWiHEB5MxqLN1BhVQeLzkonKQJqMJtbBtdGg+2OSfSE
         9itNA6kvl2UCvrioAMQ0SWd4wuBgEsuJWDN4HLzXxsisOc1QPYqpwT7qENrjzL/+qKAO
         JaSA==
X-Gm-Message-State: APjAAAXkGXF24JTz0iyyAeIe6wXkc0KDpaRvVdEbi/hWQRUFiolYlJ1/
        gLqDOlh+mayW+tRIaO0aW6h05nKlQDnCaYkT5xU=
X-Google-Smtp-Source: APXvYqwfDIGoayx+Ya6dhtrJkiqTLPfA3xU22tc4uwhQOdlUL6FZKkNwW4/viYIf5l5oULjNskgccwavQWIiXWm3t+A=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr7724269qkj.39.1562961475643;
 Fri, 12 Jul 2019 12:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190712135631.91398-1-iii@linux.ibm.com>
In-Reply-To: <20190712135631.91398-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 12:57:44 -0700
Message-ID: <CAEf4BzbgFzb5z-Ozmq2eYprzv-e_wvzhrDZVSb3XuiLFWY9cQw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: make directory prerequisites order-only
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 6:57 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> When directories are used as prerequisites in Makefiles, they can cause
> a lot of unnecessary rebuilds, because a directory is considered changed
> whenever a file in this directory is added, removed or modified.
>
> If the only thing a target is interested in is the existence of the
> directory it depends on, which is the case for selftests/bpf, this
> directory should be specified as an order-only prerequisite: it would
> still be created in case it does not exist, but it would not trigger a
> rebuild of a target in case it's considered changed.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/testing/selftests/bpf/Makefile | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>

[...]
