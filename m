Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D655E7BA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbiF1PLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346886AbiF1PLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:11:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5188E2AC6D;
        Tue, 28 Jun 2022 08:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E125760EAE;
        Tue, 28 Jun 2022 15:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED921C3411D;
        Tue, 28 Jun 2022 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656429110;
        bh=6CRrz5GE3sbPpBNvpOE8bS4r8rF34+JaaCSHcXzLz7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FgGFKKvuIrmCI31odpnLzLZxivYQQycW+SNotiBpZhqhEy592cZmU5RPF8+Cu3/Vg
         qADsWEpad00yrFTBKMUKFU6MfFf7XZErZkBgHBKYlEccfAam9HgzjizQiiO20aTu0Z
         rBy3Wvfv/rz3gkJpniPu55HK43Qraxym3Jo2lOr7I5BrCPlPRR1816zUAB6mVbmKKb
         vjs7FTztRASVm+SJi7LYR0P6EeRHt/5ENUVgrU8NN8xIt+w08l4H2JLnkgum9fUQ4I
         Q2j3vkWTOQCoUZmZEf4bV4sUD1oENLFAypIfj51+DyRqden0TlkTNJYQlDuptQgWb4
         +XGbWFt3Rtr0Q==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 675E24096F; Tue, 28 Jun 2022 12:11:47 -0300 (-03)
Date:   Tue, 28 Jun 2022 12:11:47 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf bpf: 8 byte align bpil data
Message-ID: <YrsaM7q1KDKwfeLp@kernel.org>
References: <20220614014714.1407239-1-irogers@google.com>
 <Yrq4fFtgcpwa2JUu@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yrq4fFtgcpwa2JUu@krava>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jun 28, 2022 at 10:14:52AM +0200, Jiri Olsa escreveu:
> On Mon, Jun 13, 2022 at 06:47:14PM -0700, Ian Rogers wrote:
> > bpil data is accessed assuming 64-bit alignment resulting in undefined
> > behavior as the data is just byte aligned. With an -fsanitize=undefined
> > build the following errors are observed:
> > 
> > $ sudo perf record -a sleep 1
> > util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
> > 0x55f61084520f: note: pointer points here
> >  a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
> >              ^
> > util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
> > 0x55f61084522f: note: pointer points here
> >  ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
> >              ^
> > util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
> > 0x55f61084523f: note: pointer points here
> >  58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00
> > 
> > Correct this by rouding up the data sizes and aligning the pointers.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/bpf-utils.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
> > index e271e05e51bc..80b1d2b3729b 100644
> > --- a/tools/perf/util/bpf-utils.c
> > +++ b/tools/perf/util/bpf-utils.c
> > @@ -149,11 +149,10 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
> >  		count = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
> >  		size  = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
> >  
> > -		data_len += count * size;
> > +		data_len += roundup(count * size, sizeof(__u64));
> >  	}
> >  
> >  	/* step 3: allocate continuous memory */
> > -	data_len = roundup(data_len, sizeof(__u64));
> >  	info_linear = malloc(sizeof(struct perf_bpil) + data_len);
> >  	if (!info_linear)
> >  		return ERR_PTR(-ENOMEM);
> > @@ -180,7 +179,7 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
> >  		bpf_prog_info_set_offset_u64(&info_linear->info,
> >  					     desc->array_offset,
> >  					     ptr_to_u64(ptr));
> > -		ptr += count * size;
> > +		ptr += roundup(count * size, sizeof(__u64));
> 
> this one depends on info_linear->data being alligned(8), right?
> 
> should we make sure it's allways the case like in the patch
> below, or it's superfluous?
> 
> thanks,
> jirka
> 
> 
> ---
> diff --git a/tools/perf/util/bpf-utils.h b/tools/perf/util/bpf-utils.h
> index 86a5055cdfad..1aba76c44116 100644
> --- a/tools/perf/util/bpf-utils.h
> +++ b/tools/perf/util/bpf-utils.h
> @@ -60,7 +60,7 @@ struct perf_bpil {
>  	/* which arrays are included in data */
>  	__u64			arrays;
>  	struct bpf_prog_info	info;
> -	__u8			data[];
> +	__u8			data[] __attribute__((aligned(8)));
>  };
>  
>  struct perf_bpil *

⬢[acme@toolbox perf-urgent]$ pahole -C perf_bpil ~/bin/perf
struct perf_bpil {
	__u32                      info_len;             /*     0     4 */
	__u32                      data_len;             /*     4     4 */
	__u64                      arrays;               /*     8     8 */
	struct bpf_prog_info       info __attribute__((__aligned__(8))); /*    16   224 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 3 boundary (192 bytes) was 48 bytes ago --- */
	__u8                       data[];               /*   240     0 */

	/* size: 240, cachelines: 4, members: 5 */
	/* paddings: 1, sum paddings: 4 */
	/* forced alignments: 1 */
	/* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));
⬢[acme@toolbox perf-urgent]$


Humm, lotsa explicit alignments already?

Looking at the sources:

struct perf_bpil {
        /* size of struct bpf_prog_info, when the tool is compiled */
        __u32                   info_len;
        /* total bytes allocated for data, round up to 8 bytes */
        __u32                   data_len;
        /* which arrays are included in data */
        __u64                   arrays;
        struct bpf_prog_info    info;
        __u8                    data[];
};

Interesting, where is pahole finding those aligned attributes? Ok
'struct bpf_prog_info' in tools/include/uapi/linux/bpf.h has aligned(8)
for the whole struct, so perf_bpil's info gets that.

sp that data right after 'info' is 8 byte alignedas
sizeof(bpf_prog_info) is a multiple of 8 bytes.

So I think I can apply the patch as-is and leave making sure data is
8-byte aligned for later.

Doing that now.

- Arnaldo
