Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B5A964BE
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbfHTPkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:40:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729351AbfHTPkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:40:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2399A10576D3;
        Tue, 20 Aug 2019 15:40:10 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DF9A1000324;
        Tue, 20 Aug 2019 15:40:08 +0000 (UTC)
Date:   Tue, 20 Aug 2019 17:40:05 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation
 to mdiobus_write_sts
Message-ID: <20190820154005.GM891@localhost>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at>
 <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost>
 <20190820152306.GJ29991@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820152306.GJ29991@lunn.ch>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 20 Aug 2019 15:40:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 05:23:06PM +0200, Andrew Lunn wrote:
> > - take a second "post" system timestamp after the completion
> 
> For this hardware, completion is an interrupt, which has a lot of
> jitter on it. But this hardware is odd, in that it uses an
> interrupt. Every other MDIO bus controller uses polled IO, with an
> mdelay(10) or similar between each poll. So the jitter is going to be
> much larger.

I think a large jitter is ok in this case. We just need to timestamp
something that we know for sure happened after the PHC timestamp. It
should have no impact on the offset and its stability, just the
reported delay. A test with phc2sys should be able to confirm that.
phc2sys selects the measurement with the shortest delay, which has
least uncertainty. I'd say that applies to both interrupt and polling.

If it is difficult to specify the minimum interrupt delay, I'd still
prefer an overly pessimistic interval assuming a zero delay.

-- 
Miroslav Lichvar
