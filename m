Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781CDDF407
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfJURSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:18:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27514 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727017AbfJURSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571678330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=COUQpCQOyKZl+Mt1Tp8T4A2/59o1xTpxVAS5tO6bCLs=;
        b=MGvta99edb7lVgzvuOFk6JauPNQbHIP5TcmK7i09xCcYMfcCGZthKjJdw2qdjJGfMsuMcq
        wJcbkrTjYto+V6segvLySaM2w3491FeYfVl1x3O6p4SeVk1N6lr1PfXrKByAurcRkdsur8
        E+ogYuUq5y9FdnEMkYO40pGihSMno7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-xeMj4WMUPPquj-nL25zMSw-1; Mon, 21 Oct 2019 13:18:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99AFD800D41;
        Mon, 21 Oct 2019 17:18:45 +0000 (UTC)
Received: from localhost (unknown [10.14.78.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 249A55C28F;
        Mon, 21 Oct 2019 17:18:45 +0000 (UTC)
Date:   Mon, 21 Oct 2019 19:18:44 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191021191844.1e57f9a0@redhat.com>
In-Reply-To: <CALx6S342=MKHK35=H+2xMW9odHKMj7A5Ws+kNVGxzTDFnxdsPQ@mail.gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
        <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
        <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
        <20191009124814.GB17712@martin-VirtualBox>
        <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
        <20191009174216.1b3dd3dc@redhat.com>
        <CALx6S342=MKHK35=H+2xMW9odHKMj7A5Ws+kNVGxzTDFnxdsPQ@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: xeMj4WMUPPquj-nL25zMSw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 13:03:56 -0700, Tom Herbert wrote:
> More specifically fou allows encapsulation of anything that has an IP
> protocol number. That includes an L3 protocols that have been assigned
> a number (e.g. MPLS, GRE, IPv6, IPv4, EtherIP). So the only need for
> an alternate method to do L3 encapsulation would be for those
> protocols that don't have an IP protocol number assignment.
> Presumably, those just have an EtherType. In that case, it seems
> simple enough to just extend fou to processed an encapsulated
> EtherType. This should be little more than modifying the "struct fou"
> to hold 16 bit EtherType (union with protocol), adding
> FOU_ENCAP_ETHER, corresponding attribute, and then populate
> appropriate receive functions for the socket.

How do you suggest to plug that in? We need the received inner packets
to be "encapsulated" in an Ethernet header; the current approach of
"ip link add type ipip|sit encap fou" does not work here. Are you
suggesting to add another rtnl link type? How would it look like?
"ip link add type ethernet encap fou" does not sound appealing,
especially since "type ethernet" would have no meaning without the
"encap fou".

Thanks,

 Jiri

