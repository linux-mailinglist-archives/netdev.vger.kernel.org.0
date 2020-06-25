Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D420A5D6
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406544AbgFYT3r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 15:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403781AbgFYT3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:29:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5C3C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 12:29:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42D89129D591D;
        Thu, 25 Jun 2020 12:29:46 -0700 (PDT)
Date:   Thu, 25 Jun 2020 12:29:45 -0700 (PDT)
Message-Id: <20200625.122945.321093402617646704.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: Re: [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the
 presence of VLAN tags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159308610390.190211.17831843954243284203.stgit@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
        <159308610390.190211.17831843954243284203.stgit@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 12:29:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 25 Jun 2020 13:55:03 +0200

> From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
> 
> CAKE was using the return value of tc_skb_protocol() and expecting it to be
> the IP protocol type. This can fail in the presence of QinQ VLAN tags,
> making CAKE unable to handle ECN marking and diffserv parsing in this case.
> Fix this by implementing our own version of tc_skb_protocol(), which will
> use skb->protocol directly, but also parse and skip over any VLAN tags and
> return the inner protocol number instead.
> 
> Also fix CE marking by implementing a version of INET_ECN_set_ce() that
> uses the same parsing routine.
> 
> Fixes: ea82511518f4 ("sch_cake: Add NAT awareness to packet classifier")
> Fixes: b2100cc56fca ("sch_cake: Use tc_skb_protocol() helper for getting packet protocol")
> Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
> Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
> [ squash original two patches, rewrite commit message ]
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

First, this is a bug fix and should probably be steered to 'net'.

Also, other users of tc_skb_protocol() are almost certainly hitting a
similar problem aren't they?  Maybe fix this generically.

