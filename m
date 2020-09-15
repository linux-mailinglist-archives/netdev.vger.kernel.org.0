Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63A426B265
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgIOWqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbgIOPpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 11:45:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144F72074B;
        Tue, 15 Sep 2020 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600184009;
        bh=2iRcJU8Ti0lcAhNxfiVEN4cswY2yaG6DJiD4aEN8qs8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eOFqPPCZHUX6vbwqI6qX/xtTObi7g8YLeDSTfUVbhqZWGBJ6rRmo0aotdv/VDqlDV
         A/ai9GUIEGMte35YGxf1x3H9fD2/dbFwNZJICQhH7wp1KfG1UlbUL6g5PEH1DqNf+N
         7x9A73jQBRz5MAIDJzKSsca2ZZpwEdYXLHWEObUI=
Date:   Tue, 15 Sep 2020 08:33:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
Message-ID: <20200915083327.7e98cf2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914184630.1048718-1-yhs@fb.com>
References: <20200914184630.1048718-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 11:46:30 -0700 Yonghong Song wrote:
> Currently, we use bucket_lock when traversing bpf_sk_storage_map
> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
> we do not have a deadlock issue which exists for hashmap when
> using bucket_lock ([1]).
> 
> If a bucket contains a lot of sockets, during bpf_iter traversing
> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
> some undesirable delays. Using rcu_read_lock() is a reasonable
> compromise here. Although it may lose some precision, e.g.,
> access stale sockets, but it will not hurt performance of other
> bpf programs.
> 
> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
> 
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Sparse is not happy about it. Could you add some annotations, perhaps?

include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_find_next' - unexpected unlock
include/linux/rcupdate.h:686:9: warning: context imbalance in 'bpf_sk_storage_map_seq_stop' - unexpected unlock
