Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF648D8A0
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfHNQ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:59:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNQ7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:59:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78D4F154CEC78;
        Wed, 14 Aug 2019 09:58:59 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:58:58 -0400 (EDT)
Message-Id: <20190814.125858.37782529545578263.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     gnault@redhat.com, haliu@redhat.com, edumazet@google.com,
        linus.luessing@c0d3.blue, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Fix return value of ipv6_mc_may_pull() for
 malformed packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
References: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 09:58:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Tue, 13 Aug 2019 00:46:01 +0200

> Commit ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and
> ipv6_mc_check_mld() calls") replaces direct calls to pskb_may_pull()
> in br_ipv6_multicast_mld2_report() with calls to ipv6_mc_may_pull(),
> that returns -EINVAL on buffers too short to be valid IPv6 packets,
> while maintaining the previous handling of the return code.
> 
> This leads to the direct opposite of the intended effect: if the
> packet is malformed, -EINVAL evaluates as true, and we'll happily
> proceed with the processing.
> 
> Return 0 if the packet is too short, in the same way as this was
> fixed for IPv4 by commit 083b78a9ed64 ("ip: fix ip_mc_may_pull()
> return value").
> 
> I don't have a reproducer for this, unlike the one referred to by
> the IPv4 commit, but this is clearly broken.
> 
> Fixes: ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and ipv6_mc_check_mld() calls")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Applied and queued up for -stable.
