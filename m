Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE891608EC
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgBQD33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:29:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgBQD33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:29:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5A69157413F9;
        Sun, 16 Feb 2020 19:29:28 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:29:28 -0800 (PST)
Message-Id: <20200216.192928.1291469951934245769.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix application of verbose no_mask bitset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215005553.4D202E03D6@unicorn.suse.cz>
References: <20200215005553.4D202E03D6@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:29:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Sat, 15 Feb 2020 01:55:53 +0100 (CET)

> A bitset without mask in a _SET request means we want exactly the bits in
> the bitset to be set. This works correctly for compact format but when
> verbose format is parsed, ethnl_update_bitset32_verbose() only sets the
> bits present in the request bitset but does not clear the rest. This can
> cause incorrect results like
> 
>   lion:~ # ethtool eth0 | grep Wake
>           Supports Wake-on: pumbg
>           Wake-on: g
>   lion:~ # ethtool -s eth0 wol u
>   lion:~ # ethtool eth0 | grep Wake
>           Supports Wake-on: pumbg
>           Wake-on: ug
> 
> when the second ethtool command issues request
> 
> ETHTOOL_MSG_WOL_SET
>     ETHTOOL_A_WOL_HEADER
>         ETHTOOL_A_HEADER_DEV_NAME = "eth0"
>     ETHTOOL_A_WOL_MODES
>         ETHTOOL_A_BITSET_NOMASK
>         ETHTOOL_A_BITSET_BITS
>             ETHTOOL_A_BITSET_BITS_BIT
>                 ETHTOOL_BITSET_BIT_INDEX = 1
> 
> Fix the logic by clearing the whole target bitmap before we start iterating
> through the request bits.
> 
> Fixes: 10b518d4e6dd ("ethtool: netlink bitset handling")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks Michal.
