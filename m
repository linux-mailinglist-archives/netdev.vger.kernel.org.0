Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F3515F73
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 10:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfEGIgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 04:36:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfEGIgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 04:36:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E7D93079B69;
        Tue,  7 May 2019 08:36:03 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48CB75D9D1;
        Tue,  7 May 2019 08:36:01 +0000 (UTC)
Date:   Tue, 7 May 2019 10:35:59 +0200
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, Jiri Benc <jbenc@redhat.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next] macvlan: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to real device
Message-ID: <20190507083559.GD13858@localhost>
References: <20190417154306.om6rjkxq4hikhsht@localhost>
 <20190417205958.6508bda2@redhat.com>
 <20190418033157.irs25halxnemh65y@localhost>
 <20190418080509.GD5984@localhost>
 <20190423041817.GE18865@dhcp-12-139.nay.redhat.com>
 <20190423083141.GA5188@localhost>
 <20190423091543.GF18865@dhcp-12-139.nay.redhat.com>
 <20190423093213.GA7246@localhost>
 <20190425134006.GG18865@dhcp-12-139.nay.redhat.com>
 <20190506140123.k2kw7apaubvljsa5@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506140123.k2kw7apaubvljsa5@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 07 May 2019 08:36:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 07:01:23AM -0700, Richard Cochran wrote:
> On Thu, Apr 25, 2019 at 09:40:06PM +0800, Hangbin Liu wrote:
> > Would you please help have a look at it and see which way we should use?
> > Drop SIOCSHWTSTAMP in container or add a filter on macvlan(maybe only in
> > container)?
> 
> I vote for dropping SIOCSHWTSTAMP altogether.  Why?  Because the
> filter idea means that the ioctl will magically succeed or fail, based
> on the unknowable state of the container's host.

That's a good point. I agree that SIOCSHWTSTAMP always failing would
be a less surprising behavior than failing only with some specific
configurations.

> It is better IMHO to
> let the admin of the host set up HWTSTAMP globally (like with
> hwtstamp_ctl for example) and configure the apps appropriately (like
> with ptp4l --hwts_filter=check).

Makes sense to me.

Some applications that support HW timestamping cannot do that
currently (they call SIOCSHWTSTAMP even if nothing is changing), but
it shouldn't be difficult to add support for this case.

Thanks,

-- 
Miroslav Lichvar
