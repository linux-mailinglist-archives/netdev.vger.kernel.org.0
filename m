Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5CE12FBBE
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgACRrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:47:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33647 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgACRrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:47:16 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so36600343lji.0;
        Fri, 03 Jan 2020 09:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0RSeiMU8QPdyOoG9B7y/fvlmT9zXEcFUjZ8OB6A7lk=;
        b=KqwmgltChF4dNJvggsEgsGSiEsBSUXu+bcHz6HLV8dVvSnyVFmshCVm7mtsBYqtA+e
         09lS+yhsyGC2JGAGM58yWnZ1eW9V1k6RRebEHZkpy5XkUp5aRONRu0Ih4g9LPfG2iOxE
         LWBHodFYN1sKKWJEyHuRIPy0YrV39XFdFJ4OgW9ukiK4uRAj3b/nTbLtRtEsC0/YXxGv
         TsZRgehd1v6WYfO/WFHID9jwuzpblaSKNiLsNtRiGjRl82h8bWpJdTDKpXFLddz049nG
         eJIxEHqhzRJoNM9NVrJKRGknHmgSeCKXEQ6Ms4gaXH1Jw1WrBOe64KcDWSGVy1Saf/y6
         +69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0RSeiMU8QPdyOoG9B7y/fvlmT9zXEcFUjZ8OB6A7lk=;
        b=ejQ5MRBfASwIEnCTFqMN49bvA78nP+p/M1MJnUwDWbkAHjRTmATirxyV55TrHGHfn1
         fwwwIZtJRLkMiVsr8te2uJngRl8vMYpBof/aoF4Cv9CeubrL19LYUVkeXQXFaXJ23e/l
         ppoT/RtTSMTHkuawMzyN0hoApC6tErMQ+1DTAKTugUi1YOaO30At3diaMgAf44DYhzFh
         +vBQzPGzw1vW2/hsXFzVeX7sy7Hky12jfHQ6MlkvT4GpEl7T93txmJJvmkZ1VncrpsMd
         vPOw292SxbXgtYD63c8i/7epNVf8QH1dKUCXNEWmS6/qE9puA2PG0IZG4Ymxj9kuChic
         OzvA==
X-Gm-Message-State: APjAAAVdB0KxAILsQepRrmW4vU+WQ4cuLgKw9Fi8S78R2J0OdgfzUU4U
        GAwz7sqpXo9FG2W7lbHoLddV8fkWj0vaAfOo2fawZlz9
X-Google-Smtp-Source: APXvYqzVneOWPg55BXdA3ZDaSFLNRTK6aUClojuZRBSWrtYXVqP/JPBgHG7a/2h8VK53E45cVQy+QGViybaJibiKk9g=
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr53035655ljm.68.1578073633455;
 Fri, 03 Jan 2020 09:47:13 -0800 (PST)
MIME-Version: 1.0
References: <20191227215034.3169624-1-guro@fb.com>
In-Reply-To: <20191227215034.3169624-1-guro@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 3 Jan 2020 09:47:01 -0800
Message-ID: <CAPhsuW7SKrS9WOVZXXoXjeGaFugUZmwip-m44gWAWyCbEkhBvA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup bpf
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 1:50 PM Roman Gushchin <guro@fb.com> wrote:
>
> Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf
> from cgroup itself") cgroup bpf structures were released with
> corresponding cgroup structures. It guaranteed the hierarchical order
> of destruction: children were always first. It preserved attached
> programs from being released before their propagated copies.
>
> But with cgroup auto-detachment there are no such guarantees anymore:
> cgroup bpf is released as soon as the cgroup is offline and there are
> no live associated sockets. It means that an attached program can be
> detached and released, while its propagated copy is still living
> in the cgroup subtree. This will obviously lead to an use-after-free
> bug.
>
[...]
>
> Thanks to Josef Bacik for the debugging and the initial analysis of
> the problem.
>
> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: stable@vger.kernel.org

LGTM. Thanks for the fix!

Acked-by: Song Liu <songliubraving@fb.com>
