Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65911708EB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgBZT2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:28:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60302 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgBZT2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 14:28:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E73815AA762A;
        Wed, 26 Feb 2020 11:28:39 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:28:38 -0800 (PST)
Message-Id: <20200226.112838.716163849297775455.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: limit bitset size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224194212.426B4E1E06@unicorn.suse.cz>
References: <20200224194212.426B4E1E06@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 11:28:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon, 24 Feb 2020 20:42:12 +0100 (CET)

> Syzbot reported that ethnl_compact_sanity_checks() can be tricked into
> reading past the end of ETHTOOL_A_BITSET_VALUE and ETHTOOL_A_BITSET_MASK
> attributes and even the message by passing a value between (u32)(-31)
> and (u32)(-1) as ETHTOOL_A_BITSET_SIZE.
> 
> The problem is that DIV_ROUND_UP(attr_nbits, 32) is 0 for such values so
> that zero length ETHTOOL_A_BITSET_VALUE will pass the length check but
> ethnl_bitmap32_not_zero() check would try to access up to 512 MB of
> attribute "payload".
> 
> Prevent this overflow byt limiting the bitset size. Technically, compact
> bitset format would allow bitset sizes up to almost 2^18 (so that the
> nest size does not exceed U16_MAX) but bitsets used by ethtool are much
> shorter. S16_MAX, the largest value which can be directly used as an
> upper limit in policy, should be a reasonable compromise.
> 
> Fixes: 10b518d4e6dd ("ethtool: netlink bitset handling")
> Reported-by: syzbot+7fd4ed5b4234ab1fdccd@syzkaller.appspotmail.com
> Reported-by: syzbot+709b7a64d57978247e44@syzkaller.appspotmail.com
> Reported-by: syzbot+983cb8fb2d17a7af549d@syzkaller.appspotmail.com
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks Michal.
