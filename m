Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC4B576933
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiGOVuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiGOVuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:50:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362F4F197;
        Fri, 15 Jul 2022 14:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5654CE31C2;
        Fri, 15 Jul 2022 21:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C064EC34115;
        Fri, 15 Jul 2022 21:50:44 +0000 (UTC)
Date:   Fri, 15 Jul 2022 17:50:43 -0400
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
Message-ID: <20220715175043.03fa0d9f@gandalf.local.home>
In-Reply-To: <019DBB19-E3BC-4EB5-8D96-DB1D0E10FD73@fb.com>
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
        <20220715172919.76d60b47@gandalf.local.home>
        <019DBB19-E3BC-4EB5-8D96-DB1D0E10FD73@fb.com>
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

On Fri, 15 Jul 2022 21:48:21 +0000
Song Liu <songliubraving@fb.com> wrote:

> >> int register_ftrace_function(struct ftrace_ops *ops)
> >> +	__releases(&direct_mutex)
> >> {
> >> +	bool direct_mutex_locked;

You'll need:

	bool direct_mutex_locked = false;

obviously ;-)

-- Steve

> >> 	int ret;
> >> 
> >> 	ftrace_ops_init(ops);
> >> 
> >> +	ret = prepare_direct_functions_for_ipmodify(ops);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	direct_mutex_locked = ret == 1;
> >> +  
> > 
> > Please make the above:
> > 
> > 	if (ret < 0)
> > 		return ret;
> > 	else if (ret == 1)
> > 		direct_mutex_locked = true;
> > 
> > It's much easier to read that way.  
> 
> Thanks for the clarification! 

