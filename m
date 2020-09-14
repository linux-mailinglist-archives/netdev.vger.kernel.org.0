Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68D2699D4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgINXlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINXlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:41:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889BCC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:41:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A801128CAD69;
        Mon, 14 Sep 2020 16:24:17 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:41:03 -0700 (PDT)
Message-Id: <20200914.164103.588605919188301861.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, ying.xue@windriver.com
Subject: Re: [PATCH net] tipc: use skb_unshare() instead in
 tipc_buf_append()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0fcddb2bab6bde5632dcd4889961ebce1ec8bb8f.1599997051.git.lucien.xin@gmail.com>
References: <0fcddb2bab6bde5632dcd4889961ebce1ec8bb8f.1599997051.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:24:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 13 Sep 2020 19:37:31 +0800

> In tipc_buf_append() it may change skb's frag_list, and it causes
> problems when this skb is cloned. skb_unclone() doesn't really
> make this skb's flag_list available to change.
> 
> Shuang Li has reported an use-after-free issue because of this
> when creating quite a few macvlan dev over the same dev, where
> the broadcast packets will be cloned and go up to the stack:
  ...
> So fix it by using skb_unshare() instead, which would create a new
> skb for the cloned frag and it'll be safe to change its frag_list.
> The similar things were also done in sctp_make_reassembled_event(),
> which is using skb_copy().
> 
> Reported-by: Shuang Li <shuali@redhat.com>
> Fixes: 37e22164a8a3 ("tipc: rename and move message reassembly function")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
