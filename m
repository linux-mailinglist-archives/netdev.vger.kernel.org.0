Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E982BE0A20
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfJVRKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:10:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730701AbfJVRKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571764198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ea0DGR/Fb9YC9/4m0v21gRCZP0VGrlWbEyztpX0Z9ng=;
        b=irqliam/36ddu8lN3Elq8mGowvtvcojLtOhY93kVxqukvGs1ncPavdgIkqMSdIyuApSs2D
        na7211PJVg600qn9xpuHiR5SZ/q4Mt5SqRXMoWYBW/8vt1hc9YPaCoSHZ8qhqo0/BMHsD7
        nnRMN4uECbyF4m3nGCAK004J5W5qo38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-VZbt4oL-PpmSTIGMa51sPQ-1; Tue, 22 Oct 2019 13:09:55 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6717107AD31;
        Tue, 22 Oct 2019 17:09:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-180.rdu2.redhat.com [10.10.121.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE3BF450F;
        Tue, 22 Oct 2019 17:09:49 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DFE65C0AAD; Tue, 22 Oct 2019 14:09:47 -0300 (-03)
Date:   Tue, 22 Oct 2019 14:09:47 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Message-ID: <20191022170947.GA4321@localhost.localdomain>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022151524.GZ4321@localhost.localdomain>
 <vbflftcwzes.fsf@mellanox.com>
MIME-Version: 1.0
In-Reply-To: <vbflftcwzes.fsf@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: VZbt4oL-PpmSTIGMa51sPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 03:52:31PM +0000, Vlad Buslov wrote:
>=20
> On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redhat.com=
> wrote:
> > On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
> >> - Extend actions that are used for hardware offloads with optional
> >>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action flag a=
nd
> >>   update affected actions to not allocate percpu counters when the fla=
g
> >>   is set.
> >
> > I just went over all the patches and they mostly make sense to me. So
> > far the only point I'm uncertain of is the naming of the flag,
> > "fast_init".  That is not clear on what it does and can be overloaded
> > with other stuff later and we probably don't want that.
>=20
> I intentionally named it like that because I do want to overload it with
> other stuff in future, instead of adding new flag value for every single
> small optimization we might come up with :)

Hah :-)

>=20
> Also, I didn't want to hardcode implementation details into UAPI that we
> will have to maintain for long time after percpu allocator in kernel is
> potentially replaced with something new and better (like idr is being
> replaced with xarray now, for example)

I see. OTOH, this also means that the UAPI here would be unstable
(different meanings over time for the same call), and hopefully new
behaviors would always be backwards compatible.

>=20
> Anyway, lets see what other people think. I'm open to changing it.
>=20
> >
> > Say, for example, we want percpu counters but to disable allocating
> > the stats for hw, to make the counter in 28169abadb08 ("net/sched: Add
> > hardware specific counters to TC actions") optional.
> >
> > So what about:
> > TCA_ACT_FLAGS_NO_PERCPU_STATS
> > TCA_ACT_FLAGS_NO_HW_STATS (this one to be done on a subsequent patchset=
, yes)
> > ?
> >
> >   Marcelo
>=20

