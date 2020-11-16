Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB8A2B5014
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgKPSnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbgKPSnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 13:43:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B59A6217A0;
        Mon, 16 Nov 2020 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552222;
        bh=Tswb3FD7l4bvQma3X+DSkIH6OycRFZvJEDuWyxxYhsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NTjH9ouFuQiDS4K7wk0OzzC2ziMNI6WIga6s9ZheLrQMge6OzQT7Yp1ijql9/XqDh
         bxux9YdtO1iqXF1C4qmw5/UuR/93OkUMOqmpT6MkAqw8iHWRIYwxkMnbbRmEvlt+5P
         Z5QgLMGM3uzT1BbThRZkPrdhlKmeZepmbqnFncno=
Date:   Mon, 16 Nov 2020 10:43:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201116104340.60692716@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116183749.6aaknb5ptvzlp7ss@kafai-mbp.dhcp.thefacebook.com>
References: <20201112211255.2585961-1-kafai@fb.com>
        <20201112211313.2587383-1-kafai@fb.com>
        <20201114171720.50ae0a51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116173734.a5efp2rvg43762ut@kafai-mbp.dhcp.thefacebook.com>
        <20201116100004.1bc5e70e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116183749.6aaknb5ptvzlp7ss@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 10:37:49 -0800 Martin KaFai Lau wrote:
> On Mon, Nov 16, 2020 at 10:00:04AM -0800, Jakub Kicinski wrote:
> > Locks that can run in any context but preempt disabled or softirq
> > disabled?  
> Not exactly. e.g. running from irq won't work.
> 
> > Let me cut to the chase. Are you sure you didn't mean to check
> > if (irq_count()) ?  
> so, no.
> 
> From preempt.h:
> 
> /*
>  * ...
>  * in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
>  * ...
>  */
> #define in_interrupt()          (irq_count())

Right, as I said in my correction (in_irq() || in_nmi()).

Just to spell it out AFAIU in_serving_softirq() will return true when
softirq is active and interrupted by a hard irq or an NMI.

