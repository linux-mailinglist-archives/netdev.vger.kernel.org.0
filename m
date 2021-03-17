Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F4D33F829
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhCQScs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhCQScQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 127A764F5E;
        Wed, 17 Mar 2021 18:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616005936;
        bh=5HCaUIAS4At51sMGbk1p/gfrBxEz6C4ZacDUltVwV/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AeJa8d8PNhSmi0jiXvcMe0dGGq3mwwt6PqM0Xm7P+s7vzpQjbuMtLS5XKNb0HNfZO
         okfJxAWlzCNLrPyBG1uwu2WNaod0CEGyW9fRnOvdCap0ljGmfBVNyaP3peiKpg/1yJ
         CaH2PJAFk7clsNG7Iaok2Bl4jVbaeMJRp2SWtNNqmTtQPvvS6GMLURbxrxeIDkYcv0
         PLrNYK+GF95R2UHDGErmr/+J5MUSnWNQd6oIcnD5LBnSP5OLpDv7eB1Mt/g8Raa8Yn
         e1jUxL2cjAJB/4mPQCFdN/Z8TrGAqdgZR+iuwpskRMdSr8YLcqX4AMkC2YMAGpmI+y
         +XnVfuOOL03pQ==
Date:   Wed, 17 Mar 2021 11:32:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 5/9] net: hns3: refactor flow director
 configuration
Message-ID: <20210317113215.10437c2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cbedbd4d-f293-3733-f86e-65f434a09e82@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
        <1615811031-55209-6-git-send-email-tanhuazhong@huawei.com>
        <20210315130027.669b8afa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cbedbd4d-f293-3733-f86e-65f434a09e82@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 09:47:45 +0800 Huazhong Tan wrote:
> On 2021/3/16 4:00, Jakub Kicinski wrote:
> > On Mon, 15 Mar 2021 20:23:47 +0800 Huazhong Tan wrote:  
> >> From: Jian Shen <shenjian15@huawei.com>
> >>
> >> Currently, there are 3 flow director work modes in HNS3 driver,
> >> include EP(ethtool), tc flower and aRFS. The flow director rules
> >> are configured synchronously and need holding spin lock. With this
> >> limitation, all the commands with firmware are also needed to use
> >> spin lock.
> >>
> >> To eliminate the limitation, configure flow director rules
> >> asynchronously. The rules are still kept in the fd_rule_list
> >> with below states.
> >> TO_ADD: the rule is waiting to add to hardware
> >> TO_DEL: the rule is waiting to remove from hardware
> >> ADDING: the rule is adding to hardware
> >> ACTIVE: the rule is already added in hardware
> >>
> >> When receive a new request to add or delete flow director rule,
> >> check whether the rule location is existent, update the rule
> >> content and state, and request to schedule the service task to
> >> finish the configuration.
> >>
> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>  
> > How is the application supposed to know if the ethtool rule was already
> > installed or installation is still pending?  
> 
> 
> Yes, it's unable for the application to know whether pending or installed.
> 
> The primitive motivation is to move out the aRFS rule configuration from
> IO path. To keep consistent, so does the ethtool way. We thought
> of it before, considered that the time window between the two state is
> very small.
> 
> How about keep aRFS asynchronously, and the ethtool synchronously?

That'd be fine by me.
