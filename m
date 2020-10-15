Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B228F79A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404945AbgJORYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404921AbgJORYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 13:24:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F8C22210;
        Thu, 15 Oct 2020 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602782640;
        bh=2XeKjuAuyGfPWYFkfNE8b5tzApIKKHz0ppha135J0h8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTTeIaxKyYzWlYDK5zeZgqh2/tVafcDJeSwjhQU26eoPLQbuzjbbcONz/CbCwnKZG
         MRPHRSvWYurTGpOcpLEk4fs7zwuXyAZB/uFrFspFjyh9u9jE46uih0a+zFT9/ks5ll
         KQpJCtzcv22LTps5cPlkD7u3xP/t4+m9ijbY73io=
Date:   Thu, 15 Oct 2020 10:23:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH net v3] net: fix pos incrementment in
 ipv6_route_seq_next
Message-ID: <20201015102358.0cdef2ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014144612.2245396-1-yhs@fb.com>
References: <20201014144612.2245396-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 07:46:12 -0700 Yonghong Song wrote:
> Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
> tried to fix the issue where seq_file pos is not increased
> if a NULL element is returned with seq_ops->next(). See bug
>   https://bugzilla.kernel.org/show_bug.cgi?id=206283
> The commit effectively does:
>   - increase pos for all seq_ops->start()
>   - increase pos for all seq_ops->next()
> 
> For ipv6_route, increasing pos for all seq_ops->next() is correct.
> But increasing pos for seq_ops->start() is not correct
> since pos is used to determine how many items to skip during
> seq_ops->start():
>   iter->skip = *pos;
> seq_ops->start() just fetches the *current* pos item.
> The item can be skipped only after seq_ops->show() which essentially
> is the beginning of seq_ops->next().

Applied, queued for stable, thanks!
