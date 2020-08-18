Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9F248C84
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgHRRHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgHRRHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 13:07:01 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283ECC061389;
        Tue, 18 Aug 2020 10:07:00 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v12so22253009ljc.10;
        Tue, 18 Aug 2020 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1c/4yYVQMz5AXCBeUFg3WeRQ4gJyBE8RLv9ILCFc0o=;
        b=QvghSaoinoGGEoblQhcc781ePNo6gwt6MuJSI3NIScgE+n9xRSfVF5USpt6fHYkQfx
         NS43fpPE3KciwhmCAqOdIcDekVhipGjwAiIjuKhISbystiv4TcP359qcWiCCMsedw4KO
         ctdVBY09AfDpUy3FV3Rq8LXrF/8AsNkej9Ws7i35qQl0Q0gnPygTQviqYfML/PhGOKgO
         mvmW/nATUYaIkQ4Pd6Hvi2qi2oLOWimYK0KUusEL9Wdj1eY0nQtPjBT44Hm00MTxLSwZ
         KIn4ddBAhdGYClkYUjW9Xmx4L+P4R1eBQT3lWmGRIeOqRHV5bEH6m3UKpnFWMD4/Zttb
         TLCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1c/4yYVQMz5AXCBeUFg3WeRQ4gJyBE8RLv9ILCFc0o=;
        b=LSFocWq0ZnZTKNK7Gke3ybNA8001u3ZYNIfXPMlWntfrtkNsZjfnj2EeRF+DqWCpdT
         xSe+qOy62sLvCB6/XYgWV76P9CnLdCwpdvSf6VWiZXWO3d5fzfnjJNVrchJBv7AfNv64
         l2Mnsm+8hso7H9W2BECIGtU6EI7rx6VD59d7aY8m/IiMnVsxUd5GpsbCbu5H35OoQ83X
         Hz/3Q4bAKu/xyMJqCHurGN07sdoW4YkgW89jS8DedMh7WNYPsIdNWKtzfMYKsfgzNwDi
         1tL3N7wncZ/MjyPmcqoHwDPB24tF3x1f1tbNTMJykZiSVIMSbYkljL6AmG1GMdd6UqoJ
         p89w==
X-Gm-Message-State: AOAM531HDDpmfh0oUquO7mOyodylNsuJ1u7z8a/BmB75fTiNqeNMPvrG
        7SRUiSMmhEMeV2ItS8kVz2mjFACKVMw4EQoRHxA=
X-Google-Smtp-Source: ABdhPJxfJlqVZNsDe12u4bVbuOkl3hOs64lMGe8ZJvh0aMYrK8khzErkDso/qwds4PALzJ+TFNKE4J98b6BbuAHAZqg=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr9576006ljk.290.1597770418614;
 Tue, 18 Aug 2020 10:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200818162408.836759-1-yhs@fb.com> <20200818162408.836816-1-yhs@fb.com>
In-Reply-To: <20200818162408.836816-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Aug 2020 10:06:47 -0700
Message-ID: <CAADnVQL-2PKh8rzVWjCWCSSO6WkdhS+azFUtcLmNT=1Wj1hH+A@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix a rcu_sched stall issue with bpf
 task/task_file iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 9:24 AM Yonghong Song <yhs@fb.com> wrote:
> index f21b5e1e4540..885b14cab2c0 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -27,6 +27,8 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>         struct task_struct *task = NULL;
>         struct pid *pid;
>
> +       cond_resched();
> +
>         rcu_read_lock();
>  retry:
>         pid = idr_get_next(&ns->idr, tid);
> @@ -137,6 +139,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
>         struct task_struct *curr_task;
>         int curr_fd = info->fd;
>
> +       cond_resched();
> +

Instead of adding it to every *seq_get_next() it probably should be in
bpf_seq_read().
If cond_resched() is needed in task_file_seq_get_next() it should
probably be after 'again:'.
