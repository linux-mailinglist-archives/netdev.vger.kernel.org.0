Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D4162E17
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfGICZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:25:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGICZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:25:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BF1E133E9760;
        Mon,  8 Jul 2019 19:25:59 -0700 (PDT)
Date:   Mon, 08 Jul 2019 19:25:58 -0700 (PDT)
Message-Id: <20190708.192558.1304552003355538760.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] coallocate socket_wq with socket itself
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705191416.GL17978@ZenIV.linux.org.uk>
References: <20190705191322.GK17978@ZenIV.linux.org.uk>
        <20190705191416.GL17978@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 19:25:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 5 Jul 2019 20:14:16 +0100

> socket->wq is assign-once, set when we are initializing both
> struct socket it's in and struct socket_wq it points to.  As the
> matter of fact, the only reason for separate allocation was the
> ability to RCU-delay freeing of socket_wq.  RCU-delaying the
> freeing of socket itself gets rid of that need, so we can just
> fold struct socket_wq into the end of struct socket and simplify
> the life both for sock_alloc_inode() (one allocation instead of
> two) and for tun/tap oddballs, where we used to embed struct socket
> and struct socket_wq into the same structure (now - embedding just
> the struct socket).
> 
> Note that reference to struct socket_wq in struct sock does remain
> a reference - that's unchanged.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied.
