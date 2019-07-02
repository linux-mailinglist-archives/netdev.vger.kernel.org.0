Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1375D954
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfGCAkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:40:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfGCAkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:40:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 539BB13FE98F8;
        Tue,  2 Jul 2019 15:08:15 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:08:11 -0700 (PDT)
Message-Id: <20190702.150811.1940085234903099096.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] tipc: use rcu dereference functions properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <07e0518ac689f5919890a38634df38edf95d34a1.1562000095.git.lucien.xin@gmail.com>
References: <07e0518ac689f5919890a38634df38edf95d34a1.1562000095.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:08:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  2 Jul 2019 00:54:55 +0800

> For these places are protected by rcu_read_lock, we change from
> rcu_dereference_rtnl to rcu_dereference, as there is no need to
> check if rtnl lock is held.
> 
> For these places are protected by rtnl_lock, we change from
> rcu_dereference_rtnl to rtnl_dereference/rcu_dereference_protected,
> as no extra memory barriers are needed under rtnl_lock() which also
> protects tn->bearer_list[] and dev->tipc_ptr/b->media_ptr updating.
> 
> rcu_dereference_rtnl will be only used in the places where it could
> be under rcu_read_lock or rtnl_lock.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

In the cases where RTNL is held, even if rcu_read_lock() is also taken,
we should use rtnl_dereference() because that avoids the READ_ONCE().
