Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733106C2A8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfGQVbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:31:14 -0400
Received: from mx.0dd.nl ([5.2.79.48]:37116 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfGQVbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 17:31:14 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id DC7F65FEB1;
        Wed, 17 Jul 2019 23:31:11 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="Y1Mag4ir";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 82B4C1D15C07;
        Wed, 17 Jul 2019 23:31:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 82B4C1D15C07
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1563399071;
        bh=OUnw6YIBPD+atbkFig4vIJnBvqEisgFqsgM6Z5l98eY=;
        h=Date:From:To:Cc:Subject:From;
        b=Y1Mag4irJdiDg+H+Ugm889jsCDnSwpjQPwZZAO4eDLuXhqW3+0IKK6Ai05Uwc0DNH
         t0d7BfgDfo8hmVRKCxXcsfKr9RXhM18M76W2ixkbiTIUzyvBwIJwvY2wdWwswoCngc
         xRq8yqJYzj7TZTTU0IL7nZWv5W9cdih+mPteJq05TDQ0cnRQTmP8X4A7y6Obm8czf2
         jIcrW+dbP6lDPvYtqWDjFLqpzXl+WboP4NhMxurZ+Cnr0u9y+r1KJg55dxbgBzvohL
         tnM+ZyKrYS6r50mU5fq7eYKNsVOiqAs4UZ4UD+3MIIgrYQ2l3qJ/3Q1AeTCBpY2WmR
         JK6sRGT8OJKwg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Wed, 17 Jul 2019 21:31:11 +0000
Date:   Wed, 17 Jul 2019 21:31:11 +0000
Message-ID: <20190717213111.Horde.nir2D5kAJww569fjh8BZgZm@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@arm.linux.org.uk>
Subject: phylink: flow control on fixed-link not working.
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am trying to enable flow control/pause on PHYLINK and fixed-link.

My setup SOC mac (mt7621) <-> RGMII <-> SWITCH mac (mt7530).

It seems that in fixed-link mode all the flow control/pause bits are  
cleared in
phylink_parse_fixedlink(). If I read phylink_parse_fixedlink() [0] correctly,
I see that pl->link_config.advertising is AND with pl->supprted which has only
the PHY_SETTING() modes bits set. pl->link_config.advertising is losing Pause
bits. pl->link_config.advertising is used in phylink_resolve_flow() to set the
MLO_PAUSE_RX/TX BITS.

I think this is an error.
Because in phylink_start() see this part [1].

  /* Apply the link configuration to the MAC when starting. This allows
   * a fixed-link to start with the correct parameters, and also
   * ensures that we set the appropriate advertisement for Serdes links.
   */
  phylink_resolve_flow(pl, &pl->link_config);
  phylink_mac_config(pl, &pl->link_config);


If I add a this hacky patch below, flow control is enabled on the fixed-link.
         if (s) {
                 __set_bit(s->bit, pl->supported);
+               if (phylink_test(pl->link_config.advertising, Pause))
+                       phylink_set(pl->supported, Pause);
         } else {

So is phylink_parse_fixedlink() broken or should it handled in a other way?

Greats,

René

[0]:  
https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phylink.c#L196
[1]:  
https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phylink.c#L897

