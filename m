Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E064F17E8
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352991AbiDDPHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbiDDPHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:07:13 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F2024F30;
        Mon,  4 Apr 2022 08:05:17 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 167CF221D4;
        Mon,  4 Apr 2022 17:05:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649084714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vFi7yXUyhEvuyEPAaB5PJBj31x6UAMrx11hHIwLpdNw=;
        b=dc6JR3Kh1Ky3QpzM5AVH203vP79qpSRIe0/7KFPStc93uVzLA6hMlEPEl7+mjlOxUUQm5N
        s9pNBuWORJiOmTMckn+4ooQE8mRVMNiYtpgDX5TFNKNcHP/PVUlWNuQAxyqLeNzAafgFs1
        9HQ+CQBtpNZYNCqrUyrqASCM2kV4p6Q=
From:   Michael Walle <michael@walle.cc>
To:     richardcochran@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, grygorii.strashko@ti.com,
        kuba@kernel.org, kurt@linutronix.de, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping layer be selectable.
Date:   Mon,  4 Apr 2022 17:05:08 +0200
Message-Id: <20220404150508.3945833-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104014215.GA20062@hoboy.vegasvil.org>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
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

Sorry for digging out this older thread, but it seems to be discussed
in [1].

> IMO, the default should be PHY because up until now the PHY layer was
> prefered.
> 
> Or would you say the MAC layer should take default priority?
> 
> (that may well break some existing systems)

Correct me if I'm wrong, but for systems with multiple interfaces,
in particular switches, you'd need external circuits to synchronize
the PHCs within in the PHYs. (And if you use a time aware scheduler
you'd need to synchronize the MAC, too). Whereas for switches there
is usually just one PHC in the MAC which just works.

On these systems, pushing the timestamping to the PHY would mean
that this external circuitry must exist and have to be in use/
supported. MAC timestamping will work in all cases without any
external dependencies.

I'm working on a board with the LAN9668 switch which has one LAN8814
PHY and two GPY215 PHYs and two internal PHYs. The LAN9668 driver
will forward all timestamping ioctls to the PHY if it supports
timestamping (unconditionally). As soon as the patches to add ptp
support to the LAN8814 will be accepted, I guess it will break the
PTP/TAS support because there is no synchronization between all the
PHCs on that board. Thus, IMHO MAC timestamping should be the default.

-michael

[1] https://lore.kernel.org/netdev/20220308145405.GD29063@hoboy.vegasvil.org/
