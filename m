Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314BC2BB212
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgKTSGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbgKTSGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:06:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 866A22240B;
        Fri, 20 Nov 2020 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605895574;
        bh=5QsJhiNlDYF6e5+XXwRtT9R/LRbCv501uDAH0fgcN0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KYlbryWpufKcNB1iYssy8CcD1+/3Gqqh2EdgFmZ9rTm6f4AXmNUy1gjQvi6APx9PN
         r1AmcaO7XP5Y1fOxjaLen/tWVjpFkEzsN+vCD9HbgGQJ5gIbMizYt3/SxLds3QVXjh
         6sY9n3QbkPvlEyGj3Ok3Z22jd+4VvnGPpHqfme3w=
Date:   Fri, 20 Nov 2020 10:06:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     ralf@linux-mips.org, davem@davemloft.net, saeed@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH v5 net] rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201120100612.62d9d770@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119191043.28813-1-anmol.karan123@gmail.com>
References: <20201115114448.GA40574@Thinkpad>
        <20201119191043.28813-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 00:40:43 +0530 Anmol Karn wrote:
> rose_send_frame() dereferences `neigh->dev` when called from
> rose_transmit_clear_request(), and the first occurrence of the
> `neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
> and it is initialized in rose_add_loopback_neigh() as NULL.
> i.e when `rose_loopback_neigh` used in rose_loopback_timer()
> its `->dev` was still NULL and rose_loopback_timer() was calling
> rose_rx_call_request() without checking for NULL.
> 
> - net/rose/rose_link.c
> This bug seems to get triggered in this line:
> 
> rose_call = (ax25_address *)neigh->dev->dev_addr;
> 
> Fix it by adding NULL checking for `rose_loopback_neigh->dev`
> in rose_loopback_timer().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
> Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>

Applied to net, thanks!
