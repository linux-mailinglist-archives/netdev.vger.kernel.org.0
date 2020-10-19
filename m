Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0998292C6A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbgJSRPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgJSRPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 13:15:10 -0400
X-Greylist: delayed 393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Oct 2020 10:15:09 PDT
Received: from edrik.securmail.fr (edrik.securmail.fr [IPv6:2a0e:f41:0:1::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08755C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 10:15:09 -0700 (PDT)
Received: from irc-clt.no.as208627.net (irc-clt.no.as208627.net [IPv6:2a0e:f42:a::3])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id A7D2AB0D05;
        Mon, 19 Oct 2020 19:08:30 +0200 (CEST)
Authentication-Results: edrik.securmail.fr/A7D2AB0D05; dmarc=none (p=none dis=none) header.from=swordarmor.fr
Date:   Mon, 19 Oct 2020 19:08:28 +0200
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     =?utf-8?B?15zXmdeo158g15DXldeT15nXlg==?= <liranodiz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: GRE Tunnel Over Linux VRF
Message-ID: <20201019170828.GA11371@irc-clt.no.as208627.net>
References: <CAFZsvkmCyRdOePeedok0b6Hn4PR-FPcNjfY7sWBzSBOAW+HRWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFZsvkmCyRdOePeedok0b6Hn4PR-FPcNjfY7sWBzSBOAW+HRWg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon 19 Oct 2020 17:59:56 GMT, לירן אודיז wrote:
> Hi, i am trying to create GRE tunnel over vrf.
> after binding  the GRE tunnel interface (also the LAN & WAN
> interfaces) to VRF, the traffic didn't forwarded via the WAN
> interface,  the path is LAN(VRx)----->GRE--x-->WAN(VRx) .
> only while the WAN interface is binding to the default router, the
> traffic forwarded correctly via the WAN interface, the path is
> LAN(VRx)----->GRE----->WAN(VRx).
> 
> used configuration:
> ifconfig lan1 80.80.80.1/24 up
> ifconfig wan2 50.50.50.1/24 up
> ip link add VR2 type vrf table 2
> ip link set dev VR2 up
> ip route add table 2 unreachable default metric 4278198272
> ip tunnel add greT2 mode gre local 50.50.50.1 remote 50.50.50.2
> ip addr add 55.55.55.1/24 dev greT2
> ip link set greT2 up
> ip link set dev greT2 master VR2
> ip link set dev lan1 master VR2
> ip link set dev wan2 master VR2
> ip route add vrf VR2 90.90.90.0/24 via 55.55.55.2
> 
> what is the correct way to create GRE tunnel over VRF.
> Thank for support.
> 
> BR, Liran

The IPs used as tunnel endpoints must be reachable via the GRT (and not
on the tunnel).

Here is an example of how I set it up here:
core01-arendal ~ # ip link show gre2
17: gre2@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue master as208627 state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre 85.166.254.210 peer 45.134.89.103
    alias Core: edge03
core01-arendal ~ # ip r g 85.166.254.210
local 85.166.254.210 dev lo table local src 85.166.254.210 uid 0
    cache <local>
core01-arendal ~ # ip r g 45.134.89.103
45.134.89.103 via 85.166.252.1 dev enp2s0 src 85.166.254.210 uid 0
    cache
core01-arendal ~ # ip addr show gre2
17: gre2@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue master as208627 state UNKNOWN group default qlen 1000
    link/gre 85.166.254.210 peer 45.134.89.103
    inet 45.91.126.224/31 scope global gre2
       valid_lft forever preferred_lft forever
    inet6 2a0e:f42:fffe:1::1a/127 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::200:5efe:55a6:fed2/64 scope link
       valid_lft forever preferred_lft forever
core01-arendal ~ # ip link show as208627
6: as208627: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 4e:82:77:cd:dd:b7 brd ff:ff:ff:ff:ff:ff
core01-arendal ~ # ip vrf sh
Name              Table
-----------------------
as208627         208627

-- 
Alarig
