Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDD92061C9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393149AbgFWUu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404143AbgFWUuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 16:50:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDDE72145D;
        Tue, 23 Jun 2020 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945409;
        bh=n3Dwo2ucZ0JQxiocnRaLLDeGlCzh4hohybtbn2oJiMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Crr6UFiwqsiN4Km8Ra7FSY/aeoxMjRRnq7id5zOD+eMKMaql6akRAtOOt5QX2UTAv
         KdJMIh1VoOE4k+cS0H+bS2UZciGUE/7BM4xad87ywPxneYmMrAW0XBJXmYrh/HHWY4
         tJSsYSktkna61XWn8xc2SL/wcKg62kgVvG7PT4uA=
Date:   Tue, 23 Jun 2020 13:50:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kaige Li <likaige@loongson.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
Message-ID: <20200623135007.3105d067@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
References: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 16:13:09 +0800 Kaige Li wrote:
> The kernel module may sleep with holding a spinlock.
> 
> The function call paths (from bottom to top) are:
> 
> [FUNC] zalloc_cpumask_var(GFP_KERNEL)
> drivers/net/ethernet/cisco/enic/enic_main.c, 125: zalloc_cpumask_var in enic_init_affinity_hint
> drivers/net/ethernet/cisco/enic/enic_main.c, 1918: enic_init_affinity_hint in enic_open
> drivers/net/ethernet/cisco/enic/enic_main.c, 2348: enic_open in enic_reset
> drivers/net/ethernet/cisco/enic/enic_main.c, 2341: spin_lock in enic_reset
> 
> To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.
> 
> Signed-off-by: Kaige Li <likaige@loongson.cn>

I don't think this is sufficient. Calling open with a spin lock held
seems like a very bad idea. At a quick look the driver also calls
request_irq() from open - request_irq() can sleep.
