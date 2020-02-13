Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9C515C2C8
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387991AbgBMPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgBMPag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 10:30:36 -0500
Received: from kicinski-fedora-PC1C0HJN (mobile-166-170-39-42.mycingular.net [166.170.39.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4982465D;
        Thu, 13 Feb 2020 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607836;
        bh=5o3xb8FrlPLpSSQuBTDmkQAgYT/me+gGXdkm+ieNt2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=txSJtbI9FMecm5whhPXQscV4wsoWQr4yTHypdXzmaRKMcA+a5pI217H/VlYmo5Lrd
         wrniku0+6gI6BQKO6D+WfJonDBTjOA+rFhM4g4EjSPhtyiIQxCQcSsdrXfEIM3iD5z
         2Vn9Mcz5YvQBLbksXmmUUR3pckqomxpoZRTudN4I=
Date:   Thu, 13 Feb 2020 07:30:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [net] net/tls: Fix to avoid gettig invalid tls record
Message-ID: <20200213072921.232ac66c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <6a47e7aa-c98a-ede5-f0d6-ce2bdc4875e8@chelsio.com>
References: <20200212071630.26650-1-rohitm@chelsio.com>
 <20200212200945.34460c3a@cakuba.hsd1.ca.comcast.net>
 <6a47e7aa-c98a-ede5-f0d6-ce2bdc4875e8@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Feb 2020 12:25:36 +0530 rohit maheshwari wrote:
> On 13/02/20 9:39 AM, Jakub Kicinski wrote:
> >> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> >> index cd91ad812291..2898517298bf 100644
> >> --- a/net/tls/tls_device.c
> >> +++ b/net/tls/tls_device.c
> >> @@ -602,7 +602,8 @@ struct tls_record_info *tls_get_record(struct
> >> tls_offload_context_tx *context, */
> >>   		info =
> >> list_first_entry_or_null(&context->records_list, struct
> >> tls_record_info, list);
> >> -		if (!info)
> >> +		/* return NULL if seq number even before the 1st
> >> entry. */
> >> +		if (!info || before(seq, info->end_seq -
> >> info->len))  
> > Is it not more appropriate to use between() in the actual comparison
> > below? I feel like with this patch we can get false negatives.  
> 
> If we use between(), though record doesn't exist, we still go and 
> compare each record,
> 
> which I think, should actually be avoided.

You can between() first and last element on the list at the very start 
of the search.

> >>   			return NULL;
> >>   		record_sn = context->unacked_record_sn;
> >>   	}  
> > If you post a v2 please add a Fixes tag and CC maintainers of this
> > code.  

