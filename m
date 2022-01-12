Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E5B48BF06
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 08:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351218AbiALHeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 02:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351213AbiALHeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 02:34:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B378FC06173F;
        Tue, 11 Jan 2022 23:34:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6EFB81DDD;
        Wed, 12 Jan 2022 07:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD50EC36AE9;
        Wed, 12 Jan 2022 07:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641972840;
        bh=katItcAdlIg1VGt12/hCRr+LeICzVsuaMib2lQWOzyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JCK9Eaqtu1se7xDxHwSZE0k9cZHqZJpt3dd3i/+RmEzcrQGfK8Ht8FRJFQ1fCPTMr
         vl0S1e1jJrCth141cPiBkIXHpfiIhnHBFfUEaQ/uNkAYhQewg8GxeOVlGKhIuzu9C1
         nfG9q0n8Z7WGki8vqIB0xNbi6RhIgNSR57ltVOH9aG4ur78CMlID+55fOa2mu8rMIW
         KYC3Y2kHSASWIDmkwIeWYCzKvQTdco4loYa3dkG1wRsyXsfJEIUumYdcR4mEl2eej5
         +b7E79Pe/oeZAFMOH58YSNWZ1OJnrkbcgmTft1lpW/UL3j73ebTYKxJqxwVOvBvE2C
         8uFqL4QfhplzA==
Date:   Wed, 12 Jan 2022 16:33:53 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/6] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220112163353.4da6a6b9c6eef69dbda50324@kernel.org>
In-Reply-To: <20220111223944.jbi3mxedwifxwyz5@ast-mbp.lan>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <164191321766.806991.7930388561276940676.stgit@devnote2>
        <20220111223944.jbi3mxedwifxwyz5@ast-mbp.lan>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Tue, 11 Jan 2022 14:39:44 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Jan 12, 2022 at 12:00:17AM +0900, Masami Hiramatsu wrote:
> > Hi Jiri,
> > 
> > Here is a short series of patches, which shows what I replied
> > to your series.
> > 
> > This introduces the fprobe, the function entry/exit probe with
> > multiple probe point support. This also introduces the rethook
> > for hooking function return, which I cloned from kretprobe.
> > 
> > I also rewrite your [08/13] bpf patch to use this fprobe instead
> > of kprobes. I didn't tested that one, but the sample module seems
> > to work. Please test bpf part with your libbpf updates.
> > 
> > BTW, while implementing the fprobe, I introduced the per-probe
> > point private data, but I'm not sure why you need it. It seems
> > that data is not used from bpf...
> > 
> > If this is good for you, I would like to proceed this with
> > the rethook and rewrite the kretprobe to use the rethook to
> > hook the functions. That should be much cleaner (and easy to
> > prepare for the fgraph tracer integration)
> 
> What is the speed of attach/detach of thousands fprobes?

I've treaked my example module and it shows below result;

/lib/modules/5.16.0-rc4+/kernel/samples/fprobe # time insmod ./fprobe_example.ko
 symbol='btrfs_*'
[  187.095925] fprobe_init: 1028 symbols found
[  188.521694] fprobe_init: Planted fprobe at btrfs_*
real	0m 1.47s
user	0m 0.00s
sys	0m 1.36s

I think using ftrace_set_filter_ips() can make it faster.
(maybe it needs to drop per-probe point private data, that
prevents fprobe to use that interface)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
