Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E603DE0BC
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhHBUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHBUcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F4160D07;
        Mon,  2 Aug 2021 20:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627936352;
        bh=7Omv5X3Y5yxWtYvKeuj6gzKo2AOy6KsbmDol1EN2zbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cA3Zk9hkCToaUg0zm9Es4aHNDzwrtmj0F9dFDoYejpNrAZL6G4EcwcrDmhLK1ym1w
         kEhalschuUFLdwQqZsTV6EIVz4NVF93syTVMxY5/lb5JZAwSdazHKqcdSsKJ/HGEZf
         /69fKF19AEWyyMpxb7catLPAuqgJwXnS7O7fRk8+m8p9iOwrih7A1fSdqNtgqJ6Xfv
         POAbG8c5k//sbYcTgXZBPKMHZ4jHpr0FHXDdINNJX8WgsrBdE1fT/YIRekkhe1jev+
         Jl4Pg0c7GvnlhakMGitXFndsnWXg9tUd8/iUewyak873rUXmP179OSFh/gSPsD24Se
         3JDssKIJ0X19A==
Date:   Mon, 2 Aug 2021 13:32:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: fec: fix MAC internal delay doesn't work
Message-ID: <20210802133230.1a17ac4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730114709.12385-1-qiangqing.zhang@nxp.com>
References: <20210730114709.12385-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 19:47:09 +0800 Joakim Zhang wrote:
> @@ -3806,6 +3827,10 @@ fec_probe(struct platform_device *pdev)
>  		fep->phy_interface = interface;
>  	}
>  
> +	ret = fec_enet_parse_rgmii_delay(fep, np);
> +	if (ret)
> +		goto failed_phy;

You're jumping to the wrong label, it looks like phy_node needs to be
released at this point.
