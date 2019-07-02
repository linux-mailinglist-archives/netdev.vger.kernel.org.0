Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7420D5C6E2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGBCCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:02:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGBCCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:02:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1C7914DE9788;
        Mon,  1 Jul 2019 19:02:24 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:02:24 -0700 (PDT)
Message-Id: <20190701.190224.767132828354505683.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org, lucien.xin@gmail.com,
        nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, hdanton@sina.com
Subject: Re: [PATCH net] sctp: fix error handling on stream scheduler
 initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
References: <bcbc85604e53843a731a79df620d5f92b194d085.1561675505.git.marcelo.leitner@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:02:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 27 Jun 2019 19:48:10 -0300

> It allocates the extended area for outbound streams only on sendmsg
> calls, if they are not yet allocated.  When using the priority
> stream scheduler, this initialization may imply into a subsequent
> allocation, which may fail.  In this case, it was aborting the stream
> scheduler initialization but leaving the ->ext pointer (allocated) in
> there, thus in a partially initialized state.  On a subsequent call to
> sendmsg, it would notice the ->ext pointer in there, and trip on
> uninitialized stuff when trying to schedule the data chunk.
> 
> The fix is undo the ->ext initialization if the stream scheduler
> initialization fails and avoid the partially initialized state.
> 
> Although syzkaller bisected this to commit 4ff40b86262b ("sctp: set
> chunk transport correctly when it's a new asoc"), this bug was actually
> introduced on the commit I marked below.
> 
> Reported-by: syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Tested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable, thanks.
