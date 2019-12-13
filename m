Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C659511EC73
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 22:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLMVEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 16:04:22 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44735 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfLMVEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 16:04:21 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19so123259lji.11;
        Fri, 13 Dec 2019 13:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n3yWfNzbkvRbbDeZJmQEVXV/JdfI39R66ZQaXIjNxB8=;
        b=A2E5ngrfo+Cq5lf1+hmyMOhkOca8jn7tUR3suBaizqDReMperJHPaEdezTqnBswlAk
         Zkn6SoWk5h7eb+4VwlEpQ/eoLVcyvSGAqugOGwQ7UHb91cJYGzDwlgweT7lOlgHEMxHb
         U8LpjkcgGLrh7VDk46wJGBdXr2dPS3yDv8DUnJxBeJH9iv/3i8HTJOpPj4si1tVqohrp
         z+KBRYVFCIbQ3FBChogIRPAvJAbGh8cbMaCKeKgJ+257B+bMiMLv/0JYZJ7gmqJOC4AJ
         +n/XZAkal/TuLZpfBJMLuBRLlXWdHQ+SWm23E8L9QdQfl9RPGGl2vCSfo2mipxQtytEg
         Y7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n3yWfNzbkvRbbDeZJmQEVXV/JdfI39R66ZQaXIjNxB8=;
        b=ICdrsx5cFfw0VvQuvwLEh1qk0ocihgUng6LPmsUBszYq0tGGVeVb9z9URYFMRAFzHI
         ie2cEhZGxM/HL+3B909dLbKjFV/3mMzswpzTZD24YT5PtqcuUXZUCtWDZGRWhe6Fv7zD
         Q1SZFGQ9Nspa2MtxIDbH7RZRFV/i2VzvccQR+S0VkTCz08fhII1fLTqBOml37x5lRgCh
         +XbOZhXn0KO4j+8X6f/9PG7IUfj3aRgSF0fQ1yZjbjIJjKoLhzMqrSR7i7lvSbEOKHzo
         mUgRGsFtGDx9Uk12WdDhEdLsRcnzMRgMHk75e7xa6Rx+BHoiSUj8NovFsffY/QdZZ50w
         UAww==
X-Gm-Message-State: APjAAAV3NC0NUrhm3uvJagmPnKQRkE0mbhhvvS40XoFu18WuvmHo28t4
        biQX3k6ka4YYUq/zbaPjqf8QZeJ16+d5KQcdRC0=
X-Google-Smtp-Source: APXvYqySr3A+VsfA51cIfx5g3b0tFTKTHpRev6b7cJJ0qql29AN6C0EPaPoziewf8ahFfMMqUT50lNXgP4GeBVk2dN8=
X-Received: by 2002:a2e:93c9:: with SMTP id p9mr11034740ljh.136.1576271059297;
 Fri, 13 Dec 2019 13:04:19 -0800 (PST)
MIME-Version: 1.0
References: <20191212013521.1689228-1-andriin@fb.com>
In-Reply-To: <20191212013521.1689228-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 13:04:08 -0800
Message-ID: <CAADnVQJMBbFma+0cGSJXX75=r=5jDK85AxLoqCPUWutf7bmnzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
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

On Wed, Dec 11, 2019 at 5:35 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set fixes perf_buffer__new() behavior on systems which have some of
> the CPUs offline/missing (due to difference between "possible" and "online"
> sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> perf_event only on CPUs present and online at the moment of perf_buffer
> creation. Without this logic, perf_buffer creation has no chances of
> succeeding on such systems, preventing valid and correct BPF applications from
> starting.

Applied. Thanks
