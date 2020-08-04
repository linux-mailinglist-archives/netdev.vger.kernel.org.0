Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB74B23C047
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgHDTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHDTsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:48:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261EDC06174A;
        Tue,  4 Aug 2020 12:48:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFC24128809BC;
        Tue,  4 Aug 2020 12:31:13 -0700 (PDT)
Date:   Tue, 04 Aug 2020 12:47:56 -0700 (PDT)
Message-Id: <20200804.124756.115062893076378926.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, gnault@redhat.com, pmachata@gmail.com,
        roopa@cumulusnetworks.com, dsahern@kernel.org, akaris@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCHv2 net 2/2] vxlan: fix getting tos value from DSCP field
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804014312.549760-3-liuhangbin@gmail.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
        <20200804014312.549760-1-liuhangbin@gmail.com>
        <20200804014312.549760-3-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 12:31:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue,  4 Aug 2020 09:43:12 +0800

> In commit 71130f29979c ("vxlan: fix tos value before xmit") we strict
> the vxlan tos value before xmit. But as IP tos field has been obsoleted
> by RFC2474, and updated by RFC3168 later. We should use new DSCP field,
> or we will lost the first 3 bits value when xmit.
> 
> Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Looking at the Fixes: tag commit more closely, it doesn't make much
sense at all to me and I think the fix is that the Fixes: commit
should be reverted.

If you pass the raw TOS into ip_tunnel_ecn_encap(), then that has the
same exact effect as your patch series here.  The ECN encap routines
will clear the ECN bits before potentially incorporating the ECN value
from the inner header etc.  The clearing of the ECN bits done by your
RT_DSCP() helper is completely unnecessary, the ECN helpers do the
right thing.  So effectively the RT_DSCP() isn't changing the tos
value at all.

I also think that your commit messages are lacking, as you fail
(especially in the Fixes: commit) to show exactly where things go
wrong.  It's always good to give example code paths and show what
happens to the TOS and/or ECN values in these places, what part of
that transformation you feel is incorrect, and what exactly you
believe the correct transformation to be.

I'm not applying this series, sorry.
