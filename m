Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E1A8AAEB
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 01:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfHLXEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 19:04:02 -0400
Received: from scorn.kernelslacker.org ([45.56.101.199]:42532 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHLXEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 19:04:02 -0400
X-Greylist: delayed 2647 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 19:04:02 EDT
Received: from [2601:196:4600:6634:ae9e:17ff:feb7:72ca] (helo=wopr.kernelslacker.org)
        by scorn.kernelslacker.org with esmtp (Exim 4.92)
        (envelope-from <davej@codemonkey.org.uk>)
        id 1hxIfS-000811-Pg; Mon, 12 Aug 2019 18:19:54 -0400
Received: by wopr.kernelslacker.org (Postfix, from userid 1026)
        id 5DADD560184; Mon, 12 Aug 2019 18:19:54 -0400 (EDT)
Date:   Mon, 12 Aug 2019 18:19:54 -0400
From:   Dave Jones <davej@codemonkey.org.uk>
To:     Alexis Bauvin <abauvin@scaleway.com>
Cc:     netdev@vger.kernel.org
Subject: Re: tun: mark small packets as owned by the tap sock
Message-ID: <20190812221954.GA13314@codemonkey.org.uk>
References: <git-mailbomb-linux-master-4b663366246be1d1d4b1b8b01245b2e88ad9e706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <git-mailbomb-linux-master-4b663366246be1d1d4b1b8b01245b2e88ad9e706@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Note: SpamAssassin invocation failed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 12:30:07AM +0000, Linux Kernel wrote:
 > Commit:     4b663366246be1d1d4b1b8b01245b2e88ad9e706
 > Parent:     16b2084a8afa1432d14ba72b7c97d7908e178178
 > Web:        https://git.kernel.org/torvalds/c/4b663366246be1d1d4b1b8b01245b2e88ad9e706
 > Author:     Alexis Bauvin <abauvin@scaleway.com>
 > AuthorDate: Tue Jul 23 16:23:01 2019 +0200
 > 
 >     tun: mark small packets as owned by the tap sock
 >     
 >     - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patch size
 >     
 >     Small packets going out of a tap device go through an optimized code
 >     path that uses build_skb() rather than sock_alloc_send_pskb(). The
 >     latter calls skb_set_owner_w(), but the small packet code path does not.
 >     
 >     The net effect is that small packets are not owned by the userland
 >     application's socket (e.g. QEMU), while large packets are.
 >     This can be seen with a TCP session, where packets are not owned when
 >     the window size is small enough (around PAGE_SIZE), while they are once
 >     the window grows (note that this requires the host to support virtio
 >     tso for the guest to offload segmentation).
 >     All this leads to inconsistent behaviour in the kernel, especially on
 >     netfilter modules that uses sk->socket (e.g. xt_owner).
 >     
 >     Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
 >     Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
 >     Acked-by: Jason Wang <jasowang@redhat.com>

This commit breaks ipv6 routing when I deployed on it a linode.
It seems to work briefly after boot, and then silently all packets get
dropped. (Presumably, it's dropping RA or ND packets)

With this reverted, everything works as it did in rc3.

	Dave

