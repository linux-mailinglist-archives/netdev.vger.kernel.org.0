Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6876F1709B0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 21:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBZUal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 15:30:41 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:46314 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727277AbgBZUal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 15:30:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582749040; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=vlkuDFwc/a9vJiCzz56RDXSwh0BzKKiV+zozwUytWaw=;
 b=oB+GBGW9Mzo8vqbiEzS8eH/A3MIC8r1w3Hg3audKRyIs6yqCEf5rSW01NUNU5IaAQ2WBrQVe
 Mr9eI8ENNkR8tRf3/9xRBo2xakqjDGv8CJhq5gDgHmy3jGleLESUA5YseTf1BOeeEFGlPoOI
 r+XlaQXVqqomVwBsIp0PXK+tT4w=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e56d567.7f1c6757ed18-smtp-out-n02;
 Wed, 26 Feb 2020 20:30:31 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46A15C447A4; Wed, 26 Feb 2020 20:30:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08F0BC43383;
        Wed, 26 Feb 2020 20:30:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Feb 2020 13:30:28 -0700
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 00/10] net: rmnet: fix several bugs
In-Reply-To: <20200226174159.3769-1-ap420073@gmail.com>
References: <20200226174159.3769-1-ap420073@gmail.com>
Message-ID: <781062ea4708aed21d2d94e29fbd63ed@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-26 10:41, Taehee Yoo wrote:
> This patchset is to fix several bugs in RMNET module.
> 
> 1. The first patch fixes NULL-ptr-deref in rmnet_newlink().
> When rmnet interface is being created, it uses IFLA_LINK
> without checking NULL.
> So, if userspace doesn't set IFLA_LINK, panic will occur.
> In this patch, checking NULL pointer code is added.
> 
> 2. The second patch adds module alias.
> In the current rmnet code, there is no module alias.
> So, RTNL couldn't load rmnet module automatically.
> 
> 3. The third patch fixes NULL-ptr-deref in rmnet_changelink().
> To get real device in rmnet_changelink(), it uses IFLA_LINK.
> But, IFLA_LINK should not be used in rmnet_changelink().
> 
> 4. The fourth patch fixes suspicious RCU usage in rmnet_get_port().
> rmnet_get_port() uses rcu_dereference_rtnl().
> But, rmnet_get_port() is used by datapath.
> So, rcu_dereference() should be used instead of rcu_dereference_rtnl().
> 
> 5. The fifth patch fixes suspicious RCU usage in
> rmnet_force_unassociate_device().
> RCU critical section should not be scheduled.
> But, unregister_netdevice_queue() in the 
> rmnet_force_unassociate_device()
> would be scheduled.
> So, the RCU warning occurs.
> In this patch, the rcu_read_lock() in the 
> rmnet_force_unassociate_device()
> is removed because it's unnecessary.
> 
> 6. The sixth patch adds extack error messages when command fails
> When rmnet netlink command fails, it doesn't print any error message.
> So, users couldn't know the exact reason.
> 
> 7. The seventh patch fixes duplicate MUX ID case.
> RMNET MUX ID is unique.
> So, rmnet interface isn't allowed to be created, which have
> a duplicate MUX ID.
> But, only rmnet_newlink() checks this condition, rmnet_changelink()
> doesn't check this.
> So, duplicate MUX ID case would happen.
> 
> 8. The eighth patch fixes upper/lower interface relationship problems.
> When IFLA_LINK is used, the upper/lower infrastructure should be used.
> Because it checks the maximum depth of upper/lower interfaces and it 
> also
> checks circular interface relationship, etc.
> In this patch, netdev_upper_dev_link() is used.
> 
> 9. The ninth patch fixes bridge related problems.
> a) ->ndo_del_slave() doesn't work.
> b) It couldn't detect circular upper/lower interface relationship.
> c) It couldn't prevent stack overflow because of too deep depth
> of upper/lower interface
> d) It doesn't check the number of lower interfaces.
> e) Panics because of several reasons.
> These problems are actually the same problem.
> So, this patch fixes these problems.
> 
> 10. The tenth patch fixes packet forwarding issue in bridge mode
> Packet forwarding is not working in rmnet bridge mode.
> Because when a packet is forwarded, skb_push() for an ethernet header
> is needed. But it doesn't call skb_push().
> So, the ethernet header will be lost.
> 
> Taehee Yoo (10):
>   net: rmnet: fix NULL pointer dereference in rmnet_newlink()
>   net: rmnet: add missing module alias
>   net: rmnet: fix NULL pointer dereference in rmnet_changelink()
>   net: rmnet: fix suspicious RCU usage
>   net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
>   net: rmnet: print error message when command fails
>   net: rmnet: do not allow to change mux id if mux id is duplicated
>   net: rmnet: use upper/lower device infrastructure
>   net: rmnet: fix bridge mode bugs
>   net: rmnet: fix packet forwarding in rmnet bridge mode
> 
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    | 210 +++++++++---------
>  .../ethernet/qualcomm/rmnet/rmnet_config.h    |   3 +-
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |   7 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  20 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   4 +-
>  5 files changed, 122 insertions(+), 122 deletions(-)

Hi Taehee

Thanks for sending the fixes.
I have some minor comments on few of the patches.
