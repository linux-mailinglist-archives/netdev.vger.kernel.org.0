Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDE62B698
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiKPJde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238176AbiKPJdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:33:31 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698F25D2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:33:27 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 215E2124C;
        Wed, 16 Nov 2022 10:33:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1668591205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kd2hqQDUV/k1sDNK0E6zkntZwCK69brjunticKAOOLU=;
        b=eVglJKALziacgLkif57+DqFFJxGTfwqUDfE4NJ5oe7mJc0Ofsrm3vsr5u6cUcL8g8gW+IX
        AJ36uXpp1uchHHTYsdVKyt7fx+2GU6paKjZw35Dbi95n6/l3Q3i424xBYvz0ELOUyL/Il1
        jcj6ljWuqTaxet6tR29Xc2GxqydbnZUUkyE+to02HykESoPtmw/ve32z8QUurqBRWFnAiG
        NeLUU5ww0nwdUGvsYgfguGVJm9xyhQxhdIZM432LLlQyc4Sfr/RrwtFtPZ54NfwLgp2LEw
        wa7RbT1c8Y3xxZX9J03hjH27mIEBoU7mpo5PnocFs3S2ZnJoNqGoCQKT6736lg==
MIME-Version: 1.0
Date:   Wed, 16 Nov 2022 10:33:24 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [PATCH v2 net-next 0/6] Autoload DSA tagging driver when
 dynamically changing protocol
In-Reply-To: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
References: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <af7b34c0c17cdd73c40a9dcac081fb71@walle.cc>
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

Am 2022-11-15 02:18, schrieb Vladimir Oltean:
> v1->v2:
> - fix module auto-loading when changing tag protocol via sysfs
>   (don't pass sysfs-formatted string with '\n' to request_module())
> - change modalias format from "dsa_tag-21" to "dsa_tag:id-21".
> - move some private DSA helpers to net/dsa/dsa_priv.h.
> 
> v1 at:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=689585
> 
> This patch set solves the issue reported by Michael and Heiko here:
> https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
> making full use of Michael's suggestion of having two modaliases: one
> gets used for loading the tagging protocol when it's the default one
> reported by the switch driver, the other gets loaded at user's request,
> by name.
> 
>   # modinfo tag_ocelot
>   filename:       /lib/modules/6.1.0-rc4+/kernel/net/dsa/tag_ocelot.ko
>   license:        GPL v2
>   alias:          dsa_tag:seville
>   alias:          dsa_tag:id-21
>   alias:          dsa_tag:ocelot
>   alias:          dsa_tag:id-15
>   depends:        dsa_core
>   intree:         Y
>   name:           tag_ocelot
>   vermagic:       6.1.0-rc4+ SMP preempt mod_unload modversions aarch64
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
> "ocelot-8021q". Traffic works as well. Furthermore, "echo ocelot-8021q"
> into the aforementioned sysfs file now auto-loads the driver for it.
> 
> Vladimir Oltean (6):
>   net: dsa: stop exposing tag proto module helpers to the world
>   net: dsa: rename tagging protocol driver modalias
>   net: dsa: provide a second modalias to tag proto drivers based on
>     their name
>   net: dsa: strip sysfs "tagging" string of trailing newline
>   net: dsa: rename dsa_tag_driver_get() to dsa_tag_driver_get_by_id()
>   net: dsa: autoload tag driver module on tagging protocol change

FWIW just retested the entire series. But my tags are already on the
appropriate patches.

In any case,
Tested-by: Michael Walle <michael@walle.cc>

Thanks for taking care,
-michael
