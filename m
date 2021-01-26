Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0D303517
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbhAZFe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732183AbhAZCGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 21:06:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9128E21D93;
        Tue, 26 Jan 2021 01:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611626160;
        bh=em4Po2VocQxdSNQVloeUP6kBUPQg1jeeOSq/6yV7Cuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tFn/UzN8ew42dGOJRfscnR0FPO2eAdFkMX8efKJiMJfbXZvNFeeqXseWzhV5447ae
         PWFKUFvKOi58+3Pc3ctCfImq78ynWDRetNMTKXSBgTuXtcKx7hzji8aY/Ch4QfzDqM
         +b8zq7Emi3NmMrxsLX9eEZv5K7OUlRpd8I5vOfFgy+riTXnBaJvFdyc4EJ1DZK+1V8
         1m217805WEz6zsAiCY/duGs7EBAXcS9wRURxHVsxIgO7vAR4w7pAUp+XEQajO4xJPx
         0/civgAL3Oo2K1DLRs1pJH5Bh2/oCu1HupQHSvVy8hfJIQaUAyoa0o4lv8V616P65r
         lrC6EBfcwN1ag==
Date:   Mon, 25 Jan 2021 17:55:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 2/4] rtnetlink: extend RTEXT_FILTER_SKIP_STATS
 to IFLA_VF_INFO
Message-ID: <20210125175559.467229e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123045321.2797360-3-edwin.peer@broadcom.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
        <20210123045321.2797360-3-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 20:53:19 -0800 Edwin Peer wrote:
> This filter already exists for excluding IPv6 SNMP stats. Extend its
> definition to also exclude IFLA_VF_INFO stats in RTM_GETLINK.
> 
> This patch constitutes a partial fix for a netlink attribute nesting
> overflow bug in IFLA_VFINFO_LIST. By excluding the stats when the
> requester doesn't need them, the truncation of the VF list is avoided.
> 
> While it was technically only the stats added in commit c5a9f6f0ab40
> ("net/core: Add drop counters to VF statistics") breaking the camel's
> back, the appreciable size of the stats data should never have been
> included without due consideration for the maximum number of VFs
> supported by PCI.
> 
> Fixes: 3b766cd83232 ("net/core: Add reading VF statistics through the PF netdevice")
> Fixes: c5a9f6f0ab40 ("net/core: Add drop counters to VF statistics")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>

Could you include in the commit message the size breakdown of a single
VF nest? With and without efficient unaligned 64b access?
