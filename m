Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3034316B015
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgBXTN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:13:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgBXTN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:13:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99D7B11E3C074;
        Mon, 24 Feb 2020 11:13:55 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:13:55 -0800 (PST)
Message-Id: <20200224.111355.456289899614012541.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net v2] net: bridge: fix stale eth hdr pointer in
 br_dev_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224164622.1472051-1-nikolay@cumulusnetworks.com>
References: <83cadec7-d659-cf2a-c0c0-a85d2f6503bc@cumulusnetworks.com>
        <20200224164622.1472051-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 11:13:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Mon, 24 Feb 2020 18:46:22 +0200

> In br_dev_xmit() we perform vlan filtering in br_allowed_ingress() but
> if the packet has the vlan header inside (e.g. bridge with disabled
> tx-vlan-offload) then the vlan filtering code will use skb_vlan_untag()
> to extract the vid before filtering which in turn calls pskb_may_pull()
> and we may end up with a stale eth pointer. Moreover the cached eth header
> pointer will generally be wrong after that operation. Remove the eth header
> caching and just use eth_hdr() directly, the compiler does the right thing
> and calculates it only once so we don't lose anything.
> 
> Fixes: 057658cb33fb ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> v2: remove syzbot's reported-by tag, this seems to be a different bug

Applied and queued up for -stable, thanks Nikolay.
