Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA792A5287
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 11:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbfIBJI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 05:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729804AbfIBJI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 05:08:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 739483084212;
        Mon,  2 Sep 2019 09:08:26 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5244819C5B;
        Mon,  2 Sep 2019 09:08:19 +0000 (UTC)
Date:   Mon, 2 Sep 2019 11:08:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     brouer@redhat.com, "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke.hoiland-jorgensen@kau.se>,
        Andy Gospodarek <gospo@broadcom.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Message-ID: <20190902110818.2f6a8894@carbon>
In-Reply-To: <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
        <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 02 Sep 2019 09:08:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Sep 2019 18:47:15 +0200
Kal Cutter Conley <kal.conley@dectris.com> wrote:

> Hi,
> I figured out the problem. Let me document the issue here for others
> and hopefully start a discussion.
> 
> The mlx5 driver uses special queue ids for ZC. If N is the number of
> configured queues, then for XDP_ZEROCOPY the queue ids start at N. So
> queue ids [0..N) can only be used with XDP_COPY and queue ids [N..2N)
> can only be used with XDP_ZEROCOPY.

Thanks for the followup and explanation on how mlx5 AF_XDP queue
implementation is different from other vendors.


> sudo ethtool -L eth0 combined 16
> sudo samples/bpf/xdpsock -r -i eth0 -c -q 0   # OK
> sudo samples/bpf/xdpsock -r -i eth0 -z -q 0   # ERROR
> sudo samples/bpf/xdpsock -r -i eth0 -c -q 16  # ERROR
> sudo samples/bpf/xdpsock -r -i eth0 -z -q 16  # OK
> 
> Why was this done? To use zerocopy if available and fallback on copy
> mode normally you would set sxdp_flags=0. However, here this is no
> longer possible. To support this driver, you have to first try binding
> with XDP_ZEROCOPY and the special queue id, then if that fails, you
> have to try binding again with a normal queue id. Peculiarities like
> this complicate the XDP user api. Maybe someone can explain the
> benefits?

Thanks for complaining, it is actually valuable. It really illustrate
the kernel need to improve in this area, which is what our talk[1] at
LPC2019 (Sep 10) is about.

Title: "Making Networking Queues a First Class Citizen in the Kernel"
 [1] https://linuxplumbersconf.org/event/4/contributions/462/

As you can see, several vendors are actually involved. Kudos to Magnus
for taking initiative here!  It's unfortunately not solved "tomorrow",
as first we have to agree this is needed (facility to register queues),
then agree on API and get commitment from vendors, as this requires
drivers changes.  There is a long road ahead, but I think it will be
worthwhile in the end, as effective use of dedicated hardware queues
(both RX and TX) is key to performance.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer



> On Wed, Aug 7, 2019 at 2:49 PM Kal Cutter Conley <kal.conley@dectris.com> wrote:
> >
> > Hello,
> > I am testing the mlx5e driver with AF_XDP. When I specify
> > XDP_ZEROCOPY, bind() always returns EINVAL. I observe the same problem
> > with the xdpsock sample:
> >
> > sudo samples/bpf/xdpsock -r -i dcb1-port1 -z
> > samples/bpf/xdpsock_user.c:xsk_configure_socket:322: errno:
> > 22/"Invalid argument"
> >
> > Without XDP_ZEROCOPY, everything works as expected. Is this a known
> > issue/limitation? I expected this to be supported looking at the
> > code/commit history.
> >
> > Thanks,
> > Kal  



