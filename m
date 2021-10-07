Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244B4425758
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbhJGQGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235232AbhJGQF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58AFF60F9C;
        Thu,  7 Oct 2021 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633622645;
        bh=tf0G0RGsr4RO11iT0sEPjUlA9rmNBxhk4Q4mxta2poI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E3oZ77wsEKq+YDVsHOc52CpKWU10Bh+1YziLNcD5i2qxsA2s/EFBKWpdNT4jqCmwU
         eND46M9XEdZIMf6UcETF+n2rMBkGIgk0kg6V+QoNDczUCA7iGuyfU5wsMcDJJiYqdd
         zrEoILcVhmVNzEJLe97agu1z1s2q+iRuTdS1aLJzzb0/yk1qt+vXS8gBpDC8lwA8bT
         sb6BhnqW4AptFNPyhpPX6geq83YWfPlKcY4ybz3XkOxobd6Ti1fskcuY4HyuUC2of6
         NDdAwPHrDTjlg74xhnxS9PsJ5CPCvS3ZduPGyzSShZ7Z4sM2ElJ0geE6gxTKJSksQx
         YBJCCIDSH9nZA==
Date:   Thu, 7 Oct 2021 09:04:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Palethorpe <rpalethorpe@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@richiejp.com>
Subject: Re: [PATCH v2 2/2] vsock: Enable y2038 safe timeval for timeout
Message-ID: <20211007090404.20e555d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007123147.5780-2-rpalethorpe@suse.com>
References: <20211007123147.5780-1-rpalethorpe@suse.com>
        <20211007123147.5780-2-rpalethorpe@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 13:31:47 +0100 Richard Palethorpe wrote:
> Reuse the timeval compat code from core/sock to handle 32-bit and
> 64-bit timeval structures. Also introduce a new socket option define
> to allow using y2038 safe timeval under 32-bit.
> 
> The existing behavior of sock_set_timeout and vsock's timeout setter
> differ when the time value is out of bounds. vsocks current behavior
> is retained at the expense of not being able to share the full
> implementation.
> 
> This allows the LTP test vsock01 to pass under 32-bit compat mode.
> 
> Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Richard Palethorpe <rpalethorpe@richiejp.com>

This breaks 32bit x86 build:

ERROR: modpost: "__divdi3" [net/vmw_vsock/vsock.ko] undefined!

If the 64 bit division is intention you need to use an appropriate
helper.
