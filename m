Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9080222301C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgGQAwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgGQAwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:52:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776E620787;
        Fri, 17 Jul 2020 00:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594947162;
        bh=OxsxLgcYiEQhzPb6mMJuTVn/vVGMZwTT97Zjl8SsCBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d7GyF0vBVZzJtDgEBRxLTqyqKtHS1IoVnaaDx8z9PuFg3bS5qhmfTBtjp2TvZPU5f
         NwIikeAdtdFp/4dtoFDkG547AZFdAjIzsS9R4TGbVkwgcuLNBISDaynKgyTZHf/T6Q
         RN/KUduSRTe7IAItjG9R/Uw3l1kgyc7FrrvHRnV8=
Date:   Thu, 16 Jul 2020 17:52:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH V3 net-next 1/8] net: ena: avoid unnecessary rearming of
 interrupt vector when busy-polling
Message-ID: <20200716175239.1d04e729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594923010-6234-2-git-send-email-akiyano@amazon.com>
References: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
        <1594923010-6234-2-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 21:10:03 +0300 akiyano@amazon.com wrote:
> This patch doesn't require smp_rmb() instruction in the napi routine
> because it assumes cache coherency between two cores. I.e. the
> 'interrupts_masked' flag set would be seen by the napi routine, even if
> the flag is stored in L1 cache.
> To the best of my knowledge this assumption holds for ARM64 and x86_64
> architecture which use a MESI like cache coherency model.

If that's the case - for those architectures smb_rmb() should be defined
to barrier(). Why can't you adhere to kernel's memory model, rather
than guessing the architecture in the driver.
