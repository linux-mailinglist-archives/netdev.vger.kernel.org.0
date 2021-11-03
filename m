Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1F44460C
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhKCQlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhKCQlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51C076103B;
        Wed,  3 Nov 2021 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635957524;
        bh=LTvKT4L16N9jCnuM9BZtU78iuPa4pEylaVkfbD7/bds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mBcW9ImrTOCGdoNgCSP+E0Gtz5DWSwJzwHYyue20scqQeAUyjVbiJ9wuLai8JSU8R
         d9wy4e89GPbdNhKlfz4kh9NqZAXw23Izjcm77bjPxivAJA1ZJdpE0c6/pp913UFC7B
         rTT3bCmyTKqcBDVaVmvEDrA+qHxrjpyTKk1+xQVhlOS7lnmGV0M7JqktKMNolutQQ9
         QFCzi7B4VkXZuEc2/OJPd2suzv9qQUcRCd4wI+YuOSIr4JQLE4+IB+d1oZ0LKFkuRY
         oL66WaxEqyyNoyWy+uH+QADGSFyzrVodQIWPqJ7o6ZCUasxg4J/SevcGBUJrKpBvoQ
         Onvs7DyM5DEFA==
Date:   Wed, 3 Nov 2021 09:38:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Is it ok for switch TCAMs to depend on the bridge state?
Message-ID: <20211103093843.200fc421@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
References: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 11:03:53 +0000 Vladimir Oltean wrote:
> I don't have a clear picture in my mind about what is wrong. An airplane
> viewer might argue that the TCAM should be completely separate from the
> bridging service, but I'm not completely sure that this can be achieved
> in the aforementioned case with VLAN rewriting on ingress and on egress,
> it would seem more natural for these features to operate on the
> classified VLAN (which again, depends on VLAN awareness being turned on).
> Alternatively, one might argue that the deletion of a bridge interface
> should be vetoed, and so should the removal of a port from a bridge.
> But that is quite complicated, and doesn't answer questions such as
> "what should you do when you reboot".
> Alternatively, one might say that letting the user remove TCAM
> dependencies from the bridging service is fine, but the driver should
> have a way to also unoffload the tc-flower keys as long as the
> requirements are not satisfied. I think this is also difficult to
> implement.

Some random thoughts which may be completely nonsensical.

I thought we do have a way of indicating that flower rules are no
longer offloaded because tunnel rules need neigh to be resolved, 
but looking at the code it seems we only report some semblance of
offload status as part of stats.

For port removal maybe we can add a callback just for vetoing in case
the operation originates from user space?
