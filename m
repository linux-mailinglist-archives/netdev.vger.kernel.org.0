Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429F650970
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfFXLIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:08:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbfFXLIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 07:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+fmi+ZSQNZKWfLg7h0rz9xCg0r+OkI0+jdLLJqV5Gds=; b=mQ6DTx7dBBzKhnce0ZURQodes
        UCd2kBQf5z2qKSaZ8bhomBPmrNa8XK8apI0uFFKqPHzR/ktugUVQ287q3Lz0AC8a1HQ6V9xFmnQTO
        /WrcAvwRjAQ0OM9+GC26dooWO5yIC6gAYysKDMf9wG7DAknoK8onjsvg/m/AhTTq1+GcY6SD0m4Fr
        bysCrDg5zxCDQQirgjMVyViB5IYAanySyrqw7JKcX73KhJPDT8Z2IqOijAy/2FcByhbFKZbq+oY34
        9FkSNZNiDjNfSMiREvqKzfQOGYpDHiKJ/V2yjZNh/NAny2JOYvJx8B9PSzYtmD1EmT5IhjwmjZi+b
        hcFgTDc8g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfMp1-0004yL-EE; Mon, 24 Jun 2019 11:07:39 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4DF6C203C694B; Mon, 24 Jun 2019 13:07:37 +0200 (CEST)
Date:   Mon, 24 Jun 2019 13:07:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, ast@kernel.org, daniel@iogearbox.net,
        akpm@linux-foundation.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 3/3] module: Properly propagate MODULE_STATE_COMING
 failure
Message-ID: <20190624110737.GU3419@hirez.programming.kicks-ass.net>
References: <20190624091843.859714294@infradead.org>
 <20190624092109.863781858@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624092109.863781858@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 11:18:46AM +0200, Peter Zijlstra wrote:
> Now that notifiers got unbroken; use the proper interface to handle
> notifier errors and propagate them.
> 
> There were already MODULE_STATE_COMING notifiers that failed; notably:
> 
>  - jump_label_module_notifier()
>  - tracepoint_module_notify()
>  - bpf_event_notify()
> 
> By propagating this error, we fix those users.
> 
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/module.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3643,9 +3643,10 @@ static int prepare_coming_module(struct
>  	if (err)
>  		return err;
>  
> -	blocking_notifier_call_chain(&module_notify_list,
> -				     MODULE_STATE_COMING, mod);
> -	return 0;
> +	err = blocking_notifier_call_chain_error(&module_notify_list,
> +			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
> +
> +	return notifier_to_errno(err);
>  }

Argh, I messed up that klp thing again :/
