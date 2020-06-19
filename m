Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E9E201D3A
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 23:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgFSVkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 17:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgFSVkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 17:40:11 -0400
X-Greylist: delayed 542 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Jun 2020 14:40:11 PDT
Received: from mail.bugwerft.de (mail.bugwerft.de [IPv6:2a03:6000:1011::59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B60F3C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 14:40:11 -0700 (PDT)
Received: from [192.168.178.106] (p57bc9d37.dip0.t-ipconnect.de [87.188.157.55])
        by mail.bugwerft.de (Postfix) with ESMTPSA id E542742ADAF;
        Fri, 19 Jun 2020 21:31:04 +0000 (UTC)
From:   Daniel Mack <daniel@zonque.org>
Subject: Question on DSA switches, IGMP forwarding and switchdev
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Message-ID: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
Date:   Fri, 19 Jun 2020 23:31:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm working on a custom board featuring a Marvell mv88e6085 Ethernet
switch controlled by the Linux DSA driver, and I'm facing an issue with
IGMP packet flows.

Consider two Ethernet stations, each connected to the switch on a
dedicated port. A Linux bridge combines the two ports. In my setup, I
need these two stations to send and receive multicast traffic, with IGMP
snooping enabled.

When an IGMP query enters the switch, it is redirected to the CPU port
as all 'external' ports are configured for IGMP/MLP snooping by the
driver. The issue that I'm seeing is that the Linux bridge does not
forward the IGMP frames to any other port, no matter whether the bridge
is in snooping mode or not. This needs to happen however, otherwise the
stations will not see IGMP queries, and unsolicited membership reports
are not being transferred either.

I've traced these frames through the bridge code and figured forwarding
fails in should_deliver() in net/bridge/br_forward.c because
nbp_switchdev_allowed_egress() denies it due to the fact that the frame
has already been forwarded by the same parent device. This check causes
all manual software forwarding of frames between two such switch ports
to fail. Note that IGMP traffic is the only class of communication that
is affected by this as it is not handled in hardware.

So my question now is how to fix that. Would the DSA driver need to mark
the ports as independent somehow?


Thanks,
Daniel

