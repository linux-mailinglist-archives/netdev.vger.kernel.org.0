Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2DB24A9E3
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHSXWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSXWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 19:22:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A7C061757;
        Wed, 19 Aug 2020 16:22:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7631511E4576A;
        Wed, 19 Aug 2020 16:06:02 -0700 (PDT)
Date:   Wed, 19 Aug 2020 16:22:47 -0700 (PDT)
Message-Id: <20200819.162247.527509541688231611.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        kuba@kernel.org, alexei.starovoitov@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net v6] net: xdp: account for layer 3 packets in
 generic skb handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815074102.5357-1-Jason@zx2c4.com>
References: <20200814.135546.2266851283177227377.davem@davemloft.net>
        <20200815074102.5357-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 16:06:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 15 Aug 2020 09:41:02 +0200

> A user reported that packets from wireguard were possibly ignored by XDP
> [1]. Another user reported that modifying packets from layer 3
> interfaces results in impossible to diagnose drops.

Jason this really is a minefield.

If you make everything look like ethernet, even when it isn't, that is
a huge pile of worms.

If the XDP program changes the fake ethernet header's protocol field,
what will update the next protocol field in the wireguard
encapsulation headers so that it matches?

How do you support pushing VLAN headers as some XDP programs do?  What
will undo the fake ethernet header and push the VLAN header into the
right place, and set it's next protocol field correctly?

And so on, and so forth...

With so many unanswered questions and unclear semantics the only
reasonable approach right now is to reject L3 devices from having XDP
programs attached at this time.

Arguably the best answer is the hardest answer, which is that we
expose device protocols and headers exactly how they are and don't try
to pretend they are something else.  But it really means that XDP
programs have to be written targetted to the attach point device type.
And it also means we need a way to update skb->protocol properly,
handle the pushing of new headers, etc.

In short, you can't just push a fake ethernet header and expect
everything to just work.
