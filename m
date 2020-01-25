Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E5F1496A7
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgAYQfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:35:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYQfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 11:35:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/uAT0LRlvL6fbNuydQ0A53uGpAnx3j1J3+NiJXl3x7U=; b=OqEfS3UcXkdg9h4WbKKcVQgC/t
        5/PuS0PCXTBINgJePmxDpcTK5KQztSXpJgIYQQkWChc0lhdBoDTsYQgPRevDqsYXcqwM+JSzNKOHo
        g0Xi+Pk3qhWC76LuLhaSOXhleHrje3xPU7KBOF9I/lYZ4M+dWDX2MhaBwotRxdgl0ChU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivOOm-00078b-I0; Sat, 25 Jan 2020 17:35:04 +0100
Date:   Sat, 25 Jan 2020 17:35:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
Message-ID: <20200125163504.GF18311@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124161828.12206-7-horatiu.vultur@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
>   MRP_Test frames on the mrp ring ports. This is called only on nodes that have
>   the role Media Redundancy Manager.

How do you handle the 'headless chicken' scenario? User space tells
the port to start sending MRP_Test frames. It then dies. The hardware
continues sending these messages, and the neighbours thinks everything
is O.K, but in reality the state machine is dead, and when the ring
breaks, the daemon is not there to fix it?

And it is not just the daemon that could die. The kernel could opps or
deadlock, etc.

For a robust design, it seems like SWITCHDEV_OBJ_ID_RING_TEST_MRP
should mean: start sending MRP_Test frames for the next X seconds, and
then stop. And the request is repeated every X-1 seconds.

     Andrew
