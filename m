Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3CA1F51CC
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFJKDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:03:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35962 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727946AbgFJKDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591783425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3gVkRYNcyACplWqSVHWQ8TB063FgXgKpFwaGhzUCAc=;
        b=SfLq/ehYF/CuzWpK4ZdVAuWZbNGZ66z+lq3t6EpdmOo3CzDTRvNuo/dP3qfXqz5h9e6QoY
        fPV4lbMposXWdCRzzl1+IWGOhbgoV+cKqWHrxwoY1EmxTHL/Dnh89kURKm6iZaQL0E2uxu
        N6Ytk9yfaG/0vznmL13U8/qj5z7cVrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-T8iVgHxrNIi00NgPnGyftQ-1; Wed, 10 Jun 2020 06:03:43 -0400
X-MC-Unique: T8iVgHxrNIi00NgPnGyftQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EA0E107ACCD;
        Wed, 10 Jun 2020 10:03:42 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 893017C336;
        Wed, 10 Jun 2020 10:03:31 +0000 (UTC)
Date:   Wed, 10 Jun 2020 12:03:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv4 bpf-next 0/2] xdp: add dev map multicast support
Message-ID: <20200610120330.5dbdcce2@carbon>
In-Reply-To: <20200610023508.GR102436@dhcp-12-153.nay.redhat.com>
References: <20200604040940.GL102436@dhcp-12-153.nay.redhat.com>
        <871rmvkvwn.fsf@toke.dk>
        <20200604121212.GM102436@dhcp-12-153.nay.redhat.com>
        <87bllzj9bw.fsf@toke.dk>
        <20200604144145.GN102436@dhcp-12-153.nay.redhat.com>
        <87d06ees41.fsf@toke.dk>
        <20200605062606.GO102436@dhcp-12-153.nay.redhat.com>
        <878sgxd13t.fsf@toke.dk>
        <20200609030344.GP102436@dhcp-12-153.nay.redhat.com>
        <87lfkw7zhk.fsf@toke.dk>
        <20200610023508.GR102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jun 2020 10:35:08 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Tue, Jun 09, 2020 at 10:31:19PM +0200, Toke H=C3=83=C2=B8iland-J=C3=83=
=C2=B8rgensen wrote:
> > > Oh, sorry for the typo, the numbers make me crazy, it should be only
> > > ingress i40e, egress veth. Here is the right description:
> > >
> > > Kernel 5.7 + my patch(ingress i40e, egress i40e)
> > > xdp_redirect_map:
> > >   generic mode: 1.9M PPS
> > >   driver mode: 10.2M PPS
> > >
> > > xdp_redirect_map_multi:
> > >   generic mode: 1.58M PPS
> > >   driver mode: 7.16M PPS
> > >
> > > Kernel 5.7 + my patch(ingress i40e, egress veth(No XDP on peer))
> > > xdp_redirect_map:
> > >   generic mode: 2.2M PPS
> > >   driver mode: 14.2M PPS =20
> >=20
> > A few messages up-thread you were getting 4.15M PPS in this case - what
> > changed? It's inconsistencies like these that make me suspicious of the
> > whole set of results :/ =20
>=20
> I got the number after a reboot, not sure what happened.
> And I also feel surprised... But the result shows the number, so I have
> to put it here.
>=20
> >=20
> > Are you getting these numbers from ethtool_stats.pl or from the XDP
> > program? What counter are you looking at, exactly? =20
>=20
> For bridge testing I use ethtool_stats.pl. For later xdp_redirect_map
> and xdp_redirect_map_multi testing, I checked that ethtool_stats.pl and
> XDP program shows the same number. When run ethtool_stats.pl the number
> will go a little bit slower. So at the end I use the xdp program's number.

You cannot trust the xdp program's number, because it just counts all
RX-packets, and don't take into account if the packets are getting
dropped.  We really want to verify (e.g. with ethtool_stats.pl) that
the packets were successfully transmitted.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

