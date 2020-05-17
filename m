Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327C11D6886
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgEQPGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 11:06:24 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:36051 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgEQPGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 11:06:24 -0400
Received: from apollo (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1EC3F22FB3;
        Sun, 17 May 2020 17:06:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589727978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PlxDmGUL7vSgFkSocNJTuV7KHAzhpf8zLReQ6bR+urI=;
        b=sMw601jcZ94qHD7RKcu8XHGuWI6FEdPoPt3Nvu10lOSTIwFLXPuzMTusYMgnIm4czKtSzc
        inT5Uocr9JuwqBXS9Pt2d/OFB6jmlAB5ZmY/77/k0OCNtY7EuRktGur5UPJgu6BXvMjDg3
        XwR+XmJ35FIsBSpXJewyRmZlSMEsNNo=
Date:   Sun, 17 May 2020 17:06:01 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200517170601.31832446@apollo>
In-Reply-To: <20200516012948.3173993-1-vinicius.gomes@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Fri, 15 May 2020 18:29:44 -0700
schrieb Vinicius Costa Gomes <vinicius.gomes@intel.com>:

> Hi,
> 
> This series adds support for configuring frame preemption, as defined
> by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
> 
> Frame preemption allows a packet from a higher priority queue marked
> as "express" to preempt a packet from lower priority queue marked as
> "preemptible". The idea is that this can help reduce the latency for
> higher priority traffic.
> 
> Previously, the proposed interface for configuring these features was
> using the qdisc layer. But as this is very hardware dependent and all
> that qdisc did was pass the information to the driver, it makes sense
> to have this in ethtool.
> 
> One example, for retrieving and setting the configuration:
> 
> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
> Frame preemption settings for enp3s0:
> 	support: supported
> 	active: active
> 	supported queues: 0xf
> 	supported queues: 0xe
> 	minimum fragment size: 68
> 
> 
> $ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68
> preemptible-queues-mask 0xe
> 
> This is a RFC because I wanted to have feedback on some points:
> 
>   - The parameters added are enough for the hardware I have, is it
>     enough in general?

What about the Qbu handshake state? And some NICs support overriding
this. I.e. enable frame preemption even if the handshake wasn't
successful.

-michael

> 
>   - even with the ethtool via netlink effort, I chose to keep the
>     ioctl() way, in case someone wants to backport this to an older
>     kernel, is there a problem with this?
> 
>   - Some space for bikeshedding the names and location (for example,
>     does it make sense for these settings to be per-queue?), as I am
>     not quite happy with them, one example, is the use of preemptible
>     vs. preemptable;
> 
> 
> About the patches, should be quite straightforward:
> 
> Patch 1, adds the ETHTOOL_GFP and ETHOOL_SFP commands and the
> associated data structures;
> 
> Patch 2, adds the ETHTOOL_MSG_PREEMPT_GET and ETHTOOL_MSG_PREEMPT_SET
> netlink messages and the associated attributes;
> 
> Patch 3, is the example implementation for the igc driver, the catch
> here is that frame preemption in igc is dependent on the TSN "mode"
> being enabled;
> 
> Patch 4, adds some registers that helped during implementation.
> 
> Another thing is that because igc is still under development, to avoid
> conflicts, I think it might be easier for the PATCH version of this
> series to go through Jeff Kirsher's tree.
> 
> Vinicius Costa Gomes (4):
>   ethtool: Add support for configuring frame preemption
>   ethtool: Add support for configuring frame preemption via netlink
>   igc: Add support for configuring frame preemption
>   igc: Add support for exposing frame preemption stats registers
> 
>  drivers/net/ethernet/intel/igc/igc.h         |   3 +
>  drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
>  drivers/net/ethernet/intel/igc/igc_ethtool.c |  77 ++++++++
>  drivers/net/ethernet/intel/igc/igc_regs.h    |  10 +
>  drivers/net/ethernet/intel/igc/igc_tsn.c     |  46 ++++-
>  include/linux/ethtool.h                      |   6 +
>  include/uapi/linux/ethtool.h                 |  25 +++
>  include/uapi/linux/ethtool_netlink.h         |  19 ++
>  net/ethtool/Makefile                         |   3 +-
>  net/ethtool/ioctl.c                          |  36 ++++
>  net/ethtool/netlink.c                        |  15 ++
>  net/ethtool/netlink.h                        |   2 +
>  net/ethtool/preempt.c                        | 181
> +++++++++++++++++++ 13 files changed, 423 insertions(+), 6
> deletions(-) create mode 100644 net/ethtool/preempt.c
> 

