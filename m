Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428C4F0BB7
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbfKFBkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:40:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730553AbfKFBkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:40:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36673150F9C6C;
        Tue,  5 Nov 2019 17:40:52 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:40:51 -0800 (PST)
Message-Id: <20191105.174051.2132646390435868066.davem@davemloft.net>
To:     jay.vosburgh@canonical.com
Cc:     netdev@vger.kernel.org, zakharov.a.g@yandex.ru,
        zhangsha.zhang@huawei.com, maheshb@google.com, vfalico@gmail.com,
        andy@greyhouse.net
Subject: Re: [PATCH v2 net] bonding: fix state transition issue in link
 monitoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2068.1572670602@famine>
References: <2068.1572670602@famine>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:40:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jay Vosburgh <jay.vosburgh@canonical.com>
Date: Fri, 01 Nov 2019 21:56:42 -0700

> 	 Since de77ecd4ef02 ("bonding: improve link-status update in
> mii-monitoring"), the bonding driver has utilized two separate variables
> to indicate the next link state a particular slave should transition to.
> Each is used to communicate to a different portion of the link state
> change commit logic; one to the bond_miimon_commit function itself, and
> another to the state transition logic.
> 
> 	Unfortunately, the two variables can become unsynchronized,
> resulting in incorrect link state transitions within bonding.  This can
> cause slaves to become stuck in an incorrect link state until a
> subsequent carrier state transition.
> 
> 	The issue occurs when a special case in bond_slave_netdev_event
> sets slave->link directly to BOND_LINK_FAIL.  On the next pass through
> bond_miimon_inspect after the slave goes carrier up, the BOND_LINK_FAIL
> case will set the proposed next state (link_new_state) to BOND_LINK_UP,
> but the new_link to BOND_LINK_DOWN.  The setting of the final link state
> from new_link comes after that from link_new_state, and so the slave
> will end up incorrectly in _DOWN state.
> 
> 	Resolve this by combining the two variables into one.
> 
> Reported-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
> Reported-by: Sha Zhang <zhangsha.zhang@huawei.com>
> Cc: Mahesh Bandewar <maheshb@google.com>
> Fixes: de77ecd4ef02 ("bonding: improve link-status update in mii-monitoring")
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Applied and queued up for -stable, thanks.
