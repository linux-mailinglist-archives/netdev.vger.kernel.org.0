Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EE6144668
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgAUV2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:28:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgAUV2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:28:35 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6631B158C30AC;
        Tue, 21 Jan 2020 13:28:33 -0800 (PST)
Date:   Tue, 21 Jan 2020 22:28:29 +0100 (CET)
Message-Id: <20200121.222829.888926574980511328.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MN2PR21MB1375A6F208BC94CD4CFA016BCA0D0@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1579558957-62496-2-git-send-email-haiyangz@microsoft.com>
        <20200121.110454.2077433904156411260.davem@davemloft.net>
        <MN2PR21MB1375A6F208BC94CD4CFA016BCA0D0@MN2PR21MB1375.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 13:28:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 21 Jan 2020 18:53:28 +0000

> Sorry I was replying too quickly. See more detailed explanation below.
> 
>> -----Original Message-----
>> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
>> owner@vger.kernel.org> On Behalf Of David Miller
>> Sent: Tuesday, January 21, 2020 5:05 AM
>> To: Haiyang Zhang <haiyangz@microsoft.com>
>> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.org;
>> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
>> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
>> <vkuznets@redhat.com>; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH V2,net-next, 1/2] hv_netvsc: Add XDP support
>> 
>> From: Haiyang Zhang <haiyangz@microsoft.com>
>> Date: Mon, 20 Jan 2020 14:22:36 -0800
>> 
>> > +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
>> > +		   struct xdp_buff *xdp)
>> > +{
>> > +	struct page *page = NULL;
>> > +	void *data = nvchan->rsc.data[0];
>> > +	u32 len = nvchan->rsc.len[0];
>> > +	struct bpf_prog *prog;
>> > +	u32 act = XDP_PASS;
>> 
>> Please use reverse christmas tree ordering of local variables.
> Will do.
> 
>> 
>> > +	xdp->data_hard_start = page_address(page);
>> > +	xdp->data = xdp->data_hard_start + NETVSC_XDP_HDRM;
>> > +	xdp_set_data_meta_invalid(xdp);
>> > +	xdp->data_end = xdp->data + len;
>> > +	xdp->rxq = &nvchan->xdp_rxq;
>> > +	xdp->handle = 0;
>> > +
>> > +	memcpy(xdp->data, data, len);
>> 
>> Why can't the program run directly on nvchan->rsc.data[0]?
> 
> The Azure/Hyper-V synthetic NIC receive buffer doesn't provide headroom 
> for XDP. We thought about re-use the RNDIS header space, but it's too 
> small. So we decided to copy the packets to a page buffer for XDP. And, 
> most of our VMs on Azure have Accelerated  Network (SRIOV) enabled, so 
> most of the packets run on VF NIC. The synthetic NIC is considered as a 
> fallback data-path. So the data copy on netvsc won't impact performance 
> significantly.

You need to explain this in your commit message otherwise every reviewer with
XDP expertiece will ask the same question.
