Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B7362D6A
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 06:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhDQEFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 00:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhDQEFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 00:05:03 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021F5C061574;
        Fri, 16 Apr 2021 21:04:37 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXcC4-005wRq-R6; Sat, 17 Apr 2021 04:04:29 +0000
Date:   Sat, 17 Apr 2021 04:04:28 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
Message-ID: <YHpeTKV2Y+sjuzbD@zeniv-ca.linux.org.uk>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-12-alexei.starovoitov@gmail.com>
 <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
 <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 08:46:05PM -0700, Alexei Starovoitov wrote:
> On Fri, Apr 16, 2021 at 8:42 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Fri, Apr 16, 2021 at 08:32:20PM -0700, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Add bpf_sys_close() helper to be used by the syscall/loader program to close
> > > intermediate FDs and other cleanup.
> >
> > Conditional NAK.  In a lot of contexts close_fd() is very much unsafe.
> > In particular, anything that might call it between fdget() and fdput()
> > is Right Fucking Out(tm).
> > In which contexts can that thing be executed?
> 
> user context only.
> It's not for all of bpf _obviously_.

Let me restate the question: what call chains could lead to bpf_sys_close()?
