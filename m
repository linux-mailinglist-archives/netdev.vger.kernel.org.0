Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9695777567
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbfG0AYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:24:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37068 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbfG0AYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:24:47 -0400
Received: by mail-lj1-f195.google.com with SMTP id z28so53165092ljn.4;
        Fri, 26 Jul 2019 17:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RvlR/MQduBGCyLx0ksbnAr/pUPxdaK/A6eI0InZLMc=;
        b=eGnMlGI46KkUudWQE8kXm8OiKpnh58RhOFKf4GghMZsNda+v6otIlbysBPazP1SMJ3
         c6xUYqqQoiJSsSV7vcLrAEPpAVe6pArd7jJXHD4XKxRXwLQEjlRKC1rMj4vexZJYiLDL
         m3inPWNBRX9mmiSr8X7+6fVmIEg+0s3miZIb88YgwydrbVAydFRvUutOo/ZfP6jfzzPq
         5QoooFwoMz5nt57TAAoeE5d/jn2uUuzUOGjlTmw4aqv98CRpvylQp0yUkNrdAoAIrdQO
         E5a0av0QsK96NVztZeM4Hdm9KMMDfRxTbLMXehB7C8sJsMHD1ELb0CIji4d0ad4ptR/N
         PqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RvlR/MQduBGCyLx0ksbnAr/pUPxdaK/A6eI0InZLMc=;
        b=EyFpAkEHXoXl+3TnhB4m/GS1O8YCi8baCo1XFWkcTaIgjO92Umm9kD5BsZ+uvwTv8H
         oQlUJqj0makJnXwcctYCI3SInbiQShHXV1P9TrlXnVLgAdhuYiv4squhHNm1CbT3jw7o
         8CBUD5XlAMikNN5AAcc+v0LdnMWTF9loLkuqalD9XQ+LfhMNsw6WlYcNsHj7COAtwGqW
         GD6kRxxA+MQS+22WMyRwA8FLLJ0Ri7MX1WPtA3AedzTgLNfavAiB9KBmP8AsinTjwFyz
         LvKd6MUyQAwYmlUpvncPXRXjhp64c4iF41gFc93cwopBW8WM9kGWKnZaYc5Rou6BtKsE
         fZ8Q==
X-Gm-Message-State: APjAAAWskzcf2UJqX3lR+rLoO8oBeDHa719oQxLxgcsW8nLEZTu7jIjx
        OSYwbn2NlwMsx1Cz/FMnJT5ILpgYz7xYxo/7EkM=
X-Google-Smtp-Source: APXvYqzh6irLJm8DBc7EV+YFuD0sEpMuQsHmvC2nWHVzmRxJhb+gKKuAlIMRLRihbXCut94CV2Ji5dsKcZWg+ZXmItY=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr50372002ljj.17.1564187084849;
 Fri, 26 Jul 2019 17:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190726212438.1269599-1-andriin@fb.com>
In-Reply-To: <20190726212438.1269599-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Jul 2019 17:24:32 -0700
Message-ID: <CAADnVQK4mj7bwTQyJu34J=xU3rz7FrXg0Px+xin+Ab5W6AvYDw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix erroneous multi-closing of BTF FD
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 2:25 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Libbpf stores associated BTF FD per each instance of bpf_program. When
> program is unloaded, that FD is closed. This is wrong, because leads to
> a race and possibly closing of unrelated files, if application
> simultaneously opens new files while bpf_programs are unloaded.
>
> It's also unnecessary, because struct btf "owns" that FD, and
> btf__free(), called from bpf_object__close() will close it. Thus the fix
> is to never have per-program BTF FD and fetch it from obj->btf, when
> necessary.
>
> Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
