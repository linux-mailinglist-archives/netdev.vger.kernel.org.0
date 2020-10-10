Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FE1289D1A
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgJJBfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729350AbgJJB0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:26:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73505206D9;
        Sat, 10 Oct 2020 01:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602293193;
        bh=/VWKzt+yLafsJfbtHzRSdLHEo2sn1dq1p/xS0sni+I4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EfLgytedPH70c9WadaUqyiFyknUVu90OoGzAyLcmyKn8VATUMN9bb3HDayxF//kds
         lzoCXF1YGH1OQqCfn9e8uT5aIivYq8rUk7EGcbKGyFjQtLwV5WdlWwFayJyF1hUORl
         zyP+eN06P9Dzct7hjOpe0C9XC7POcnw9f1H/tlcA=
Date:   Fri, 9 Oct 2020 18:26:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: Re: [Patch net] tipc: fix the skb_unshare() in tipc_buf_append()
Message-ID: <20201009182631.5fb4cf17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008041250.22642-1-xiyou.wangcong@gmail.com>
References: <20201008041250.22642-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 21:12:50 -0700 Cong Wang wrote:
> skb_unshare() drops a reference count on the old skb unconditionally,
> so in the failure case, we end up freeing the skb twice here.
> And because the skb is allocated in fclone and cloned by caller
> tipc_msg_reassemble(), the consequence is actually freeing the
> original skb too, thus triggered the UAF by syzbot.
> 
> Fix this by replacing this skb_unshare() with skb_cloned()+skb_copy().
> 
> Fixes: ff48b6222e65 ("tipc: use skb_unshare() instead in tipc_buf_append()")
> Reported-and-tested-by: syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued for stable, thank you!
