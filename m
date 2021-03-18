Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAC23401E9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 10:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCRJWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 05:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhCRJWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 05:22:36 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743F1C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 02:22:36 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id f145so1814401ybg.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 02:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nzXE+/KwH4fPuwoOWXmhq2loL1OnU6sJlBVpnf3MUI0=;
        b=pjNtXlGAkDSiggfyX3An6Xq5D9lynOf/rf4L1b9sV3K+s6KA31uWDYJMIaQYtZa/kv
         guTEy5ZXR02wdhAr3YZOMhj7itrbwKM6/ek0RWhn25+/9lM+ipGAM/VCcv1VmRSkyh3/
         VALxaSPuX4yKRGEE/yk+pUaoTQfBfRZYUZtV26/2DvtD5l9NALle947QkVNvY5qtWrDG
         XD/FqAkRNyWLMIuekIvtuXNlgUWLRj+nr84tONe/+UTDjVMRAxGm/h40XPTcENvvviMG
         U6p+7HTxdl7QWwRr53/4ogB+kn+ZuAcOdQoW8zW45lMJ22kOdfKUZ6U+mfSf1nG0tKFd
         gSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nzXE+/KwH4fPuwoOWXmhq2loL1OnU6sJlBVpnf3MUI0=;
        b=iVIKTPp61fiIkXPheNizBLk+c3ZbZCxn8i14hqcAWPD4iRsK/5RtE8Ci7v1xxfXeLd
         sDG1zt/Vx+MIz4/qdnp8u0IP5lqybBRMKzgurli8xZtgUJKRhqhw8MY6X9P6mU4yPz9w
         /feekeoSCCNbcaJypUDb9cBpqICVNU8t2+Q7SPplLuQ/gCzIHhScNuk+ufK1cnGdPSnE
         NsC8JXZy2CUoPPuha9CWS3gloRID3nM/EkT88Lhj1KiO5kL5yhDOGbQud+wQ6U3CUurR
         nmwBKbAna2o8eKnACKltU/nuOwMeQnGOJysnh8xZi+BUgsETgjxSWHiiks0nvEQnVXVO
         TZHQ==
X-Gm-Message-State: AOAM532MRy0hBExYCUuLF33030Nk/QjNXtD0gWwUCuCaGLkkdm1gRYTw
        YJ7lE+4rm1L0ArNDE82qPzQBJ5yO8l3KlrjkCovle0w5HsEjfA==
X-Google-Smtp-Source: ABdhPJxRoBlBip+yB5qXLd4MawvnqToJEGN+O6QMGoUUkj2YzTb5aqZuV5oK8umtqveFZcFcHLXj74BqPTuCe8esu98=
X-Received: by 2002:a5b:78f:: with SMTP id b15mr10030933ybq.234.1616059355371;
 Thu, 18 Mar 2021 02:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210318080450.38893-1-ljp@linux.ibm.com>
In-Reply-To: <20210318080450.38893-1-ljp@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 18 Mar 2021 10:22:23 +0100
Message-ID: <CANn89iK-AQeDvdV-FSjqA6QPm=tSUJTqMZ2z8D1Dw401n-xPYg@mail.gmail.com>
Subject: Re: [PATCH net] net: core: avoid napi_disable to cause deadlock
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, tlfalcon@linux.ibm.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        shemminger@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 9:04 AM Lijun Pan <ljp@linux.ibm.com> wrote:
>
> There are chances that napi_disable is called twice by NIC driver.


???

Please fix the buggy driver, or explain why it can not be fixed.


> This could generate deadlock. For example,
> the first napi_disable will spin until NAPI_STATE_SCHED is cleared
> by napi_complete_done, then set it again.
> When napi_disable is called the second time, it will loop infinitely
> because no dev->poll will be running to clear NAPI_STATE_SCHED.
>
> CPU0                            CPU1
>  napi_disable
>   test_and_set_bit
>   (napi_complete_done clears
>    NAPI_STATE_SCHED, ret 0,
>    and set NAPI_STATE_SCHED)
>                                 napi_disable
>                                  test_and_set_bit
>                                  (ret 1 and loop infinitely because
>                                   no napi instance is scheduled to
>                                   clear NAPI_STATE_SCHED bit)
>
> Checking the napi state bit to make sure if napi is already disabled,
> exit the call early enough to avoid spinning infinitely.
>
> Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
>  net/core/dev.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
