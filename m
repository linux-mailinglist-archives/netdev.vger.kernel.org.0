Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD11F1771FE
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgCCJIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:08:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35954 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727644AbgCCJIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583226513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EBfUnvvXsqNrrqNEeFrR6BTh0wBjxNHO7nDOkZ5dRnM=;
        b=iV9qbltz7xzRVfIfOA3Dd85B09iA4fq1b5Vfl5CvLCrY9NLmKAM3AdU0B6ehLqvOwVBfdi
        W9JeGTxCrJojGY7GWLkW3f0Nc63KNqjLdKfUWGXtbJ0MBWRaY5OGSFey6DzyIG541+l3qL
        f2pEzJd91WZaIjfE0f5/fJgqFTwsq+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-_umTDSosM1ezGs0qqsowWw-1; Tue, 03 Mar 2020 04:08:29 -0500
X-MC-Unique: _umTDSosM1ezGs0qqsowWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A95100DFC2;
        Tue,  3 Mar 2020 09:08:27 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7DEA5D9C9;
        Tue,  3 Mar 2020 09:08:13 +0000 (UTC)
Date:   Tue, 3 Mar 2020 10:08:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path
 for xdp_frames
Message-ID: <20200303100812.2e98d7f1@carbon>
In-Reply-To: <318c0a44-b540-1c7f-9667-c01da5a8ac73@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
        <20200227032013.12385-10-dsahern@kernel.org>
        <20200302183040.tgnrg6tkblrjwsqj@ast-mbp>
        <318c0a44-b540-1c7f-9667-c01da5a8ac73@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020 21:27:08 -0700
David Ahern <dahern@digitalocean.com> wrote:

> On 3/2/20 11:30 AM, Alexei Starovoitov wrote:
> > On Wed, Feb 26, 2020 at 08:20:11PM -0700, David Ahern wrote:  
> >> +
> >> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> >> +		switch (act) {
> >> +		case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
> >> +			act = XDP_PASS;
> >> +			break;
> >> +		case XDP_PASS:
> >> +			break;
> >> +		case XDP_REDIRECT:
> >> +			/* fall through */
> >> +		default:
> >> +			bpf_warn_invalid_xdp_action(act);
> >> +			/* fall through */
> >> +		case XDP_ABORTED:
> >> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> >> +			/* fall through */
> >> +		case XDP_DROP:
> >> +			break;
> >> +		}  
> > 
> > patch 8 has very similar switch. Can you share the code?  
> 
> Most likely; I'll take a look.
> 
> > 
> > I'm worried that XDP_TX is a silent alias to XDP_PASS.
> > What were the reasons to go with this approach?  
> 
> As I stated in the cover letter:
> 
> "XDP_TX on Rx means send the packet out the device it arrived
> on; given that, XDP_Tx for the Tx path is treated as equivalent to
> XDP_PASS - ie., continue on the Tx path."

I'm not really buying this.  IHMO XDP_PASS should mean continue on the
Tx path, as this is a tx/egress XDP hook.  I don't see a reason to
basically "remove" the XDP_TX return code at this point.

> > imo it's less error prone and extensible to warn on XDP_TX.
> > Which will mean that both XDP_TX and XDP_REDICT are not supported
> > for egress atm.  

I agree.

I more see "XDP_TX" as a mirror facility... maybe there is a use-case
for bouncing packets back in the TX/Egress hook? That is future work,
but not reason disable the option now.


> I personally don't care either way; I was going with the simplest
> concept from a user perspective.
> 
> > 
> > Patches 8 and 9 cover tun only. I'd like to see egress hook to be
> > implemented in at least one physical NIC. Pick any hw. Something
> > that handles real frames. Adding this hook to virtual NIC is easy,
> > but it doesn't demonstrate design trade-offs one would need to
> > think through by adding egress hook to physical nic. That's why I
> > think it's mandatory to have it as part of the patch set.
> > 
> > Patch 11 exposes egress to samples/bpf. It's nice, but without
> > selftests it's no go. All new features must be exercised as part of
> > selftests/bpf.  
> 
> Patches that exercise the rtnetlink uapi are fairly easy to do on
> single node; anything traffic related requires multiple nodes or
> namespace level capabilities.  Unless I am missing something that is
> why all current XDP tests ride on top of veth; veth changes are not
> part of this set.
> 
> So to be clear you are saying that all new XDP features require
> patches to a h/w nic, veth and whatever the author really cares about
> before new features like this go in?

I would say yes. XDP is founded for physical HW NICs, and we need to
show it makes sense for physical HW NICs.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

