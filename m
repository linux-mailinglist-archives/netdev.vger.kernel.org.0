Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570144E2525
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346731AbiCULXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346730AbiCULXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:23:15 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E569E8BE19;
        Mon, 21 Mar 2022 04:21:49 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 62E6922175;
        Mon, 21 Mar 2022 12:21:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647861708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vTGNgxQ0XsK0oOSlp1IzamOEjyBB0AvzrZZ0Ss1/2Tw=;
        b=iDE/Qo46vzHu5Jo2ge2/0/5mkHGnU95dkxQV1qJi9UuT5U8YZU2qVRjiDdtWhi3b/1qlZp
        r2kNcTMAhx4m3uef4liOCmsIeaN09p/SY7AaOVElqoAQqZJMJPYG8mo0o+c1wvOtDLMQPM
        U/URznJuJo9Dx41uHSfuaMbbKqWQ1Ns=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Mar 2022 12:21:48 +0100
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Clause 45 and Clause 22 PHYs on one MDIO bus
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a board with a c22 phy (microchip lan8814) and a c45 phy
(intel/maxlinear gyp215) on one bus. If I understand it correctly, both
accesses should be able to coexist on one bus. But the microchip lan8814
actually has a bug and gets confused by c45 accesses. For example it 
will
respond in the middle of another transaction with its own data if it
decodes it as a read. That is something we can see on a logic analyzer.
But we also see random register writes on the lan8814 (which you don't 
see
on the logic analyzer obviously). Fortunately, the GPY215 supports 
indirect
MMD access by the standard c22 registers. Thus as a workaround for the
problem, we could have a c22 only mdio bus.

The SoC I'm using is the LAN9668, which uses the mdio-mscc-mdio driver.
First problem there, it doesn't support C45 (yet) but also doesn't check
for MII_ADDR_C45 and happily reads/writes bogus registers.

I've looked at the mdio subsystem in linux, there is probe_capabilities
(MDIOBUS_C45 and friends) but the mxl-gpy.c is using c45 accesses
nevertheless. I'm not sure if this is a bug or not.

I was thinking of a fallback mechanism for the c45 read access like
in read_mmd. And even if the mdio controller is c45 capable, a PHY
might opt out. In my case, the lan8814.

What do you think?

-michael
