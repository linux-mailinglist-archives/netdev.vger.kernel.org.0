Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A11680F8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgBUO5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:57:55 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:46861 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUO5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:57:55 -0500
X-Originating-IP: 86.201.231.92
Received: from localhost (lfbn-tou-1-149-92.w86-201.abo.wanadoo.fr [86.201.231.92])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id D15951BF211;
        Fri, 21 Feb 2020 14:57:51 +0000 (UTC)
Date:   Fri, 21 Feb 2020 15:57:51 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>, sd@queasysnail.net
Subject: Re: [RFC 00/18] net: atlantic: MACSec support for AQC devices
Message-ID: <20200221145751.GA3530@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Igor,

Thanks for sending this series!

Please Cc Sabrina Dubroca <sd@queasysnail.net> (the IEEE 802.1AE driver
author) on such series.

Antoine

On Fri, Feb 14, 2020 at 06:02:40PM +0300, Igor Russkikh wrote:
> This RFC patchset introduces MACSec HW offloading support in
> Marvell(Aquantia) AQC atlantic driver.
> 
> This implementation is a joint effort of Marvell developers on top of
> the work started by Antoine Tenart.
> 
> Several patches introduce backward-incompatible changes and are
> subject for discussion/drop:
> 
> 1) patch 0008:
>   multicast/broadcast when offloading is needed to handle ARP requests,
>   because they have broadcast destination address;
>   With this patch we also match and encrypt/decrypt packets between macsec
>   hw and realdev based on device's mac address.
>   This potentially can be used to support multiple macsec offloaded interfaces
>   on top of one realdev.
>   On some environments however this could lead to problems, e.g. bridge over
>   macsec configuration will expect packets with unknown src MAC
>   should come through macsec.
>   The patch is questionable, we've used it because our current hw setup and
>   requirements assumes decryption is only done based on mac address match.
>   This could be changed by encrypting/decripting all the traffic (except control).
> 
> 2) patch 0010:
>    HW offloading is enabled by default. This is a workaround for the fact
>    that macsec offload can't be configured at the moment of macsec device
>    creation. This causes side effects on atlantic device. The best way to
>    resolve this is to implement an option in ip tools to specify macsec
>    offload type immediately inside the command where it is created.
>    Such a comment was proposed in ip tools discussion.
> 
> 3) patch 0011:
>   real_dev features are now propagated to macsec device (when HW
>   offloading is enabled), otherwise feature set might lead to HW
>   reconfiguration during MACSec configuration.
>   Also, HW offloaded macsec should be able to keep LRO LSO features,
>   since they are transparent for macsec engine (at least in our hardware).
> 
> Antoine Tenart (4):
>   net: introduce the MACSEC netdev feature
>   net: add a reference to MACsec ops in net_device
>   net: macsec: allow to reference a netdev from a MACsec context
>   net: macsec: add support for offloading to the MAC
> 
> Dmitry Bogdanov (9):
>   net: macsec: init secy pointer in macsec_context
>   net: macsec: invoke mdo_upd_secy callback when mac address changed
>   net: macsec: allow multiple macsec devices with offload
>   net: macsec: add support for getting offloaded stats
>   net: atlantic: MACSec offload skeleton
>   net: atlantic: MACSec egress offload HW bindings
>   net: atlantic: MACSec egress offload implementation
>   net: atlantic: MACSec offload statistics HW bindings
>   net: atlantic: MACSec offload statistics implementation
> 
> Mark Starovoytov (5):
>   net: macsec: support multicast/broadcast when offloading
>   net: macsec: enable HW offloading by default (when available)
>   net: macsec: report real_dev features when HW offloading is enabled
>   net: atlantic: MACSec ingress offload HW bindings
>   net: atlantic: MACSec ingress offload implementation
> 
>  .../net/ethernet/aquantia/atlantic/Makefile   |    6 +-
>  .../ethernet/aquantia/atlantic/aq_ethtool.c   |  160 +-
>  .../net/ethernet/aquantia/atlantic/aq_hw.h    |    6 +
>  .../ethernet/aquantia/atlantic/aq_macsec.c    | 1842 +++++++++++
>  .../ethernet/aquantia/atlantic/aq_macsec.h    |  138 +
>  .../net/ethernet/aquantia/atlantic/aq_nic.c   |   21 +-
>  .../net/ethernet/aquantia/atlantic/aq_nic.h   |    6 +-
>  .../ethernet/aquantia/atlantic/aq_pci_func.c  |    5 +
>  .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   51 +-
>  .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |   69 +
>  .../atlantic/macsec/MSS_Egress_registers.h    |   78 +
>  .../atlantic/macsec/MSS_Ingress_registers.h   |   82 +
>  .../aquantia/atlantic/macsec/macsec_api.c     | 2938 +++++++++++++++++
>  .../aquantia/atlantic/macsec/macsec_api.h     |  328 ++
>  .../aquantia/atlantic/macsec/macsec_struct.h  |  919 ++++++
>  drivers/net/macsec.c                          |  510 ++-
>  include/linux/netdev_features.h               |    3 +
>  include/linux/netdevice.h                     |    9 +
>  include/net/macsec.h                          |   29 +-
>  include/uapi/linux/if_link.h                  |    1 +
>  net/ethtool/common.c                          |    1 +
>  tools/include/uapi/linux/if_link.h            |    1 +
>  22 files changed, 7018 insertions(+), 185 deletions(-)
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Egress_registers.h
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
>  create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
> 
> -- 
> 2.17.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
