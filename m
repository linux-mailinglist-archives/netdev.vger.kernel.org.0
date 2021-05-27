Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5C0392A99
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhE0JVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbhE0JVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:21:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1BEC061574;
        Thu, 27 May 2021 02:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iRsknJTfFiEDd9n74h43kOIWLR9thmAzm1ZrB74a5Xk=; b=Mt+PC76TyiEwy+b6L48ycifDAR
        XKE8hldzILOrEh24nLs1DSsELIQas2IMv96tixj0ygC3f1Lv3VEvRBeKiKDdtAWb19AjM5LU/k5h/
        x3XDVHdV417fF1H3Ioq5EQ/NwRnCfBr+Fc1RIrEBzMubdx7Ex60adikqLp3aVUdx7YpCkeCFVn2k6
        gyVeE5GIlQjhhQX6EMJnfTUpNzx1SHu06QnzDFpnSeKq7kiP0aebbIVgqScJDxi7FexSCpNSXgBHN
        1vL261F7MmvNoS69Ac4LUN+xB6UnMqaSfWnV3cPlTxon563qfBxvhw3p6iNh2RBqXL5IZxp9HvQB8
        7v4DbJ5Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmC9l-005NI5-1e; Thu, 27 May 2021 09:18:41 +0000
Date:   Thu, 27 May 2021 10:18:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <YK9j3YeMTZ+0I8NA@infradead.org>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org>
 <20210527090422.GA30378@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527090422.GA30378@techsingularity.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 10:04:22AM +0100, Mel Gorman wrote:
> What do you suggest as an alternative?
> 
> I added Arnaldo to the cc as he tagged the last released version of
> pahole (1.21) and may be able to tag a 1.22 with Andrii's fix for pahole
> included.
> 
> The most obvious alternative fix for this issue is to require pahole
> 1.22 to set CONFIG_DEBUG_INFO_BTF but obviously a version 1.22 that works
> needs to exist first and right now it does not. I'd be ok with this but
> users of DEBUG_INFO_BTF may object given that it'll be impossible to set
> the option until there is a release.

Yes, disable BTF.  Empty structs are a very useful feature that we use
in various places in the kernel.  We can't just keep piling hacks over
hacks to make that work with a recent fringe feature.
