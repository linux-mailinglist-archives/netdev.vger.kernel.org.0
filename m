Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A693E26971A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgINUwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgINUwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 16:52:38 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60BF4218AC;
        Mon, 14 Sep 2020 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600116757;
        bh=yHgI+Sr9jwoe9TRfWW90cuxRyTn1tAIe+oD9RF6J39I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BiwqpdTYQOBtWTC2wBZqEgxqKSuqHFfEX20AViyi4dkm/ognyC4pTDIR5V9HPZFNQ
         E6jQkxi15JO6Q+AdtrI1gS84y6312OMwYBRReQAC0EZmHQqtJmGqN1Ihkb4FAPY2TD
         3eV87Pi7f//JQQHWareSEAHe67Bys8Tz8IBSJOi8=
Received: by mail-lj1-f179.google.com with SMTP id u21so871808ljl.6;
        Mon, 14 Sep 2020 13:52:37 -0700 (PDT)
X-Gm-Message-State: AOAM533J7+yZi7jAuOPxJbOvoaOLPUyMX7Cl1hXpTFayzYR6t8jC4GbL
        0f185ZOSwAITv2YOk3PQC1gAcj6Zk/UaisvoN3Y=
X-Google-Smtp-Source: ABdhPJzgo4USz8FapNukkkeuwuITZpww0+o3fFIGc8iwBX2Mv5WYcVLyp+M3WrCT8GWHcsTG4onew9xmu5X0P1nPJaE=
X-Received: by 2002:a2e:9c8d:: with SMTP id x13mr5290616lji.392.1600116755650;
 Mon, 14 Sep 2020 13:52:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net> <20200911143022.414783-2-nicolas.rybowski@tessares.net>
In-Reply-To: <20200911143022.414783-2-nicolas.rybowski@tessares.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 13:52:24 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4xqPD641gHAs7GjhmW7SANMhz75VKbP02Xyja9CnpZ-g@mail.gmail.com>
Message-ID: <CAPhsuW4xqPD641gHAs7GjhmW7SANMhz75VKbP02Xyja9CnpZ-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] mptcp: attach subflow socket to parent cgroup
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Networking <netdev@vger.kernel.org>, mptcp@lists.01.org,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 9:43 AM Nicolas Rybowski
<nicolas.rybowski@tessares.net> wrote:
>
> It has been observed that the kernel sockets created for the subflows
> (except the first one) are not in the same cgroup as their parents.
> That's because the additional subflows are created by kernel workers.
>
> This is a problem with eBPF programs attached to the parent's
> cgroup won't be executed for the children. But also with any other features
> of CGroup linked to a sk.
>
> This patch fixes this behaviour.
>
> As the subflow sockets are created by the kernel, we can't use
> 'mem_cgroup_sk_alloc' because of the current context being the one of the
> kworker. This is why we have to do low level memcg manipulation, if
> required.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
