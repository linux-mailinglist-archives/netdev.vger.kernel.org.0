Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D94B60FC52
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiJ0PuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiJ0PuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:50:15 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8410717F9B6
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:50:11 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 894CD1D6F;
        Thu, 27 Oct 2022 17:50:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1666885809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E7Or28xBgYu/nRUeSpH4hT5twaqUzGnlqBsG0p+ziLk=;
        b=gt1xX2hn8OFVJ8OtCPjtRvxHJMqUkCuYZu2DEX0lNuSD9Jo0OeND+Uw/qS8AoUUTHd7ZzO
        RlLyGMym0Y19j1jOUiP5A/qW937PT1qlRiVZYcb2CgVzOe1UZhCl9m25y4Qh/lFZSVLnJ+
        ETUj9gKekPea0wPhxn71IX9q3CRGf6e2QmWcSz6THXJAE2vopSrKypvbrr3xFbygDC2CQL
        v5W/RszuvBebbX9YAJ9w19DFhyK3Z+1bcvENlfdZB33e4TNT+Df+WJBypLRGVvV9zatCBe
        XYveC8Ue2S4eyJUL9ijJOcdNoz3mkRn73odQMe4TjQK3WFu4xTJAYOneVEZA4g==
MIME-Version: 1.0
Date:   Thu, 27 Oct 2022 17:50:09 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH net] net: dsa: fall back to default tagger if we can't
 load the one from DT
In-Reply-To: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
References: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <40e050352de4553cb788022ed018ed91@walle.cc>
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

Am 2022-10-27 16:54, schrieb Vladimir Oltean:
> DSA tagging protocol drivers can be changed at runtime through sysfs 
> and
> at probe time through the device tree (support for the latter was added
> later).
> 
> When changing through sysfs, it is assumed that the module for the new
> tagging protocol was already loaded into the kernel (in fact this is
> only a concern for Ocelot/Felix switches, where we have tag_ocelot.ko
> and tag_ocelot_8021q.ko; for every other switch, the default and
> alternative protocols are compiled within the same .ko, so there is
> nothing for the user to load).
> 
> The kernel cannot currently call request_module(), because it has no 
> way
> of constructing the modalias name of the tagging protocol driver
> ("dsa_tag-%d", where the number is one of DSA_TAG_PROTO_*_VALUE).
> The device tree only contains the string name of the tagging protocol
> ("ocelot-8021q"), and the only mapping between the string and the
> DSA_TAG_PROTO_OCELOT_8021Q_VALUE is present in tag_ocelot_8021q.ko.
> So this is a chicken-and-egg situation and dsa_core.ko has nothing 
> based
> on which it can automatically request the insertion of the module.
> 
> As a consequence, if CONFIG_NET_DSA_TAG_OCELOT_8021Q is built as 
> module,
> the switch will forever defer probing.
> 
> The long-term solution is to make DSA call request_module() somehow,
> but that probably needs some refactoring.
> 
> What we can do to keep operating with existing device tree blobs is to
> cancel the attempt to change the tagging protocol with the one 
> specified
> there, and to remain operating with the default one. Depending on the
> situation, the default protocol might still allow some functionality
> (in the case of ocelot, it does), and it's better to have that than to
> fail to probe.
> 
> Fixes: deff710703d8 ("net: dsa: Allow default tag protocol to be
> overridden from DT")
> Link: 
> https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
> Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Michael Walle <michael@walle.cc>

Thanks,
-michael
