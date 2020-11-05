Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A3E2A894B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 22:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbgKEVxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 16:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgKEVxl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 16:53:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2ECF2080D;
        Thu,  5 Nov 2020 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604613220;
        bh=kT732eXeXvpQOZkP7sHcwHnMaCo4/gCoi7XxP4AhVcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g/SpMkdapSZcg0SLvg1Y57+3E6a9K6OL8Z2aLxpCgnnKYHmNhDa6FCPZw7zoTJ2zj
         KtTyX6Cpewcq107QqkJ056W7vo52UjwQRKsBsjTGuEZBw0tHo7xMxnbg3kNFtcKBUp
         jhN0Ij3Di/QIa9znffpExV58LvOfFBRgQ3E3R6oM=
Date:   Thu, 5 Nov 2020 13:53:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by
 default
Message-ID: <20201105135338.316e1677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
References: <20200423195850.1259827-1-andriin@fb.com>
        <20201105170202.5bb47fef@redhat.com>
        <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 13:22:12 -0800 Andrii Nakryiko wrote:
> On Thu, Nov 5, 2020 at 8:02 AM Jiri Benc <jbenc@redhat.com> wrote:
> > On Thu, 23 Apr 2020 12:58:50 -0700, Andrii Nakryiko wrote:  
> > > To make BPF verifier verbose log more releavant and easier to use to debug
> > > verification failures, "pop" parts of log that were successfully verified.
> > > This has effect of leaving only verifier logs that correspond to code branches
> > > that lead to verification failure, which in practice should result in much
> > > shorter and more relevant verifier log dumps. This behavior is made the
> > > default behavior and can be overriden to do exhaustive logging by specifying
> > > BPF_LOG_LEVEL2 log level.  
> >
> > This patch broke the test_offload.py selftest:
> >
> > [...]
> > Test TC offloads work...
> > FAIL: Missing or incorrect message from netdevsim in verifier log
> > [...]
> >
> > The selftest expects to receive "[netdevsim] Hello from netdevsim!" in
> > the log (coming from nsim_bpf_verify_insn) but that part of the log is
> > cleared by bpf_vlog_reset added by this patch.  
> 
> Should we just drop check_verifier_log() checks?

Drivers only print error messages when something goes wrong, so the
messages are high priority. IIUC this change was just supposed to
decrease verbosity, right?
