Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB15EF8B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfGCXMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:12:19 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43039 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGCXMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:12:19 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so8843843ios.10;
        Wed, 03 Jul 2019 16:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tGNbCenqk4D5zPNDz4iosj2mBlbruzr36tjE/MopiKE=;
        b=InhklmkSkkK/HA3YoeqF5yr9eQ1NO7z2ilyOf5P/gaLCLxMTz8Ns4r51W6rd+Bb1oh
         X8s12BziS/vNRlPWY9w9ORQ6CxmNsWbVb3YDj5wQpDL4zlXKVVxClyg2tLbBDYL9mVBf
         JtahYYgGjZrBCfKRgS0dn0+qzi+DbJ4bTEE9ZrLFWSc9u1K1pfGeXhxgPIqotR7OpYbE
         rBu2VKV5NzndICCNGI0IyRIOSCQttUF7xDyijcHtwbdP00ODnvAjHdIv+vtpRWZSZmJF
         xfT8htS0Zjtn2nlIRJTLMINrt8pUuFTWiZaxZY8H5R8KBkz2HbMpry27I9zlOkrg1FUg
         Jk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tGNbCenqk4D5zPNDz4iosj2mBlbruzr36tjE/MopiKE=;
        b=Tgv6+MNzxfVQtuPvv0dUieKqJmpDCuQ3hoYmdeGeUP4Zb0j6hxPL3HkFcJLdn0qxzV
         4e8easNiMa54UZMFhuOOpC6t94WKoFZbUwD+G6XQm7ymvPYx4NgmGuSLv8Rwe1zlgrRF
         edr+HvS8qnpD5rirdalfZg6qvvoufQW9WaEmc3nHzmIdweigsOvO860b64sLoLJKzrSz
         GTEHRnfPgHEk2wi5di1fBgWftGWzrdZqZAO/2nxhfEBrfucnQPqN0usBUGskCxRQZjEI
         EICMyr79HmuiRQQfOnkhy3itO0Bh4vWPSYcrWq7ytaMpthMQE0L91H6HQR7CkGaaOBhq
         Az/A==
X-Gm-Message-State: APjAAAVglfxmT9T5FhJyZAgyLW5+YPmdPKZ2RvQBkKS8SS76NLNhTv2r
        MH6ZjxSepHetvrnQIMTZYzLCHNxKnr4fS/03b7KytkV/
X-Google-Smtp-Source: APXvYqy/teLPZRHiadfrPE9fYCBZuHxM5iCaXq/z84d1D81XGh602Cl9ZJ/1ZIsUE4RIf5t9TokOVV1I78lFKGCBOsw=
X-Received: by 2002:a05:6638:81:: with SMTP id v1mr15308520jao.72.1562195538412;
 Wed, 03 Jul 2019 16:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190703160346.63982-1-iii@linux.ibm.com>
In-Reply-To: <20190703160346.63982-1-iii@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 3 Jul 2019 16:11:42 -0700
Message-ID: <CAH3MdRWXcGVeo30KDy6r3s-cxFB69SJ3mFh5Ds1CiGthVP4Lzw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix "alu with different scalars
 1" on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 9:06 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> BPF_LDX_MEM is used to load the least significant byte of the retrieved
> test_val.index, however, on big-endian machines it ends up retrieving
> the most significant byte.
>
> Use the correct least significant byte offset on big-endian machines.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> index c3de1a2c9dc5..3b221bb4b317 100644
> --- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> +++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> @@ -183,7 +183,11 @@
>         BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>         BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
>         BPF_EXIT_INSN(),
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
>         BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
> +#else
> +       BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, sizeof(int) - 1),
> +#endif
>         BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 3),
>         BPF_MOV64_IMM(BPF_REG_2, 0),
>         BPF_MOV64_IMM(BPF_REG_3, 0x100000),
> --
> 2.21.0
>

In verifier directory, we mostly use __BYTE_ORDER macros.

-bash-4.4$ pwd
/home/yhs/work/net-next/tools/testing/selftests/bpf/verifier
-bash-4.4$ grep __BYTE_ORDER *
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
ctx_skb.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
lwt.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
perf_event_sample_period.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
perf_event_sample_period.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
perf_event_sample_period.c:#if __BYTE_ORDER == __LITTLE_ENDIAN
-bash-4.4$

Your code above should also work (it requires gcc 4.6 and later, but
we require newer gcc compiler anyway).
Maybe if the above __BYTE_ORDER works for s360, maybe using that is
better for consistency?
