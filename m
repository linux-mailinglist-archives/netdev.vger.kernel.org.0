Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3478817EEE8
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgCJC6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:58:39 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45181 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJC6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:58:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id e18so12393389ljn.12;
        Mon, 09 Mar 2020 19:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8w1avlyjommOVYhWkXy7kWGzZEnGy6jEhoPqNTesssg=;
        b=WbOdnKvAC2us7JRQc/4FjvUZdNbJJt4E5xfxRGzD3HXeasP6KOXJCCNDISopOIWnbX
         +jar2Bb+Mx/DzIjdl2dWPEPQc5c6O5/R3+YSWVCs5Ne98iIVTe/vV1bekpfdWKKdQuZ2
         bV1FNXMAW6jIH872YIq7U/07hl5d9Bw/qyBOezofs5caftNWqeEJCOPr4YdmqKqd1suu
         0NCyuywWL/wVDtkhSGFg9DewQ/7/TwQwgRVJht0wutAcEmkbIPg2UCk1lsC44eZu1/kL
         CZvNdPrJ4K36WHHdZrs3CxxEjnHXX/j98IF2QAqnPXMD9XYelHzjBdth74efVF8fDxsd
         XmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8w1avlyjommOVYhWkXy7kWGzZEnGy6jEhoPqNTesssg=;
        b=if5OyaVAnkJow7kAooNHcBMUTWgFulx0lEQIsx51ksd23A4PfnovHOiAzNS0JySoDo
         7qIonyuRcYDiXhlcNtNGLgSMX7vWokkgHapXnuddutiwWZho2hTX+ATkbqX/MFgAeRo+
         LZlHsprtibNe6isUB1LAG0yHMdG86ChRcMEo/CodVjeWt7ZF1Uw5j6/Uc9HrlJ5/vkSi
         in8295QFCJFVnQVYjXUASkWuSg2MhrWA8ypMv3EEyC7A3Zhg37J8XqoMvZw320h7hb7m
         av8gyYfb34oR7nKTyxjg4kesp+jZPMuVrsL7119FQ1iEWXVK6/RU4Eu4XBNREep8UcnI
         Kj0w==
X-Gm-Message-State: ANhLgQ04M+HoEw0jm4UzmpmVwPfvqjTyPQLT1AGSa4tD3IleaO8S8KiC
        /TTqKg2AUgXejDEkmjTHFVO2m/mLMAOXtLb1ab0=
X-Google-Smtp-Source: ADFU+vsnhdv4550HiroV2JUaNciFZVJrfOjPvjJs0PQaj8yivJLJVh1Sbp/VdU+dkG9jDbGq30rJN/UP3t0Ud3zHLYg=
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr11331442lja.138.1583809116430;
 Mon, 09 Mar 2020 19:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200309222756.1018737-1-andriin@fb.com>
In-Reply-To: <20200309222756.1018737-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 9 Mar 2020 19:58:24 -0700
Message-ID: <CAADnVQ+1tDeyMAS=XwvF58fCAUN0929QGE-NNj-i4m6jjLUw3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: initialize storage pointers to NULL to
 prevent freeing garbage pointer
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 3:28 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Local storage array isn't initialized, so if cgroup storage allocation fails
> for BPF_CGROUP_STORAGE_SHARED, error handling code will attempt to free
> uninitialized pointer for BPF_CGROUP_STORAGE_PERCPI storage type. Avoid this
> by always initializing storage pointers to NULLs.
>
> Fixes: 8bad74f9840f ("bpf: extend cgroup bpf core to allow multiple cgroup storage types")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied to bpf tree and fixed typo in commit log.
