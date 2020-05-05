Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088881C643A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgEEW7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:59:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728717AbgEEW7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588719557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLmdw3LXI4CtXnPp/sh022YqaVJWK6SleAWQvTfde7A=;
        b=cd4X4SN5dHyVm5oNWjaMemhL4cGDVXFHjoYJt6vBhtefk5hkaF+LBGZmNu5yVFrEcvVxiW
        jUYYcaE09QIe1zugH8jl1MGRFUIMdHze6llNtue80G7m1mj8C8umCLtgWQaiENnd5ddBAJ
        nSBMmUkpvSw5IGRLsgpouHS9p1+LJpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-B6M9_wFJNq6Ytglhin6_Vg-1; Tue, 05 May 2020 18:59:15 -0400
X-MC-Unique: B6M9_wFJNq6Ytglhin6_Vg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 389A1835B8B;
        Tue,  5 May 2020 22:59:13 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 592885D9C5;
        Tue,  5 May 2020 22:59:11 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v2 0/3] bonding: support hardware crypto offload
Date:   Tue,  5 May 2020 18:58:35 -0400
Message-Id: <20200505225838.59505-1-jarod@redhat.com>
In-Reply-To: <20200504145943.8841-1-jarod@redhat.com>
References: <20200504145943.8841-1-jarod@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an initial "proof of concept" functional implementation for doing
pass-through of hardware encryption from bonding device to capable slaves=
.
This was tested using an ixgbe-driven Intel x520 NIC with libreswan and a
transport mode connection, on top of an active-backup bond, using netperf
and downing an interface during. Failover takes a moment, but does work,
and overall performance is right on par with offload when running on a
bare interface.

Caveats: this is ONLY enabled for active-backup, because I'm not sure
how one would manage multiple offload handles for different devices all
running at the same time in the same xfrm, and it relies on some minor
changes to both the xfrm code and slave device driver code to get things
to behave, and I don't have immediate access to any other hardware that
could function similarly to update driver code accordingly.

I'm hoping folks with more of an idea about xfrm have some thoughts on
ways to make this cleaner, and possibly support more bonding modes, but
I'm reasonably happy I've made it this far. :)

v2: fix build with CONFIG_XFRM_OFFLOAD disabled and rebase on latest
    net-next tree bonding changes

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
CC: intel-wired-lan@lists.osuosl.org

Jarod Wilson (3):
  xfrm: bail early on slave pass over skb
  ixgbe_ipsec: become aware of when running as a bonding slave
  bonding: support hardware encryption offload to slaves

 drivers/net/bonding/bond_main.c               | 111 +++++++++++++++++-
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |  39 ++++--
 include/net/bonding.h                         |   3 +
 include/net/xfrm.h                            |   1 +
 net/xfrm/xfrm_device.c                        |  34 +++---
 5 files changed, 160 insertions(+), 28 deletions(-)

--=20
2.20.1

