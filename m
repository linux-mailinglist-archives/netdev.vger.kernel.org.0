Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD765FC83E
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNN7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:59:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49660 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfKNN7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 08:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RO0R2uX0myetPZy48Pt/keNvG06wRn8KGY9AfrvLL9w=; b=fDF2HEor8gvhw4Pm2d2dZsEuY6
        hr3efgYJQK4s6muLfa50ubDy7JM+a3TNIPwqyuF4OG1x0nMt3G+m7cAPerQMZKoGfjx//JLLppk9i
        b6qGJuWK2mpIFb0Z6/CeRD0x7r7/xPLhmB7i1qN48GXafH2eGh2dVJyDhP40StFSaUSz82O4Uv+2U
        aoqsKCxRiHUtR3WwLIVJl/6wXP4vLEvg1EqWPEe+3hx9Jev5yIV8/cGeiNKu4zVVCUYUJDnYLPALq
        p211Yt6/ZpyXzVPZuA/J5isFOFNaUgKAGWC2Zay8+jtArcBeFlAbFsotsi4pPl6TECMl6ux54JI0G
        eY5gQxzg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVFe5-0007TP-8Q; Thu, 14 Nov 2019 13:58:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E62E730018B;
        Thu, 14 Nov 2019 14:57:39 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A107F203A589D; Thu, 14 Nov 2019 14:58:47 +0100 (CET)
Date:   Thu, 14 Nov 2019 14:58:47 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
Message-ID: <20191114135847.GY4131@hirez.programming.kicks-ass.net>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
 <20191113204737.31623-3-bjorn.topel@gmail.com>
 <fa188bb2-6223-5aef-98e4-b5f7976ed485@solarflare.com>
 <CAJ+HfNiDa912Uwt41_KMv+Z-sGr8fU7s4ncBPiUSx4PPAMQQqQ@mail.gmail.com>
 <96811723-ab08-b987-78c7-2c9f2a0a972c@solarflare.com>
 <CAJ+HfNhaOj+V7JuLb-SCAMf=7BudcE-C4EZAQrzT6P_NGpwvsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNhaOj+V7JuLb-SCAMf=7BudcE-C4EZAQrzT6P_NGpwvsw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 12:21:27PM +0100, Björn Töpel wrote:
> Again, thanks for the pointers. PeterZ is (hopefully) still working on
> the static_call stuff [3]. The static_call_inline would be a good fit
> here, and maybe even using static_call as a patchpad/dispatcher like
> you did is a better route. I will checkout Nadav's work!

Yes, I'll repost that once the current pile of text_poke and ftrace
changes lands.
