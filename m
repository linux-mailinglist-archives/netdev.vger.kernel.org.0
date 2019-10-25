Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF68DE4889
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438844AbfJYKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:24:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438821AbfJYKY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 06:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571999067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fd3Y3oI+rraDy+voQIUbavglENhhZeRqRgQHciU38fk=;
        b=VUreUnu/VHC7lLzD5Fz+/YvNzndK6UEC8FKwjKQgtaM23B4uuftEMc4WnFDpGTaTfMIfZ3
        AW7Kjk7zoit+fPVdHb2WGnmWrRW+pYdCzP/pMbu3p4jHx4RWMGYdATKsDchmrVoYc5PzHw
        9rQxiQQBBzU85x70n3ygnhwvreO4myM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-fTKGBHY-MAOjZVqjlRZ2hg-1; Fri, 25 Oct 2019 06:24:26 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9D961005509;
        Fri, 25 Oct 2019 10:24:24 +0000 (UTC)
Received: from ovpn-116-201.ams2.redhat.com (ovpn-116-201.ams2.redhat.com [10.36.116.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA7AB1001B28;
        Fri, 25 Oct 2019 10:24:23 +0000 (UTC)
Message-ID: <e73c5f4e91c194a35fcb07a824dec3b0335494b3.camel@redhat.com>
Subject: Re: [PATCH net] ipv4: fix route update on metric change.
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 25 Oct 2019 12:24:22 +0200
In-Reply-To: <a93347d4-b363-23c8-75e4-d5d0c8ad4592@gmail.com>
References: <84623b02bd882d91555b9bf76ea58d6cff29cd2a.1571908701.git.pabeni@redhat.com>
         <a93347d4-b363-23c8-75e4-d5d0c8ad4592@gmail.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: fTKGBHY-MAOjZVqjlRZ2hg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-24 at 09:50 -0600, David Ahern wrote:
> On 10/24/19 3:19 AM, Paolo Abeni wrote:
> > Since commit af4d768ad28c ("net/ipv4: Add support for specifying metric
> > of connected routes"), when updating an IP address with a different met=
ric,
> > the associated connected route is updated, too.
> >=20
> > Still, the mentioned commit doesn't handle properly some corner cases:
> >=20
> > $ ip addr add dev eth0 192.168.1.0/24
> > $ ip addr add dev eth0 192.168.2.1/32 peer 192.168.2.2
> > $ ip addr add dev eth0 192.168.3.1/24
> > $ ip addr change dev eth0 192.168.1.0/24 metric 10
> > $ ip addr change dev eth0 192.168.2.1/32 peer 192.168.2.2 metric 10
> > $ ip addr change dev eth0 192.168.3.1/24 metric 10
> > $ ip -4 route
> > 192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.0
> > 192.168.2.2 dev eth0 proto kernel scope link src 192.168.2.1
> > 192.168.3.0/24 dev eth0 proto kernel scope link src 192.168.2.1 metric =
10
>=20
> Please add this test and route checking to
> tools/testing/selftests/net/fib_tests.sh. There is a
> ipv4_addr_metric_test function that handles permutations and I guess the
> above was missed.

Do you prefer a net-next patch for that, or a repost on -net with a
separate patch for the self-test appended?

> Also, does a similar sequence for IPv6 work as expected?

Just tested, it works without issue, It looks like IPv6 has not special
handing connected route with peers/128 bit masks.

Thank you,

Paolo

