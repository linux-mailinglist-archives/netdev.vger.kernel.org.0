Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E06D2F89C3
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbhAPAIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbhAPAIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 19:08:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D20C923A01;
        Sat, 16 Jan 2021 00:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610755645;
        bh=yYr2q7lNAq/q/Obg++NQkrKqBVKTH2282wttNpy5bM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OiR5cD0oCTw30+tm55FACqWBQc8Tq5JCFpac9JbwqQM/dgPzt34V+hCcsgCs1p9P5
         BYiKibSThr8u+d5Ac6ViitpJjlqMsewFTcEhEycsGtXxP/Q34wm58tNrzBVlY4Y6Fa
         oOjDJ+WT85Nn9Fnm4UWhufxz24HiXkTOwjAtc1csTNfyocrHqKY9yoazMuSqk1+xFD
         VdRlN6h3tJcSHSsdh+auZ3GtzXOv4xwyttgDQt81KKo5vn3GyA1Tiap6NKTSJNXfcz
         Mi7CnKxrNQUHv8FvsGeFYUpHBygUqgSoK+DKa1ZKNLPL74bgiS7nhnDdgfh0XGbrHL
         xuxVZAN02rA0A==
Date:   Fri, 15 Jan 2021 16:07:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net 1/2] net: introduce CAN specific pointer in the
 struct net_device
Message-ID: <20210115160723.7abd75ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115143036.31275-1-o.rempel@pengutronix.de>
References: <20210115143036.31275-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 15:30:35 +0100 Oleksij Rempel wrote:
> Since 20dd3850bcf8 ("can: Speed up CAN frame receiption by using
> ml_priv") the CAN framework uses per device specific data in the AF_CAN
> protocol. For this purpose the struct net_device->ml_priv is used. Later
> the ml_priv usage in CAN was extended for other users, one of them being
> CAN_J1939.
> 
> Later in the kernel ml_priv was converted to an union, used by other
> drivers. E.g. the tun driver started storing it's stats pointer.
> 
> Since tun devices can claim to be a CAN device, CAN specific protocols
> will wrongly interpret this pointer, which will cause system crashes.
> Mostly this issue is visible in the CAN_J1939 stack.
> 
> To fix this issue, we request a dedicated CAN pointer within the
> net_device struct.

No strong objection, others already added their pointers, but 
I wonder if we can't save those couple of bytes by adding a
ml_priv_type, to check instead of dev->type? And leave it 0
for drivers using stats?

That way other device types which are limited by all being 
ARPHDR_ETHER can start using ml_priv as well?

> +#if IS_ENABLED(CONFIG_CAN)
> +	struct can_ml_priv	*can;
> +#endif

Perhaps put it next to all the _ptr fields?
