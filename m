Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B19134412
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgAHNlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:41:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:50544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAHNlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 08:41:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6BEF8AE52;
        Wed,  8 Jan 2020 13:41:50 +0000 (UTC)
Date:   Wed, 8 Jan 2020 13:41:48 +0000
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Peter Wu <peter@lekensteyn.nl>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/2] bpftool: Add misc secion and probe for
 large INSN limit
Message-ID: <20200108134148.GD2954@wotan.suse.de>
References: <20200107130308.20242-1-mrostecki@opensuse.org>
 <20200107130308.20242-3-mrostecki@opensuse.org>
 <70565317-89af-358f-313c-c4b327cdca4a@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70565317-89af-358f-313c-c4b327cdca4a@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 02:36:15PM +0000, Quentin Monnet wrote:
> Nit: typo in subject ("secion").
> 
> 2020-01-07 14:03 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> > Introduce a new probe section (misc) for probes not related to concrete
> > map types, program types, functions or kernel configuration. Introduce a
> > probe for large INSN limit as the first one in that section.
> > 
> > Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> > ---
> >  tools/bpf/bpftool/feature.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> > index 03bdc5b3ac49..d8ce93092c45 100644
> > --- a/tools/bpf/bpftool/feature.c
> > +++ b/tools/bpf/bpftool/feature.c
> > @@ -572,6 +572,18 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
> >  		printf("\n");
> >  }
> >  
> > +static void
> > +probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
> > +{
> > +	bool res;
> > +
> > +	res = bpf_probe_large_insn_limit(ifindex);
> > +	print_bool_feature("have_large_insn_limit",
> > +			   "Large complexity and program size limit",
> 
> I am not sure we should mention "complexity" here. Although it is
> related to program size in the kernel commit you describe, the probe
> that is run is only on instruction number. This can make a difference
> for offloaded programs: When you probe a device, if kernel has commit
> c04c0d2b968a and supports up to 1M instructions, but hardware supports
> no more than 4k instructions, you may still benefit from the new value
> for BPF_COMPLEXITY_LIMIT_INSNS for complexity, but not for the total
> number of available instructions. In that case the probe will fail, and
> the message on complexity would not be accurate.
> 
> Looks good otherwise, thanks Michal!
> 
> Quentin

Thanks for review! Should I change the description just to "Large
program size limit" or "Large instruction limit"?

Michal
