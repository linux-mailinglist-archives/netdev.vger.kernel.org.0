Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771F72C811A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgK3Jdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 04:33:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726158AbgK3Jds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 04:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606728742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XnOfdREIt4Lxkgjic2xKmB+sb4GzQklc68BVQDEWvs=;
        b=CLfl/LZ0FxaPgvT7C3esajUE9zLv9dM6qwRctYSZIzU3epRgYvJjvHa4E5D9WIVH/vajbL
        rZPTrdN/fkYCJZufHttcCUGrQ5H5/qDp+Qd+RCZm7VkJvQiDrSfw3CanUxaQAlAaa28hUL
        mUvtOhtPxvzaoAZK3I/UP8W0tbnlVxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-74MbqdniMdmq5_A4fpal4Q-1; Mon, 30 Nov 2020 04:32:20 -0500
X-MC-Unique: 74MbqdniMdmq5_A4fpal4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8064B8030AB;
        Mon, 30 Nov 2020 09:32:18 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 829A25D9D2;
        Mon, 30 Nov 2020 09:32:09 +0000 (UTC)
Date:   Mon, 30 Nov 2020 10:32:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201130103208.6d5305e2@carbon>
In-Reply-To: <20201130075107.GB277949@localhost.localdomain>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
        <20201126084325.477470-1-liuhangbin@gmail.com>
        <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
        <20201130075107.GB277949@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 15:51:07 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Thu, Nov 26, 2020 at 10:31:56PM -0800, Yonghong Song wrote:
> > > index 35e16dee613e..8bdec0865e1d 100644
> > > --- a/samples/bpf/xdp_redirect_map_user.c
> > > +++ b/samples/bpf/xdp_redirect_map_user.c
> > > @@ -21,12 +21,13 @@
> > >   static int ifindex_in;
> > >   static int ifindex_out;
> > > -static bool ifindex_out_xdp_dummy_attached = true;
> > > +static bool ifindex_out_xdp_dummy_attached = false;
> > > +static bool xdp_prog_attached = false;  
> > 
> > Maybe xdp_devmap_prog_attached? Feel xdp_prog_attached
> > is too generic since actually it controls xdp_devmap program
> > attachment.  
> 
> Hi Yonghong,
> 
> Thanks for your comments. As Jesper replied, The 2nd xdp_prog on egress
> doesn't tell us if the redirect was successful. So the number is meaningless.

Well, I would not say the counter is meaningless.  It true that 2nd
devmap xdp_prog doesn't tell us if the redirect was successful, which
means that your description/(understanding) of the counter was wrong.

I still think it is relevant to have a counter for packets processed by
this 2nd xdp_prog, just to make is visually clear that the 2nd xdp-prog
attached (to devmap entry) is running.  The point is that QA is using
these programs.

The lack of good output from this specific sample have cause many
bugzilla cases for me.  BZ cases that requires going back and forth a
number of times, before figuring out how the prog was (mis)used.  This
is why other samples like xdp_rxq_info and xdp_redirect_cpu have such a
verbose output, which in-practice have helped many times on QA issues.


> I plan to write a example about vlan header modification based on egress
> index. I will post the patch later.

I did notice the internal thread you had with Toke.  I still think it
will be more simple to modify the Ethernet mac addresses.  Adding a
VLAN id tag is more work, and will confuse benchmarks.  You are
increasing the packet size, which means that you NIC need to spend
slightly more time sending this packet (3.2 nanosec at 10Gbit/s), which
could falsely be interpreted as cost of 2nd devmap XDP-program.

(Details: these 3.2 ns will not be visible for smaller packets, because
the minimum Ethernet frame size will hide this, but I've experience this
problem with larger frames on real switch hardware (Juniper), where
ingress didn't have VLAN-tag and egress we added VLAN-tag with XDP, and
then switch buffer slowly increased until overflow).

As Alexei already pointed out, you assignment is to modify the packet
in the 2nd devmap XDP-prog.  Why: because you need to realize that this
will break your approach to multicast in your previous patchset.
(Yes, the offlist patch I gave you, that move running 2nd devmap
XDP-prog to a later stage, solved this packet-modify issue).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

