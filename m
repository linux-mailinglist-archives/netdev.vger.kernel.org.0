Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D5E357A6
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 09:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfFEH1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 03:27:18 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:56205 "EHLO
        cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfFEH1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 03:27:18 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50])
        by cassarossa.samfundet.no with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sesse@samfundet.no>)
        id 1hYQKG-0004NP-UQ; Wed, 05 Jun 2019 09:27:13 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1hYQKG-0007D7-HF; Wed, 05 Jun 2019 09:27:12 +0200
Date:   Wed, 5 Jun 2019 09:27:12 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: EoGRE sends undersized frames without padding
Message-ID: <20190605072712.avp3svw27smrq2qx@sesse.net>
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
 <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
X-Operating-System: Linux 5.1.2 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 09:31:42PM -0700, Cong Wang wrote:
>> This works fine for large packets, but the system in the other end
>> drops smaller packets, such as ARP requests and small ICMP pings.
> Is the other end Linux too?

Yes and no. The other end is Linux with Open vSwitch, which sends the packet
on to a VM. The VM is an appliance which I do not control, and while the
management plane runs Linux, the data plane is as far as I know implemented
in userspace.

The appliance itself can also run EoGRE directly, but I haven't gotten it to
work.

> If the packet doesn't go through any real wire, it could still be accepted
> by Linux even when it is smaller than ETH_ZLEN, I think.

Yes, but that's just Linux accepting something invalid, no? It doesn't mean
it should be sending it out.

> Some hardware switches pad for ETH_ZLEN when it goes through a real wire.

All hardware switches should; it's a 802.1Q demand. (Some have traditionally
been buggy in that they haven't added extra padding back when they strip the
VLAN tag.)

> It is still too early to say it is a bug. Is this a regression?

I haven't tried it with earlier versions; I would suspect it's not a
regression.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
