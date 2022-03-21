Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F344E33F5
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiCUXAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiCUW7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:59:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4E5399B50;
        Mon, 21 Mar 2022 15:47:35 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 99799223EA;
        Mon, 21 Mar 2022 22:51:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647899489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zZPO69nLtcVoVNY/8WX7cNadUBapLv4v6RdmgLF+eNE=;
        b=qC2R+Sk2zeSQp8GXc0s2WUZq/ahHlgtEhKCGH/PNDSbsgJQY0dRaNcDRdCPau4/UsejBxC
        ZxWV2ZHm5B6MIL95cCFX4NNFA/kYiHNr1GWv57NH0rukuNgaLfV5rEngsLk6Chp6daOdKm
        bi8zajADj1XswTXM2s5RihUA2YXiepg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Mar 2022 22:51:29 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
In-Reply-To: <YjjeMo2YjMZkPIYa@lunn.ch>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
 <YjjeMo2YjMZkPIYa@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e26585742f492bf03959cfc469d02c52@walle.cc>
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

Am 2022-03-21 21:21, schrieb Andrew Lunn:
> On Mon, Mar 21, 2022 at 12:21:48PM +0100, Michael Walle wrote:
>> The SoC I'm using is the LAN9668, which uses the mdio-mscc-mdio 
>> driver.
>> First problem there, it doesn't support C45 (yet) but also doesn't 
>> check
>> for MII_ADDR_C45 and happily reads/writes bogus registers.
> 
> There are many drivers like that :-(
> 
> Whenever a new driver is posted, it is one of the things i ask
> for. But older drivers are missing such checks.

Should that be a patch for net or net-next? One thing to consider;
The gpy215 is probing just fine with a c22 only mdio driver which 
doesn't
check for c45 accesses. It might read fishy registers during its probe,
though. After adding the c45 check in the mdio drivers read and write
it will fail to probe. So depending on the mdio driver it might went
unnoticed that the phy_get_c45_ids() could fail.

If it should go via net, then it should probably be accompanied
by a patch to fix the gpy_probe() (i.e. ignoring -EOPNOTSUPP
error).

-michael
