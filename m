Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE95C5768E4
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiGOV30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiGOV3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ED474786;
        Fri, 15 Jul 2022 14:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329A861874;
        Fri, 15 Jul 2022 21:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF20C341C6;
        Fri, 15 Jul 2022 21:29:21 +0000 (UTC)
Date:   Fri, 15 Jul 2022 17:29:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220715172919.76d60b47@gandalf.local.home>
In-Reply-To: <6271DEDF-F585-4A3B-90BF-BA2EB76DDC01@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-4-song@kernel.org>
        <20220713203343.4997eb71@rorschach.local.home>
        <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
        <20220714204817.2889e280@rorschach.local.home>
        <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
        <20220714224646.62d49e36@rorschach.local.home>
        <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
        <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
        <20220715151217.141dc98f@gandalf.local.home>
        <0EB34157-8BCA-47FC-B78F-AA8FE45A1707@fb.com>
        <20220715155953.4fb692e2@gandalf.local.home>
        <6271DEDF-F585-4A3B-90BF-BA2EB76DDC01@fb.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 20:21:49 +0000
Song Liu <songliubraving@fb.com> wrote:

> >>> Wouldn't this need to be done anyway if BPF was first and live kernel
> >>> patching needed the update? An -EAGAIN would not suffice.    
> >> 
> >> prepare_direct_functions_for_ipmodify handles BPF-first-livepatch-later
> >> case. The benefit of prepare_direct_functions_for_ipmodify() is that it 
> >> holds direct_mutex before ftrace_lock, and keeps holding it if necessary. 
> >> This is enough to make sure we don't need the wash-rinse-repeat. 
> >> 
> >> OTOH, if we wait until __ftrace_hash_update_ipmodify(), we already hold
> >> ftrace_lock, but not direct_mutex. To make changes to bpf trampoline, we
> >> have to unlock ftrace_lock and lock direct_mutex to avoid deadlock. 
> >> However, this means we will need the wash-rinse-repeat.   
> 
> What do you think about the prepare_direct_functions_for_ipmodify() 
> approach? If this is not ideal, maybe we can simplify it so that it only
> holds direct_mutex (when necessary). The benefit is that we are sure
> direct_mutex is already held in __ftrace_hash_update_ipmodify(). However, 
> I think it is not safe to unlock ftrace_lock in __ftrace_hash_update_ipmodify(). 
> We can get parallel do_for_each_ftrace_rec(), which is dangerous, no? 

I'm fine with it. But one nit on the logic:

>  int register_ftrace_function(struct ftrace_ops *ops)
> +	__releases(&direct_mutex)
>  {
> +	bool direct_mutex_locked;
>  	int ret;
>  
>  	ftrace_ops_init(ops);
>  
> +	ret = prepare_direct_functions_for_ipmodify(ops);
> +	if (ret < 0)
> +		return ret;
> +
> +	direct_mutex_locked = ret == 1;
> +

Please make the above:

	if (ret < 0)
		return ret;
	else if (ret == 1)
		direct_mutex_locked = true;

It's much easier to read that way.

-- Steve

>  	mutex_lock(&ftrace_lock);
>  
>  	ret = ftrace_startup(ops, 0);
>  
>  	mutex_unlock(&ftrace_lock);
>  
> +	if (direct_mutex_locked)
> +		mutex_unlock(&direct_mutex);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(register_ftrace_function);
> -- 
