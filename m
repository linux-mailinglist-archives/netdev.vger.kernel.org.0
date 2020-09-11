Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A866F265AF5
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgIKH6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 03:58:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725468AbgIKH6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 03:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599811122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XErkIQ5mdeKAcHJcnRXSH+TaJIkkP4+grW1KLUdXd9A=;
        b=AqhGXLBiYiHnq3l//bETnl+EK1zNg/T0d2Ag4UWTK7YvMjAQK3TQcofKjgNnCGI+MFmWob
        5l/99So7x/d4kNePF/9wBvL6KlRf/QSpmqNktyYXxiTLARc8H54OEL8FSL7HwgO9Cvisij
        t+GE8Wj19Pi8800D6Tt9Z5iJL2AFO+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-o5ppQwdiOJWTSU3wDVbcig-1; Fri, 11 Sep 2020 03:58:36 -0400
X-MC-Unique: o5ppQwdiOJWTSU3wDVbcig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF9A81007B01;
        Fri, 11 Sep 2020 07:58:34 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2A6275121;
        Fri, 11 Sep 2020 07:58:21 +0000 (UTC)
Date:   Fri, 11 Sep 2020 09:58:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>, brouer@redhat.com
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200911095820.304d9877@carbon>
In-Reply-To: <47566856-75e2-8f2b-4347-f03a7cb5493b@gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
        <20200907082724.1721685-1-liuhangbin@gmail.com>
        <20200907082724.1721685-3-liuhangbin@gmail.com>
        <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
        <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
        <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
        <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
        <87o8mearu5.fsf@toke.dk>
        <20200910195014.13ff24e4@carbon>
        <47566856-75e2-8f2b-4347-f03a7cb5493b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 12:35:33 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 9/10/20 11:50 AM, Jesper Dangaard Brouer wrote:
> > Maybe we should change the devmap-prog approach, and run this on the
> > xdp_frame's (in bq_xmit_all() to be precise) .  Hangbin's patchset
> > clearly shows that we need this "layer" between running the xdp_prog and
> > the devmap-prog.   
> 
> I would prefer to leave it in dev_map_enqueue.
> 
> The main premise at the moment is that the program attached to the
> DEVMAP entry is an ACL specific to that dev. If the program is going to
> drop the packet, then no sense queueing it.
> 
> I also expect a follow on feature will be useful to allow the DEVMAP
> program to do another REDIRECT (e.g., potentially after modifying). It
> is not handled at the moment as it needs thought - e.g., limiting the
> number of iterative redirects. If such a feature does happen, then no
> sense queueing it to the current device.

It makes a lot of sense to do queuing before redirecting again.  The
(hidden) bulking we do at XDP redirect is the primary reason for the
performance boost. We all remember performance difference between
non-map version of redirect (which Toke fixed via always having the
bulking available in net_device->xdp_bulkq).

In a simple micro-benchmark I bet it will look better running the
devmap-prog right after the xdp_prog (which is what we have today). But
I claim this is the wrong approach, as soon as (1) traffic is more
intermixed, and (2) devmap-prog gets bigger and becomes more specific
to the egress-device (e.g. BPF update constants per egress-device).
When this happens performance suffers, as I-cache and data-access to
each egress-device gets pushed out of cache. (Hint VPP/fd.io approach)

Queuing xdp_frames up for your devmap-prog makes sense, as these share
common properties.  With intermix traffic the first xdp_prog will sort
packets into egress-devices, and then the devmap-prog can operate on
these.  The best illustration[1] of this sorting I saw in a Netflix
blogpost[2] about FreeBSD, section "RSS Assisted LRO" (not directly
related, but illustration was good).


[1] https://miro.medium.com/max/700/1%2alTGL1_D6hTMEMa7EDV8yZA.png
[2] https://netflixtechblog.com/serving-100-gbps-from-an-open-connect-appliance-cdb51dda3b99
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

