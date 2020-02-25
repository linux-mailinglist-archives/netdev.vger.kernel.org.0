Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1373416C198
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgBYNC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:02:26 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2114 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbgBYNC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:02:26 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 8OEkw47HCS/PfRHEv6iP0A73HoSI9Ymr6oxqJ3c9424ugpU3k8B0Eu6dn4d/IKMXZcfUHtC6k6
 qzJMPn/y7iDznf+5SmQaRK0FFd1BWvm5Xe5Bq+iXZJ2wMHnIBj4HxdWG+m3OVhMOnd433VIQZ+
 5Xw495Ow/BeHZltAdS4LjpFEHtPfZnwrYb5PGfRlpozonMbpfDaxVxrztWf/jQF2uyawFhaLS0
 T+x7BCLVAncfyGX4jPd8YJnsXBxLRlOVIjLZZk78T0ACOoZRsQB3GFqG17wktwfkqCp0S8oqlB
 niQ=
X-IronPort-AV: E=Sophos;i="5.70,484,1574146800"; 
   d="scan'208";a="67889274"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Feb 2020 06:02:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Feb 2020 06:02:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 25 Feb 2020 06:02:24 -0700
Date:   Tue, 25 Feb 2020 14:02:23 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <alexandru.marginean@nxp.com>,
        <claudiu.manoil@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 net-next 0/2] Allow unknown unicast traffic to CPU for
 Felix DSA
Message-ID: <20200225130223.kb7jg7u2kgjjrlpo@lx-anielsen.microsemi.net>
References: <20200224213458.32451-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224213458.32451-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 23:34, Vladimir Oltean wrote:
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>This is the continuation of the previous "[PATCH net-next] net: mscc:
>ocelot: Workaround to allow traffic to CPU in standalone mode":
>
>https://www.spinics.net/lists/netdev/msg631067.html
>
>Following the feedback received from Allan Nielsen, the Ocelot and Felix
>drivers were made to use the CPU port module in the same way (patch 1),
>and Felix was made to additionally allow unknown unicast frames towards
>the CPU port module (patch 2).
>
>Vladimir Oltean (2):
>  net: mscc: ocelot: eliminate confusion between CPU and NPI port
>  net: dsa: felix: Allow unknown unicast traffic towards the CPU port
>    module
>
> drivers/net/dsa/ocelot/felix.c           | 16 ++++--
> drivers/net/ethernet/mscc/ocelot.c       | 62 +++++++++++++---------
> drivers/net/ethernet/mscc/ocelot.h       | 10 ----
> drivers/net/ethernet/mscc/ocelot_board.c |  5 +-
> include/soc/mscc/ocelot.h                | 67 ++++++++++++++++++++++--
> net/dsa/tag_ocelot.c                     |  3 +-
> 6 files changed, 117 insertions(+), 46 deletions(-)

Hi Vladimer,

Did this fix you original issue with the spamming of the CPU?

/Allan
