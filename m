Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A30610CE5
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJ1JRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJ1JRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:17:43 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A69E1C69EA
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 02:17:42 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7D6CA1C96;
        Fri, 28 Oct 2022 11:17:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1666948660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tTWmujdcGHgoGCE5ZJCjuEsi0f2WA5eAWRA5P23BV6A=;
        b=XyTczr8dw/YchcREHiLo7p/b9O+S8EPPulifM9z78/A/5U1ozlt6YK4fKbFb6J0y2VNzHc
        viLkB5OqZQy4W/oAeWmfl0ZoCt1yNEADnhDGaw88DfX2U4JEcZRDdZRqPgRdO9bqjQPtxm
        yHza2vMIf+LF0cD45rGDg27B1HsvvgCmcZd4Zs1P1fYxCbBTA5y2bjwR/DvWOw8gtyJlN/
        v5tsC8maW2Xb23ktadMNTcC0A3hMbJb7hb4xekB7Oue7UuEasd0dhqQrfwkb2aSG08szyk
        TSEtsEdcvxXpqZlCAphm4zWeGk0/8/kLKeVrdorChbd8v4LDVYQsuDuuvhrvuA==
MIME-Version: 1.0
Date:   Fri, 28 Oct 2022 11:17:40 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
In-Reply-To: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <2bad372ce42a06254c7767fd658d2a66@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-10-27 23:08, schrieb Vladimir Oltean:
> This patch set solves the issue reported by Michael and Heiko here:
> https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
> making full use of Michael's suggestion of having two modaliases: one
> gets used for loading the tagging protocol when it's the default one
> reported by the switch driver, the other gets loaded at user's request,
> by name.
> 
>   # modinfo tag_ocelot_8021q
>   filename:       
> /lib/modules/6.1.0-rc2+/kernel/net/dsa/tag_ocelot_8021q.ko
>   alias:          dsa_tag-ocelot-8021q
>   alias:          dsa_tag-20

I know that name clashes are not to be expected because one is a 
numerical id
and the other is a string, but it might still make sense to have a 
different
prefix so the user of modinfo can figure that out more easily.

Presuming that backwards compatibility is not an issue, maybe:
dsa_tag-ocelot-8021q
dsa_tag-id-20

>   license:        GPL v2
>   depends:        dsa_core
>   intree:         Y
>   name:           tag_ocelot_8021q
>   vermagic:       6.1.0-rc2+ SMP preempt mod_unload modversions aarch64
> 
> Tested on NXP LS1028A-RDB with the following device tree addition:
> 
> &mscc_felix_port4 {
> 	dsa-tag-protocol = "ocelot-8021q";
> };
> 
> &mscc_felix_port5 {
> 	dsa-tag-protocol = "ocelot-8021q";
> };
> 
> CONFIG_NET_DSA and everything that depends on it is built as module.
> Everything auto-loads, and "cat /sys/class/net/eno2/dsa/tagging" shows
> "ocelot-8021q". Traffic works as well.
> 
> Note: I included patch 1/3 because I secretly want to see if the
> patchwork build tests pass :) But I also submitted it separately to
> "net" already, and without it, patch 3/3 doesn't apply to current 
> net-next.
> So if you want to leave comments on 1/3, make sure to leave them here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20221027145439.3086017-1-vladimir.oltean@nxp.com/
> 
> Vladimir Oltean (3):
>   net: dsa: fall back to default tagger if we can't load the one from 
> DT
>   net: dsa: provide a second modalias to tag proto drivers based on
>     their name
>   net: dsa: autoload tag driver module on tagging protocol change
> 
>  include/net/dsa.h          |  5 +++--
>  net/dsa/dsa.c              |  8 +++++---
>  net/dsa/dsa2.c             | 15 +++++++++++----
>  net/dsa/dsa_priv.h         |  4 ++--
>  net/dsa/master.c           |  4 ++--
>  net/dsa/tag_ar9331.c       |  6 ++++--
>  net/dsa/tag_brcm.c         | 16 ++++++++++------
>  net/dsa/tag_dsa.c          | 11 +++++++----
>  net/dsa/tag_gswip.c        |  6 ++++--
>  net/dsa/tag_hellcreek.c    |  6 ++++--
>  net/dsa/tag_ksz.c          | 21 +++++++++++++--------
>  net/dsa/tag_lan9303.c      |  6 ++++--
>  net/dsa/tag_mtk.c          |  6 ++++--
>  net/dsa/tag_ocelot.c       | 11 +++++++----
>  net/dsa/tag_ocelot_8021q.c |  6 ++++--
>  net/dsa/tag_qca.c          |  6 ++++--
>  net/dsa/tag_rtl4_a.c       |  6 ++++--
>  net/dsa/tag_rtl8_4.c       |  7 +++++--
>  net/dsa/tag_rzn1_a5psw.c   |  6 ++++--
>  net/dsa/tag_sja1105.c      | 11 +++++++----
>  net/dsa/tag_trailer.c      |  6 ++++--
>  net/dsa/tag_xrs700x.c      |  6 ++++--
>  22 files changed, 116 insertions(+), 63 deletions(-)

FWIW
Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28 w/ 
ocelot_8021q

Thanks,
-michael
