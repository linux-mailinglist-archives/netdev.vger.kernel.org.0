Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3533C74D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhCOUA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233913AbhCOUA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4CDB64E83;
        Mon, 15 Mar 2021 20:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615838429;
        bh=g9Dyxz7ePeJEi4z+MlDgmRhvCOWmlSeMPc6J1OV2yFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qQzj5beyWp8QQlzPyZ+YB1Ua5hSkjgKlIH3NQdF06Ys+vHwx0uxEi2GXJB2UkPznZ
         IwgAaXxSoqatHbBqFiuPwf0vRe1K4ftCYkfzNs9e8nlfh7PEGuatj9raL8N1sDkYxf
         ROAUuIrgo4AuSPL5PXcymvXZ1UcfSsV19GP4GQ/w8xxCMi9hQibsKu1dgLO7Nt++tP
         eLVhk3tpJ50wgZDtHV7ls7g+IY9yVa8jjUm2TX9zR14GMcVFDC1s2Af091GnxiDXZA
         3hhFHtQDM0FvuTQVtC9pIqFM7N927FG957fS//AZ4benosZ5pul7Kadtq1mq8/VvdJ
         DJHx+UNc+84SA==
Date:   Mon, 15 Mar 2021 13:00:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 5/9] net: hns3: refactor flow director
 configuration
Message-ID: <20210315130027.669b8afa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615811031-55209-6-git-send-email-tanhuazhong@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
        <1615811031-55209-6-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 20:23:47 +0800 Huazhong Tan wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> Currently, there are 3 flow director work modes in HNS3 driver,
> include EP(ethtool), tc flower and aRFS. The flow director rules
> are configured synchronously and need holding spin lock. With this
> limitation, all the commands with firmware are also needed to use
> spin lock.
> 
> To eliminate the limitation, configure flow director rules
> asynchronously. The rules are still kept in the fd_rule_list
> with below states.
> TO_ADD: the rule is waiting to add to hardware
> TO_DEL: the rule is waiting to remove from hardware
> ADDING: the rule is adding to hardware
> ACTIVE: the rule is already added in hardware
> 
> When receive a new request to add or delete flow director rule,
> check whether the rule location is existent, update the rule
> content and state, and request to schedule the service task to
> finish the configuration.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

How is the application supposed to know if the ethtool rule was already
installed or installation is still pending?

With the firmware bloat on all devices this sort of async mechanism
seems to be popping up in more and more drivers but IMHO we shouldn't
weaken the semantics without amending the kernel <> user space API.
