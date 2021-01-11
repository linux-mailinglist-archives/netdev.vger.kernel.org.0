Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652D12F24E5
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405324AbhALAZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390487AbhAKWol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 17:44:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D2B22D04;
        Mon, 11 Jan 2021 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610405041;
        bh=cZ6VsNQt5c5aYDYyx+tzt8oHFWLq65k2Zpz//p/EgX0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MIQQ9DJp2oa7YQF0GjAOB1yDBjijpAr9pVEBA5Scz24QOkDN5+n7IVZ8kMxJv4Y57
         2WI5DAmDQmnkxVEBUxcZsxCzkJV0BI/Ous0dZHadORaEOejN6C6ErLa21HW/1IJ6YO
         m7PJMwDrI62sKmY9kDLepmY68TuyFUw81Fb16bCk0N79RtBWCo3aTjmqsnPPzonXfZ
         7LGb8jMLVK5S8As90xq7Z95ADVTZHNkysk2MbPcaTr6vJP1UWbT6YoLwXyh1kotDkc
         eFBt/kOtON9zo753e7X7SfqO6kTqOZIQxc8ZDAGvKup+WtJFP6LCoHXYDtSnYSM2UJ
         NWg3clw9lVzGA==
Message-ID: <91eabb20de91a45a89a123746945fb586262bcfe.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 08/15] net: allow ndo_get_stats64 to return
 an int error code
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Mon, 11 Jan 2021 14:43:59 -0800
In-Reply-To: <20210109172624.2028156-9-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-9-olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some drivers need to do special tricks to comply with the new policy
> of
> ndo_get_stats64 being sleepable. For example, the bonding driver,
> which
> derives its stats from its lower interfaces, must recurse with
> dev_get_stats into its lowers with no locks held. But for that to
> work,
> it needs to dynamically allocate some memory for a refcounted copy of
> its array of slave interfaces (because recursing unlocked means that
> the
> original one is subject to disappearing). And since memory allocation
> can fail under pressure, we should not let it go unnoticed, but
> instead
> propagate the error code.
> 
> This patch converts all implementations of .ndo_get_stats64 to return
> int, and propagates that to the dev_get_stats calling site. Error
> checking will be done in further patches.
> 
> 

My only concern about this patch is userland apps who never expected
this to fail, they might crash when this eventually returns an err
under stress, so maybe for user facing APIs,
always return 0? mainly it is procfs, others netlink/sysfs might
already fail for other reasons, i think ..






