Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4387A216397
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 04:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgGGCH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 22:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgGGCH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 22:07:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7551D206E6;
        Tue,  7 Jul 2020 02:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594087677;
        bh=jbGDUIGvWHFxfOr2K9dhq/WVM2luJ+MG5pZSVocXvyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KHMXF/0fdFr06ZMUILckRc5hSIms/dmQGXEbWqqNSO+6sHmN4bgW6AndH7dk0TMbd
         IcmrZYdK7RsJVzkVfIl/n+6Lgf0R3nu+7PRuunAWrA1mzDtQsH/5P92EeAlDq/6T6y
         iQvP6gP03fPXGxM1cBrrQccwXr00BaBJgy9yt26U=
Date:   Mon, 6 Jul 2020 19:07:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Message-ID: <20200706190755.688f6fa7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f5ddd73d9fc5ccdf340de0c6c335888de51d98de.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
        <20200702221923.650779-3-saeedm@mellanox.com>
        <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
        <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
        <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
        <20200706125704.465b3a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f5ddd73d9fc5ccdf340de0c6c335888de51d98de.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jul 2020 01:51:21 +0000 Saeed Mahameed wrote:
> > Also looks like you report the total number of mcast packets in
> > ethtool
> > -S, which should be identical to ip -s? If so please remove that.  
> 
> why ? it is ok to report the same counter both in ehttool and netdev
> stats.

I don't think it is, Stephen and I have been trying to catch this in
review for a while now. It's an entirely unnecessary code duplication.
We should steer towards proper APIs first if those exist.

Using ethtool -S stats gets very messy very quickly in production.
