Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AE085E43
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbfHHJaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731038AbfHHJaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 05:30:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A19030FB8C3;
        Thu,  8 Aug 2019 09:30:00 +0000 (UTC)
Received: from carbon (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B529710016E9;
        Thu,  8 Aug 2019 09:29:57 +0000 (UTC)
Date:   Thu, 8 Aug 2019 11:29:55 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Xdp <xdp-newbies@vger.kernel.org>,
        Anton Protopopov <a.s.protopopov@gmail.com>, dsahern@gmail.com,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [bpf-next PATCH 0/3] bpf: improvements to xdp_fwd sample
Message-ID: <20190808112955.5a29c9e1@carbon>
In-Reply-To: <CAC1LvL29KS9CKcXYwR4EHeNo7++i4hYQuXfY5OLtbPFDVUO2mw@mail.gmail.com>
References: <156518133219.5636.728822418668658886.stgit@firesoul>
        <20190807150010.1a58a1d2@carbon>
        <CAC1LvL29KS9CKcXYwR4EHeNo7++i4hYQuXfY5OLtbPFDVUO2mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 08 Aug 2019 09:30:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 15:09:09 -0700
Zvi Effron <zeffron@riotgames.com> wrote:

> On Wed, Aug 7, 2019 at 6:00 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> >
> > Toke's devmap lookup improvement is first avail in kernel v5.3.
> > Thus, not part of XDP-tutorial yet.
> >  
> I probably missed this in an earlier email, but what are Toke's devmap
> improvements? Performance? Capability?

Toke's devmap and redirect improvements are primarily about usability.

Currently, from BPF-context (kernel-side) you cannot read the contents
of devmap (or cpumap or xskmap(AF_XDP)).  Because for devmap you get
the real pointer to the net_device ifindex, and we cannot allow you to
write/change that from BPF (kernel would likely crash or be inconsistent).

The work-around, is to keep a shadow map, that contains the "config" of
the devmap, which you check/validate against instead.  It is just a pain
to maintain this shadow map.  Toke's change allow you to read devmap
from BPF-context.  Thus, you can avoid this shadow map.

Another improvement from Toke, is that the bpf_redirect_map() helper,
now also check if the redirect index is valid in the map.  If not, then
it returns another value than XDP_REDIRECT.  You can choose the
alternative return value yourself, via "flags" e.g. XDP_PASS.  Thus,
you don't even need to check/validate devmap in your BPF-code, as it is
part of the bpf_redirect_map() call now.

 action = bpf_redirect_map(&map, &index, flags_as_xdp_value) 

The default flags used in most programs today is 0, which maps to
XDP_ABORTED.  This is sort of a small UAPI change, but for the better.
As today, the packet is dropped later, only diagnose/seen via
tracepoint xdp:xdp_redirect_map_err.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
 
