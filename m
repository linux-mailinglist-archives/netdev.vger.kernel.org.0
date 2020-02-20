Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20D41666D2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 20:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgBTTFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 14:05:21 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35150 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbgBTTFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 14:05:21 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so5384696ljb.2;
        Thu, 20 Feb 2020 11:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9raQUjDDhmLv9P7ko9b+c9Z7E107qXdSV56UnvmDfQ=;
        b=rFvcUUrDGcvFDa65GDNyAy26T83xiiD3ab1ytYaVrmtfFSu8YaQ+csr8AWbyD9TyLs
         lguy+6fmt4lug+vTr53Nq0sgG0tyYxpQJaZ7ujn0ChG3oe+kgYczcLZyI5Wfb2Px9K93
         oN6UZ6jh1AX2xN9LTwOi0cbmMPcIEDvw4yQClbgQorzQRUEwEdE7u89dUs+p+i/3p7iY
         27Sr60qP8D/bmX3SuE2rUloK4LN+4chitpBLPdh58FlbG1EnvLatvtDBcEbfDgdu5YT5
         y1kOaefdt2tojRf038PEMT0/rgve7PZryjr1Yz05tssg0pnoowFDeelgkMLxKgJcF/Ae
         S7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9raQUjDDhmLv9P7ko9b+c9Z7E107qXdSV56UnvmDfQ=;
        b=DIOVLfHKgPPcfz/pUSUOjl2uENBfV5mywEavd04tHoRmmYS+SYEFro+XSlffgNXjZ9
         nBOfzIWesF9jl+YzhTGBtD+OtOPgjETUKAtwrJ8SytcsBTSCzd2Fgqi1D7fTzh1DU5WH
         HKiAcQ2UIK8IuLPLTSe/0dL186qMfuvw7bnqICNGTvQwopeRv6CUTAW78s5xTqZGTTI4
         ifiersUl8Q4ZlYsplGDiGq7rjNWoFj6Rz6PB1xniP1UA4qeC/Z8DLnzwFkC4aslPX1qP
         Kt+YanHvqfr666/wqxDTTVmY/JYwVLoR6kt7BSvE1Ap7OTzSSM68x1ANsHYyNmjjHJQ/
         YD5A==
X-Gm-Message-State: APjAAAU6VBOqIezs124ROknAY6Qi7DxRIniEx+lVVySHJ7umWyU+mPLo
        39kSMRtTDbLbmJj9JYi8lwQtIwXd0+RZuJIEEGw=
X-Google-Smtp-Source: APXvYqzR8vtIr8uBPqaGAKGtUEgLts5LL/+NZ+o29/gqGp3vSEQFUktE+us4AJmewsw8Kw0RYFBfyNgqRhTNKn2UHgE=
X-Received: by 2002:a2e:a404:: with SMTP id p4mr20331638ljn.234.1582225518868;
 Thu, 20 Feb 2020 11:05:18 -0800 (PST)
MIME-Version: 1.0
References: <20200220062635.1497872-1-andriin@fb.com>
In-Reply-To: <20200220062635.1497872-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Feb 2020 11:05:07 -0800
Message-ID: <CAADnVQJdONoTQmu8WugEXLsiZOzbb9Kiw-Q9ZVC+pDiSUufTOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: relax check whether BTF is mandatory
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Julia Kartseva <hex@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 10:27 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> If BPF program is using BTF-defined maps, BTF is required only for
> libbpf itself to process map definitions. If after that BTF fails to
> be loaded into kernel (e.g., if it doesn't support BTF at all), this
> shouldn't prevent valid BPF program from loading. Existing
> retry-without-BTF logic for creating maps will succeed to create such
> maps without any problems. So, presence of .maps section shouldn't make
> BTF required for kernel. Update the check accordingly.
>
> Validated by ensuring simple BPF program with BTF-defined maps is still
> loaded on old kernel without BTF support and map is correctly parsed and
> created.
>
> Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
> Reported-by: Julia Kartseva <hex@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
