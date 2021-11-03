Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D560144401F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhKCKtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:49:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44292 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhKCKtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 06:49:14 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A32352191A;
        Wed,  3 Nov 2021 10:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635936397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQvwUR1GkDC5A3L4vKfVz174T1nRGcTthlFbfoydpDI=;
        b=QT14xJnKpiTDJxFOXjUBT+lJMzkTLRSGAtigGNEkB1YWrlwGY//JNuKM8LnMJZq1ixwl/z
        VGHFFwWLSzWEye1WyNowmDi69phPPo4fZHAKzoy1EKmMpjTgRGLdmfI7TbPslrjXwDy5k6
        MW97IzphkyMy44AvAh+aO2AvL4gXsNY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635936397;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQvwUR1GkDC5A3L4vKfVz174T1nRGcTthlFbfoydpDI=;
        b=2Mt5P6Gpspyz8Flhko6KrbEYXe+paC1UgKx2+kd5R8t8lcG6xLXg2KR8DGF6ILknZK4bEY
        iknnLNTrfmj2xtBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF08513FE9;
        Wed,  3 Nov 2021 10:46:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lNrCMoxogmGpHQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 03 Nov 2021 10:46:36 +0000
Subject: Re: [PATCH v2 0/6] Add FDMA support on ocelot switch driver
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <3e7b8321-c93c-5afe-8cbd-977333763888@suse.de>
Date:   Wed, 3 Nov 2021 13:46:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211103091943.3878621-1-clement.leger@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/3/21 12:19 PM, Clément Léger пишет:
> This series adds support for the Frame DMA present on the VSC7514
> switch. The FDMA is able to extract and inject packets on the various
> ethernet interfaces present on the switch.
> 
> While adding FDMA support, bindings were switched from .txt to .yaml
> and MAC address reading from device-tree was added for testing
> purposes. Jumbo frame support was also added since it gives a large
> performance improvement with FDMA.

The series should be prefixed with net-next

> 
> ------------------
> Changes in V2:
> - Read MAC for each port and not as switch base MAC address
> - Add missing static for some functions in ocelot_fdma.c
> - Split change_mtu from fdma commit
> - Add jumbo support for register based xmit
> - Move precomputed header into ocelot_port struct
> - Remove use of QUIRK_ENDIAN_LITTLE due to misconfiguration for tests
> - Remove fragmented packet sending which has not been tested
> 
> Clément Léger (6):
>    net: ocelot: add support to get port mac from device-tree
>    dt-bindings: net: convert mscc,vsc7514-switch bindings to yaml
>    net: ocelot: pre-compute injection frame header content
>    net: ocelot: add support for ndo_change_mtu
>    net: ocelot: add FDMA support
>    net: ocelot: add jumbo frame support for FDMA
> 
>   .../bindings/net/mscc,vsc7514-switch.yaml     | 184 +++++
>   .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --
>   drivers/net/ethernet/mscc/Makefile            |   1 +
>   drivers/net/ethernet/mscc/ocelot.c            |  23 +-
>   drivers/net/ethernet/mscc/ocelot.h            |   3 +
>   drivers/net/ethernet/mscc/ocelot_fdma.c       | 754 ++++++++++++++++++
>   drivers/net/ethernet/mscc/ocelot_fdma.h       |  60 ++
>   drivers/net/ethernet/mscc/ocelot_net.c        |  37 +-
>   drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  15 +
>   include/soc/mscc/ocelot.h                     |   7 +
>   10 files changed, 1075 insertions(+), 92 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
>   delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
>   create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
>   create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h
> 
