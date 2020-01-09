Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17CD135EEC
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387975AbgAIRKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731544AbgAIRKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:10:38 -0500
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F352067D;
        Thu,  9 Jan 2020 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578589837;
        bh=lsmfN75tT3y2ZzCHh1gZs0tkBZ8Qzf3q8K+xDOnI9Lg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DY+i+bSZcVP598O9FzGDOOxSWqOE2RIxedZW0w5ofNupS5TQcQrsEtwqsI/XPBA9k
         SMiTOKGLF10gf5u7Q2sa2revWsxLxqyQJRVLCBco3OsdADi7maYg1Ce7w9O9UFYbfy
         +9HO8Hvy+NZJ8qIQlZNtH+uE1+8cJD9LyCeXueoE=
Received: by mail-qv1-f48.google.com with SMTP id y8so3265864qvk.6;
        Thu, 09 Jan 2020 09:10:37 -0800 (PST)
X-Gm-Message-State: APjAAAUof1C6Dgsow2pEm8rm9QesUSo+LviCXf3MWRPfXZE6RnH8U0dO
        /4pVNYaBXL+94dATLQ56atYHTUndnQZDFe2zge4=
X-Google-Smtp-Source: APXvYqzJx++tLk9e5/Pav1+ioq++/OIhjqGNoyldFYjVbM+ULektPHWvA9pQzIyayWBIRRKRy9HAfQcFSCFlPb3DeT0=
X-Received: by 2002:a05:6214:14a6:: with SMTP id bo6mr9935842qvb.8.1578589836935;
 Thu, 09 Jan 2020 09:10:36 -0800 (PST)
MIME-Version: 1.0
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2> <157851806382.1732.8320375873100251133.stgit@ubuntu3-kvm2>
In-Reply-To: <157851806382.1732.8320375873100251133.stgit@ubuntu3-kvm2>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Jan 2020 09:10:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW697e5umg2JLBiFLmSQ-hYLLeVxGAvc9W0BPzMAs0cH8Q@mail.gmail.com>
Message-ID: <CAPhsuW697e5umg2JLBiFLmSQ-hYLLeVxGAvc9W0BPzMAs0cH8Q@mail.gmail.com>
Subject: Re: [bpf PATCH 2/9] bpf: sockmap, ensure sock lock held during tear down
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 1:14 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> The sock_map_free() and sock_hash_free() paths used to delete sockmap
> and sockhash maps walk the maps and destroy psock and bpf state associated
> with the socks in the map. When done the socks no longer have BPF programs
> attached and will function normally. This can happen while the socks in
> the map are still "live" meaning data may be sent/received during the walk.
>
> Currently, though we don't take the sock_lock when the psock and bpf state
> is removed through this path. Specifically, this means we can be writing
> into the ops structure pointers such as sendmsg, sendpage, recvmsg, etc.
> while they are also being called from the networking side. This is not
> safe, we never used proper READ_ONCE/WRITE_ONCE semantics here if we
> believed it was safe. Further its not clear to me its even a good idea
> to try and do this on "live" sockets while networking side might also
> be using the socket. Instead of trying to reason about using the socks
> from both sides lets realize that every use case I'm aware of rarely
> deletes maps, in fact kubernetes/Cilium case builds map at init and
> never tears it down except on errors. So lets do the simple fix and
> grab sock lock.
>
> This patch wraps sock deletes from maps in sock lock and adds some
> annotations so we catch any other cases easier.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
