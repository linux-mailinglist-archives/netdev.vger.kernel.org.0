Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FC82F474C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbhAMJMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbhAMJMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:12:46 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CF9C061575;
        Wed, 13 Jan 2021 01:12:06 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id k4so1507999ybp.6;
        Wed, 13 Jan 2021 01:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+UISjrL550gfhmvw9AzjdNc0+nCeTUcmhmxQT8jwGJU=;
        b=n8mHVnHZwJxlQMZgjIZo73AWm9QQ84X9tp+JYCWoBkCrdJYNY4bu2DgzJ9ZMKoYWMc
         /OEYICE8Cc1jJKFrcn581XcoIYMs+mVOtsOvRF91IpiKmav6EUzvlJPrOT7ZlZuOu55j
         jsdvUJohWo+zMLyhPrhWCwya5ByBcVvInvGuoBJ3nreFs0toUCICXV55CTMAdiEkZ/6f
         wvE9Uf5TXhMsA5xHwmp1u2qRBtjWZ7u0bJpDzK4HA/8dvczW26QAFsvggtQ0RjO7RUFO
         mehGCJkg9cIRSIzN3eIUVL6nn0XujnPWvNy8URrljvzJE5DbhNxfrMwttUErYBe3iSTE
         Ep9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+UISjrL550gfhmvw9AzjdNc0+nCeTUcmhmxQT8jwGJU=;
        b=pX78VJz4q0Y+MHZZ5mMxXykwmI6eoXGdMhCOA+CEkmpo3Dxa2qXaoYxPOovxhnCp9a
         B21c9h4AOORcDWtWgnMhgwZG7WkZ/IbOz0kW705Oc9pzRn6VqQ84xxVlyE7KpWx4R3ul
         qjFJWsDVa4nTTmLNwNwCMh2Hr8zEY/+du8TqDyElXeL6Azqu1VycB+4eUSQX4sTQdzLq
         Ny7NVBcc2Oh24bHFs3c0J2Z93cPnH+RL+4XhADqclxmGjzRJjsaNPjHeS4pGzbvNl1WQ
         Cg2lN5vqYoSluKZvrGGyBSYfWYKbiD3y+uYKhCVO+3YDtl040giPq7gw0PL1CuW4O5AH
         kafA==
X-Gm-Message-State: AOAM533d03zk4oyH8FQOaH08x81eXsRjCmQiLN7y1VofmYUjukWacMUM
        farptBegkyDm3IB1jYVfEPS/KIvozEIVviWW8Pc=
X-Google-Smtp-Source: ABdhPJxHYJlNJ+tzU0vPiAhQXYN4nl9mQe3E1HlzQ3U/nyC0k0Foq0tAx2at32v+QjlKNlPoaA2Zsbwy00ZVA9dXp78=
X-Received: by 2002:a25:880a:: with SMTP id c10mr1906156ybl.456.1610529125588;
 Wed, 13 Jan 2021 01:12:05 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Wed, 13 Jan 2021 17:11:39 +0800
Message-ID: <CAD-N9QWcdR5oxt2JJrEowPwddyNTZVfU5iSOXNV+cTy2+TKnuQ@mail.gmail.com>
Subject: "KASAN: vmalloc-out-of-bounds Read in bpf_trace_run1/2/3/5" and "BUG:
 unable to handle kernel paging request in bpf_trace_run1/2/3/4" should share
 the same root cause
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        yhs@fb.com, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi developers,

I found the following cases should share the same root cause:

BUG: unable to handle kernel paging request in bpf_trace_run1
BUG: unable to handle kernel paging request in bpf_trace_run2
BUG: unable to handle kernel paging request in bpf_trace_run3
BUG: unable to handle kernel paging request in bpf_trace_run4
KASAN: vmalloc-out-of-bounds Read in bpf_trace_run1
KASAN: vmalloc-out-of-bounds Read in bpf_trace_run2
KASAN: vmalloc-out-of-bounds Read in bpf_trace_run3
KASAN: vmalloc-out-of-bounds Read in bpf_trace_run5

The PoCs after minimization are almost the same except for the
different tracepoint arguments.
And the difference for "bpf_trace_run1/2/3/4/5" is due to the
corresponding tracepoints -
"ext4_mballoc_alloc"/"sys_enter"/"sched_switch"/"ext4_ext_show_extent"/"ext4_journal_start".

The underlying reason for those cases is the allocation failure in the
following trace:

tracepoint_probe_unregister
    tracepoint_remove_func
        func_remove
             allocate_probes
                 kmalloc

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
