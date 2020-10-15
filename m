Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBFE28EFDC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 12:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbgJOKIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 06:08:10 -0400
Received: from lechat.rtp-net.org ([51.15.165.164]:52202 "EHLO
        lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbgJOKIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 06:08:10 -0400
X-Greylist: delayed 1932 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2020 06:08:09 EDT
Received: by lechat.rtp-net.org (Postfix, from userid 115)
        id C256E1808BA; Thu, 15 Oct 2020 12:08:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on lechat.rtp-net.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from lechat.rtp-net.org (localhost [IPv6:::1])
        by lechat.rtp-net.org (Postfix) with ESMTPS id D366B180293;
        Thu, 15 Oct 2020 12:08:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=rtp-net.org; s=email;
        t=1602756480; bh=/WP2iatIa6ZGmlsfOvc3rkcr4CT/R4RHFTNo01YUKWk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kVbdlxhWmyVpu8RAONRZ3NsI4UCW1y740Zo7qCI0egcGUmP9fLDI9YLzOQv/LKA+x
         Lg9mhjNHh029ecEAn3yWv8lVLtAeZUd0k2jFgs2QjJ7pLb742vcuMb6u+StqJENYvt
         wBg7yncIgJttJx9OWHhld4NMs8VzYAHvjY638jWuk4L1+GVffq4tPreCMt3+L2ip56
         ywnB+B5POLi+KC5YlKMq4VDR4cCGHtmiSky5hWtlXfiv2y2dJe1A1iG6E4TDy27WqO
         IX8Weny2SO97XkeVBzYen1Wf1SlspGfsfLNU400PR2zZYSEVevUTEzFF7iyV7QhA8V
         A+4v5wAPtZzJr5sMraHf6nErEJHbv+txK2QTvyDN7GEfpJr3eYXKwnS9NtQJibWvqr
         v4Yv8Hc9+Nt7yjQukENjSWRVpSNoJKFqSjraOimeBKTTiv39azUsZ3ceQ8XUoK79cO
         E1k9/dDdE+Vot7G4OUEgS9Z2T2s29lESWGfZfPjn0vBp4E7rsuAcyHdEb22qlXpWFq
         7+cMkkFo6iVHiKhFDXuQa7xyam3Nlaf670UNFkJ19m7bUY7h0sOYNVirBWkOChGY4c
         RJQsPhdWWTIKjgqyKZgOgoUGwAWgWSv1mLJ6AzlSRBxPB9Ih7PUWONyYektyiZx//s
         zex23j9vjprfOPyRd75t7meo=
From:   Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case
Organization: RtpNet
References: <20201015093221.720980174@rtp-net.org>
        <20201015100455.GA3938169@kroah.com>
Date:   Thu, 15 Oct 2020 12:08:00 +0200
In-Reply-To: <20201015100455.GA3938169@kroah.com> (Greg KH's message of "Thu,
        15 Oct 2020 12:04:55 +0200")
Message-ID: <87wnzr6bun.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Oct 15, 2020 at 11:32:15AM +0200, Arnaud Patard wrote:
>> commit d934423ac26ed373dfe089734d505dca5ff679b6 upstream.
>> 
>> Orion5.x systems are still using machine files and not device-tree.
>> Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
>> specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
>> leading to a oops at boot and not working network, as reported in
>> https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
>>     
>> Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
>> Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
>> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> 
>
> What stable tree(s) are you asking for this to be backported to?

oops, forgot to put it in the mail subject. It's for 4.19.X, which is
used in Debian stable.

Arnaud
