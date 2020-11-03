Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA52A4FEC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgKCTTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:14 -0500
Received: from mg.ssi.bg ([178.16.128.9]:45192 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbgKCTTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:19:10 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id B70F42A4DD;
        Tue,  3 Nov 2020 21:19:06 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id B7AC12A5C1;
        Tue,  3 Nov 2020 21:19:05 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id BF6403C09C1;
        Tue,  3 Nov 2020 21:19:02 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 0A3JIv8w008680;
        Tue, 3 Nov 2020 21:19:00 +0200
Date:   Tue, 3 Nov 2020 21:18:57 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     =?UTF-8?Q?Cezar_S=C3=A1_Espinola?= <cezarsa@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH RFC] ipvs: add genetlink cmd to dump all services and
 destinations
In-Reply-To: <CA++F93jp=6mfVm9brGOMeBE0EKoJhg4EAuN04jeBnXKsC-rTag@mail.gmail.com>
Message-ID: <5b911129-e3de-f198-625a-8998cd6cdf0@ssi.bg>
References: <20201030202727.1053534-1-cezarsa@gmail.com> <9140ef65-f76d-4bf1-b211-e88c101a5461@ssi.bg> <CA++F93jp=6mfVm9brGOMeBE0EKoJhg4EAuN04jeBnXKsC-rTag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1624316750-1604431142=:3799"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1624316750-1604431142=:3799
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Tue, 3 Nov 2020, Cezar Sá Espinola wrote:

> >         And now what happens if all dests can not fit in a packet?
> > We should start next packet with the same svc? And then
> > user space should merge the dests when multiple packets
> > start with same service?
> 
> My (maybe not so great) idea was to avoid repeating the svc on each
> packet. It's possible for a packet to start with a destination and
> user space must consider then as belonging to the last svc received on
> the previous packet. The comparison "ctx->last_svc != svc" was
> intended to ensure that a packet only starts with destinations if the
> current service is the same as the svc we sent on the previous packet.

	You can also consider the idea of having 3 coordinates
for start svc: idx_svc_tab (0 or 1), idx_svc_row (0..IP_VS_SVC_TAB_SIZE-1)
and idx_svc for index in row's chain. On new packet this will
indicate the htable and its row and we have to skip svcs in
this row to find our starting svc. I think, this will still fit in
the netlink_callback's args area. If not, we can always kmalloc
our context in args[0]. In single table, this should speedup
the start svc lookup 128 times in average (we have 256 rows).
In setup with 1024 svcs (average 4 in each of the 256 rows)
we should skip these 0..3 entries instead of 512 in average.

> >         last_svc is used out of __ip_vs_mutex region,
> > so it is not safe. We can get a reference count but this
> > is bad if user space blocks.
> 
> I thought it would be relatively safe to store a pointer to the last
> svc since I would only use it for pointer comparison and never
> dereferencing it. But in retrospect it does look unsafe and fragile
> and could probably lead to errors especially if services are modified
> during a dump causing the stored pointer to point to a different
> service.

	Yes, nobody is using such pointers. We should create
packets that correctly identify svc for the dests. The drawback
is that user space may need more work for merging. We can always
create a sorted array of pointers to svcs, so that we can binary
search with bsearch() the svc from every received packet. Then we
will know if this is a new svc or an old one (with dests in
multiple packets). Should we also check for dest duplicates in
the svc? The question is how much safe we should play. In
user space the max work we can do is to avoid duplicates
and to put dests to their correct svc.

> >         But even if we use just indexes it should be ok.
> > If multiple agents are used in parallel it is not our
> > problem. What can happen is that we can send duplicates
> > or to skip entries (both svcs and dests). It is impossible
> > to keep any kind of references to current entries or even
> > keys to lookup them if another agent can remove them.
> 
> Got it. I noticed this behavior while writing this patch and even
> created a few crude validation scripts running parallel agents and
> checking the diff in [1].

	Ok, make sure your tests cover cases with multiple
dests, so that single service occupies multiple packets,
I'm not sure if 100 dests fit in one packet or not.

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1624316750-1604431142=:3799--

