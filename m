Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B195620F9
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbfGHO5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:57:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbfGHO5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 10:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kFVqv+VQQ5oHg8mbNP0YefqMseFotXwtvn39zIlZM8g=; b=CG9RiwSZNuGw9rLKKBueQ3qPai
        s2rNDfPXbFXyKO3WqWSDFr9NzCDm+isnTaKgn0XG0SvgsH4jv+m7nUftJNmcWBTQc7tBGDIWBYr7e
        Ac/+IHPJUvKhYOrTqHCnN7bouPOhpsEhZI6D2/izwRb5SxSscCO88xkkIc8xBR4C6uE8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkV5B-0002OO-DZ; Mon, 08 Jul 2019 16:57:33 +0200
Date:   Mon, 8 Jul 2019 16:57:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <20190708145733.GA9027@lunn.ch>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
 <20190704155347.GJ18473@lunn.ch>
 <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
 <20190705143647.GC4428@lunn.ch>
 <5e35a41c-be0e-efd4-cb69-cf5c860b872e@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e35a41c-be0e-efd4-cb69-cf5c860b872e@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> I got it working a little bit better. When I'm fast enough I can read
> the registers I want but it isn't a solution.

Why do you need to read registers?

What you actually might be interested in is the debugfs patches in
Viviens github tree.

> Here is an output of the tracing even with my custom accesses.
> mii -i 2 0 0x9b60; mii -i 2 1
> phyid:2, reg:0x01 -> 0xc801
> 
> Do you know how to delete EEInt bit? It is always one. And now all 
> accesses coming from the kworker thread. Maybe this is your polling 
> function?

EEInt should clear on read for older chips. For 6390, it might be
necessary to read global 2, register 0x13, index 03.
 
> I view the INT pin on an oscilloscope but it never changed. So maybe
> this is the problem. We just soldered a pull-up to that pin but it 
> still never changend. Maybe you have an idea?

The EEInt bit is probably masked. So it will not generate in
interrupt.

> So what I think is, because of the EEInt bit is never set back to one 
> i will poll it as fast as possible.

Is it forever looping in mv88e6xxx_g1_irq_thread_work? Or is it the
polling code, mv88e6xxx_irq_poll() firing every 100ms?

	Andrew
