Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC01C20F0
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgEAWxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726827AbgEAWxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:53:08 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E14CC061A0C;
        Fri,  1 May 2020 15:53:08 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so3943584lja.13;
        Fri, 01 May 2020 15:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lC79aPZW6AjC9pf7KF8UTKymwTC6u0lyxph48s2QozU=;
        b=EC0PL+meS4hS3Mzrl5h9s5GzvdQ7CxHT0K9CC4ygBhbvNuxg6XnxPEQidGMkuAFF06
         ZKrAPoZSXAq8iRmnsYsePO2J8EEPvRbzzrgwI4ZxT3VIm7vOXs9/Jx+E21rmtl7lyAMW
         KI+hVtsxhO3NcEdN3I4oaKJ/nQyB15/67DqxB/2/IadsoG6YTVRpbPbBYCkQtsDM/PWl
         fTbP98DaAJzzV8QsnfWcMqR6ZRoNwWcErdSAeW7mmJVcfLzCzUu5EkVRM9V3NFKzFISi
         bXTbb9OarriNXBUClMO3a9Bk33DE8VBni2CpMc33hx4jR7Di39Q+IEARCzvyEwvUDB8Y
         W5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lC79aPZW6AjC9pf7KF8UTKymwTC6u0lyxph48s2QozU=;
        b=GubtPvjX7eMIBRuH9h3GvPfElK0pyZRSl4gq2nFh8aKHS+zOLSvzat7tQoT9c0r+dn
         4yr/wI6l5KU87uMInAquyisyGpeg0JbrsmXucmoyQDWmOIypmSuDthYrzo+UT9QpoYNj
         zibdkbEoboSif6Vv8ntwUcunpUgCpE3kv6A78FWmqzb4d71xnA8hPzNc4qM15oGpKZ1q
         AElLAXVCZTUWlM9mQ8uHsZyJOLwEeaIeFtGZGMkMt2vSgpkGAR5S2WCJyDAvhGMi8P+w
         J1ikfmy+spPDaJaatr6vosqFRmdwSQ0iRZWBMFCEnBV8OPVo6fz2ErcWZAObCPfSED/r
         k5ZQ==
X-Gm-Message-State: AGi0PuauCmG5wjE5pS+zaNMfcyYQE8d851QJHZawNdMJZocT1yvZjClc
        3PBw6mFrFX8mSiZap75KtCQkhJ19chHZAWXWehw=
X-Google-Smtp-Source: APiQypL+fpYSX9qKqj7U2vjZ4YXtK3zGMlam/cJc3ck7NPVl1pfwUAoSjyJ4yzloVNbz+lUYs/UcktlF3is5ipZeRkc=
X-Received: by 2002:a2e:b80b:: with SMTP id u11mr3673872ljo.212.1588373586809;
 Fri, 01 May 2020 15:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200501185622.3088964-1-andriin@fb.com> <20200501195929.4s6y7wee3u5usk4n@kafai-mbp>
In-Reply-To: <20200501195929.4s6y7wee3u5usk4n@kafai-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 1 May 2020 15:52:55 -0700
Message-ID: <CAADnVQLpT4b9CC1bwVrqLiFKLG5mAoDbo1ae0jJCwVq8A0eSRw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: fix use-after-free of bpf_link when
 priming half-fails
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 1:00 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, May 01, 2020 at 11:56:22AM -0700, Andrii Nakryiko wrote:
> > If bpf_link_prime() succeeds to allocate new anon file, but then fails to
> > allocate ID for it, link priming is considered to be failed and user is
> > supposed ot be able to directly kfree() bpf_link, because it was never exposed
> > to user-space.
> >
> > But at that point file already keeps a pointer to bpf_link and will eventually
> > call bpf_link_release(), so if bpf_link was kfree()'d by caller, that would
> > lead to use-after-free.
> >
> > Fix this by first allocating ID and only then allocating file. Adding ID to
> > link_idr is ok, because link at that point still doesn't have its ID set, so
> > no user-space process can create a new FD for it.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
