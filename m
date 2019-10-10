Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF0D2F3C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfJJRGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbfJJRGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 13:06:07 -0400
Received: from localhost (unknown [131.107.174.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010A52067B;
        Thu, 10 Oct 2019 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570727167;
        bh=Eht+PU+lHi92IsU0YnYYmvQeiFi7TS8nU1DAoBr0TR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mwe6JmqF5r7rPK//hTLRFVxCLNcK7OzfHjShXp/yQa//v67d3otQbngXYyZrt+KiM
         Z0N1bRUbs9VydvDRPOqptRoNzaVjAcfUqyD8pe6TUvLLfwNaT7C72QaYZqLYkNw+mW
         ACpLWo8Oi2+4FZjKlfO2EE6Qv7bDK2DWyLC4Em+I=
Date:   Thu, 10 Oct 2019 13:06:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>, davem@davemloft.net
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "himadri18.07" <himadri18.07@gmail.com>
Subject: Re: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
Message-ID: <20191010170606.GA1396@sasha-vm>
References: <20190725051125.10605-1-himadri18.07@gmail.com>
 <MWHPR21MB078479F82BBA6D3E6527ECECD7DF0@MWHPR21MB0784.namprd21.prod.outlook.com>
 <20191004154817.GL17454@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191004154817.GL17454@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 11:48:17AM -0400, Sasha Levin wrote:
>On Wed, Jul 31, 2019 at 01:02:03AM +0000, Michael Kelley wrote:
>>From: Himadri Pandya <himadrispandya@gmail.com> Sent: Wednesday, July 24, 2019 10:11 PM
>>>
>>>Older windows hosts require the hv_sock ring buffer to be defined
>>>using 4K pages. This was achieved by using the symbol PAGE_SIZE_4K
>>>defined specifically for this purpose. But now we have a new symbol
>>>HV_HYP_PAGE_SIZE defined in hyperv-tlfs which can be used for this.
>>>
>>>This patch removes the definition of symbol PAGE_SIZE_4K and replaces
>>>its usage with the symbol HV_HYP_PAGE_SIZE. This patch also aligns
>>>sndbuf and rcvbuf to hyper-v specific page size using HV_HYP_PAGE_SIZE
>>>instead of the guest page size(PAGE_SIZE) as hyper-v expects the page
>>>size to be 4K and it might not be the case on ARM64 architecture.
>>>
>>>Signed-off-by: Himadri Pandya <himadri18.07@gmail.com>
>>>---
>>> net/vmw_vsock/hyperv_transport.c | 21 +++++++++++----------
>>> 1 file changed, 11 insertions(+), 10 deletions(-)
>>>
>>>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>>>index f2084e3f7aa4..ecb5d72d8010 100644
>>>--- a/net/vmw_vsock/hyperv_transport.c
>>>+++ b/net/vmw_vsock/hyperv_transport.c
>>>@@ -13,15 +13,16 @@
>>> #include <linux/hyperv.h>
>>> #include <net/sock.h>
>>> #include <net/af_vsock.h>
>>>+#include <asm/hyperv-tlfs.h>
>>>
>>
>>Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
>>
>>This patch depends on a prerequisite patch in
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/hyperv
>>
>>that defines HV_HYP_PAGE_SIZE.
>
>David, the above prerequisite patch is now upstream, so this patch
>should be good to go. Would you take it through the net tree or should I
>do it via the hyperv tree?

Ping?

-- 
Thanks,
Sasha
