Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58FE51718D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385533AbiEBOcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiEBOa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:30:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A5EE006
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:26:56 -0700 (PDT)
Date:   Mon, 2 May 2022 16:26:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651501614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8sglzs/Aiv6oZEi/rwIoODLWzhFcJSno99XyKIq7GDY=;
        b=nhStawDhKPfeoAtPqWfCQOKMypSLiXlB5tp7H1kTXNkcL35WTk3/t/uDKl3uJrt+YUdT5y
        BTHW5r9oDfgdYNQFvSDHK+ceWumAGB9rALfrggeK4mPHzNwOXtzH5PZaJK/9ELwSq+KJcJ
        WuFD172TEA+Tstou9Lxr/zDPJcVybuXzv1/K04nJpK1eQ8EjQycle3UT8+CEtZBsp1NcTd
        UCn9Y2gaI+cqjVV66lsezpm3L8L5JnOIgefaiscEmKtQqO1U2L0KIl6kuTdVoMyGmWdb3J
        wx1EUUZxI8E6Ys4qolPDQe7p5SsFB1Hw0/nr+ITrwp49ozy0VK/hSCVSKCSMfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651501614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8sglzs/Aiv6oZEi/rwIoODLWzhFcJSno99XyKIq7GDY=;
        b=a+9AjspdP7lrvlJu69QJooug/xVw61F0ubw4jV+tFEnBfktj2p+G3qRiTc6qAiDNA+gNBj
        oAmNHBBe8me3XKBA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Message-ID: <Ym/qLBsiQVEMiDYY@linutronix.de>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
 <87v8usiemh.fsf@kurt>
 <20220429093845.tyzwcwppsgbjbw2s@skbuf>
 <87h76ci4ac.fsf@kurt>
 <20220429110038.6jv76qeyjjxborez@skbuf>
 <Ymv2l6Un7QXjrXFy@linutronix.de>
 <20220430131959.obb74c2z7ihap6ek@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220430131959.obb74c2z7ihap6ek@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-30 13:19:59 [+0000], Vladimir Oltean wrote:
> Hi Sebastian,
Hi Vladimir,

> If I get you right, you're saying it would be preferable to submit
> isochron for inclusion in Debian Testing.

If you intend to change command line switches or something that could
confuse users, you could start with experimental. Otherwise, yes,
testing.

> Ok, I've submitted an Intent To Package:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1010396

Thank you. 

> but if you don't mind, I'd still like to proceed with v2 right away,
> since the process of getting isochron packaged by Debian is essentially
> unbounded and I wouldn't like to create a dependency between packaging
> and this selftest. There is already a link to the Github repo in
> tsn_lib.sh, I expect people are still going to get it from there for a
> while. I will also make the dependency optional via a REQUIRE_ISOCHRON
> variable, as discussed with Kurt. I hope that's ok.

Sure.

Sebastian
