Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B3C25A133
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgIAWKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgIAWKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:10:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66278C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:10:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88C25136564DD;
        Tue,  1 Sep 2020 14:53:44 -0700 (PDT)
Date:   Tue, 01 Sep 2020 15:10:28 -0700 (PDT)
Message-Id: <20200901.151028.670408362469941141.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v2 1/4] tipc: optimize key switching time and logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831083817.3611-2-tuong.t.lien@dektech.com.au>
References: <20200831083817.3611-1-tuong.t.lien@dektech.com.au>
        <20200831083817.3611-2-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 14:53:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Mon, 31 Aug 2020 15:38:14 +0700

> We reduce the lasting time for a pending TX key to be active as well as
> for a passive RX key to be freed which generally helps speed up the key
> switching. It is not expected to be too fast but should not be too slow
> either. Also the key handling logic is simplified that a pending RX key
> will be removed automatically if it is found not working after a number
> of times; the probing for a pending TX key is now carried on a specific
> message user ('LINK_PROTOCOL' or 'LINK_CONFIG') which is more efficient
> than using a timer on broadcast messages, the timer is reserved for use
> later as needed.
> 
> The kernel logs or 'pr***()' are now made as clear as possible to user.
> Some prints are added, removed or changed to the debug-level. The
> 'TIPC_CRYPTO_DEBUG' definition is removed, and the 'pr_debug()' is used
> instead which will be much helpful in runtime.
> 
> Besides we also optimize the code in some other places as a preparation
> for later commits.
> 
> This commit does not change the en/decryption functionalities.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Random log messages in response to user config requests are
inappropriate especially with netlink.

Report such informational responses to errors using the
genl_info->extack instead, as is standard practice across
the entire kernel.

Please remove all kernel log messages that get emitted due to
netlink operations and use extack notifications instead.

I also disagree with the commit message stating:

	This commit does not change the en/decryption functionalities.

You are changing timer lengths and other aspects of crypto behavior,
so the patch is in fact changing things.
