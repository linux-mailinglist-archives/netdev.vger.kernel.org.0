Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F3035A617
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhDISuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhDISuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4619C6113A;
        Fri,  9 Apr 2021 18:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617994202;
        bh=6G8Fk2gp9v3C/TfK5xuPhAjKD+l6qS9JG78lcgHh6AE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h5QpkV0VkZws/30Y20LekV0TxsZ9ytrZrpK2Vgm+IaRp0x/NQv53ojicI0fZggBqx
         VpqQbTHDRrasblKxS8R4y1va7xMStUMioheV0esl+/gosXVODB//XauplmmRPw5HPA
         kUGrXiYXQzRbUvKyReLp83Lqlw92zL1BszIAT8zXbmjsekk1HfQmQLUVUEjNlRRIIn
         eMZiOWsF9E3+5p6EJ0PlPVW4rf2HeNooxtlO7qXaZ1wRVaycpKL2V4+hb79oAqdl5U
         7Pr8XKSIU8g/6T3kRUBxEzCSfNinreDdE2V+1ll16O56ZblsA0fE4No0JQBZo0rvTV
         Ol14DNxEWI+kw==
Date:   Fri, 9 Apr 2021 11:50:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Balaev Pavel <balaevpa@infotecs.ru>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: multipath routing: configurable seed
Message-ID: <20210409114847.02435bb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHBcBRXLuFsHudyg@rnd>
References: <YHBcBRXLuFsHudyg@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 16:52:05 +0300 Balaev Pavel wrote:
> Hello, this patch adds ability for user to set seed value for

nit: please drop the 'Hello' and use imperative form to describe 
the commit.

> multipath routing hashes. Now kernel uses random seed value:
> this is done to prevent hash-flooding DoS attacks,
> but it breaks some scenario, f.e:
> 
> +-------+        +------+        +--------+
> |       |-eth0---| FW0  |---eth0-|        |
> |       |        +------+        |        |
> |  GW0  |ECMP                ECMP|  GW1   |
> |       |        +------+        |        |
> |       |-eth1---| FW1  |---eth1-|        |
> +-------+        +------+        +--------+
> 
> In this scenario two ECMP routers used as traffic balancers between
> two firewalls. So if return path of one flow will not be the same,
> such flow will be dropped, because keep-state rules was created on
> other firewall.
> 
> This patch add sysctl variable: net.ipv4.fib_multipath_hash_seed.
> User can set the same seed value on GW0 and GW1 and traffic will
> be mirror-balanced. By default random value is used.
> 
> Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>

Please try to find relevant reviewers and put them on CC.
Try to find people who have worked on this code in the past.

This patch seems to add new sparse warnings:

net/ipv4/sysctl_net_ipv4.c:544:38: warning: incorrect type in assignment (different base types)
net/ipv4/sysctl_net_ipv4.c:544:38:    expected unsigned long long
net/ipv4/sysctl_net_ipv4.c:544:38:    got restricted __le64
net/ipv4/sysctl_net_ipv4.c:545:38: warning: incorrect type in assignment (different base types)
net/ipv4/sysctl_net_ipv4.c:545:38:    expected unsigned long long
net/ipv4/sysctl_net_ipv4.c:545:38:    got restricted __le64

> {
> 	u32 multipath_hash = fl4 ? fl4->flowi4_multipath_hash : 0;
> 	struct flow_keys hash_keys;
> +	struct multipath_seed_ctx *seed_ctx;

Please order variable declaration lines longest to shortest.
