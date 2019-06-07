Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3DD396DB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 22:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbfFGUbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 16:31:51 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:59117 "EHLO
        cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbfFGUbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 16:31:50 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50])
        by cassarossa.samfundet.no with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sesse@samfundet.no>)
        id 1hZLWX-0008J9-R8; Fri, 07 Jun 2019 22:31:44 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1hZLWX-0004jd-LP; Fri, 07 Jun 2019 22:31:41 +0200
Date:   Fri, 7 Jun 2019 22:31:41 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: EoGRE sends undersized frames without padding
Message-ID: <20190607203141.tj5xnkjyitlfz5yl@sesse.net>
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
 <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
 <20190605072712.avp3svw27smrq2qx@sesse.net>
 <CAM_iQpXWM35ySoigS=TdsXr8+3Ws4ZMspJCBVdWngggCBi362g@mail.gmail.com>
 <20190606073611.7n2w5n52pfh3jzks@sesse.net>
 <CAM_iQpVFq8TdnHSOsC7+6tK3KEoeyF1SFOQ-DheLW7Y=g77xxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpVFq8TdnHSOsC7+6tK3KEoeyF1SFOQ-DheLW7Y=g77xxg@mail.gmail.com>
X-Operating-System: Linux 5.1.2 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 12:57:57PM -0700, Cong Wang wrote:
>> Well, openvswitch say that they just throw packets around and assume they're
>> valid... :-)
> _If_ the hardware switch has to pad them (according to what you said),
> why software switch doesn't?

Trust me, I'm telling them they have to deal with this, too. :-)

But you can't really assume there's a switch in the middle at all (whether
hardware nor software). You can connect a NIC to a NIC with no switch in-between.

Normally, it's not the switch that adds the padding; it's done in the NIC
(MAC sublayer), so if the switch doesn't modify the packet, it can just send
it on. However, there are situations where it has to, like for instance when
stripping a VLAN tag (802.1Q-2005, section 6.5.1), since that makes the
packet shorter.

> Rather than arguing about this, please check what ethernet standard
> says. It would be much easier to convince others with standard.

The Ethernet standard? That's pretty clear; Ethernet frames are a minimum of
64 bytes (including FCS at the end, so 60 payload bytes including MAC
addresses etc.). IEEE 802.3-2015 4.2.3.3:

  The CSMA/CD Media Access mechanism requires that a minimum frame length of
  minFrameSize bits be transmitted. If frameSize is less than minFrameSize,
  then the CSMA/CD MAC sublayer shall append extra bits in units of octets
  (Pad), after the end of the MAC Client Data field but prior to calculating
  and appending the FCS (if not provided by the MAC client). The number of
  extra bits shall be sufficient to ensure that the frame, from the DA field
  through the FCS field inclusive, is at least minFrameSize bits.

4A.2.3.2.4 also says, without assuming anything about CSMA/CD:

  The MAC requires that a minimum frame length of minFrameSize bits be
  transmitted. If frameSize is less than minFrameSize, then the MAC sublayer
  shall append extra bits in units of octets (pad), after the end of the MAC
  client data field but prior to calculating, and appending, the FCS (if not
  provided by the MAC client). The number of extra bits shall be sufficient
  to ensure that the frame, from the DA field through the FCS field
  inclusive, is at least minFrameSize bits. If the FCS is (optionally)
  provided by the MAC client, the pad shall also be provided by the MAC
  client. The content of the pad is unspecified.

minFrameSize is defined in 4A.4.2:

  minFrameSize   512 bits (64 octets)

As for what to do on undersized packets, section 4.2.9 contains this
pseudocode:

  receiveSucceeding := (frameSize ≥ minFrameSize) {Reject frames too small}

To be honest, I don't see that dropping undersized frames gives any
real-world gains in the case of EoGRE, though. I'd say that the most
reasonable thing to do would be to pad on transmit, and accept undersized
frames on receive. You could argue that's wasteful for cases like the
loopback interface, but honestly, you never really know what people are going
to do with the packets (just consider the case of tcpreplay).

/* Steinar */
-- 
Homepage: https://www.sesse.net/
