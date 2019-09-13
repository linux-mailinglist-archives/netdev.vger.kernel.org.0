Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA019B1D84
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 14:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388345AbfIMMTj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Sep 2019 08:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388309AbfIMMT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 08:19:29 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2FB2A79704
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 12:19:29 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id j8so17037278edl.11
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 05:19:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FUyOcPi0NHmHBGgNXqP+P7obEs5/r8uMUZC4jE6n+fs=;
        b=bwVLVLMGjgCNi37HpJEbst440RRi7wZKVshHXROaM6vQggaiwZZQzLDnsLFk7QKC70
         lfLoa9TzJr22QxYQVLDzwb9yuBR16a7I0l5BPsdrHx6oWNlKJ6Hw4ygEdv8GxUMNOY9q
         2tLiSVnpfWNQVrXYoBvgwBUJfHxCiHAR87+hK/lpLMncpR6Yt0mIZo4MhQuHu7UInoaM
         EWtFsab4pWXiR8shpJqLAO9nmz/6fCzcBtoLoJxM3+rRBSDvkMGp7m7oRjzaFCpE/qUY
         XJLQyZZxuEJRsg1sFm7h00bxBVQKBLyDVR6rmij6tQTxFGrpSJB1yGeMSf0IjkgTcGam
         reIQ==
X-Gm-Message-State: APjAAAWreVZCv3oMn0JXmJlrS536DPkrR0d1FzoLhmHE5OnihJ2A/xIp
        geVZ68Ft7r29ZyRbsImBJtrayXIsEICKHoqISNbn2F7W4Va9Mgzl63lTArQGAy3t8tiXJU8m6WF
        DwTOaPGGFzr+bbOFq
X-Received: by 2002:a50:f30c:: with SMTP id p12mr46858205edm.299.1568377168003;
        Fri, 13 Sep 2019 05:19:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyyJlvDFyQWbdgNap7j6wIzmKQY/VrKSgEVURx/1Gzi41LI0cvKYDz9tVgKPwUjHeIr/5xDNA==
X-Received: by 2002:a50:f30c:: with SMTP id p12mr46858177edm.299.1568377167788;
        Fri, 13 Sep 2019 05:19:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p11sm5241842edh.77.2019.09.13.05.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 05:19:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 68597180613; Fri, 13 Sep 2019 14:19:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
In-Reply-To: <CABCJKufGy0aRDSUPQEOKYZ9tLjqwQDcDaTW-6im-VfjkB_gUsw@mail.gmail.com>
References: <20190909223236.157099-1-samitolvanen@google.com> <4f4136f5-db54-f541-2843-ccb35be25ab4@fb.com> <20190910172253.GA164966@google.com> <c7c7668e-6336-0367-42b3-2f6026c466dd@fb.com> <fd8b6f04-3902-12e9-eab1-fa85b7e44dd5@intel.com> <87impzt4pu.fsf@toke.dk> <CABCJKufCwjXQ6a4oLjywDmxY2apUZ1yop-5+qty82bfwV-QTAA@mail.gmail.com> <87sgp1ssfk.fsf@toke.dk> <CABCJKufGy0aRDSUPQEOKYZ9tLjqwQDcDaTW-6im-VfjkB_gUsw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 13 Sep 2019 14:19:26 +0200
Message-ID: <87h85gs81d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sami Tolvanen <samitolvanen@google.com> writes:

> On Thu, Sep 12, 2019 at 3:52 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> I think it would be good if you do both. I'm a bit worried that XDP
>> performance will end up in a "death by a thousand paper cuts" situation,
>> so I'd rather push back on even relatively small overheads like this; so
>> being able to turn it off in the config would be good.
>
> OK, thanks for the feedback. In that case, I think it's probably
> better to wait until we have CFI ready for upstreaming and use the
> same config for this one.

SGTM, thanks!

>> Can you share more details about what the "future CFI checking" is
>> likely to look like?
>
> Sure, I posted an overview of CFI and what we're doing in Pixel devices here:
>
> https://android-developers.googleblog.com/2018/10/control-flow-integrity-in-android-kernel.html

Great, thank you.

-Toke
