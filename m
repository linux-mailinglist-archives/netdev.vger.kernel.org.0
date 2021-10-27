Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F258C43CD18
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbhJ0PKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234640AbhJ0PKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:10:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96DEB60F5A;
        Wed, 27 Oct 2021 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635347294;
        bh=7r3u1uaz8DQg8Ts4xPCGL1lYvyrZyANmuMHQEBtft0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y4qAPrzl5n/Ffy+zOSUr0lxtxdj/W5tka65XNN0yriIlWFE9AuYGMEOCE9hncX9M+
         6k1MLNO6km00X0FlYN4U02X8e1HSieWZKzyxZYDDBMePikWT8ARoAkrJItCYSgyaZf
         bQV51RYEXOwGpC+OUA8tya+r0dxSmK5XfQHqeqWMTgfm5YIXDUX1AC8vIrdHIfWUqZ
         tIh/ubab47629IA+Zt1p6dbhbSUg1cMSdNK5uBSgxV10c3kjLVc0zKsuv0RQRJkBdY
         dncalRGplTQe4SkzsKvv0xX9+r2F5NIB+lVNgUcjuFp1hT9h/zLVuen7SQE7YgsVEx
         F6+p5xJDZY26w==
Date:   Wed, 27 Oct 2021 08:08:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer
 space when data was already sent"
Message-ID: <20211027080813.238b82ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
        <20211027085208.16048-2-tonylu@linux.alibaba.com>
        <9bbd05ac-5fa5-7d7a-fe69-e7e072ccd1ab@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 12:21:32 +0200 Karsten Graul wrote:
> On 27/10/2021 10:52, Tony Lu wrote:
> > From: Tony Lu <tony.ly@linux.alibaba.com>
> > 
> > This reverts commit 6889b36da78a21a312d8b462c1fa25a03c2ff192.
> > 
> > When using SMC to replace TCP, some userspace applications like netperf
> > don't check the return code of send syscall correctly, which means how
> > many bytes are sent. If rc of send() is smaller than expected, it should
> > try to send again, instead of exit directly. It is difficult to change
> > the uncorrect behaviors of userspace applications, so choose to revert it.  
> 
> Your change would restore the old behavior to handle all sockets like they 
> are blocking sockets, trying forever to send the provided data bytes.
> This is not how it should work.

Isn't the application supposed to make the socket non-blocking or
pass MSG_DONTWAIT if it doesn't want to sleep? It's unclear why 
the fix was needed in the first place.
 
> We encountered the same issue with netperf, but this is the only 'broken'
> application that we know of so far which does not implement the socket API
> correctly.

