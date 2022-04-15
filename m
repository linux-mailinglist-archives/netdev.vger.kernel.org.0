Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC9502CF0
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355604AbiDOPkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355561AbiDOPkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:40:07 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D3D47048
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:37:24 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7CA6060008;
        Fri, 15 Apr 2022 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650037040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ij0H5L8ZW1gD/KNj5IYgoazS+UY2ozgxRzm7e6WPS4Y=;
        b=R5BAnE7kTbvZIkVn90ihmKmWNi9jFWw4OxiqJRYH+952BeLuRb23Vlq1D5xwuD2KWoQV74
        oqUmDxlE3eYUA934NW38kiykkBWp8gGfK+pRzx8D8vBydp7HYKxvQhcHkxr86AG5yi4ekh
        uVc4g6wxiG/u4xXvcw4isr5urXqs1JemjJMSK4+hBzZ7gih+icXia+jvF/lP8wR8CLRdHh
        VDi8a9ilrqe00bCpBCdRXdXOk5llq4+Mrr1l/zKdlf9Zk9X//9wClrDL3b31UcpgPMEv1w
        bqqYQmDBg6e9P4HwS8TncLczZomsWidmSpF17fT6cws1JBSxD7tB5jg+3RXpLQ==
Date:   Fri, 15 Apr 2022 17:37:18 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vladimir.oltean@nxp.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>
Subject: Offloading Priority Tables for queue classification
Message-ID: <20220415173718.494f5fdb@fedora>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

I'm starting this thread before any kind of series submission to
discuss on the manner with which we could deal with Queue
Classification in NICs, and more specifically how we could handle
internal classification tables like DSCP, VLAN Prio and any other
tables that we can populate in modern NICs to quickly assign a priority
to both egress and ingress traffic, and use that priority to select a
queue in which the packet will be enqueued/dequeued from.

The use-case we have in mind is to offload all of these classification
steps into a switch , where traffic would be classified internally
into queues, that we could configure for Frame-Preemption or any other
QoS techniques. I know that Frame Preemption itself and the way to
configure it is still under discussion, with debate on where to
configure the queue preemptability (hence why some of you ended-up CC'd
to that thread) :

https://lore.kernel.org/netdev/20210626003314.3159402-1-vinicius.gomes@intel.com/
  
There are already ways to do this classification, but from what
I've gathered, it looks like it's scattered across several places :

 - In TC, we can of course use TC flower for that. We can neatly decide
   which flows goes where, match on any of the fields that we can use
   to determine the priority of the packet. This however scales poorly
   when the underlying hardware uses tables dedicated only to matching
   specific fields, to assign each DSCP or VLAN a priority.

   TC flower works well when we want to use a full-featured
   classifier, using a TCAM of some sort combined with complete
   classification rules. Using TC flower to configure such tables would
   mean entering one rule per entry in our tables, which could work for
   VLAN prio, but not that much for DSCP tables for example.

 - TC skbedit with the priority offloading is exactly what we want to
   achieve, that is to emulate the skb->priority behaviour that we can
   configure with various ways, and map this priority to queues with
   mqpriofor example. tc-skbedit priority when offloaded handles that
   notion of "packet priority" that is used internally in a switch.

 - TC mqprio and TC taprio can be used for the actual prio->queue
   mapping, even though there's the "traffic class" layer sitting in
   the middle.

 - It looks like DCB could be a way to go to configure the DSCP/VLAN
   prio/any other QoS tables, since we can configure all of these tables
   with the "dcb app" command, which then calls hooks into the driver to
   configure offloading of these tables. Using DCB for this is perfect,
   since the traffic to prio assignment really is independant to the
   mqprio layer.

 - Finally for the last part of the chain, we can setup the queues for
   PFC or Frame-Preemption, possibly using ethtool as suggested in the
   above-mentionned thread.

So in the end, my question would be : Is it OK to mix all of these
together ? Using the dcb layer to configure the internal mapping of
traffic -> priority, then using mqprio to configure the priority ->
queue mapping, and then either TC again or ethtool do configure the
behaviour of the queues themselves ? Or is there some other way that
we've missed ?

Thanks in advance,

Best regards,

Maxime


