Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B29CF0A1
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfJHBpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:45:45 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46717 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfJHBpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 21:45:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id t8so10619008lfc.13;
        Mon, 07 Oct 2019 18:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0T5z5Aam+qq3J75OoFPjVz49j0SYnEU25DCwL/obILg=;
        b=ATm1SdrmtsgPUBtY7LXd/VjkTI6ppvr00Ojdi7hU0aqJpVpDSF1Fzpgb8PYMMxnD9f
         M8OacHjbzJKpUg/VxsOBf2WjRYkQm8YPvKKIZoTmqjFybpcoYdy0mdaIi5x+66SIFvGm
         AgvXRPE4Bd7cQI8eLn2+o0S77Ag0ggSJVqwGq7pBQJKDMh7nWt6qdIHzwm313rrhB5Kd
         svCFLyGJ6AgTL4zEtyCST6MaoGx5t0enI0vM7j6JGqAskbV5jj1LM8Co/u49uhsoPRlI
         awtQXpyQULmGVlmx/HrySlmQ3vaFI0FaLEXJmIQoML8VlOqdm62SRRuWubSQ+rQU7T/z
         hgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0T5z5Aam+qq3J75OoFPjVz49j0SYnEU25DCwL/obILg=;
        b=CRNDgVSdoz/WfJXNthDFOXHErkO3bNfGDLV5hENBt7JlTIjs3F4KeXYMh138udgslF
         MNXhDPXUoP360cpx5Y3f5jx9e0UvoaB5QVZ7SXp1wujtME7IF39f31vE+AXLhdXArdS1
         lXbxqJQgcMM4C5X22LepR9mP8XfwtaQqgPG2zMx661fDx5GppWEyHFNRQlHmROK5XBV0
         vJ0/bXSKjYyAT2lVsYbZB2IOZt1gWas+DG7tdpfjA+cITAiuKgHZedNHtCToux+o7JEl
         hUaH4GYAHqkmtNueoWjyZLFo9EUiGhM2+J1yYvL/pxnOwxrKV1+7Se3zFfsHTYn09IlO
         M0AA==
X-Gm-Message-State: APjAAAWNDQZWuXx+CPW+GqAEBdPpC6GEYq85JIQOCiF4SGM7m1X4jC/+
        IQ6VmhXJh6OLcxzVY675VGCYfNryfVUYeJrH9Wg=
X-Google-Smtp-Source: APXvYqyJCZflbLqq7aS1W3C1mUa17ol7ChqxkXnyPANbrsadmEBYyA3VfXVZjcBWNGiB17USOWM9ZZjVEN+0AvU4Cfk=
X-Received: by 2002:ac2:4114:: with SMTP id b20mr2967816lfi.19.1570499143034;
 Mon, 07 Oct 2019 18:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191007225604.2006146-1-andriin@fb.com>
In-Reply-To: <20191007225604.2006146-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Oct 2019 18:45:30 -0700
Message-ID: <CAADnVQKnbzC9AL1LGUPSX=bb=6ceO51TCUSVUSNV+JnEQ+BuUg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpftool: fix bpftool build by switching to bpf_object__open_file()
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 3:58 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> As part of libbpf in 5e61f2707029 ("libbpf: stop enforcing kern_version,
> populate it for users") non-LIBBPF_API __bpf_object__open_xattr() API
> was removed from libbpf.h header. This broke bpftool, which relied on
> that function. This patch fixes the build by switching to newly added
> bpf_object__open_file() which provides the same capabilities, but is
> official and future-proof API.
>
> v1->v2:
> - fix prog_type shadowing (Stanislav).
>
> Fixes: 5e61f2707029 ("libbpf: stop enforcing kern_version, populate it for users")
> Reported-by: Stanislav Fomichev <sdf@google.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
