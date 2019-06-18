Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90C4AD71
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfFRVke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:40:34 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38873 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbfFRVkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:40:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id v11so8382519pgl.5;
        Tue, 18 Jun 2019 14:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0CRWiiVSKIjoBp4n/nm8FrP7Qr+0QnYVn1u8kwvPtuE=;
        b=JFXlULSr7TbU+rembrz9PQLQJ3OEnRWpjblJaycr04uNY+LBMbSZh3x3FJFJPU9EcQ
         ZhIj4jkFp2y2qlhkzRvYz7w2Nr40F5GXD0KovoxbT5APZ/t+GIHuf4tv/cIv6oyi6f0Q
         FnzIw5IgDHjctFteCggxPBHGD/hAlkPyp3d1+xIJAy3SvvrVUsVzYwwCFWxGtz/VUJ+7
         RJCuyPyUH7X2dAwL+BWp1qkuEssCSGSeC8pvPIMM5TN8E+gSYsFiTLu8fCVu2vZrnKf4
         q5hInEHii4rzW1lZSjjS2UavYqraGb9hQPhTCgkVzE9tdEnYW6YW/uq5IpX2da6RNycg
         3opA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0CRWiiVSKIjoBp4n/nm8FrP7Qr+0QnYVn1u8kwvPtuE=;
        b=IAfgglfHjEEuFzpHq8zGbxu6l00b8naaFUH4Hs7vn70fDva09jBkA1XIZGTPRM3dgT
         AFILeriCh3h5hLrXFEN+E51o5LU2duo18P4zCs93Yek11GGGAKWefKbj34pxylAxDLY9
         +hZeQsoSOImefIvX1BJsmLucPwIE/DrHCtsSnmMXA3GVgQQrSiTSAvDVsQWf0TuhQq7r
         e6kEu9NSksqzSwqBiiGHJlpZk+QqcDg4Y51hJyqkB3F90BWzWUbqdg/JApGi0bRfOGRo
         Fk0wNS6XnouPAwT3F7udDqK4jwEtEFFu8MK8cyXUwuds+Y419vl+Sv8kHJzSpS8EvvQy
         w3dA==
X-Gm-Message-State: APjAAAVJ8MYvY8ukmVms+dGbVF4kH6m/pfrAY4UxeiKCHoASC+QmsE9J
        /C0paeec0jCpvCLaep3SZro=
X-Google-Smtp-Source: APXvYqxIfKOiXsJN0D0lcesu+lBDmW8byLeq8kPQgoJ7u7WPMYWHfl4tcJMxRrJUgdueZFfwh6TPlQ==
X-Received: by 2002:a17:90a:9306:: with SMTP id p6mr7133347pjo.6.1560894032753;
        Tue, 18 Jun 2019 14:40:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:ae73])
        by smtp.gmail.com with ESMTPSA id f3sm2778658pjo.31.2019.06.18.14.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 14:40:31 -0700 (PDT)
Date:   Tue, 18 Jun 2019 14:40:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andreas Steinmetz <ast@domdv.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: eBPF verifier slowness, more than 2 cpu seconds for about 600
 instructions
Message-ID: <20190618214028.y2qzbtonozr5cc7a@ast-mbp.dhcp.thefacebook.com>
References: <f0179a5f61ecd32efcea10ae05eb6aa3a151f791.camel@domdv.de>
 <CAADnVQLmrF579H6-TAdMK8wDM9eUz2rP3F6LmhkSW4yuVKJnPg@mail.gmail.com>
 <e9f7226d1066cb0e86b60ad3d84cf7908f12a1cc.camel@domdv.de>
 <CAADnVQKJr-=gZM2hAG-Zi3WA3oxSU_S6Nh54qG+z6Bi8m2e3PA@mail.gmail.com>
 <9917583f188315a5e6f961146c65b3d8371cc05e.camel@domdv.de>
 <CAADnVQKe7RYNJXRQYuu4O_rL0YpAHe-ZrWPDL9gq_mRa6dkxMg@mail.gmail.com>
 <CAADnVQ+wEdHKR2zR+E6vNQV_J8gfBmReYsLUQ2tegpX8ZFO=2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+wEdHKR2zR+E6vNQV_J8gfBmReYsLUQ2tegpX8ZFO=2A@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:26:28AM -0700, Alexei Starovoitov wrote:
> On Sun, Jun 16, 2019 at 11:59 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jun 6, 2019 at 6:31 PM Andreas Steinmetz <ast@domdv.de> wrote:
> > >
> > > Below is the source in question. It may look a bit strange but I
> > > had to extract it from the project and preset parameters to fixed
> > > values.
> > > It takes from 2.8 to 4.5 seconds to load, depending on the processor.
> > > Just compile and run the code below.
> >
> > Thanks for the report.
> > It's interesting one indeed.
> > 600+ instructions consume
> > processed 280464 insns (limit 1000000) max_states_per_insn 15
> > total_states 87341 peak_states 580 mark_read 45
> >
> > The verifier finds a lot of different ways to go through branches
> > in the program and majority of the states are not equivalent and
> > do not help pruning, so it's doing full brute force walk of all possible
> > combinations.
> > We need to figure out whether there is a way to make it smarter.
> 
> btw my pending backtracking logic helps it quite a bit:
> processed 164110 insns (limit 1000000) max_states_per_insn 11
> total_states 13398 peak_states 349 mark_read 10
> 
> and it's 2x faster to verify, but 164k insns processed shows that
> there is still room for improvement.

Hi Andreas,

Could you please create selftests/bpf/verifier/.c out of it?
Currently we don't have a single test that exercises the verifier this way.
Could you also annotate instructions with comments like you did
at the top of your file?
The program logic is interesting.
If my understanding of assembler is correct it has unrolled
parsing of ipv6 extension headers. Then unrolled parsing of tcp options.
The way the program is using packet pointers forces the verifier to try
all possible combinations of extension headers and tcp options.

The precise backtracking logic helps to reduce amount of walking.
Also I think it's safe to reduce precision of variable part
of packet pointers. The following patch on top of bounded loop
series help to reduce it further.

Original:
  processed 280464 insns (limit 1000000) max_states_per_insn 15
  total_states 87341 peak_states 580 mark_read 45

Backtracking:
  processed 164110 insns (limit 1000000) max_states_per_insn 11
  total_states 13398 peak_states 349 mark_read 10

Backtracking + pkt_ptr var precision:
  processed 96739 insns (limit 1000000) max_states_per_insn 11
  total_states 7891 peak_states 329 mark_read 10

The patch helps w/o backtracking as well:
  processed 165254 insns (limit 1000000) max_states_per_insn 15
  total_states 51434 peak_states 572 mark_read 45

Backtracking and bounded loop heuristics reduce total memory
consumption quite a bit. Which was nice to see.

Anyway would be great if you could create a test out of it.
Would be even more awesome if you convert it to C code
and try to use bounded loops to parse extension headers
and tcp options. That would be a true test for both loops
and 'reduce precision' features.

Thanks!

From 4681224057af73335de0fdd629a2149bad91d59d Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Tue, 18 Jun 2019 13:40:29 -0700
Subject: [PATCH bpf-next] bpf: relax tracking of variable offset in packet pointers

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d2c8a6677ac4..e37c69ad57b3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3730,6 +3730,27 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst_reg->id = ++env->id_gen;
 			/* something was added to pkt_ptr, set range to zero */
 			dst_reg->raw = 0;
+			if (bpf_prog_is_dev_bound(env->prog->aux))
+				/* nfp offload needs accurate max_pkt_offset */
+				break;
+			if (env->strict_alignment)
+				break;
+			/* scalar added to pkt pointer is within BPF_MAX_VAR_OFF bounds.
+			 * 64-bit pkt_data pointer can be safely compared with pkt_data_end
+			 * even on 32-bit architectures.
+			 * In case this scalar was positive the verifier
+			 * doesn't need to track it precisely.
+			 */
+			if (dst_reg->smin_value >= 0)
+				/* clear variable part of pkt pointer */
+				__mark_reg_known_zero(dst_reg);
+				/* no need to clear dst_reg->off.
+				 * It's a known part of the pointer.
+				 * When this pkt_ptr compared with pkt_end
+				 * the 'range' will be initialized from 'off' and
+				 * *(u8*)(dst_reg - off) is still more than packet start,
+				 * since unknown value was positive.
+				 */
 		}
 		break;
 	case BPF_SUB:
-- 
2.20.0

