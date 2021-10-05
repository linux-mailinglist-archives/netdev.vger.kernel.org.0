Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648974231DA
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhJEU1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:27:48 -0400
Received: from mail.w1.fi ([212.71.239.96]:45786 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhJEU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 16:27:48 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2021 16:27:47 EDT
Received: from localhost (localhost [127.0.0.1])
        by li674-96.members.linode.com (Postfix) with ESMTP id 6DC7A110DE;
        Tue,  5 Oct 2021 20:20:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W-kqsIKIJhpv; Tue,  5 Oct 2021 20:20:47 +0000 (UTC)
Received: by jm (sSMTP sendmail emulation); Tue, 05 Oct 2021 23:20:45 +0300
Date:   Tue, 5 Oct 2021 23:20:45 +0300
From:   Jouni Malinen <j@w1.fi>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Youghandhar Chintala <youghand@codeaurora.org>,
        Abhishek Kumar <kuabhs@chromium.org>,
        Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
Message-ID: <20211005202045.GA18000@w1.fi>
References: <20201215172352.5311-1-youghand@codeaurora.org>
 <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
 <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
 <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
 <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
 <66ba0f836dba111b8c7692f78da3f079@codeaurora.org>
 <5826123db4731bde01594212101ed5dbbea4d54f.camel@sipsolutions.net>
 <30fa98673ad816ec849f34853c9e1257@codeaurora.org>
 <90d3c3c8cedcf5f8baa77b3b6e94b18656fcd0be.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90d3c3c8cedcf5f8baa77b3b6e94b18656fcd0be.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 11:20:50AM +0200, Johannes Berg wrote:
> > We thought sending the delba would solve the problem as earlier thought 
> > but the actual problem is with TX PN in a secure mode.
> > It is not because of delba that the Seq number and TX PN are reset to 
> > zero.
> > It’s because of the HW restart, these parameters are reset to zero.
> > Since FW/HW is the one which decides the TX PN, when it goes through 
> > SSR, all these parameters are reset.
> 
> Right, we solved this problem too - in a sense the driver reads the
> database (not just TX PN btw, also RX replay counters) when the firmware
> crashes, and sending it back after the restart. mac80211 has some hooks
> for that.

This might be doable for some cases where the firmware is the component
assigning the PN values on TX and the firmware still being in a state
where the counter used for this could be fetched after a crash or
detected misbehavior. However, this does not sound like a very reliable
mechanism for cases where the firmware state for this cannot be trusted
or for the cases where the TX PN is actually assigned by the hardware
(which would get cleared on that restart and the value might be
unreadable before that restart). Trying to pull for this information
periodically before the issue is detected does not sound like a very
robust design either, since that would both waste resources and have a
race condition with the lower layers having transmitted additional
frames.

Obviously it would be nice to be able to restore this type of state in
all cases accurately, but that may not really be a viable approach for
all designs and it would seem to make sense to provide an alternative
approach to minimize the user visible impact from the rare cases of
having to restart some low level components during an association.

-- 
Jouni Malinen                                            PGP id EFC895FA
