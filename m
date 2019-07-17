Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259156B5C8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 07:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfGQFJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 01:09:34 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45522 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQFJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 01:09:34 -0400
Received: by mail-io1-f65.google.com with SMTP id g20so43733364ioc.12;
        Tue, 16 Jul 2019 22:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cq1sFiIjH7dg7alnvE7ubXj9bXnCDF0yuMpefZi/u4I=;
        b=NZyYpuSnJbt1eQG7JRRx2U0FHIKhp1mIvE41Aoy5qg+mTQ8ZyJYLkEcu/heZ6zu+yW
         BxRu2lnvi/U1gGTgpvHr+XC8Wz7MMT4BPG0Lgdm30zhddAw5LtlSxcgxr/jn4PoXy8RS
         SZXeBJmk0nMlBY1B1nrrVUWvZTfYSHviTY6lIJyJuc6w167bQTwbbpU6niu2Uzn65VNw
         0rFYqlZNyutgLSbDy0Bk+MZKg0bM5J3IehlmoJSNaENzsUEzD8V6v6XNFzAlakhy1hQ9
         a0fBlj9BKXD27EcvfIQjF7mDvCsTu89+jWiYt/yU7hpz7yRPrhYmIqp3H7aaazAgmFy+
         PYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cq1sFiIjH7dg7alnvE7ubXj9bXnCDF0yuMpefZi/u4I=;
        b=gl08sGGcfgmoKIGI29BXNZmkWpmc09jHnQvWDaHfWWwluGn2BQr/VsQ3p9dS+08GGA
         Up4x9En4UFBjUpl/5umw0/btEBtm0ABhBuCg5bRqanEUZfiz8Weg75CxXLANtq1xW87Z
         vWfINb4vhtQDfzcolXQLWidJ591Kw/OqreJyEEs/xCU22oqxpP4b3KJ2RqYAx5GUi28l
         g3KW0v76Br4SzT9xsnCCoj2LGVdtssVq5PikZ5bvD5PMHVXorxyhvCjRfqf/rxP1p0ev
         DOtBjK5OMe3+0NeUwDP/Ra2W1RC7SwGmVEUAdMExrBW+VwiOg3z9+fjLMg++EQ6ZOylw
         oEEg==
X-Gm-Message-State: APjAAAX9xwmZg0cTVd8nLmYhkEgGPFKRx4vo33eq4RyL99gh+emlybE2
        RLYO7JV5xI/8GlzZ37NQRw6ZfxBEHOWZPt3fwkeK0g==
X-Google-Smtp-Source: APXvYqw7cW/YLAuMtWYo30TXKuYS5k7Db1Xvm+35pIyB1OfzeZ9Ghku8riAH3ixeiQ2exJMyT13DNDZ/o9hQMb6bWTE=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr1966504ioc.97.1563340173212;
 Tue, 16 Jul 2019 22:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190716115910.23093-1-iii@linux.ibm.com>
In-Reply-To: <20190716115910.23093-1-iii@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Tue, 16 Jul 2019 22:08:56 -0700
Message-ID: <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 4:59 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> test_pkt_md_access is failing on s390, since the associated eBPF prog
> returns TC_ACT_SHOT, which in turn happens because loading a part of a
> struct __sk_buff field produces an incorrect result.
>
> The problem is that when verifier emits the code to replace partial load
> of a field with a full load, a shift and a bitwise AND, it assumes that
> the machine is little endian.
>
> Adjust shift count calculation to account for endianness.
>
> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  kernel/bpf/verifier.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5900cbb966b1..3f9353653558 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8616,8 +8616,12 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>                 }
>
>                 if (is_narrower_load && size < target_size) {
> -                       u8 shift = (off & (size_default - 1)) * 8;
> -
> +                       u8 load_off = off & (size_default - 1);
> +#ifdef __LITTLE_ENDIAN
> +                       u8 shift = load_off * 8;
> +#else
> +                       u8 shift = (size_default - (load_off + size)) * 8;
> +#endif

All the values are in register. The shifting operations should be the
same for big endian and little endian, e.g., value 64 >> 2 = 16 when
value "64" is in register. So I did not see a problem here.

Could you elaborate which field access in test_pkt_md_access
caused problem?

It would be good if you can give detailed memory la


>                         if (ctx_field_size <= 4) {
>                                 if (shift)
>                                         insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
> --
> 2.21.0
>
