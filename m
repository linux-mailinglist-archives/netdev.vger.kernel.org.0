Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2443F5EDFE7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 17:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbiI1PPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 11:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiI1PPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 11:15:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35E938463
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 08:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3512FCE1EA3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 15:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F2AC433C1;
        Wed, 28 Sep 2022 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664378111;
        bh=lfszzX60ex3VmkV2UqCiJHDGDUnsJjxUomKfRalTkO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jdzzxoX5eLF7MjuXEjOI7Qfs0384X2BpNNGdoAmsG9lUWRdLkvhlx/56FZBho8i80
         5lIJ1z9OYy69f7Fa7kJdwA8sFM78iIiPRczmbLrgsByNXqDEUHZMked6BD4bz+QjK5
         HH/akdlDX/HHGIGgVnVXEn2tmx+VpNIMfv3WHJxidjEW7YJpUPtz7iwWFQAtdXxJLi
         GG7AreEAMGxasGxQ+D+JUDNRpS6XFHWQUgGr1BmdiT3sVM+qzOHPe3GLDZn0jAG7vt
         Wlve3zxr1jXZX8t94q3YyX9AQi4XiGQrfY5usgqNDPi0Vmk+8NK3IiqiI0bZ7gu7AU
         XW2CwsUz9xm9w==
Date:   Wed, 28 Sep 2022 08:15:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     nicolas.dichtel@6wind.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage
 of Netlink flags
Message-ID: <20220928081509.2e169f4d@kernel.org>
In-Reply-To: <60f75b7a-e9c3-ed30-0992-711c7ab23bc1@blackwall.org>
References: <20220927212306.823862-1-kuba@kernel.org>
        <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
        <d93ee260-9199-b760-40fe-f3d61a0af701@6wind.com>
        <e4db8d52-5bbb-8667-86a6-c7a2154598d1@blackwall.org>
        <20220928073709.1b93b74a@kernel.org>
        <60f75b7a-e9c3-ed30-0992-711c7ab23bc1@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 17:46:28 +0300 Nikolay Aleksandrov wrote:
> I like it, can't check right now if we can get into the same issue as with BULK where
> someone is passing unused/wrong flags with the command and we break him though.

So it'd only be effective for new commands, hopefully that's good
enough:

-	if (hdr->cmd >= family->resv_start_op && hdr->reserved)
+	if (hdr->cmd >= family->resv_start_op && genl_header_check(nlh, hdr))

the resv_start_op thing I added in this cycle.

> But I'd bite the bullet and maybe issue an extack msg as well.

Fair point, more tests more magic. I'll add a msg.
