Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271FC6CBFA7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjC1Ms3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbjC1MsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:48:19 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96129AD15;
        Tue, 28 Mar 2023 05:47:59 -0700 (PDT)
Received: from kandell (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPS id C5BBA1C147B;
        Tue, 28 Mar 2023 14:47:54 +0200 (CEST)
Authentication-Results: mail.nic.cz;
        none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1680007675; bh=HAg+KDLLnm2gtSA7y8AFWHCygEKFrbfSNudr8b36DU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Reply-To:
         Subject:To:Cc;
        b=YUgaphPOQa0LwjUvK7e7VwILMLTR4FeRYzBJNdL6//XE8UjfCQsnoe/aeO5Jphh99
         cHfBLny+PY8H9Kgt/bbXhE8niton9LmUbtH2e58MNYJl5+MSgopj2ogsK9t6Rkysy/
         pUOYTyZdy9NTH3CFGWAKYvyIVniO9XuACcf7YUC4=
Date:   Tue, 28 Mar 2023 14:47:54 +0200
From:   Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Gustav Ekelund <gustav.ekelund@axis.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        Gustav Ekelund <gustaek@axis.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog
 register
Message-ID: <20230328124754.oscahd3wtod6vkfy@kandell>
References: <20230328115511.400145-1-gustav.ekelund@axis.com>
 <20230328120604.zawfeskqs4yhlze6@kandell>
 <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba1722a-8dd7-4d6d-bade-b4c702c8387f@lunn.ch>
X-Virus-Scanned: clamav-milter 0.103.7 at mail
X-Virus-Status: Clean
X-Rspamd-Action: no action
X-Rspamd-Server: mail
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spamd-Result: default: False [-0.10 / 20.00];
        MIME_GOOD(-0.10)[text/plain];
        TAGGED_RCPT(0.00)[];
        ARC_NA(0.00)[];
        FROM_EQ_ENVFROM(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com];
        WHITELISTED_IP(0.00)[172.20.6.87];
        FROM_HAS_DN(0.00)[];
        MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: C5BBA1C147B
X-Spamd-Bar: /
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: WHITELISTED_IP
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 02:30:37PM +0200, Andrew Lunn wrote:
> > > +static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
> > > +{
> > > +	mv88e6390_watchdog_action(chip, irq);
> > > +
> > > +	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
> > > +			   MV88E6390_G2_WDOG_CTL_UPDATE |
> > > +			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
> > > +
> > > +	return IRQ_HANDLED;
> > > +}
> > 
> > Shouldn't this update be in .irq_setup() method? In the commit message
> > you're saying that the problem is that bits aren't cleared with SW
> > reset. So I would guess that the change should be in the setup of
> > watchdog IRQ, not in IRQ action?
> 
> I think it is a bit more complex than that. At least for the 6352,
> which i just looked at the data sheet, the interrupt bits are listed
> as "ROC". Which is missing from the list of definitions, but seems to
> mean Read Only, Clear on read. So even if it was not cleared on
> software reset, it would only fire once, and then be cleared.
> 
> The problem description here is that it does not clear on read, it
> needs an explicit write. Which suggests Marvell changed it for the
> 6393.
> 
> So i have a couple of questions:
> 
> 1) Is this new behaviour limited to the 6393, or does the 6390 also
> need this write?

OK I am looking at the func specs of 6390 and 6393x, at the table
descrinbing the Data Path Watch Dog Event register (index 0x12 of global
2, which is the one being written), and the tables are exactly the same.

For every non-reserved bit there is the following:
  This bit is cleared by a SWReset (Global 1 offset 0x04). It will
  automatically be cleared to zero if the SWReset on WD bit (index 0x13)
  is set to a one and this event's Func bit is cleared to zero (index
  0x11).

Moreover only bit 0 of this register (ForceWD Event) is RWR. Bits 1 to 3
(EgressWD Event, QC WD Event and CT WD Event) are all RO. Bits 4-7 are
reserved. (Once again, exactly as in func spec of 6390.)

So I am not exactly sure what is going on. The errata document I have
does not mention watch dog at all.

Marek

> 2) What about other interrupts? Is this the only one which has changed
> behaviour?
> 
> 	Andrew
