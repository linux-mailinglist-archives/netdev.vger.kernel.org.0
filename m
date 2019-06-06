Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167BF368A7
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFFAOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:14:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFAOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:14:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2288113AEF259;
        Wed,  5 Jun 2019 17:14:49 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:14:48 -0700 (PDT)
Message-Id: <20190605.171448.1980183910828510087.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     linux-sctp@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH V2] Fix memory leak in sctp_process_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603203259.21508-1-nhorman@tuxdriver.com>
References: <00000000000097abb90589e804fd@google.com>
        <20190603203259.21508-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:14:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon,  3 Jun 2019 16:32:59 -0400

> syzbot found the following leak in sctp_process_init
> BUG: memory leak
> unreferenced object 0xffff88810ef68400 (size 1024):
 ...
> The problem was that the peer.cookie value points to an skb allocated
> area on the first pass through this function, at which point it is
> overwritten with a heap allocated value, but in certain cases, where a
> COOKIE_ECHO chunk is included in the packet, a second pass through
> sctp_process_init is made, where the cookie value is re-allocated,
> leaking the first allocation.
> 
> Fix is to always allocate the cookie value, and free it when we are done
> using it.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com

Applied and queued up for -stable.
