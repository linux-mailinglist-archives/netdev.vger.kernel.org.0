Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9151B8331
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 04:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgDYCMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 22:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgDYCMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 22:12:37 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC63BC09B049;
        Fri, 24 Apr 2020 19:12:36 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ep1so5714777qvb.0;
        Fri, 24 Apr 2020 19:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KyUECTsYiJzOr7ZiRM8r6pAEaHqQs/NLjEFCNbGXKJg=;
        b=cdSZhX3BA1GLQjs+fH5Q1dt75sIt9swip8LRzsReCXpzA8fM7FvucNLAXI4W+R3/gQ
         acZJcaFyJSLwlaSjOoyAHC1bb7BvZl2QO0u6bavunGdZSeypvG3XT0Iooi9/afvZZdY4
         ioPcBd8vRBjVL1RDa8pgdGbv3LlSM2my6kPp1cfOx87xq0BhLDJrXpRLapsRp7OsHhya
         tzymJzTaKB/pKmlzaMkJW7X1P39aFlC+w4gn+6/xMOkZeAmQddiwlHFEdVAUZ3Ucozye
         p5au+tdNCWsahj5RGm1xsRidIoO2UD3/vx8PaHjVKICiwGcI138gUQXjtNIXevOPhN44
         q19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KyUECTsYiJzOr7ZiRM8r6pAEaHqQs/NLjEFCNbGXKJg=;
        b=krmvEHME6AfJd96rKUA4/yxci0adJlZUD0SFrCHTdC52y3QZ2w6b2o9dUMKIdziRxk
         sGjOz85LZuoPRpvljl073jB00yF9RDyV5NP2ssX8i9Wjnj1SWGdkQYtccuysbr1Om1A+
         PUOLr024NeSh7JTTXv3/xDpjNVKIXi1jgeoQuwNiQuisurdnGIf3B2k6Kgf2f9fTP6Xp
         4EvyxCSRHn58WQEzzFE4Y6A7wC5c2X811Lxi/4s3g5k0RqkrQKg22aW5PKukg6CpKoWt
         2yQS821fI5ZDbQlL4pAVpA6vI0xV8DprOtu4YQScX6G9rJSgHRBQyuowyKUWXFmpGJQc
         zmag==
X-Gm-Message-State: AGi0PuamewH9vejhT/tEPI0wptMoZkveZx245VUs+/GhndmJqa9jW7Vj
        OqkG1FtM8rwlOAqMQ5jwDCgOa3qaDODeJQT/ZoQ=
X-Google-Smtp-Source: APiQypKrGNxvNUFeMIRZwUvJ/RgIKinJdocbYzHtSHIAkdcjW7/dlzk54KItPU3mRGYSWNuvDwGzkLpPkeR985s3M80=
X-Received: by 2002:a0c:fd8c:: with SMTP id p12mr12389819qvr.163.1587780755745;
 Fri, 24 Apr 2020 19:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200424052045.4002963-1-andriin@fb.com> <CAADnVQJSG1NxydbgM9-YXfhSeKeawwDnfKBemZ_HOL+c7tJGDw@mail.gmail.com>
In-Reply-To: <CAADnVQJSG1NxydbgM9-YXfhSeKeawwDnfKBemZ_HOL+c7tJGDw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 19:12:24 -0700
Message-ID: <CAEf4BzbPpj0FDT1=XRSi7xXVgRH29XYFfLxZhpKvO9DxZg+Kag@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] bpf: fix leak in LINK_UPDATE and enforce empty old_prog_fd
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 5:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 23, 2020 at 10:21 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Fix bug of not putting bpf_link in LINK_UPDATE command.
> > Also enforce zeroed old_prog_fd if no BPF_F_REPLACE flag is specified.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Applied. Thanks

Oops, forgot to include Fixes tag :( If it's not too late, can you please add?

Fixes: 0c991ebc8c69 ("bpf: Implement bpf_prog replacement for an
active bpf_cgroup_link")

Thank you!
