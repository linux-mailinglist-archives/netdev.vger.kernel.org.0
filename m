Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C1E574097
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 02:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGNAis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 20:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiGNAir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 20:38:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2195A115E;
        Wed, 13 Jul 2022 17:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0C1661B65;
        Thu, 14 Jul 2022 00:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF86AC34114;
        Thu, 14 Jul 2022 00:38:42 +0000 (UTC)
Date:   Wed, 13 Jul 2022 20:38:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Message-ID: <20220713203841.76d66245@rorschach.local.home>
In-Reply-To: <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-2-song@kernel.org>
        <20220713191846.18b05b43@gandalf.local.home>
        <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
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

On Thu, 14 Jul 2022 00:11:53 +0000
Song Liu <songliubraving@fb.com> wrote:

> > That is, can we register a direct function with this function and pick a
> > function with IPMODIFY already attached?  
> 
> Yes, if the direct function follows regs->ip, it works. 
> 
> For example, BPF trampoline with only fentry calls will just work with only this patch.

I replied with my thoughts on this to patch 3, but I disagree with this.

ftrace has no idea if the direct trampoline modifies the IP or not.
ftrace must assume that it does, and the management should be done in
the infrastructure.

As I replied to patch 3, here's my thoughts.

DIRECT is treated as though it changes the IP. If you register it to a
function that has an IPMODIFY already set to it, it will call the
ops->ops_func() asking if the ops can use SHARED_IPMODIFY (which means
a DIRECT can be shared with IPMODIFY). If it can, then it returns true,
and the SHARED_IPMODIFY is set *by ftrace*. The user of the ftrace APIs
should not have to manage this. It should be managed by the ftrace
infrastructure.

Make sense?

-- Steve
