Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87F26ACD5
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgIOTAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727637AbgIOTA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 15:00:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E761E206A2;
        Tue, 15 Sep 2020 19:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600196428;
        bh=kG4SBxBUMbKR7Td7+QWH0A/2VOsHN2v6DsK+67l9AvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jpy6qNl5jnh7HwZku0urEhkSIQ9X0P6pKWFMNxOZdWVfCJAr7a2YcSkhZfBoz2ajG
         9XiTuNceazMTgET3HV8ikKfqWLp0QO61wwmOkLCUIUOuIW1pafCMfbq5E8MaqdsPQn
         N9PEHg1QmXdkuZwgCi78m/+x4ePIu85UyeKfCw7w=
Date:   Tue, 15 Sep 2020 12:00:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200915120025.0858e324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1dfa16c8-8bb6-a429-6644-68fd94fc2830@intel.com>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
        <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
        <7e44037cedb946d4a72055dd0898ab1d@intel.com>
        <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
        <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4b5e3547f3854fd399b26a663405b1f8@intel.com>
        <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
        <20200915103913.46cebf69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dfa16c8-8bb6-a429-6644-68fd94fc2830@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 11:44:07 -0700 Jacob Keller wrote:
> Exactly how I saw it.
> 
> Basically, the timeout should take effect as long as the (component,
> msg) pair stays the same.
> 
> So if you send percentage reports with the same message and component,
> then the timeout stays in effect. Once you start a new message, then the
> timeout would be reset.

I don't think I agree with that. As I said that'd make the timeout not
match the reality of what happens in the driver.

Say I have 4 updates (every 25%) each has a timeout of 30 seconds.
If I understand what you're saying correctly you'd set a timeout of 
2 min for the operation. But if first two chunks finish in 10 seconds,
and 3rd one timeouts out the timeout will happen (in the driver) when
the user-visible timer is at (50sec / 2 min). 

I think that each notification should update the timeout. And like
systemd we should not display the timeout counter in the first, say 5
seconds to minimize the display noise.

> We could in theory provide both a "timeout" and "time elapsed" field,
> which would allow the application to draw the timeout at an abitrary
> point. Then it could progress the time as normal if it hasn't received a
> new message yet, allowing for consistent screen updates...

I'm not sure I follow this part.

> But I think that might be overkill. For the cases where we do get some
> sort of progress, then the percentage update is usually enough.
