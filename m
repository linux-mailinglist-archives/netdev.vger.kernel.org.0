Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B47E7EDC
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 04:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfJ2D1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 23:27:23 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44385 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfJ2D1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 23:27:23 -0400
Received: by mail-lf1-f65.google.com with SMTP id v4so5960187lfd.11;
        Mon, 28 Oct 2019 20:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fRT58ADovXG1ZWMqpYAZ5DZDhgM6jsnS7oCs8Ms26/I=;
        b=MMSIUGEEqKcCoAIubIMgjGaRz1zCC7LZa3WmwbnF19eF0Yb+S9aNya9dWRJh5yh7LP
         WB6hjI+Ob1nPkaO9dz+M054/gaC76z9xb7xKy3HB2Rz68tgnowwIteGzgD6nGd0QlQRd
         rvY5bjBtk5qsKhhavgsOs7DpA4LilPiJw12aldCBLoZnuCkpLMxnHcEBXj7plm3Hz+z9
         YDGMQtXBUzbxkkvl/hQR/tNzG4c6EsZLqzUoekD0bWKhOI3sb2Qet5/J7fAi5S7gdOhr
         Ik78U9fuD70UmZE1iD9FVjPRVYco2y6+FBctlGwp/NTEq5T9KRbt2uS6YxL2JwDq8bxe
         NmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fRT58ADovXG1ZWMqpYAZ5DZDhgM6jsnS7oCs8Ms26/I=;
        b=nD4TTqE057Oko5sIiqREs4JvIKWXUof6le8b9aPGUJsI6PafsqUcPfIqVh8WY0vQgZ
         m/EaofrMnTY0pTuGXV8Hh9sa2bZwwkmV9pYW1VA82maAUx4mDZrOKSay5vmQYZ3fNiT8
         9FAcjV7SwC9vKUJe17krd9VZyPwztLl2/HvNQ39Lqt9fnflbwfkBVyQDmuIJR+jrd2A+
         eFjgIpEmIth8UHuQNYROwRq2WV0sxU4RHj86uXMe7nWvhXzEdRssQKfkAwR2TuOJIv6k
         LQmo7ydxOvsS/7802b4xo51fJNc9VbCc1+Hq6ojp73Fttum1j0qdB34xOxDZtdsOPyc3
         o42A==
X-Gm-Message-State: APjAAAVgdCBTvmdNc/qVh6YxU0jPV9JARzcVAjEJY7muKg0W6PX3EUjG
        mECrR4IkncK3CgOozg+l2ltCvga5sDFTOwiAYn8=
X-Google-Smtp-Source: APXvYqxsy4IXL3cahH/iBgrux0wUQOjfLPCYAJZaXG0qNpCMGC3fGQRqMr44/vSZ4RuSrRMb37pC96oN+qaPn/ebG+c=
X-Received: by 2002:a19:4848:: with SMTP id v69mr625755lfa.6.1572319641228;
 Mon, 28 Oct 2019 20:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 28 Oct 2019 20:27:09 -0700
Message-ID: <CAADnVQJ7je1J_u9xpHHHLWJBgnSbY+y2jz4wX0+ux88oAToRCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 2:17 AM Magnus Karlsson
<magnus.karlsson@intel.com> wrote:
>
> When the need_wakeup flag was added to AF_XDP, the format of the
> XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> kernel to take care of compatibility issues arrising from running
> applications using any of the two formats. However, libbpf was
> not extended to take care of the case when the application/libbpf
> uses the new format but the kernel only supports the old
> format. This patch adds support in libbpf for parsing the old
> format, before the need_wakeup flag was added, and emulating a
> set of static need_wakeup flags that will always work for the
> application.
>
> v2 -> v3:
> * Incorporated code improvements suggested by Jonathan Lemon
>
> v1 -> v2:
> * Rebased to bpf-next
> * Rewrote the code as the previous version made you blind
>
> Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> Reported-by: Eloy Degen <degeneloy@gmail.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied. Thanks
