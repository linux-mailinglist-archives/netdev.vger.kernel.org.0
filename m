Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE64CB084
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfJCUw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:52:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36170 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfJCUw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:52:26 -0400
Received: by mail-qt1-f194.google.com with SMTP id o12so5609171qtf.3;
        Thu, 03 Oct 2019 13:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fd92yCGjcK8Q9vbQjHTIvNq1EPtzw5PFxZpME5UvlKc=;
        b=jv0u/kP1kYnE3p1bQFj8W5PnzbxjxEdOcfHiMWUIgzj9NeaWD0QvucgMPJTIjUiDfX
         Yz33koSB4JoEUcpTfU/pKw1NIN6QVlnxWIr/+NtTQ3ZbW+dSKC+IIrL1H63v/qx0RVVJ
         YJE21hl4SbOuPqv4moDqgjtSopd8XakZ1JYMbGfQm0lal1lb67ubtQR2+t8VCsj4wnEt
         KFLpIJJZayZwaRjt4vFd7GURK37gatmNVqGhxHogG46auKD/kmZumMvHZg41QZRzp/sV
         SpDnVVaaEGPWphLDC+Yxubdocxr3buLmE6kOYnsWULa/IyP/GfG8ScauweEmX9zRlTjx
         MqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fd92yCGjcK8Q9vbQjHTIvNq1EPtzw5PFxZpME5UvlKc=;
        b=t1f76omWIXPd2zFGyjpS1w8dq0hDMBPzJjBkY1UbztPA3Ey50g87+Ibmfnp8cDvDRt
         ATwdZMycncwrELMK7QEPFI7BAxw0GUR/+wvw9TpqVaqTdwrC1KzAA+WRP++bAVVwcR0k
         OiNIhkAcTNwVVxVwZ+j30RdFCpvbMItPCQmXyAQKCOaJgNe977BGgX6WWX1Tp8lAKeRF
         qxcLQ0U/kZ9z3kvmLIbLicKgqqbbQOitlLuSKAKNhBI+g6MplDbvl5Ni7EGyIlMF0xis
         GN2g1vLKcfOWyNAhMlPklrmME3+VIct3mOvt7h1ILQCo5JO2TzbtkPobKIfSGdZ0PZUK
         wGPA==
X-Gm-Message-State: APjAAAVd5Xn7L77iRHcQ+g3H1foZ/6DUa1JWMkzzNA6tq3xhRk9ow4Ts
        sFJpvnOatNizZ1Scc+nzC3ktIfvwRqfy4pn4Ryo=
X-Google-Smtp-Source: APXvYqxkv8rerDFWmbferqiZ2NDV+sLIi1PoseuP0HFJ9xlnB0nxFAs/FkN6WkNd6Gkur5s1Iy8OBbho4cCA4VMX9wI=
X-Received: by 2002:ac8:37cb:: with SMTP id e11mr12491917qtc.22.1570135945995;
 Thu, 03 Oct 2019 13:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20191002234512.25902-1-daniel@iogearbox.net>
In-Reply-To: <20191002234512.25902-1-daniel@iogearbox.net>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:52:14 -0700
Message-ID: <CAPhsuW6==Ukxjh69SVLusC=GMf=65Y2T0gLNig55obwbS-7VqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, x86: Small optimization in comparing
 against imm0
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 5:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Replace 'cmp reg, 0' with 'test reg, reg' for comparisons against
> zero. Saves 1 byte of instruction encoding per occurrence. The flag
> results of test 'reg, reg' are identical to 'cmp reg, 0' in all
> cases except for AF which we don't use/care about. In terms of
> macro-fusibility in combination with a subsequent conditional jump
> instruction, both have the same properties for the jumps used in
> the JIT translation. For example, same JITed Cilium program can
> shrink a bit from e.g. 12,455 to 12,317 bytes as tests with 0 are
> used quite frequently.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Acked-by: Song Liu <songliubraving@fb.com>
