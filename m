Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5D21652F9
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 00:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgBSXPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 18:15:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50236 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSXPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 18:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uiByJ8uwj4w+yypG8/uZx4crDLKhT+yMvcL+mwB85R8=; b=WP9A8mQEzCaLj33FPFy10v6VT
        QtyVTShq8caCvicWnH/K9bo8peqrkxDoXUUtNPbU12UbeuhbUACu2s6pSGz/DihN4vdXfEYLyYTpZ
        8NbRWkWzW5UgsoHVJhj0hfwlhTB0OzN7RKUlcm247pxH2TBro29QK5NqMYP1sc2VO+N4wa1aAqKcJ
        Ro21Tuh9A9srdGGTphrNIGGMJTEU4odn5zXaShfeyn0yYa0CB5uf3aEVJbsqVO3cNtTjQC/1UWJe8
        0iCBQbtgMgx0n+tshKg9fv3s4V1mqiyP5/OqX/wYBGvWFubqGDQjViHsJvI4hZcgQZcSkEvj6ddO8
        ls1FL80Mg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50122)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4YZ3-00088N-7S; Wed, 19 Feb 2020 23:15:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4YYy-0001os-W4; Wed, 19 Feb 2020 23:15:29 +0000
Date:   Wed, 19 Feb 2020 23:15:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200219231528.GS25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 11:18:17AM -0800, Florian Fainelli wrote:
> On 2/19/20 10:52 AM, Vladimir Oltean wrote:
> > On Wed, 19 Feb 2020 at 02:02, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> >> Don't add vlans when vlan filtering is disabled")? If a driver wants to
> >> veto the programming of VLANs while it has ports enslaved to a bridge
> >> that does not have VLAN filtering, it should have enough information to
> >> not do that operation.
> >> --
> >> Florian
> > 
> > It would be worth mentioning that for sja1105 and hypothetical other
> > users of DSA_TAG_PROTO_8021Q, DSA doing that automatically was
> > helpful. VLAN manipulations are still being done from tag_8021q.c for
> > the purpose of DSA tagging, but the fact that the VLAN EtherType is
> > not 0x8100 means that from the perspective of real VLAN traffic, the
> > switch is VLAN unaware. DSA was the easiest place to disseminate
> > between VLAN requests of its own and VLAN requests coming from
> > switchdev.
> > Without that logic in DSA, a vlan-unaware bridge would be able to
> > destroy the configuration done for source port decoding.
> > Just saying - with enough logic in .port_vlan_prepare, I should still
> > be able to accept only what's whitelisted to work for tagging, and
> > then it won't matter who issued that VLAN command.
> 
> I suppose I am fine with Russell's approach, but maybe its meaning
> should be reversed, that is, you get VLAN objects notifications by
> default for a  VLAN unaware bridge and if you do set a specific
> dsa_switch flag, then you do not get those.

If we reverse it, I'll need someone to tell me which DSA switches
should not get the vlan object notifications.  Maybe also in that
case, we should deny the ability to toggle the state of
vlan_filtering as well?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
