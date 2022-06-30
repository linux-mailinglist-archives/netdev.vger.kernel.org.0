Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17073561962
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiF3Llo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiF3Llm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:41:42 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3F352383
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:41:40 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 77E5C22236;
        Thu, 30 Jun 2022 13:41:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656589297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ogc3bORegIjFi3i/mXSs64XLiYpZnszgDk1HkMw0VRM=;
        b=kN0RHvvlfRc61QCvbLa52WJWEIPt1jSXgalZKOShW6lyZLN10la+mR5ibqhakZXKLawas8
        hhfG4O3pAC8SygEwCA3H8JiBGBSyPJKywsHd7Dn5eSOuSOazaWbAwjPhe1Pq4EuYRlfA2j
        +G29vPobA903EQzps8em+MjKn1q4xwM=
From:   Michael Walle <michael@walle.cc>
To:     vladimir.oltean@nxp.com
Cc:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com,
        rmk+kernel@armlinux.org.uk, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference during phylink_pcs_poll_start
Date:   Thu, 30 Jun 2022 13:41:30 +0200
Message-Id: <20220630114130.627252-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
References: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The current link mode of the phylink instance may not require an
> attached PCS. However, phylink_major_config() unconditionally
> dereferences this potentially NULL pointer when restarting the link poll
> timer, which will panic the kernel.
> 
> Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
> otherwise do nothing. The code prior to the blamed patch also only
> looked at pcs->poll within an "if (pcs)" block.
> 
> Fixes: bfac8c490d60 ("net: phylink: disable PCS polling over major configuration")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Michael Walle <michael@walle.cc> # on kontron-kbox-a-230-ls

-michael
