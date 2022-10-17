Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06066017FA
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiJQTqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiJQTqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:46:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7174A7284D
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0950FB81A3C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 19:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ACDC433C1;
        Mon, 17 Oct 2022 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666035956;
        bh=AcQUpxtomyyBbwP96ZnJXZrZYKpLsZxOyq8tfXpGi3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m1/7O1XpNrpBR75siE1KA1U0ocNX/wrff4PAtRqQBfTbe49ds5CGtDObqxLPDXqjA
         hI7XpPBsq5Ql7vEwcW9SObcApm0aSpVV3uQ+1rA3lL5iAJhM9JHYqviG3PwoBteWat
         7JPqe6reGzcJpPjRso8dQ4OurhYlRRvHNG4S6m9hdhlHkUGY185sy4A/ZMxbfP0EYu
         DxdUxnI6xf5+U4o9oCuIffRhtA9sb5DLt95XwiKYl2buSUQTpCl7LdglN5hFxYPRoX
         qUx6IJS+DR7preaLroNcNAQmjviMgWFIFZI7ut6MSDvxIO6BrNh8A4Hpshvo5ObTfb
         r7lt5pHtTouNg==
Date:   Mon, 17 Oct 2022 12:45:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [net-queue bugfix RFC] i40e: Clear IFF_RXFH_CONFIGURED when RSS
 is reset
Message-ID: <20221017124555.5d79d3f7@kernel.org>
In-Reply-To: <1665701671-6353-1-git-send-email-jdamato@fastly.com>
References: <1665701671-6353-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 15:54:31 -0700 Joe Damato wrote:
> Before this change, reconfiguring the queue count using ethtool doesn't
> always work, even for queue counts that were previously accepted because
> the IFF_RXFH_CONFIGURED bit was not cleared when the flow indirection hash
> is cleared by the driver.

It's not cleared but when was it set? Could you describe the flow that
gets us to this set a bit more?

Normally clearing the IFF_RXFH_CONFIGURED in the driver is _only_
acceptable on error recovery paths, and should come with a "this should
never happen" warning.

> For example:
> 
> $ sudo ethtool -x eth0
> RX flow hash indirection table for eth0 with 34 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:     16    17    18    19    20    21    22    23
>    24:     24    25    26    27    28    29    30    31
>    32:     32    33     0     1     2     3     4     5
> [...snip...]
> 
> As you can see, the flow indirection hash distributes flows to 34 queues.
> 
> Increasing the number of queues from 34 to 64 works, and the flow
> indirection hash is reset automatically:
> 
> $ sudo ethtool -L eth0 combined 64
> $ sudo ethtool -x eth0
> RX flow hash indirection table for eth0 with 64 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:     16    17    18    19    20    21    22    23
>    24:     24    25    26    27    28    29    30    31
>    32:     32    33    34    35    36    37    38    39
>    40:     40    41    42    43    44    45    46    47
>    48:     48    49    50    51    52    53    54    55
>    56:     56    57    58    59    60    61    62    63

This is odd, if IFF_RXFH_CONFIGURED is set driver should not
re-initialize the indirection table. Which I believe is what
you describe at the end of your message:

> But, I can increase the queue count and the flow hash is preserved:
> 
> $ sudo ethtool -L eth0 combined 64
> $ sudo ethtool -x eth0
> RX flow hash indirection table for eth0 with 64 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:     16    17    18    19     0     1     2     3
