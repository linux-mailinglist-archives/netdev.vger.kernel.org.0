Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700E3127066
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfLSWIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:08:00 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39743 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfLSWIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:08:00 -0500
Received: by mail-lf1-f66.google.com with SMTP id y1so5447961lfb.6
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 14:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hR7F4YhutqO0BJIosz2jHvA6soOJCJY1vQLjY2X2/O8=;
        b=A0E8qgFtXIcXW/s4/ZRN1pdA2Rt/Qx2LrX6pMJ2FWSEA0rFfuE2nMr9XgT8pK0cCj3
         uSMJVigsqKDHbIWpHp3E3zZ0mk4UhIo+P3RBi1qfizMP1cuLIV5kGyiyLMESfdsrlbSP
         AT6RaxQBVSqO2xcOfcJgIo/Ui86hHaBO9Jz52Do8mB4SDbLm54VTxiBuZgiFP9rnpUmR
         g7uJqKLKnZCuzB4Oq3EZa//6Zs792+UJzPvJvL4vqaTJ0zIboRbVVb3KHTSWA/w0/JUL
         GyRcrZJUU3I6ANnaFv2r/kFt8P2of6noKw0AJAizbHkld69sJb/iJPma6l4C31VKC3gY
         BjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hR7F4YhutqO0BJIosz2jHvA6soOJCJY1vQLjY2X2/O8=;
        b=SUYANogfHXzrGzaqio89x2VJCC/8OfaSPGoKLnZPTnDxgQf7EYZJ9yt9JMxbg9u3vp
         8sVpeK0REgzOerw0mDb50M78tSOVmR3ZeIplCSJ9wAovctIEE+woztIA66GvGLqvHNTQ
         u3dphP4w3oEUCADoQF0E13ZJmZCoHHPNmhn5g7uHeMwxMJ+CvdKIwV0dNtI4QHKrRpnG
         s9eqSd+4mffzwobyceGRPd0y54As492m4L8/D7/woiIlcs8rFoYqvQSFs605hKqh0U6+
         Jk8r9PiIpScTduOWAn4D2KtPUqgh67r/g8vxaTpkCnDkEuutmZWZIbY3Aewk77TK3cLc
         oeNg==
X-Gm-Message-State: APjAAAWz1qGTNGZC3P90GVEVfUI6jdxpJhlBGeTcdEP56n8dqg1HTkiN
        5XMFXAYd2NeXdad04nq6aA93Pb7qmVTsq0GNpNQ=
X-Google-Smtp-Source: APXvYqzgPbqhjgmpsMNrQQnGSJbfZhyld6Q42FWEF8ncXBlQb9cKi8xm4TJCQs7kAftmD16OQANzKRF82TNlXyPR6wE=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr6951656lfc.6.1576793278165;
 Thu, 19 Dec 2019 14:07:58 -0800 (PST)
MIME-Version: 1.0
References: <20191219201601.7378-1-aforster@cloudflare.com>
In-Reply-To: <20191219201601.7378-1-aforster@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 19 Dec 2019 14:07:46 -0800
Message-ID: <CAADnVQLrsgGzVcBea68gf+yZ2R-iYzCJupE6jzaqR5ctbCKxNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix AF_XDP helper program to support
 kernels without the JMP32 eBPF instruction class
To:     Alex Forster <aforster@cloudflare.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 12:16 PM Alex Forster <aforster@cloudflare.com> wro=
te:
>
> Kernel 5.1 introduced support for the JMP32 eBPF instruction class, and c=
ommit d7d962a modified the libbpf AF_XDP helper program to use the BPF_JMP3=
2_IMM instruction. For those on earlier kernels, attempting to load the hel=
per program now results in the verifier failing with "unknown opcode 66". T=
his change replaces the usage of BPF_JMP32_IMM with BPF_JMP_IMM for compati=
bility with pre-5.1 kernels.

I though af_xdp landed after jmp32 ?
