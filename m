Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA62E6DCFBD
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 04:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjDKCfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 22:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDKCfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 22:35:31 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E7326B2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 19:35:26 -0700 (PDT)
X-QQ-mid: Yeas3t1681180469t861t32045
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 4959165728470320358
To:     "'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com> <20230403064528.343866-6-jiawenwu@trustnetic.com> <ZCrY9Pqn+fID63s3@shell.armlinux.org.uk> <00a701d96b7e$90edb890$b2c929b0$@trustnetic.com> <ZDPnpgYablOB5NRa@shell.armlinux.org.uk>
In-Reply-To: <ZDPnpgYablOB5NRa@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next 5/6] net: txgbe: Implement phylink pcs
Date:   Tue, 11 Apr 2023 10:34:27 +0800
Message-ID: <00b201d96c1e$235cc000$6a164000$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQKwNRf195lW+I6aexcIjeJmW6Wh1gJHr+azAlWE08ABYJm4YQJ8yyLdrTPzjmA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, April 10, 2023 6:41 PM, Russell King (Oracle) wrote:
> On Mon, Apr 10, 2023 at 03:32:12PM +0800, Jiawen Wu wrote:
> > > > +				       struct phylink_link_state
*state)
> > > > +{
> > > > +	int lpa, bmsr;
> > > > +
> > > > +	/* For C37 1000BASEX mode */
> > > > +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > > > +			      state->advertising)) {
> > > > +		/* Reset link state */
> > > > +		state->link = false;
> > > > +
> > > > +		/* Poll for link jitter */
> > > > +		read_poll_timeout(pcs_read, lpa, lpa,
> > > > +				  100, 50000, false, txgbe,
> > > > +				  MDIO_MMD_VEND2, MII_LPA);
> > >
> > > What jitter are you referring to? If the link is down (and thus
this
> > > register reads zero), why do we have to spin here for 50ms each
time?
> > >
> >
> > I found that when the last interrupt arrives, the link status is
often
> > still down, but it will become up after a while. It is about 30ms on
my
> > test.
> 
> It is normal for the first read of the BMSR to report that the link is
> down after it has come up. This is so that software can see if the
link
> has failed since it last read the BMSR. Phylink knows this, and will
> re-request the link state via the pcs_get_state() callback
> appropriately.
> 
> Is it reporting that the link is down after the second read of the
> link status after the interrupt?
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
> 

The link status bit of bmsr will report 1 after the second read. But
auto-negotiation looks like it will take some time to complete.
In my test case, 10000baseSR/1000baseX supported SFP on enp4s0f0, and
1000baseX supported SFP on enp4s0f1, to connect each other by optical
fiber.
Here is the log from probe the module and then change the speed with
enp4s0f0.

root@roy-System-Product-Name:~/net-next# modprobe txgbe
root@roy-System-Product-Name:~/net-next# dmesg -c
[63894.334069] txgbe 0000:04:00.0: 16.000 Gb/s available PCIe bandwidth,
limited by 5.0 GT/s PCIe x4 link at 0000:02:02.0 (capable of 32.000 Gb/s
with 5.0 GT/s PCIe x8 link)
[63894.337488] txgbe 0000:04:00.0 enp4s0f0: renamed from eth0
[63894.338181] sfp sfp.1024: Host maximum power 1.0W
[63894.351172] txgbe 0000:04:00.0 enp4s0f0: 30:09:f9:21:b9:5b
[63894.407234] txgbe 0000:04:00.0 enp4s0f0: configuring for
inband/10gbase-r link mode
[63894.889942] txgbe 0000:04:00.1: 16.000 Gb/s available PCIe bandwidth,
limited by 5.0 GT/s PCIe x4 link at 0000:02:02.0 (capable of 32.000 Gb/s
with 5.0 GT/s PCIe x8 link)
[63894.891155] txgbe 0000:04:00.1 enp4s0f1: renamed from eth0
[63894.906564] txgbe 0000:04:00.1 enp4s0f1: 30:09:f9:21:b9:5c
[63894.957750] txgbe 0000:04:00.1 enp4s0f1: configuring for
inband/10gbase-r link mode
[63895.208990] txgbe 0000:04:00.1 enp4s0f1: switched to
inband/1000base-x link mode
[63895.361265] txgbe 0000:04:00.1: [1] lpa=0x0, bmsr=0x189
[63895.361274] txgbe 0000:04:00.1: [2] lpa=0x0, bmsr=0x189
[63895.361282] txgbe 0000:04:00.1: [1] lpa=0x0, bmsr=0x189
[63895.361290] txgbe 0000:04:00.1: [2] lpa=0x0, bmsr=0x189
root@roy-System-Product-Name:~/net-next# ethtool -s enp4s0f0 advertise
0x20000000000
root@roy-System-Product-Name:~/net-next# dmesg -c
[63927.627708] txgbe 0000:04:00.1: [1] lpa=0x0, bmsr=0x189
[63927.627723] txgbe 0000:04:00.1: [2] lpa=0x0, bmsr=0x18d
[63927.627731] txgbe 0000:04:00.1: [1] lpa=0x0, bmsr=0x18d
[63927.627738] txgbe 0000:04:00.1: [2] lpa=0x0, bmsr=0x18d
[63927.647128] txgbe 0000:04:00.0: [1] lpa=0x0, bmsr=0x189
[63927.647144] txgbe 0000:04:00.0: [1] lpa=0x0, bmsr=0x18d
[63927.647148] txgbe 0000:04:00.0: [2] lpa=0x0, bmsr=0x18d
[63927.647154] txgbe 0000:04:00.0: [2] lpa=0x0, bmsr=0x18d
[63927.647162] txgbe 0000:04:00.0: [1] lpa=0x0, bmsr=0x18d
[63927.647168] txgbe 0000:04:00.0: [1] lpa=0x0, bmsr=0x18d
[63927.647172] txgbe 0000:04:00.0: [2] lpa=0x0, bmsr=0x18d
[63927.647177] txgbe 0000:04:00.0: [2] lpa=0x0, bmsr=0x18d
root@roy-System-Product-Name:~/net-next# ethtool enp4s0f0
Settings for enp4s0f0:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseX/Full
                                10000baseSR/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseX/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseX/Full
        Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Link detected: no
root@roy-System-Product-Name:~/net-next# dmesg -c
[63980.779785] txgbe 0000:04:00.0: [1] lpa=0x41a0, bmsr=0x1ad
[63980.779801] txgbe 0000:04:00.0: [2] lpa=0x41a0, bmsr=0x1ad

PS: "[1]" print for the first read, and "[2]" for the second.

By the way, I can't use the command "ethtool -s enp4s0f0 speed 1000
duplex full autoneg on" to set link, and the log shows "Cannot set new
settings: Invalid argument".



