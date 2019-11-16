Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1408FF5BE
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKPVNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:13:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:13:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8915C151A21AB;
        Sat, 16 Nov 2019 13:13:09 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:13:09 -0800 (PST)
Message-Id: <20191116.131309.972370574405253412.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        arjunroy@google.com
Subject: Re: [PATCH net-next] selftests: net: avoid ptl lock contention in
 tcp_mmap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191116015554.51077-1-edumazet@google.com>
References: <20191116015554.51077-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:13:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 15 Nov 2019 17:55:54 -0800

> tcp_mmap is used as a reference program for TCP rx zerocopy,
> so it is important to point out some potential issues.
> 
> If multiple threads are concurrently using getsockopt(...
> TCP_ZEROCOPY_RECEIVE), there is a chance the low-level mm
> functions compete on shared ptl lock, if vma are arbitrary placed.
> 
> Instead of letting the mm layer place the chunks back to back,
> this patch enforces an alignment so that each thread uses
> a different ptl lock.
> 
> Performance measured on a 100 Gbit NIC, with 8 tcp_mmap clients
> launched at the same time :
> 
> $ for f in {1..8}; do ./tcp_mmap -H 2002:a05:6608:290:: & done
> 
> In the following run, we reproduce the old behavior by requesting no alignment :
> 
> $ tcp_mmap -sz -C $((128*1024)) -a 4096
 ...
> New behavior (automatic alignment based on Hugepagesize),
> we can see the system overhead being dramatically reduced.
> 
> $ tcp_mmap -sz -C $((128*1024))
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
