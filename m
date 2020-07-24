Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D12122D270
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgGXXtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGXXtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 19:49:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0355EC0619D3;
        Fri, 24 Jul 2020 16:49:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99A8512755EF8;
        Fri, 24 Jul 2020 16:33:07 -0700 (PDT)
Date:   Fri, 24 Jul 2020 16:49:52 -0700 (PDT)
Message-Id: <20200724.164952.472536620054081569.davem@davemloft.net>
To:     hch@lst.de
Cc:     marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 net-next] sctp: fix slab-out-of-bounds in
 SCTP_DELAYED_SACK processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724064855.132552-1-hch@lst.de>
References: <20200724064855.132552-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 16:33:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 24 Jul 2020 08:48:55 +0200

> This sockopt accepts two kinds of parameters, using struct
> sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
> notice an implicit cast from the smaller (latter) struct to the bigger
> one (former) when copying the data from the user space, which now leads
> to an attempt to write beyond the buffer (because it assumes the storing
> buffer is bigger than the parameter itself).
> 
> Fix it by allocating a sctp_sack_info on stack and filling it out based
> on the small struct for the compat case.
> 
> Changelog stole from an earlier patch from Marcelo Ricardo Leitner.
> 
> Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
> Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied, thanks.
