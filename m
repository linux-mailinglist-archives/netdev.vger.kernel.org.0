Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159A9358942
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhDHQHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhDHQHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D16610F8;
        Thu,  8 Apr 2021 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617898029;
        bh=6xSvq358QScbMjwh9tjTXxeSHn5zPdkEtj+4PPV3Pbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XMVTb/oUIvmY+Ev4zhZHlu6a21a6eBrrJfQYsPGLj4cGXdx7OYcH13fXVHm08I0Cp
         ORbnROfNEzK3Bsri3O2RzhyGCjTSh8K2tFCfuvi0mqxTS2GaAcNduYCXm11wY2Khqi
         ++jAaHQE3A1Or73zxg1Mtt7dloGFjYjNT4klIuYSQ9N0gsTBlspUKj0viXOx04wf3a
         NIv7NO5xH8qAGszPDxHM0UAzcrnhryd6G9jeGX+RdljEot9M1VZZj7tMjLgCq5btsy
         85zoQm8YvCXIhwmo/0VBR6gixGwFTXq31qq3c/kBocuBk3mVu0ak3wu05pnukOdu1g
         y4Tej17YL41GQ==
Date:   Thu, 8 Apr 2021 09:07:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Message-ID: <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
        <20210408111350.3817-3-yangbo.lu@nxp.com>
        <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Apr 2021 09:02:50 -0700 Jakub Kicinski wrote:
> 		if (priv->flags & ONESTEP_BUSY) {
> 			skb_queue_tail(&priv->tx_skbs, skb);
> 			return ...;
> 		}
> 		priv->flags |= ONESTEP_BUSY;

Ah, if you have multiple queues this needs to be under a separate
spinlock, 'cause netif_tx_lock() won't be enough.
