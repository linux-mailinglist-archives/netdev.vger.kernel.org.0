Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA9B35E4B9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhDMRLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhDMRLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 13:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC3C613A9;
        Tue, 13 Apr 2021 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618333856;
        bh=19Oo8r1oTrGSENT9g9BQ+Fqz3X79n7O0E8cOyaHomb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ptn0fDLs92JZ+hAs4hFP+w8JidDG/sTRBUIyIJIip4z5eAplV/BZV6+yK+MW/ysvg
         Z//IA1j4scHAYCEyQx56cOejyvhXAm/sgPjgXL3oG2MYs4xKShJhZKzPzMjhtfQ/82
         am8XFeIl1wfaTzGln1ASDQMfi9c7VKzyBFrBB6w8xr2oTzH6QazgWwYO+OrJP230kh
         EmrRQI03Ppe2mq6Bn4XM2pxrD5OXD7vWKf0/W+9EHruSLq6LfNewfRzlJsMf/RjoRS
         r0E3FXjlrGJfjrjzfcqU6W8eNAbB+PfEnFBHbnXuKqG0La2lWfYd3iarKbm230ADDR
         og0vdyNSgOJSw==
Date:   Tue, 13 Apr 2021 10:10:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Message-ID: <20210413101055.647cc156@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413034817.8924-1-yangbo.lu@nxp.com>
References: <20210413034817.8924-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 11:48:17 +0800 Yangbo Lu wrote:
> +	/* Queue one-step Sync packet if already locked */
> +	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
> +		if (test_and_set_bit_lock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS,
> +					  &priv->flags)) {
> +			skb_queue_tail(&priv->tx_skbs, skb);
> +			return NETDEV_TX_OK;
> +		}
> +	}

Isn't this missing queue_work() as well?

Also as I mentioned I don't understand why you created a separate
workqueue instead of using the system workqueue via schedule_work().
