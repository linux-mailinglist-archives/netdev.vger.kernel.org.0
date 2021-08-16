Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF50B3EDA25
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhHPPsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232822AbhHPPsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF71B60F42;
        Mon, 16 Aug 2021 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629128862;
        bh=i6mqhZa05bh0/QvKBCg/vqpuUHYgPMxb+O5ZQZYVlwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q04xAz38cnz5G+q6BdNTGV+56X2nNyQNbX7kYAv1bZRAJllhYM0aPv8BfAGUOBPde
         2TaQG/1vjjWj3DX5VjwdbMrFJDiOFexJghkCE9fEkdlo52B3SamAh8zSopudkuUvjV
         EY0tVxnimj2wC9chonMAf6eUa9m6MNk8x4t/g+eZH7UjL2Z29WcNFGTYgvMiR2HA2H
         gJ85U3QPjmH+nRo1TwF1PYCIkat63+vycqDerd1LrVni34ATaipOsWly6gYKzgGgxz
         o3RlRIYHMyk/p1LuI4tThV3IuTLifvL/EfDKrfZtRmRD+SD22xLJQxFq9QeKAEczJC
         FvseFiXu98g5g==
Date:   Mon, 16 Aug 2021 08:47:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Message-ID: <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
References: <cover.1628933864.git.leonro@nvidia.com>
        <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The struct devlink itself is protected by internal lock and doesn't
> need global lock during operation. That global lock is used to protect
> addition/removal new devlink instances from the global list in use by
> all devlink consumers in the system.
> 
> The future conversion of linked list to be xarray will allow us to
> actually delete that lock, but first we need to count all struct devlink
> users.

Not a problem with this set but to state the obvious the global devlink
lock also protects from concurrent execution of all the ops which don't
take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely know
this but I thought I'd comment on an off chance it helps.

> The reference counting provides us a way to ensure that no new user
> space commands success to grab devlink instance which is going to be
> destroyed makes it is safe to access it without lock.

