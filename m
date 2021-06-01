Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F953397BCA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbhFAVge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234747AbhFAVge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 17:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3E0613B4;
        Tue,  1 Jun 2021 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622583292;
        bh=kqnuJdvqpIeAot1ffooo2UK7VmfmnWmuJOhnmB7pOHE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JBz/dV0tsA2sAWPt5ApH1k3KAicOPjy88X0j4W2Xj9ZCN6k5e+JMh6fGGyjF8Xb3Y
         euKnsRkdtTihdnJ0sGQUblOUqdsZ6TnN54gQuSstIzvPXuARMk4Hmq6N1uAxkAzVBD
         a4UxPjQOvmIzZt7T1rJE0OxdEMlQSPODBVK/XWuPmSkqH77v3bdL0HkjbM+ObfP5rH
         UEoenbNOS5F/cYYBy9/JE/6OKPmByrQoJYta/cHvnwv5Qb+y9NbLj0bSZa+vxNixsG
         i9A+JHLGJdjDc3VtEufqUEe0u5HUTCqQMF1HteCrJiKTCn8z631iUHpC0P3WfOqym0
         k8WyZWizSpnOw==
Date:   Tue, 1 Jun 2021 14:34:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Message-ID: <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <20190301120358.7970f0ad@cakuba.netronome.com>
        <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190304174551.2300b7bc@cakuba.netronome.com>
        <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
        <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 15:33:09 +0800 Yunsheng Lin wrote:
> On 2021/6/1 13:37, Jakub Kicinski wrote:
> > On Mon, 31 May 2021 18:36:12 +0800 moyufeng wrote:  
> >> Hi, Jiri & Jakub
> >>
> >>     Generally, a devlink instance is created for each PF/VF. This
> >> facilitates the query and configuration of the settings of each
> >> function. But if some common objects, like the health status of
> >> the entire ASIC, the data read by those instances will be duplicate.
> >>
> >>     So I wonder do I just need to apply a public devlink instance for the
> >> entire ASIC to avoid reading the same data? If so, then I can't set
> >> parameters for each function individually. Or is there a better suggestion
> >> to implement it?  
> > 
> > I don't think there is a great way to solve this today. In my mind
> > devlink instances should be per ASIC, but I never had to solve this
> > problem for a multi-function ASIC.   
> 
> Is there a reason why it didn't have to be solved yet?
> Is it because the devices currently supporting devlink do not have
> this kind of problem, like single-function ASIC or multi-function
> ASIC without sharing common resource?

I'm not 100% sure, my guess is multi-function devices supporting
devlink are simple enough for the problem not to matter all that much.

> Was there a discussion how to solved it in the past?

Not really, we floated an idea of creating aliases for devlink
instances so a single devlink instance could answer to multiple 
bus identifiers. But nothing concrete.

> > Can you assume all functions are in the same control domain? Can they
> > trust each other?  
> 
> "same control domain" means if it is controlled by a single host, not
> by multi hosts, right?
> 
> If the PF is not passed through to a vm using VFIO and other PF is still
> in the host, then I think we can say it is controlled by a single host.
> 
> And each PF is trusted with each other right now, at least at the driver
> level, but not between VF.

Right, the challenge AFAIU is how to match up multiple functions into 
a single devlink instance, when driver has to probe them one by one.
If there is no requirement that different functions are securely
isolated it becomes a lot simpler (e.g. just compare device serial
numbers).
