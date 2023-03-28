Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C76CC2BE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbjC1OsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbjC1OsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:48:10 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BA1DBCC;
        Tue, 28 Mar 2023 07:47:47 -0700 (PDT)
Received: from kandell (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPS id AB3451C147B;
        Tue, 28 Mar 2023 16:47:42 +0200 (CEST)
Authentication-Results: mail.nic.cz;
        none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1680014864; bh=8gvfVWSHMDuNvvsDwY1HViDWLctRRNs/Urhm0s1QuW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Reply-To:
         Subject:To:Cc;
        b=uQI/uAEr7SG+opneRJoqPCCRfUsWk8gV9U8WrjVC1sz/xUr81EoKBqtCgKdjYsgY2
         XFfPX7JSOehb4xadeFXIb2Uw7QUjtr9sbM02dlOZzfAkTHDhxwvbdmEH3yHxdiPhiv
         kCv/0J5dGXSJr1RuPW0RRhN5ekxh7O0fTWTRXG2o=
Date:   Tue, 28 Mar 2023 16:47:42 +0200
From:   Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Gustav Ekelund <gustaek@axis.com>,
        Gustav Ekelund <gustav.ekelund@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Message-ID: <20230328144742.vty3cpmgmsdyjiia@kandell>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
 <20230328120604.zawfeskqs4yhlze6@kandell>
 <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
 <20230328124754.oscahd3wtod6vkfy@kandell>
 <c92234f1-099b-29a0-f093-c54c046d304a@axis.com>
 <be2b5084-9cab-4cc7-ba50-a53dd71dfea5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be2b5084-9cab-4cc7-ba50-a53dd71dfea5@lunn.ch>
X-Virus-Scanned: clamav-milter 0.103.7 at mail
X-Virus-Status: Clean
X-Spamd-Bar: /
X-Spamd-Result: default: False [-0.10 / 20.00];
        MIME_GOOD(-0.10)[text/plain];
        TAGGED_RCPT(0.00)[];
        ARC_NA(0.00)[];
        FROM_EQ_ENVFROM(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com];
        WHITELISTED_IP(0.00)[172.20.6.87];
        FROM_HAS_DN(0.00)[];
        MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: AB3451C147B
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: WHITELISTED_IP
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Rspamd-Server: mail
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 03:45:51PM +0200, Andrew Lunn wrote:
> On Tue, Mar 28, 2023 at 03:34:03PM +0200, Gustav Ekelund wrote:
> 
> > 1) Marvell has confirmed that 6393x (Amethyst) differs from 6390 (Peridot)
> > with quote: “I tried this on my board and see G2 offset 0x1B index 12 bit 0
> > does not clear, I also tried doing a SWReset and the bit is still 1. I did
> > try the same on a Peridot board and it clears as advertised.”
> > 
> > 2) Marvell are not aware of any other stuck bits, but has confirmed that the
> > WD event bits are not cleared on SW reset which is indeed contradictory to
> > what the data sheet suggests.
> 
> Hi Gustav
> 
> Please expand the commit message with a summary of this
> information. It answers the questions both Marek and i have been
> asking, so deserves to be in the commit message.
> 
> 	Andrew

Maybe also add a comment next to the code writing to the register, that
this is due to an yet unreleased erratum on 6393x.

Marek
