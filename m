Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACDA5402A9
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 17:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344279AbiFGPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 11:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245474AbiFGPln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 11:41:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED49FC8BF3;
        Tue,  7 Jun 2022 08:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2805FCE2261;
        Tue,  7 Jun 2022 15:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8580C385A5;
        Tue,  7 Jun 2022 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654616497;
        bh=l+5X2UysSRek17uhSCRhsYUdPC9HnxURWjLyyr9B1U8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJRKSWL+bB2h3/PYLBLj68c/xV0Q5L1GHSFMPBkDcWFKldIxEdTny/qPVFoFfPvHl
         smMJVtm7sg1wKE6U6992txTarsRq3JiJbIsQ2Pl7zrn2v/I5ENWOFCl+x512tV5/G6
         IZ2yQTLZL6lqAHSvEU0w+le5tH19cYZrhhBccZ9M=
Date:   Tue, 7 Jun 2022 17:41:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5bGx56u55bCP?= <mangosteen728@gmail.com>
Cc:     ast <ast@kernel.org>, daniel <daniel@iogearbox.net>,
        andrii <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] bpf:add function
Message-ID: <Yp9xrkeqUEWvZm9x@kroah.com>
References: <CAB8PBH+EVX3iTr7Nu-QFHAom+VnjPLEk0hpWSi0QiyD5u-bKag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB8PBH+EVX3iTr7Nu-QFHAom+VnjPLEk0hpWSi0QiyD5u-bKag@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 09:28:58PM +0800, 山竹小 wrote:
> Add the absolute path to get the executable corresponding tothe task
> 
> Signed-off-by: mangosteen728 < mangosteen728@gmail.com>
> ---
> Hi
> This is my first attempt to submit patch, there are shortcomings
> please more but wait.
> 
> In security audit often need to get the absolute path to the
> executable of the process so I tried to add bpf_get_task_exe_path in
> the helpers function to get.
> 
> The code currently only submits the implementation of the function and
> how is this patch merge possible if I then add the relevant places。
> 
> thanks
> mangosteen728
> kernel/bpf/helpers.c | 37 +++++++++++++++++++++++++++++++++++++
> 1 file changed, 37 insertions(+)
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 225806a..797f 850 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -257,6 +257,43 @@
> .arg2_type = ARG_CONST_SIZE,
> };
> 
> +BPF_CALL_3(bpf_get_task_exe_path, struct task_struct *, task, char *,
> buf, u32, sz)
> +{
> + struct file *exe_file = NULL;
> + char *p = NULL;
> + long len = 0;
> +
> + if (!sz)
> + return 0;
> + exe_file = get_task_exe_file(tsk);
> + if (IS_ERR_OR_NULL(exe_file))
> + return 0;
> + p = d_path(&exe_file->f_path, buf, sz);
> + if (IS_ERR_OR_NULL(path)) {
> + len = PTR_ERR(p);
> + } else {
> + len = buf + sz - p;
> + memmove(buf, p, len);
> + }
> + fput(exe_file);
> + return len;
> +}
> +
> +static const struct bpf_func_proto bpf_get_task_exe_path_proto = {
> + .func       = bpf_get_task_exe_path,
> + .gpl_only   = false,
> + .ret_type   = RET_INTEGER,
> + .arg1_type  = ARG_PTR_TO_BTF_ID,
> + .arg2_type  = ARG_PTR_TO_MEM,
> + .arg3_type  = ARG_CONST_SIZE_OR_ZERO,
> +};
> +

Something went really wrong with your patch :(

But the larger issue is, there is no such thing as a "absolute path to a
file" within the kernel, sorry.  This just is not going to work, and it
has come up again and again and again with regards to other kernel
subsystems many times.

Step back and answer "why" you think you need a path to an executable?
What needs this that you can not do it in userspace?  What are you going
to do with this supposed information if you get it?

And then think about filesystem namespaces...

sorry, this isn't going to work.

greg k-h
