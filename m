Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89FA2A521A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 21:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgKCUqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 15:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730473AbgKCUqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74E222404;
        Tue,  3 Nov 2020 20:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436408;
        bh=kVsE6wot4XVJu8iliQe/+mlzpMyXJhhDiAbDDgmO8N4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=exNMGPACHVDGWotxV4RYvOPmTKBKwnX9YuuQoksFWTSxh5i3DXGuwAZHWFNJitGp+
         KR425xf9tpGDjGCxToyWruQ0ENil8JLuJJwUXY6go0B4hmAJZWGgSFF9y1J85BaGen
         02gARMjzYdi0rGmwjLlksyRowq+8084aPNJHnCPU=
Date:   Tue, 3 Nov 2020 12:46:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v4 05/10] cxgb4/ch_ktls: creating skbs causes panic
Message-ID: <20201103124646.795b96eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201030180225.11089-6-rohitm@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
        <20201030180225.11089-6-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 23:32:20 +0530 Rohit Maheshwari wrote:
> Creating SKB per tls record and freeing the original one causes
> panic. There will be race if connection reset is requested. By
> freeing original skb, refcnt will be decremented and that means,
> there is no pending record to send, and so tls_dev_del will be
> requested in control path while SKB of related connection is in
> queue.
>  Better approach is to use same SKB to send one record (partial
> data) at a time. We still have to create a new SKB when partial
> last part of a record is requested.
>  This fix introduces new API cxgb4_write_partial_sgl() to send
> partial part of skb. Present cxgb4_write_sgl can only provide
> feasibility to start from an offset which limits to header only
> and it can write sgls for the whole skb len. But this new API
> will help in both. It can start from any offset and can end
> writing in middle of the skb.

You never replied to my question on v2.

If the problem is that the socket gets freed, why don't you make the
new skb take a reference on the socket?

650 LoC is really a rather large fix.
