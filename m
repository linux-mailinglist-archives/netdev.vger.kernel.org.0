Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6002E9F9A
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbhADVf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbhADVf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:35:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 290A221D93;
        Mon,  4 Jan 2021 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609796118;
        bh=1ZDHjfHVTfzbffgIH/tkyM9JxDwwS4v3iCeQUKeg9Dg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bh3RxC0nY9zR4TCjjqdrqVZ3SNFS3IcneKMWt0OC+Ho2efgCAz/o5vkcykqSKIzAy
         gEFm4fGt5whppdP9qJL0ZpADH06M2Fl4JIw+VHSuGPzMED4b0vGT8Dh5kbjyKgjVA1
         81f9+CezjVHvvFvZaEe7qDLJwPdH7BX5QbOATOGjjE1772vyht/O2ahD13PibwDjj0
         6Ek2bPcBoJp9jRTSjMMxs73F/EGPPr8r8kQDUdhltBGsFAT+pX8ho/KcMjIzF4zu3f
         YhYKuXOFj7stQY8ABpK6suMZhuaJ9Ff3HjHfWqlnq8PI3MVyNnbjKm/oF6maQ9zKh/
         cqOx+pxgjot6g==
Date:   Mon, 4 Jan 2021 13:35:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>
Subject: Re: [PATCH net] macvlan: fix null pointer dereference in
 macvlan_changelink_sources()
Message-ID: <20210104133517.68198ccd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609324695-1516-1-git-send-email-wangyunjian@huawei.com>
References: <1609324695-1516-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Dec 2020 18:38:15 +0800 wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently pointer data is dereferenced when declaring addr before
> pointer data is null checked. This could lead to a null pointer
> dereference. Fix this by checking if pointer data is null first.
> 
> Fixes: 79cf79abce71 ("macvlan: add source mode")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

I don't see it. All calls to macvlan_changelink_sources() are under 
if (data) { ... } so data is never NULL. Looks like we should rather
clean up macvlan_changelink_sources() to not check data for
MACVLAN_MACADDR_SET. 

WDYT?
