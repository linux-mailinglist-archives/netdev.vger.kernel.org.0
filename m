Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6B1E95BC
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgEaE4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaE4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:56:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A129C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:56:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDB01128FE21D;
        Sat, 30 May 2020 21:56:14 -0700 (PDT)
Date:   Sat, 30 May 2020 21:56:13 -0700 (PDT)
Message-Id: <20200530.215613.2287572587082964436.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jchapman@katalix.com, andriin@fb.com,
        syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 net] l2tp: do not use inet_hash()/inet_unhash()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529182053.134014-1-edumazet@google.com>
References: <20200529182053.134014-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:56:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 29 May 2020 11:20:53 -0700

> syzbot recently found a way to crash the kernel [1]
> 
> Issue here is that inet_hash() & inet_unhash() are currently
> only meant to be used by TCP & DCCP, since only these protocols
> provide the needed hashinfo pointer.
> 
> L2TP uses a single list (instead of a hash table)
> 
> This old bug became an issue after commit 610236587600
> ("bpf: Add new cgroup attach type to enable sock modifications")
> since after this commit, sk_common_release() can be called
> while the L2TP socket is still considered 'hashed'.
 ...
> Fixes: 0d76751fad77 ("l2tp: Add L2TPv3 IP encapsulation (no UDP) support")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: James Chapman <jchapman@katalix.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks.
