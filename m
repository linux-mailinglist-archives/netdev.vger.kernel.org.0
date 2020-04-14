Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7671A866C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437025AbgDNQ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407464AbgDNQ6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 12:58:02 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6307BC061A0E
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 09:58:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j3so117935ljg.8
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 09:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0viW9YB2dtX1WFqr7/sv/V0TJY5h+rs1sQFV1oQL6a4=;
        b=r58yveeuQAUdnh0yL94oGE4VBBI+d+OmySg7qmWsSY614k9iQuU+jDxc3ZLBWJR3XW
         9rycIrSgJnSIZ7V5TmxhHoSBBeDMN7AefXUPh9Z4peDkpq99hZdvAQTXzqA0SHT4qjIr
         8eb+xH+qJqjtAxzIbT5nLRkdFrwpKkDK8Y/FGqICntC7gjUyYG4URWKFC/h15UsvPYv/
         qKhwhri1riV4AK1wEXxL0ij3Vpos1hjs4Pr3JDrPxGG/gmav9jZkHDgsMPN9q7whg0e5
         y5dtF3ZsiJVoxww7lF3dDsx2IGK92rJflLt+fAn043kXFvfpNMcyjhA7CTM6GVzBLViw
         jrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0viW9YB2dtX1WFqr7/sv/V0TJY5h+rs1sQFV1oQL6a4=;
        b=KAFlMrG1Y2HiovASDlK/PISPYo3Xe5fnzGdHZLJU28KzapOV15IQvAj0M8o+sle47f
         cX5BUFo0msmBftmgNlv6dXHS3fX6iBm8Snnv7xNX/z/UVJ6k85QpzS3Eg6uyT6ucQZd0
         06HflKRm6JdzhNdLkXcPbS83MoGqu/SgUyBUnt8WMyEsrVQDXGd7Kp6vTTiy8Cw0s97r
         BXGCoC+J8T/4X9FXTLztD2H1g2DatniY3c6XY6faQe3Wj1K8TE9Y0pwzBgX44UTvK9i4
         NznomBK753jsUFH5rsUFjXHLZ9ErxDGhbZMqr7Q+/2Bg4rN0oDRCzlYo/now2KsHNJuM
         beWQ==
X-Gm-Message-State: AGi0PuZS8kItTbxSsruTf8ClE7k4Q3uzuwBEAdQr2k5iyYKyDNigeUOY
        KLYuaVjZjv8KjY27SfHm1Qx2wNODzCaaslH4aGH/hW/Z
X-Google-Smtp-Source: APiQypK8VEKvTggWzkcETqh+Elb0bDoihC6cVEAN7SeWb/ReCEJnaRO5gfxADkKa4tYkq0YjPaK8fMym2Be/qeUweNI=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr671557lji.73.1586883480555;
 Tue, 14 Apr 2020 09:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200410202613.3679837-1-andriin@fb.com>
In-Reply-To: <20200410202613.3679837-1-andriin@fb.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 14 Apr 2020 18:57:34 +0200
Message-ID: <CAG48ez1xuZyOLVkxsjburqjf3Tm4TR8X6pnavUf=pm_woAxLkw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/2] bpf: prevent re-mmap()'ing BPF map as writable
 for initially r/o mapping
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

On Fri, Apr 10, 2020 at 10:26 PM Andrii Nakryiko <andriin@fb.com> wrote:
> VM_MAYWRITE flag during initial memory mapping determines if already mmap()'ed
> pages can be later remapped as writable ones through mprotect() call. To
> prevent user application to rewrite contents of memory-mapped as read-only and
> subsequently frozen BPF map, remove VM_MAYWRITE flag completely on initially
> read-only mapping.
>
> Alternatively, we could treat any memory-mapping on unfrozen map as writable
> and bump writecnt instead. But there is little legitimate reason to map
> BPF map as read-only and then re-mmap() it as writable through mprotect(),
> instead of just mmap()'ing it as read/write from the very beginning.
>
> Also, at the suggestion of Jann Horn, drop unnecessary refcounting in mmap
> operations. We can just rely on VMA holding reference to BPF map's file
> properly.
>
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Jann Horn <jannh@google.com>

(in the sense that I think this patch is good and correct, but does
not fix the entire problem in the bigger picture)
