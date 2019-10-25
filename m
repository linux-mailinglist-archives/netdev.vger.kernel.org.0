Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35AE506F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502249AbfJYPtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502051AbfJYPtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 11:49:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F39206DD;
        Fri, 25 Oct 2019 15:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572018545;
        bh=yjAaE0xQhH20vJrkI1srEKz9AtxqLuI40WnRKCUXgj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0cgKbZZFBv4uMey3849inISOi+o8JI/NP51o1L8I+z1XUhBRwjCrkqDC7OKZ2wpue
         5uHXeoI08lQR31eMc4qNzUO+kgiEFikYiwzmbTzR+To6Itq+Q5QHFTxWU9zp0JlKCF
         RkFlUdCpVDOuS+vNw3wOE0etJU5F0p6s7wp/Pp7U=
Date:   Fri, 25 Oct 2019 11:49:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.3 12/33] blackhole_netdev: fix syzkaller
 reported issue
Message-ID: <20191025154903.GH31224@sasha-vm>
References: <20191025135505.24762-1-sashal@kernel.org>
 <20191025135505.24762-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191025135505.24762-12-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 09:54:44AM -0400, Sasha Levin wrote:
>From: Mahesh Bandewar <maheshb@google.com>
>
>[ Upstream commit b0818f80c8c1bc215bba276bd61c216014fab23b ]
>
>While invalidating the dst, we assign backhole_netdev instead of
>loopback device. However, this device does not have idev pointer
>and hence no ip6_ptr even if IPv6 is enabled. Possibly this has
>triggered the syzbot reported crash.
>
>The syzbot report does not have reproducer, however, this is the
>only device that doesn't have matching idev created.
>
>Crash instruction is :
>
>static inline bool ip6_ignore_linkdown(const struct net_device *dev)
>{
>        const struct inet6_dev *idev = __in6_dev_get(dev);
>
>        return !!idev->cnf.ignore_routes_with_linkdown; <= crash
>}
>
>Also ipv6 always assumes presence of idev and never checks for it
>being NULL (as does the above referenced code). So adding a idev
>for the blackhole_netdev to avoid this class of crashes in the future.
>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Sasha Levin <sashal@kernel.org>

I've dropped this patch.

-- 
Thanks,
Sasha
