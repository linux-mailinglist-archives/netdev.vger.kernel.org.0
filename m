Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC862B4EC1
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387839AbgKPSAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbgKPSAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 13:00:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199732227F;
        Mon, 16 Nov 2020 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605549605;
        bh=HSSVWiEWRae1/633rGBU5TIb4XiNMlLzmiyff31I9wc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PpZWzc2hmFfpPd3fGq/UHX6BDca+E7oJg620hamUqXAdmqbOFfRTkk2Ef5dRACF1t
         CrV0J5/Wmx3+ojdiLQJk38KCDtio1zY6aMCXDFHHoLpjmTJwOuzm3A9+1f1fQqxqo9
         xzfRZ/OjOSdtTCbJFBrkLkS1e3Eum3AWhBBWgCmY=
Date:   Mon, 16 Nov 2020 10:00:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201116100004.1bc5e70e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116173734.a5efp2rvg43762ut@kafai-mbp.dhcp.thefacebook.com>
References: <20201112211255.2585961-1-kafai@fb.com>
        <20201112211313.2587383-1-kafai@fb.com>
        <20201114171720.50ae0a51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116173734.a5efp2rvg43762ut@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 09:37:34 -0800 Martin KaFai Lau wrote:
> On Sat, Nov 14, 2020 at 05:17:20PM -0800, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 13:13:13 -0800 Martin KaFai Lau wrote:  
> > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > in runtime that the helpers can only be called when serving
> > > softirq or running in a task context.  That should enable
> > > most common tracing use cases on sk.  
> >   
> > > +	if (!in_serving_softirq() && !in_task())  
> > 
> > This is a curious combination of checks. Would you mind indulging me
> > with an explanation?  
> The current lock usage in bpf_local_storage.c is only expected to
> run in either of these contexts.

:)

Locks that can run in any context but preempt disabled or softirq
disabled?

Let me cut to the chase. Are you sure you didn't mean to check
if (irq_count()) ?
