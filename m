Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC357B86F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 06:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfGaEOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 00:14:54 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46558 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfGaEOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 00:14:54 -0400
Received: by mail-lf1-f68.google.com with SMTP id z15so42103243lfh.13;
        Tue, 30 Jul 2019 21:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhM3atlnHqiOWZuy75jidRKog9hbo8iOvI6mHc361Lc=;
        b=DYCHTF7bTh/A0rg/VDkvjBKiiZuvXE8Zjqp0S9WiBi9n8nmteYdZhIqGI2yeG4kAZD
         Ta907O/DX4Mz8PZZv0Fm5wDAoep8504nTIhhelLaFqNzu4AOyGGNGMP1WmMwJVKW85N4
         dYKWYQwZ3oJfCLcU8J4KIKOUjenk8Udp3SdSXgBK/G88TVJ1FUBsuGv+BwSwJvWvtX4j
         7mLb04B/NhBR6PsmDC9u+9G3gBVu2g/NQsXm7vMKG+2JIawuY+iY9ikRj2wlYbSG8fId
         2Y02YVscSUtH6puo0C1ZfIFoZFUVUMOpUWidfkPkWFMnphe0oHOok7eWGCIO6rh09mfe
         PmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhM3atlnHqiOWZuy75jidRKog9hbo8iOvI6mHc361Lc=;
        b=k/Fuc111EZUu2dCUtF8hprarwhd2ACh6MSvBVk32P0u9bPjsUhMKYad3d8G3cCq7sK
         yug0Ij4ORouQKpsgpOLG9gveYsFS8cwGgLzpWc5haGIBpy8l8ETIzssRFP5lMS56dxR/
         BfbnNg4dh0oCQq8L6Dh2vN+J2d0LYtHHa4W0qjfXYQ6jikHFYYT5qWi1wBdsDVyvdJGl
         FCR9ygX/elJZSKwhn8rSs2/ML7sAEN6kTWCnjPVE1vZ0EicJdgZOn94y6zKOd3tf4170
         ce4GM6BxqUQ1pjProB8yF/WSPQlL22hKnXwZHpES4WWR9Cg/aljB2CWbrfC4oIO6Sh3b
         5cTw==
X-Gm-Message-State: APjAAAWcnb2AZvKiE9sV4Jk5H+9DHeHgHj5FVYcbfG7PU/2L2rm6Kvct
        F5wD8EherAekWxtIbrhpBkVGuZQjjlCKzYKH5Qza6Q==
X-Google-Smtp-Source: APXvYqyfdAMlC3upkY8aGPrje/zFk4w21fAow3+RYy79qjk0WETDnJFnIve4w8QMub7jvdOGgjxoAmCY5bf0I/APkd0=
X-Received: by 2002:ac2:465e:: with SMTP id s30mr9866498lfo.19.1564546492479;
 Tue, 30 Jul 2019 21:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190730180541.212452-1-andriin@fb.com>
In-Reply-To: <20190730180541.212452-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Jul 2019 21:14:41 -0700
Message-ID: <CAADnVQJJy2dmEXLkjeawOrxP54PtnAf71H_gBTGf2wdiF0b0yA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix clearing buffered output
 between tests/subtests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 11:17 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Clear buffered output once test or subtests finishes even if test was
> successful. Not doing this leads to accumulation of output from previous
> tests and on first failed tests lots of irrelevant output will be
> dumped, greatly confusing things.
>
> v1->v2: fix Fixes tag, add more context to patch
>
> Fixes: 3a516a0a3a7b ("selftests/bpf: add sub-tests support for test_progs")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
