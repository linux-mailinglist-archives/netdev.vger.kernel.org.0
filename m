Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A42DA4327
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 09:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfHaHlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 03:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfHaHlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 03:41:52 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647EB2342E;
        Sat, 31 Aug 2019 07:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567237312;
        bh=qCl3gg1bO0LD++Oq68TU72FdE0741Av+ec9xx+JDRBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eDZxuftfgqKNWJmjpQgNfxmoSAgGqJOicJK6dRs0XUSeSBCnPeDEmsLYpfomEmEFW
         eaT+Y1RuufMjMNfs9JaawCmDyxELBbNzGIpcsArm7j6t6bqXVGD9H+9aBd/YDG4dDg
         8qbF65zwIT7q2x+8jBWW7x4P/SAIkBWmtvdGAbo8=
Date:   Sat, 31 Aug 2019 10:41:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, Ray Jui <ray.jui@broadcom.com>
Subject: Re: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
Message-ID: <20190831074143.GI12611@unreal>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
 <20190826060045.GA4584@mtr-leonro.mtl.com>
 <20190830091838.GC12611@unreal>
 <CACKFLiku-5Q6mBFgd2L_gTqZ=UWUf_HTUeC_n6=aVH+V_o1p4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLiku-5Q6mBFgd2L_gTqZ=UWUf_HTUeC_n6=aVH+V_o1p4g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 09:00:27AM -0700, Michael Chan wrote:
> On Fri, Aug 30, 2019 at 2:18 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Aug 26, 2019 at 09:00:45AM +0300, Leon Romanovsky wrote:
> > > On Sun, Aug 25, 2019 at 11:54:54PM -0400, Michael Chan wrote:
> > > > Refactor the hardware/firmware configuration portion in
> > > > bnxt_sriov_enable() into a new function bnxt_cfg_hw_sriov().  This
> > > > new function can be called after a firmware reset to reconfigure the
> > > > VFs previously enabled.
> > >
> > > I wonder what does it mean for already bound VFs to vfio driver?
> > > Will you rebind them as well? Can I assume that FW error in one VF
> > > will trigger "restart" of other VFs too?
> >
> > Care to reply?
> >
> >
> Sorry, I missed your email earlier.
>
> A firmware reset/recovery has no direct effect on a VF or any function
> if it is just idle.  The PCI interface of any function does not get
> reset.
>
> If a VF driver (Linux VF driver, DPDK driver, etc) has initialized on
> that function, meaning it has exchanged messages with firmware to
> register itself and to allocate resources (such as rings), then the
> firmware reset will require all those resources to be re-discovered
> and re-initialized.  These VF resources are initially assigned by the
> PF.  So this refactored function on the PF is to re-assign these
> resources back to the VF after the firmware reset.  Again, if the VF
> is just bound to vfio and is idle, there is no effect.

Thanks for explaining the flow.
