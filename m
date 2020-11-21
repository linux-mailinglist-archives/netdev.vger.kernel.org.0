Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC592BBECD
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 12:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgKUL5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 06:57:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45938 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgKUL5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 06:57:15 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605959833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=866fJcX+86sAiYltFe9jnsRUbIt0jIPCKbl1c3NfZHQ=;
        b=27aXkP5iDC1dtXeIjBQBRslelajeYtiYvVNj6o+KGwA1SWMs3R3aMTDQDx0QfmKk+3i3MQ
        wrJiurD5shXDYOzY4eUANlHnnuYMhNHAEP2pc1PCPUH/hdrWLbaUdYGl3FRuiL4dohq0Bs
        FJ2S0UzfQsj5rLXBZJnxc1wq3IqU4NCcf8RIqXyhsnSIMjpaL4p+vU8jCYvsq8yeME9Jo/
        lkev9cSCrmdiRGHZ/fuaau3vkTm+GTEwHClWIDoXq2D8j5NUJNuYlIVUZYpC6gHf+C1QPw
        nRozGl2YZ67j24sliZBxyGJm2T2TYemv4RbzsBrG7pnfcxhDvh9psmt5zrUyog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605959833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=866fJcX+86sAiYltFe9jnsRUbIt0jIPCKbl1c3NfZHQ=;
        b=OuVLK0HmQtGSDFo6X5zNWCho1nfSsWrGkgpZE2I45JfbWXUdw+axBRQeJRJTBIX0vCXlqz
        F9kMLYLbS0yYEaCw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 0/1] net: dsa: hellcreek: Add TAPRIO offloading
Date:   Sat, 21 Nov 2020 12:57:02 +0100
Message-Id: <20201121115703.23221-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
schedules may be configured individually on each front port. Each port has eight
egress queues. The traffic is mapped to a traffic class respectively via the PCP
field of a VLAN tagged frame.

This is a respin of the original patch with the discovered issues fixed:

 * Drop TC <-> PCP mapping

  => This is handled in the TAPRIO core now.

 * Don't depend on the system's time synchronized to the PTP clock

  => Drop hrtimers and use periodic delayed work instead. Also drop the
     spinlocks as delayed work is executed in user context and mutexes can
     be used which makes everything much simpler.

Thanks,
Kurt

Kurt Kanzenbach (1):
  net: dsa: hellcreek: Add TAPRIO offloading support

 drivers/net/dsa/hirschmann/hellcreek.c | 314 +++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  22 ++
 2 files changed, 336 insertions(+)

-- 
2.20.1

