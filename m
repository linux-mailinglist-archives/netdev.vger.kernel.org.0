Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3306D20A86F
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407604AbgFYWzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 18:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405903AbgFYWzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 18:55:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1F1206FA;
        Thu, 25 Jun 2020 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593125712;
        bh=1M84izxG9rf48VE0J5VlhFFSgEO7MLiYcJc0ojtXnRk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jlWH8tKytyk91plxASken5z1UkZLZs4FqKWMOQtPhLKFlNzcmeLOxxXSQKk6zkpQT
         kFzw6U3EWqzSGYXJHH4XefxoHPMJGj/8z1Y8noFO/BQAJ3l9BFjrvfsOp3XhO2vOND
         PSBCkTiNhH15+m/RlrRyZ4NZ9tl1wTNd6A4ud6Qk=
Date:   Thu, 25 Jun 2020 15:55:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
Message-ID: <20200625155510.01e3c1c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 17:28:40 +0530 Rahul Lakkireddy wrote:
> This series of patches add support to mirror all ingress traffic
> for TC-MATCHALL ingress offload.
> 
> Patch 1 adds support to dynamically create a mirror Virtual Interface
> (VI) that accepts all mirror ingress traffic when mirror action is
> set in TC-MATCHALL offload.
> 
> Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
> mirror VI.
> 
> Patch 3 adds support to replicate all the main VI configuration to
> mirror VI. This includes replicating MTU, promiscuous mode,
> all-multicast mode, and enabled netdev Rx feature offloads.

Could you say more about this mirror VI? Is this an internal object
within the NIC or something visible to the user?

Also looking at the implementation of redirect:

		case FLOW_ACTION_REDIRECT: {
			struct net_device *out = act->dev;
			struct port_info *pi = netdev_priv(out);

			fs->action = FILTER_SWITCH;
			fs->eport = pi->port_id;
			}

How do you know the output interface is controlled by your driver, and
therefore it's sage to cast netdev_priv() to port_info?
