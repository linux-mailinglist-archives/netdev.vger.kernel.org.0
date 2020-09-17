Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D79C26E906
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgIQWhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgIQWhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 18:37:25 -0400
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E9482137B;
        Thu, 17 Sep 2020 22:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600382244;
        bh=fWq0J1V2mC5LakVng8TXhlfM5xnaNKqJuKrgIRnuFzI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yVhty9vVvXjydF6COPEVsF+tX2c1W9SKVfwOk1jVr0SBWwLoR4B1HcB8QGn8umXCG
         HNqeQCJFP8zGWMgub6Dg4/7sIwFH/Z71mMWuPZOyz0mUIs6Or5AKa3kWmBc6/K3RMZ
         J8BEqkHjWDosNJ3Lmf/3zUreifiwYgutj2dpiD4g=
Received: by mail-lf1-f54.google.com with SMTP id u8so3966235lff.1;
        Thu, 17 Sep 2020 15:37:24 -0700 (PDT)
X-Gm-Message-State: AOAM532ADRznDMILopgBCk3iAhMyKvkREPGuPRGyGldhSy+KXsSdDmO5
        VaOjPKmkz1f6mUdabQ+oSsBY8AZWz5zsu+OIAsc=
X-Google-Smtp-Source: ABdhPJxFUBrBmYaXc0rIZzVwN0YNAov9MLFepoYcOoyLKBHcsl+6snHSxKXr4XxPwbnb4NAH+7yUxpd/F7QWiGTVAI0=
X-Received: by 2002:a05:6512:3313:: with SMTP id k19mr10368213lfe.504.1600382242674;
 Thu, 17 Sep 2020 15:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200917074453.20621-1-songmuchun@bytedance.com>
In-Reply-To: <20200917074453.20621-1-songmuchun@bytedance.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Sep 2020 15:37:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7W0Cm_eyEY8pDGwMqo8pM3OWAUYUu8PyUqcUxPGLX3DA@mail.gmail.com>
Message-ID: <CAPhsuW7W0Cm_eyEY8pDGwMqo8pM3OWAUYUu8PyUqcUxPGLX3DA@mail.gmail.com>
Subject: Re: [RFC PATCH] bpf: Fix potential call bpf_link_free() in atomic context
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 12:46 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The in_atomic macro cannot always detect atomic context. In particular,
> it cannot know about held spinlocks in non-preemptible kernels. Although,
> there is no user call bpf_link_put() with holding spinlock now. Be the
> safe side, we can avoid this in the feature.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Song Liu <songliubraving@fb.com>

This is a little weird, but I guess that is OK, as bpf_link_put() is
not in the critical
path. Is the plan to eliminate in_atomic() (as much as possible)?
