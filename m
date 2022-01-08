Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FDA4883ED
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 15:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbiAHOKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 09:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiAHOKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 09:10:07 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C80C06173E
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 06:10:06 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso6548302wmj.2
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 06:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Wvr9B5Og2idB5f4e8kL+4mc9ZlXpKCsICKibs4hTE6U=;
        b=HNPCe7KrRLoYAhuKcXaBwu3uQVsuefqIavkpBVgi20r855XuhUIUKodE5uplvoIgNn
         bdo0c0Kz7FUkdZ59y8SbcSGG7YMN3crNHrLEkMJsmCCdGJoqYinG2WgRIZ/IeaNaaGZg
         xBqfCv/aLCTn5N7bb2vGTtyg8H0NgmT7xHpds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Wvr9B5Og2idB5f4e8kL+4mc9ZlXpKCsICKibs4hTE6U=;
        b=qP7ZYrv27PEQPpSu5gzuntmb8mMc5m18CY50m+WzRwdsgIWvXDn6XI3c8o56gDipHH
         0/4UuryOB8xp494Q/sM4F1MFF8iffnh1WIbkodUViVygjMv6xdGfnS8PJYuu2I1EnpYI
         KpBmeueS9X5hZUWklFdMpIgnmlkbXgSGRA9EX7ts5Gg4WEOejwEdkYmCEIEQhMuoNXJT
         3QWmSqVG3Y26D+ifx4rVYILBel7g6XOwNzatKgjlb8DUcpeVP7fkCG1Aa9shzKuE/4HR
         NsXxAXQ9vRxou14N9QQdjNj7oRbJtb0/Po9BXsz4EEmycDggq8AC1tO06AIRYhiPX0BO
         4Jpg==
X-Gm-Message-State: AOAM5312kIlfw8/tP3BiH7sCWT1ZjW8OC8Or//Jjm2dLTZMhcGCxXjbD
        x2KBXKlM5DGzfudsAOjkYm4iBA==
X-Google-Smtp-Source: ABdhPJxVHH4OnlGxc7mRvX1WqD4jFqxAfvGCz4ewLcCwoU3VfZlQPCOWpUu1qp1IfNnkqU8vjlNPgg==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr14754929wmq.166.1641651005070;
        Sat, 08 Jan 2022 06:10:05 -0800 (PST)
Received: from cloudflare.com ([2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id o1sm1701644wmc.38.2022.01.08.06.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 06:10:04 -0800 (PST)
References: <20220104214645.290900-1-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, joamaki@gmail.com
Subject: Re: [PATCH bpf-next] bpf, sockmap: fix double bpf_prog_put on error
 case in map_link
In-reply-to: <20220104214645.290900-1-john.fastabend@gmail.com>
Date:   Sat, 08 Jan 2022 15:10:03 +0100
Message-ID: <874k6epbd0.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 10:46 PM CET, John Fastabend wrote:
> sock_map_link() is called to update a sockmap entry with a sk. But, if the
> sock_map_init_proto() call fails then we return an error to the map_update
> op against the sockmap. In the error path though we need to cleanup psock
> and dec the refcnt on any programs associated with the map, because we
> refcnt them early in the update process to ensure they are pinned for the
> psock. (This avoids a race where user deletes programs while also updating
> the map with new socks.)
>
> In current code we do the prog refcnt dec explicitely by calling
> bpf_prog_put() when the program was found in the map. But, after commit
> '38207a5e81230' in this error path we've already done the prog to psock
> assignment so the programs have a reference from the psock as well. This
> then causes the psock tear down logic, invoked by sk_psock_put() in the
> error path, to similarly call bpf_prog_put on the programs there.
>
> To be explicit this logic does the prog->psock assignemnt
>
>   if (msg_*)
>     psock_set_prog(...)
>
> Then the error path under the out_progs label does a similar check and dec
> with,
>
>   if (msg_*)
>      bpf_prog_put(...)
>
> And the teardown logic sk_psock_put() does,
>
>   psock_set_prog(msg_*, NULL)
>
> triggering another bpf_prog_put(...). Then KASAN gives us this splat, found
> by syzbot because we've created an inbalance between bpf_prog_inc and
> bpf_prog_put calling put twice on the program.
>
> BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
> BUG: KASAN: vmalloc-out-of-bounds in bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
> Read of size 8 at addr ffffc90000e76038 by task syz-executor020/3641
>
> To fix clean up error path so it doesn't try to do the bpf_prog_put in the
> error path once progs are assigned then it relies on the normal psock
> tear down logic to do complete cleanup.
>
> For completness we also cover the case whereh sk_psock_init_strp() fails,
> but this is not expected because it indicates an incorrect socket type
> and should be caught earlier.
>
> Reported-by: syzbot+bb73e71cf4b8fd376a4f@syzkaller.appspotmail.com
> Fixes: 38207a5e8123 ("bpf, sockmap: Attach map progs to psock early for feature probes")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

FWIW, late :thumbup:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
