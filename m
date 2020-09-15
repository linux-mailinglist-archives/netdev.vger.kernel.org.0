Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FEE26B205
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgIOWjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbgIOQKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 12:10:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82522074B;
        Tue, 15 Sep 2020 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600185615;
        bh=HcglYP6i3X/ou3K6aehXVB4kBv5QYxbOuM6aUd5L0tk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pQX3ujv7wFa/f3nVynTuYqqaEGWbi5SRTW5Q6IxlmLmQERlv2kVDYsZG0RqjcRwac
         CDiJKaQRcDC21gYI7x5rlK6pwVXEq72zpOUdxsraJykwYjg9pIb9DxLaf8nFMddW51
         r977PG7SW0gEVpEHw8KsdASYmX+YWpSjyAj7c+Zw=
Date:   Tue, 15 Sep 2020 09:00:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200915090013.141163e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <777fd1b8-1262-160e-a711-31e5f6e2c37c@nvidia.com>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
        <1600063682-17313-2-git-send-email-moshe@mellanox.com>
        <20200914143306.4ab0f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <777fd1b8-1262-160e-a711-31e5f6e2c37c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 15:56:48 +0300 Moshe Shemesh wrote:
> On 9/15/2020 12:33 AM, Jakub Kicinski wrote:
> >> +     if (err)
> >> +             return err;
> >> +
> >> +     WARN_ON(!actions_performed);
> >> +     msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >> +     if (!msg)
> >> +             return -ENOMEM;
> >> +
> >> +     err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
> >> +                                                    DEVLINK_CMD_RELOAD, info->snd_portid,
> >> +                                                    info->snd_seq, 0);
> >> +     if (err) {
> >> +             nlmsg_free(msg);
> >> +             return err;
> >> +     }
> >> +
> >> +     return genlmsg_reply(msg, info);  
> > I think generating the reply may break existing users. Only generate
> > the reply if request contained DEVLINK_ATTR_RELOAD_ACTION (or any other
> > new attribute which existing users can't pass).  
> 
> OK, I can do that. But I update stats and generate devlink notification 
> anyway, that should fine, right ?

Yes, that should be fine.

