Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9E5637166
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKXELn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKXELl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:11:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBE4C6609;
        Wed, 23 Nov 2022 20:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78DD6B8265D;
        Thu, 24 Nov 2022 04:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0DEC433C1;
        Thu, 24 Nov 2022 04:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669263098;
        bh=d38UzBrd1Z7JsGryD1vGl6ucTPkA9qVzd7sejTB4W8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nMb7zHi+1xAADl7UrDquy2ReIUIsp/SIZVNWsb/H2vZmpxNa8tode3cWPkQRhwlB8
         JJ3TbAB+dQFw2MA9yrjfwLzfAM5JlAFW6pcMkWzbgj8VEKHV5iLuHMePYK8wG9A9rY
         qWYYO4An42o4jNhIIU4pxEC/TV/gqnUMn72RJfbv+PuIoNMpO4/idCwKBFG17y8RDL
         9Oorhs+2vJn8wQ7zcgnCNFrw5++YVDWaKVyQzRJrCFkq56a+YlSJ1TUKXH4bUMP5s7
         dOVYmQBdKMOniGYGz0yODaSb/IxGF/+qQPaG0v9ERkXd6rcGSqEAHyeKgtvS0TLvpv
         TBMXr3RRIcbHw==
Date:   Wed, 23 Nov 2022 20:11:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v3] ethtool: avoiding integer overflow in
 ethtool_phys_id()
Message-ID: <20221123201136.232ed8e7@kernel.org>
In-Reply-To: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
References: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022 15:29:01 +0300 Maxim Korotkov wrote:
> The value of an arithmetic expression "n * id.data" is subject
> to possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>

Applying to net-next, pretty sure nobody expects us to support blinking
an LED 4 billion times, at a rate low enough for a human eye to see...
But let's watch the stable bots pick it up anyway.
