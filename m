Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1997468
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfHUIHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 04:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1773 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHUIHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 04:07:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2148D7F742;
        Wed, 21 Aug 2019 08:07:14 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 482E65F74;
        Wed, 21 Aug 2019 08:07:12 +0000 (UTC)
Date:   Wed, 21 Aug 2019 10:07:09 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation
 to mdiobus_write_sts
Message-ID: <20190821080709.GO891@localhost>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at>
 <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost>
 <20190820152306.GJ29991@lunn.ch>
 <20190820154005.GM891@localhost>
 <CAFfN3gUgpzMebyUt8_-9e+5vpm3q-DVVszWdkUEFAgZQ8ex73w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFfN3gUgpzMebyUt8_-9e+5vpm3q-DVVszWdkUEFAgZQ8ex73w@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 21 Aug 2019 08:07:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 06:56:56PM +0200, Hubert Feurstein wrote:
> Am Di., 20. Aug. 2019 um 17:40 Uhr schrieb Miroslav Lichvar
> > I think a large jitter is ok in this case. We just need to timestamp
> > something that we know for sure happened after the PHC timestamp. It
> > should have no impact on the offset and its stability, just the
> > reported delay. A test with phc2sys should be able to confirm that.
> > phc2sys selects the measurement with the shortest delay, which has
> > least uncertainty. I'd say that applies to both interrupt and polling.
> >
> > If it is difficult to specify the minimum interrupt delay, I'd still
> > prefer an overly pessimistic interval assuming a zero delay.
> >
> Currently I do not see the benefit from this. The original intention was to
> compensate for the remaining offset as good as possible.

That's ok, but IMHO the change should not break the assumptions of
existing application and users.

> The current code
> of phc2sys uses the delay only for the filtering of the measurement record
> with the shortest delay and for reporting and statistics. Why not simple shift
> the timestamps with the offset to the point where we expect the PHC timestamp
> to be captured, and we have a very good result compared to where we came
> from.

Because those reports/statistics are important in calculation of
maximum error. If someone had a requirement for a clock to be accurate
to 1.5 microseconds and the ioctl returned a delay indicating a
sufficient accuracy when in reality it could be worse, that would be a
problem.

BTW, phc2sys is not the only user of the ioctl.

-- 
Miroslav Lichvar
