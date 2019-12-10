Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1881190C3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLJTfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:35:04 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37062 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfLJTfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:35:02 -0500
Received: by mail-qt1-f194.google.com with SMTP id w47so3897922qtk.4;
        Tue, 10 Dec 2019 11:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxnv/IfMAcklao71nTVes2doWULgYPnxmPQ+kvOKuow=;
        b=jEb5aySLwc+L4cu0C5RkevqiJcUVvNqYuWf6EHmu7d1vqAPnf3uBZrIcUcB4CkZ3Wr
         IobkB7Ca94cfLdZKttCUAT970gLwhMFc98znPhnMycdGTpnCBQ56KcefP/qfW0lEKyeT
         n8B9nD3c4gbnNqV9JGnbMt+uDP2XpxW/Ozp0yhgey8xOm+/5+qT52NvP+304wT+O5tRM
         pB0TnO4SdCor8yjC9jwwnP4YzAejMAK0CWnj82ICE9ycjVc2rusWFwldW53WOwGaKoVE
         rcIXxYIYxr+YM3vkSvvxf6/h/vQLYpuXo8BX8CfFULcUJGP+QYueJfgXNZ0eXakgGV4b
         yOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxnv/IfMAcklao71nTVes2doWULgYPnxmPQ+kvOKuow=;
        b=SO4YnsdwXWGg147g2uAX3h2rs0wzWvCRz0iG+Rv6isYNxJNn3i8eJ4q0LCnXaKLjJF
         T8yd74zhIEjygizf4KM6lE1Ipureiz1sx5y5RzHGGKLrBHbfCUfe1EtvAoBIWmURG4k7
         VLggKCBubuJ3Zuf94NfxM99v+g2AKNgziKlHLFbLKq9mW8h77SRyH6oTkh17dz0qKCCr
         0hJBNpVqBLoAWvG4LMZMce5OB4lPZj+CR8UCLrbgnSR+JFq2uxAWvMpmrcSWAzVaqTSL
         aadqRThVDV4XwfgxchDyME5G7mbLXCybHJeYsOes5rERLcwEdXSxKZ22qcTIbK/zfMa9
         n+IA==
X-Gm-Message-State: APjAAAU45KjyvVq1C/38z2tnBrTCD3hXr7YRzI0Vzu1KLJAtBmYXrLwd
        UA5Ak+RADE/9+z3NprL9h7jMRrZxw0leZ/qDgYs=
X-Google-Smtp-Source: APXvYqxHVWSJFJBDRCUH7/rsvTLEyM0EA0tpyrhp/A43V9aONBglTs2KCKNaNHHmdEkjLagDoUhCtHIhjDlO6OMp3Wc=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr30026197qtq.93.1576006501800;
 Tue, 10 Dec 2019 11:35:01 -0800 (PST)
MIME-Version: 1.0
References: <20191210191933.105321-1-sdf@google.com>
In-Reply-To: <20191210191933.105321-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Dec 2019 11:34:50 -0800
Message-ID: <CAEf4Bzbc9Y7vzETzahvV99tJ6_CcWs+CQ39gJJCqN4JxXXAy2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: switch to offsetofend in BPF_PROG_TEST_RUN
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 11:20 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Switch existing pattern of "offsetof(..., member) + FIELD_SIZEOF(...,
> member)' to "offsetofend(..., member)" which does exactly what
> we need without all the copy-paste.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Awesome!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  net/bpf/test_run.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>

[...]
