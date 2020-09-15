Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA126AAE0
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 19:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgIORkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgIORkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 13:40:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C15206E6;
        Tue, 15 Sep 2020 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600191603;
        bh=50cSQ09DT28MN2hajr+tkRvQFyQLLq6+Ze2bBmektmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oivw3em1Lw/7vxFjeTEMdlrMSlVsRJmX9nI5CSWBTBZdgCNzCbpALPF/HXfNJfWTn
         3w50cS+Spg2nmRRkWOF77gfN/Hl6ehTjCNAzQ45CIfHiXQ2uQFRbrsx+0Z+CRboUMZ
         ZFopceHAvP8K0KZxLt2r3vHr+9FJykPYTbC+DBv8=
Date:   Tue, 15 Sep 2020 10:40:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
Message-ID: <20200915104001.0182ae73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bc24e2da-33e5-e13c-8fe0-1e24c2a5a579@fb.com>
References: <20200914184630.1048718-1-yhs@fb.com>
        <20200915083327.7e98cf2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bc24e2da-33e5-e13c-8fe0-1e24c2a5a579@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 10:35:50 -0700 Yonghong Song wrote:
> On 9/15/20 8:33 AM, Jakub Kicinski wrote:
> > On Mon, 14 Sep 2020 11:46:30 -0700 Yonghong Song wrote:  
> >> Currently, we use bucket_lock when traversing bpf_sk_storage_map
> >> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
> >> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
> >> we do not have a deadlock issue which exists for hashmap when
> >> using bucket_lock ([1]).
> >>
> >> If a bucket contains a lot of sockets, during bpf_iter traversing
> >> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
> >> some undesirable delays. Using rcu_read_lock() is a reasonable
> >> compromise here. Although it may lose some precision, e.g.,
> >> access stale sockets, but it will not hurt performance of other
> >> bpf programs.
> >>
> >> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
> >>
> >> Cc: Martin KaFai Lau <kafai@fb.com>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>  
> > 
> > Sparse is not happy about it. Could you add some annotations, perhaps?
> > 
> > include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_find_next' - unexpected unlock
> > include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_stop' - unexpected unlock  
> 
> Okay, I will try.
> 
> On my system, sparse is unhappy and core dumped....
> 
> /data/users/yhs/work/net-next/include/linux/string.h:12:38: error: too 
> many errors
> /bin/sh: line 1: 2710132 Segmentation fault      (core dumped) sparse 
> -D__linux__ -Dlinux -D__STDC__ -Dunix
> -D__unix__ -Wbitwise -Wno-return-void -Wno-unknown-attribute 
> -D__x86_64__ --arch=x86 -mlittle-endian -m64 -W
> p,-MMD,net/core/.bpf_sk_storage.o.d -nostdinc -isystem
> ...
> /data/users/yhs/work/net-next/net/core/bpf_sk_storage.c
> make[3]: *** [net/core/bpf_sk_storage.o] Error 139
> make[3]: *** Deleting file `net/core/bpf_sk_storage.o'
> 
> -bash-4.4$ rpm -qf /bin/sparse
> sparse-0.5.2-1.el7.x86_64
> -bash-4.4$

I think you need to build from source, sadly :(

https://git.kernel.org/pub/scm//devel/sparse/sparse.git
