Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C31144A01
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAVCp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:45:57 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39154 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVCp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:45:57 -0500
Received: by mail-lj1-f194.google.com with SMTP id o11so4751746ljc.6;
        Tue, 21 Jan 2020 18:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LFWN2WUWKvDDimd9jmFQDhkOBo+JNf9WTQ4koPwnCE=;
        b=LdhBJKN3y1rQbbLCpaGYom17Zdd4Eu6UzRYW8v9CjzywX6584VlwZF6JgHN36lJ/mt
         HwveNE0/lcQoFhlU1jzIXaSENZvIjYiqKjT1Fgee33JCnEJ1MWeANn8IpLQkAkDavQoC
         GWdODCv5AU87OmodDZaH+bnbRe3aGJPulrKcy/8AQ7hQCAToFQMgYdOCRHfRs3pFJOyj
         Whcti5inXvEiUB8cBzHrpwLrMFj2e0vpytV2DDM1fnYOhmmDGJzRHIXeYiynjpaZQO7k
         9KVAKbMteWJaNFU1q+fYx9OKXGDjcxtVv7WTVlnajDuP0HIEUNt1/WKDhhN7WhWZZ1Om
         wOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LFWN2WUWKvDDimd9jmFQDhkOBo+JNf9WTQ4koPwnCE=;
        b=fu/TapOQYxL1vgxvYYMlkq6naP8KMTAWhre6usvZkKlZYBGW4G57wwTUXtCP9iAjUC
         pHBrN9SkKKUBCR6CUfsoqgbxxW5ENMmep4ceWnYwefO7qBV21yzxMNXzhiNMLx6XVhQs
         7Fmfh2vQkI60KvvRMMMHgCp6qXQdVVzTr5x5mlfBNekTuGVXUXsZLoKFDTxCsWJoFGBR
         /dUqCZSIV5O3YgxUP6AmCj4Vr9IxEdMEWsf3YJfTpu0uxUzXVodS671Pg+TOEsnmJuyV
         Xz8KSEpsQTq/ZNr/Wx+T0UQ4O/IK8RVTnDeFUXT/v49vdipEkDP0Nime48V1IwjDcs1r
         k14A==
X-Gm-Message-State: APjAAAXo3TiRGuSyPy/RRosSL0ome5H60enGgqLbdHPbf0f9aCRHrt4H
        vLpbi5uWwiVou2VCDQCn0jo85QG4DkydzAznZaw=
X-Google-Smtp-Source: APXvYqxdRV1b6Rhgd3930aoAIy8bcjOeKovNqjij9JHsaR6hGeNcgeva/eklMDKQfLQxa9znUPV5xW5oHvTJwWmvxa8=
X-Received: by 2002:a2e:b55c:: with SMTP id a28mr17753082ljn.260.1579661155077;
 Tue, 21 Jan 2020 18:45:55 -0800 (PST)
MIME-Version: 1.0
References: <20200122024138.3385590-1-ast@kernel.org>
In-Reply-To: <20200122024138.3385590-1-ast@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jan 2020 18:45:43 -0800
Message-ID: <CAADnVQ+HdfXVHnEBMkqbtE2fm2drd+4b8otrJR+Qkqb3_3OGdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix error path under memory pressure
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 6:42 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Restore the 'if (env->cur_state)' check that was incorrectly removed during
> code move. Under memory pressure env->cur_state can be freed and zeroed inside
> do_check(). Hence the check is necessary.
>
> Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Forgot to add:
Reported-by: syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com

Daniel, pls add while applying.
