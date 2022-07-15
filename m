Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6A15758B3
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 02:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiGOAsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 20:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiGOAsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 20:48:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51DC2E6B2;
        Thu, 14 Jul 2022 17:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47EE7620D5;
        Fri, 15 Jul 2022 00:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152F9C34114;
        Fri, 15 Jul 2022 00:48:18 +0000 (UTC)
Date:   Thu, 14 Jul 2022 20:48:17 -0400
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
Message-ID: <20220714204817.2889e280@rorschach.local.home>
In-Reply-To: <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-4-song@kernel.org>
        <20220713203343.4997eb71@rorschach.local.home>
        <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 00:13:51 +0000
Song Liu <songliubraving@fb.com> wrote:

> I think there is one more problem here. If we force all direct trampoline
> set IPMODIFY, and remove the SHARE_IPMODIFY flag. It may cause confusion 
> and/or extra work here (__ftrace_hash_update_ipmodify). 

I'm saying that the caller (BPF) does not need to set IPMODIFY. Just
change the ftrace.c to treat IPMODIFY the same as direct. In fact, the
two should be mutually exclusive (from a ftrace point of view). That
is, if DIRECT is set, then IPMODIFY must not be.

Again, ftrace will take care of the accounting of if a rec has both
IPMODIFY and DIRECT on it.

> 
> Say __ftrace_hash_update_ipmodify() tries to attach an ops with IPMODIFY, 
> and found the rec already has IPMODIFY. At this point, we have to iterate
> all ftrace ops (do_for_each_ftrace_op) to confirm whether the IPMODIFY is 
> from 

What I'm suggesting is that a DIRECT ops will never set IPMODIFY. Like
I mentioned before, ftrace doesn't care if the direct trampoline
modifies IP or not. All ftrace will do is ask the owner of the direct
ops if it is safe to have an IP modify attached to it or not. And at
the same time will tell the direct ops owner that it is adding an
IPMODIFY ops such that it can take the appropriate actions.

In other words, IPMODIFY on the rec means that it can not attach
anything else with an IPMODIFY on it.

The direct ops should only set the DIRECT flag. If an IPMODIFY ops is
being added, if it already has an IPMODIFY then it will fail right there.

If direct is set, then a loop for the direct ops will be done and the
callback is made. If the direct ops is OK with the IPMODIFY then it
will adjust itself to work with the IPMODIFY and the IPMODIFY will
continue to be added (and then set the rec IPMODIFY flag).

> 
> 1) a direct ops that can share IPMODIFY, or 
> 2) a direct ops that cannot share IPMODIFY, or 
> 3) another non-direct ops with IPMODIFY. 
> 
> For the 1), this attach works, while for 2) and 3), the attach doesn't work. 
> 
> OTOH, with current version (v2), we trust the direct ops to set or clear 
> IPMODIFY. rec with IPMODIFY makes it clear that it cannot share with another
> ops with IPMODIFY. Then we don't have to iterate over all ftrace ops here. 

The only time an iterate should be done is if rec->flags is DIRECT and !IPMODIFY.

> 
> Does this make sense? Did I miss some better solutions?

Did I fill in the holes? ;-)

-- Steve
