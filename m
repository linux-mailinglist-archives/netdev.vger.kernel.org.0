Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87768265032
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgIJUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgIJUAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:00:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF17C0613ED
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:00:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBC8B12A35488;
        Thu, 10 Sep 2020 12:44:01 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:00:47 -0700 (PDT)
Message-Id: <20200910.130047.2058654522640662791.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     khc@pm.waw.pl, kuba@kernel.org, netdev@vger.kernel.org,
        security@kernel.org, whutchennan@gmail.com, greg@kroah.com
Subject: Re: [PATCH v2 net] hdlc_ppp: add range checks in ppp_cp_parse_cr()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909094648.GC420136@mwanda>
References: <CAMnVd19nWToENW3X7v_PZN4snoXAoLgqKqn=dezXnd=z89zL7Q@mail.gmail.com>
        <20200909094648.GC420136@mwanda>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:44:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 9 Sep 2020 12:46:48 +0300

> There are a couple bugs here:
> 1) If opt[1] is zero then this results in a forever loop.  If the value
>    is less than 2 then it is invalid.
> 2) It assumes that "len" is more than sizeof(valid_accm) or 6 which can
>    result in memory corruption.
> 
> In the case of LCP_OPTION_ACCM, then  we should check "opt[1]" instead
> of "len" because, if "opt[1]" is less than sizeof(valid_accm) then
> "nak_len" gets out of sync and it can lead to memory corruption in the
> next iterations through the loop.  In case of LCP_OPTION_MAGIC, the
> only valid value for opt[1] is 6, but the code is trying to log invalid
> data so we should only discard the data when "len" is less than 6
> because that leads to a read overflow.
> 
> Reported-by: ChenNan Of Chaitin Security Research Lab  <whutchennan@gmail.com>
> Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v2: check opt[1] < 6 instead of len < 6 for the LCP_OPTION_ACCM case.

Applied and queued up for -stable, thanks Dan.
