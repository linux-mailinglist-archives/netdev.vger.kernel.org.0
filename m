Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B62DE016
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 09:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733092AbgLRItg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 03:49:36 -0500
Received: from gofer.mess.org ([88.97.38.141]:44631 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732841AbgLRItb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 03:49:31 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id C7FA6C6357; Fri, 18 Dec 2020 08:48:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1608281324; bh=CIzQrAxB7jgM7leCH+INznRjBjqtpr1Q5eX8IU853Gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+foaB8HTf0USnft7LqxYZA0Z5Iy4qGqYKAUqCLKH7zIZqPaJFdeYOwfT7WaMja4g
         DPdNXrfQHnGINeG3HViP1H+XaUAx9+yV/P8F7IQX9xF/rnU/FclrKt0YTptn87RRPK
         X7WiQG+hSa8B+2HGHkpE9FrW8B6PuZXQyWeNgXXm79FVDXFV5i1qLKjsLZnwjzuOe7
         xZNZlCgAHUoD5jFdPZgI9Hzb1NoXdnHG5MtYCszSeD3Am2BbxNPd4HJ7NJNSPS/GYQ
         9OlScxKHMScuJWBcYcJfy7+O66Jr29bi+bLMC8T7Y/SKkQH6KUmiqpekgvVmPVZiJI
         IMarfEcNWnM/A==
Date:   Fri, 18 Dec 2020 08:48:44 +0000
From:   Sean Young <sean@mess.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] btf: support ints larger than 128 bits
Message-ID: <20201218084844.GA28455@gofer.mess.org>
References: <20201217150102.GA13532@gofer.mess.org>
 <1e9594be-c21d-88d2-e3bf-0b8e3e991aa1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e9594be-c21d-88d2-e3bf-0b8e3e991aa1@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong,

Thank you for the detailed review.

On Thu, Dec 17, 2020 at 06:12:11PM -0800, Yonghong Song wrote:
> On 12/17/20 7:01 AM, Sean Young wrote:
> > clang supports arbitrary length ints using the _ExtInt extension. This
> > can be useful to hold very large values, e.g. 256 bit or 512 bit types.
> > 
> > Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> > case for these.
> > 
> > This requires the _ExtInt extension to enabled for BPF in clang, which
> > is under review.
> > 
> > Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> > Link: https://reviews.llvm.org/D93103
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >   Documentation/bpf/btf.rst      |  4 ++--
> >   include/uapi/linux/btf.h       |  2 +-
> >   tools/bpf/bpftool/btf_dumper.c | 39 ++++++++++++++++++++++++++++++++++
> >   tools/include/uapi/linux/btf.h |  2 +-
> >   4 files changed, 43 insertions(+), 4 deletions(-)
> 
> Thanks for the patch. But the change is not enough and no tests in the patch
> set.
> 
> For example, in kernel/bpf/btf.c, we BITS_PER_U128 to guard in various
> places where the number of integer bits must be <= 128 bits which is
> what we supported now. In function btf_type_int_is_regular(), # of int
> bits larger than 128 considered false. The extint like 256/512bits should be
> also regular int.

Right, thanks for spotting that. I'll give the next version some better
testing.

> extint permits non-power-of-2 bits (e.g., 192bits), to support them
> may not be necessary and this is not your use case. what do you think?

My feeling is that non-power-of-2 types are useful for llvm targets
which such registers. I'm not sure they have much use for our use case
or bpf in general. If anyone thinks otherwise I'm easily convinced.

> lib/bpf/btf.c btf__and_int() function also has the following check,
> 
>         /* byte_sz must be power of 2 */
>         if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 16)
>                 return -EINVAL;
> 
> So Extint 256 bits will fail here.

Indeed it will.

> Please do add some selftests tools/testing/selftests/bpf
> directories:
>    - to ensure btf with newly supported int types loaded successfully
>      in kernel
>    - to ensure bpftool map [pretty] print working fine with new types
>    - to ensure kernel map pretty print works fine
>      (tests at tools/testing/selftests/bpf/prog_tests/btf.c)
>    - to ensure btf manipulation APIs works with new types.

Absolutely. I'll send out a v2 when ready.

Thanks again for the great review.

Sean

> 
> > 
> > diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
> > index 44dc789de2b4..784f1743dbc7 100644
> > --- a/Documentation/bpf/btf.rst
> > +++ b/Documentation/bpf/btf.rst
> > @@ -132,7 +132,7 @@ The following sections detail encoding of each kind.
> >     #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
> >     #define BTF_INT_OFFSET(VAL)     (((VAL) & 0x00ff0000) >> 16)
> > -  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000000ff)
> > +  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000003ff)
> >   The ``BTF_INT_ENCODING`` has the following attributes::
> > @@ -147,7 +147,7 @@ pretty print. At most one encoding can be specified for the int type.
> >   The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
> >   type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
> >   The ``btf_type.size * 8`` must be equal to or greater than ``BTF_INT_BITS()``
> > -for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
> > +for the type. The maximum value of ``BTF_INT_BITS()`` is 512.
> >   The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
> >   for this int. For example, a bitfield struct member has:
> > diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
> > index 5a667107ad2c..1696fd02b302 100644
> > --- a/include/uapi/linux/btf.h
> > +++ b/include/uapi/linux/btf.h
> > @@ -84,7 +84,7 @@ struct btf_type {
> >    */
> >   #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
> >   #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
> > -#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
> > +#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
> >   /* Attributes stored in the BTF_INT_ENCODING */
> >   #define BTF_INT_SIGNED	(1 << 0)
> > diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> > index 0e9310727281..45ed45ea9962 100644
> > --- a/tools/bpf/bpftool/btf_dumper.c
> > +++ b/tools/bpf/bpftool/btf_dumper.c
> > @@ -271,6 +271,40 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
> >   	}
> >   }
> > +static void btf_bigint_print(json_writer_t *jw, const void *data, int nr_bits,
> > +			     bool is_plain_text)
> > +{
> > +	char buf[nr_bits / 4 + 1];
> > +	bool first = true;
> > +	int i;
> > +
> > +#ifdef __BIG_ENDIAN_BITFIELD
> > +	for (i = 0; i < nr_bits / 64; i++) {
> > +#else
> > +	for (i = nr_bits / 64 - 1; i >= 0; i++) {
> > +#endif
> > +		__u64 v = ((__u64 *)data)[i];
> > +
> > +		if (first) {
> > +			if (!v)
> > +				continue;
> > +
> > +			snprintf(buf, sizeof(buf), "%llx", v);
> > +
> > +			first = false;
> > +		} else {
> > +			size_t off = strlen(buf);
> > +
> > +			snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
> > +		}
> > +	}
> > +
> > +	if (is_plain_text)
> > +		jsonw_printf(jw, "0x%s", buf);
> > +	else
> > +		jsonw_printf(jw, "\"0x%s\"", buf);
> > +}
> > +
> >   static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
> >   			     __u16 right_shift_bits)
> >   {
> > @@ -373,6 +407,11 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
> >   		return 0;
> >   	}
> > +	if (nr_bits > 128) {
> > +		btf_bigint_print(jw, data, nr_bits, is_plain_text);
> > +		return 0;
> > +	}
> > +
> >   	if (nr_bits == 128) {
> >   		btf_int128_print(jw, data, is_plain_text);
> >   		return 0;
> [...]
