Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7DC19C3DE
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbgDBOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:21:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46554 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgDBOVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:21:21 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jK0iQ-008jXS-6S; Thu, 02 Apr 2020 14:21:06 +0000
Date:   Thu, 2 Apr 2020 15:21:06 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200402142106.GF23230@ZenIV.linux.org.uk>
References: <20200401110907.2669564-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401110907.2669564-1-jolsa@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 01:09:04PM +0200, Jiri Olsa wrote:
> hi,
> adding d_path helper to return full path for 'path' object.
> 
> I originally added and used 'file_path' helper, which did the same,
> but used 'struct file' object. Then realized that file_path is just
> a wrapper for d_path, so we'd cover more calling sites if we add
> d_path helper and allowed resolving BTF object within another object,
> so we could call d_path also with file pointer, like:
> 
>   bpf_d_path(&file->f_path, buf, size);
> 
> This feature is mainly to be able to add dpath (filepath originally)
> function to bpftrace, which seems to work nicely now, like:
> 
>   # bpftrace -e 'kretfunc:fget { printf("%s\n", dpath(args->ret->f_path));  }' 
> 
> I'm not completely sure this is all safe and bullet proof and there's
> no other way to do this, hence RFC post.
> 
> I'd be happy also with file_path function, but I thought it'd be
> a shame not to try to add d_path with the verifier change.
> I'm open to any suggestions ;-)

What are the locking conditions guaranteed to that sucker?  Note that d_path()
is *NOT* lockless - call it from an interrupt/NMI/etc. and you are fucked.
It can grab rename_lock and mount_lock; usually it avoids that, so you won't
see them grabbed on every call, but after the first seqlock mismatch it will
fall back to grabbing the spinlock in question.  And then there's ->d_dname(),
with whatever things _that_ chooses to do....
