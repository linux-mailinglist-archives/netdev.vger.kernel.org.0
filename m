Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02472EEB58
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAHCh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:37:29 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:61062 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbhAHCh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 21:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1610073448; x=1641609448;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=my3Naolu1PChTdM9Bl0HiSg56oK/sbgUmZToPz64Yxo=;
  b=f32WMGvbM46PPI7fyPA3XrD6uqbC7Ogsr8r34V4mOAebfJvoz3TDnwpF
   JIGourGztRYd0utT/5baPnm0Kc7D5IL6AbMXiBlr7nmgnJVKtq9OYSqdG
   kj3o7gz8GmOa6bC2GVwYXn5AS3HQBE7T73yLfCxeGrAAmDxf8w5oQ9bSu
   k=;
X-IronPort-AV: E=Sophos;i="5.79,330,1602547200"; 
   d="scan'208";a="76128177"
Subject: Re: [PATCH] neighbour: Disregard DEAD dst in neigh_update
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 08 Jan 2021 02:36:46 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id AD2E5A1F59;
        Fri,  8 Jan 2021 02:36:44 +0000 (UTC)
Received: from EX13D06UEA002.ant.amazon.com (10.43.61.198) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 8 Jan 2021 02:36:42 +0000
Received: from ucf43ac461c9a53.ant.amazon.com (10.43.161.68) by
 EX13D06UEA002.ant.amazon.com (10.43.61.198) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 8 Jan 2021 02:36:41 +0000
Date:   Thu, 7 Jan 2021 21:36:37 -0500
From:   Your Real Name <zhutong@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     <sashal@kernel.org>, <edumazet@google.com>, <vvs@virtuozzo.com>,
        <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210108023637.GA31904@ucf43ac461c9a53.ant.amazon.com>
References: <20201230225415.GA490@ucf43ac461c9a53.ant.amazon.com>
 <20210105.160521.1279064249478522010.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210105.160521.1279064249478522010.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D39UWA001.ant.amazon.com (10.43.160.54) To
 EX13D06UEA002.ant.amazon.com (10.43.61.198)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 04:05:21PM -0800, David Miller wrote: 
> 
> 
> From: Tong Zhu <zhutong@amazon.com>
> Date: Wed, 30 Dec 2020 17:54:23 -0500
> 
> > In 4.x kernel a dst in DST_OBSOLETE_DEAD state is associated
> > with loopback net_device and leads to loopback neighbour. It
> > leads to an ethernet header with all zero addresses.
> >
> > A very troubling case is working with mac80211 and ath9k.
> > A packet with all zero source MAC address to mac80211 will
> > eventually fail ieee80211_find_sta_by_ifaddr in ath9k (xmit.c).
> > As result, ath9k flushes tx queue (ath_tx_complete_aggr) without
> > updating baw (block ack window), damages baw logic and disables
> > transmission.
> >
> > Signed-off-by: Tong Zhu <zhutong@amazon.com>
> 
> Please repost with an appropriate Fixes: tag.
> 
> Thanks.

I had a second thought on this. This fix should go mainline too. This is a 
case we are sending out queued packets when arp reply from the neighbour 
comes in. With 5.x kernel, a dst in DST_OBSOLETE_DEAD state leads to dropping
of this packet. It is not as bad as with 4.x kernel that may end up with an
all-zero mac address packet out to ethernet or choking up ath9k when using 
block ack. Dropping the packet is still wrong. I’ll repost as a fix to
mainline and target backport to 4.x LTS releases.

Best regards
    
