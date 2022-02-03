Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675464A888B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352197AbiBCQ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:28:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:21380 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234500AbiBCQ20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 11:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643905706; x=1675441706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PuH5JHLTlQ8niLBlqJpVGw2sqNOjPzx7LuDvrGQ+67w=;
  b=GnIjy2wA+9ThV/ZFcC0MusnH2crCtYHpUpOs/sNIlD82afEs6pEiEihH
   +vZ2mYZrwL5mUERjuTM+JXoVVFZm0pERI3av+JVd+pkwW1srGvxvVJzUy
   yqhPFJCQPx0MPfT8fHzDoVT14m2m/JdwBcoRBFD3TDvVmQar191lfJpyy
   z26/Axoj5sqnOVnecw62ZUp4eFF8ftNZVuVRTiv2LY3qAhmyQ0RFfyeAT
   UV5lH+0NaW0WoG5LSM0nmSgX5v78swU/N+3RAQSqtvasXnruArQNeAIdQ
   IqVcv38fwNnjd8BPQzZaBXo6cx2al4Opqvr0tGKIWCpfusDYy9jW0E8rk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="248395764"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="248395764"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 08:28:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="566448276"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 03 Feb 2022 08:28:12 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 213GSBXM020378;
        Thu, 3 Feb 2022 16:28:11 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 3/3] net: gro: register gso and gro offload on separate lists
Date:   Thu,  3 Feb 2022 17:26:19 +0100
Message-Id: <20220203162619.13881-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CANn89iLvee2jqB7R7qap9i-_johkbKofHE4ARct18jM_DwdaZg@mail.gmail.com>
References: <cover.1643902526.git.pabeni@redhat.com> <550566fedb425275bb9d351a565a0220f67d498b.1643902527.git.pabeni@redhat.com> <CANn89iLvee2jqB7R7qap9i-_johkbKofHE4ARct18jM_DwdaZg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 3 Feb 2022 08:11:43 -0800

> On Thu, Feb 3, 2022 at 7:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > So that we know each element in gro_list has valid gro callbacks
> > (and the same for gso). This allows dropping a bunch of conditional
> > in fastpath.
> >
> > Before:
> > objdump -t net/core/gro.o | grep " F .text"
> > 0000000000000bb0 l     F .text  000000000000033c dev_gro_receive
> >
> > After:
> > 0000000000000bb0 l     F .text  0000000000000325 dev_gro_receive
> >
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/linux/netdevice.h |  3 +-
> >  net/core/gro.c            | 90 +++++++++++++++++++++++----------------
> >  2 files changed, 56 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 3213c7227b59..406cb457d788 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -2564,7 +2564,8 @@ struct packet_offload {
> >         __be16                   type;  /* This is really htons(ether_type). */
> >         u16                      priority;
> >         struct offload_callbacks callbacks;
> > -       struct list_head         list;
> > +       struct list_head         gro_list;
> > +       struct list_head         gso_list;
> >  };
> >
> 
> On the other hand, this makes this object bigger, increasing the risk
> of spanning cache lines.

As you said, GSO callbacks are barely used with most modern NICs.
Plus GRO and GSO callbacks are used in the completely different
operations.
`gro_list` occupies the same place where the `list` previously was.
Does it make a lot of sense to care about `gso_list` being placed
in a cacheline separate from `gro_list`?

> 
> It would be nice to group all struct packet_offload together in the
> same section to increase data locality.
> 
> I played in the past with a similar idea, but splitting struct
> packet_offload in two structures, one for GRO, one for GSO.
> (Note that GSO is hardly ever use with modern NIC)
> 
> But the gains were really marginal.

Thanks,
Al
