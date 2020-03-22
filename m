Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4416918EC3B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCVUn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCVUn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 16:43:58 -0400
Received: from kicinski-fedora-PC1C0HJN (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DDCD20722;
        Sun, 22 Mar 2020 20:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584909838;
        bh=7uuqlv+KI6oHqzf5REliAD4qvrHfNNTC3/A5CRNxtlE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fjyxfmz64rth8we0JsUiekHM4GD0DLhWUaRV6MU4r5Vox8tMT+WoX4/vooS5/mCIO
         xu8pnawqRACqxCLyz4ivT+u7DOR6e+2BhQq3AuFzJwL0RVAk6ovIwqh14tU6Fl59PC
         lEQgMVqL6/4h8UWPI7nZr3y9JSDMgQKLBKin7Cc4=
Date:   Sun, 22 Mar 2020 13:43:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix reference leak in some *_SET handlers
Message-ID: <20200322134356.55f7d9b8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
References: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 21:15:51 +0100 (CET) Michal Kubecek wrote:
> Andrew noticed that some handlers for *_SET commands leak a netdev
> reference if required ethtool_ops callbacks do not exist. A simple
> reproducer would be e.g.
> 
>   ip link add veth1 type veth peer name veth2
>   ethtool -s veth1 wol g
>   ip link del veth1
> 
> Make sure dev_put() is called when ethtool_ops check fails.

Fixes: e54d04e3afea ("ethtool: set message mask with DEBUG_SET request")
Fixes: a53f3d41e4d3 ("ethtool: set link settings with LINKINFO_SET request")
Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")
Fixes: 8d425b19b305 ("ethtool: set wake-on-lan settings with WOL_SET request")
 
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
