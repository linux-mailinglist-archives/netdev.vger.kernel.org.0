Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E26B38079C
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 20:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfHCSDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 14:03:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbfHCSDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 14:03:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A2B8153F53ED;
        Sat,  3 Aug 2019 11:03:40 -0700 (PDT)
Date:   Sat, 03 Aug 2019 11:03:39 -0700 (PDT)
Message-Id: <20190803.110339.449734752227362483.davem@davemloft.net>
To:     cai@lca.pw
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, David.Laight@ACULAB.COM,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/socket: fix GCC8+ Wpacked-not-aligned warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564500633-7419-1-git-send-email-cai@lca.pw>
References: <1564500633-7419-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 03 Aug 2019 11:03:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Tue, 30 Jul 2019 11:30:33 -0400

> There are a lot of those warnings with GCC8+ 64-bit,
 ...
> This is because the commit 20c9c825b12f ("[SCTP] Fix SCTP socket options
> to work with 32-bit apps on 64-bit kernels.") added "packed, aligned(4)"
> GCC attributes to some structures but one of the members, i.e, "struct
> sockaddr_storage" in those structures has the attribute,
> "aligned(__alignof__ (struct sockaddr *)" which is 8-byte on 64-bit
> systems, so the commit overwrites the designed alignments for
> "sockaddr_storage".
> 
> To fix this, "struct sockaddr_storage" needs to be aligned to 4-byte as
> it is only used in those packed sctp structure which is part of UAPI,
> and "struct __kernel_sockaddr_storage" is used in some other
> places of UAPI that need not to change alignments in order to not
> breaking userspace.
> 
> Use an implicit alignment for "struct __kernel_sockaddr_storage" so it
> can keep the same alignments as a member in both packed and un-packed
> structures without breaking UAPI.
> 
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Qian Cai <cai@lca.pw>

Ok, this just changes how the alignment is declared from using the
aligned attribute to using a union member which requires the same
alignment.

Applied.
