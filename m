Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A05219279
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgGHVZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGHVZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 17:25:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D11206DF;
        Wed,  8 Jul 2020 21:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594243547;
        bh=LC07UQTQS72wjUnmNobbgrSBLKG5ay7rOQSyS5fNqwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cAIt2VCmtg5bP7kX2do+qhOe0u+EYkF4h/kvFQJIrnUhr68413RB4C2ENqv9RWQl7
         dGaS/80GoONWcsNJYhQOrq43wG6+OtuTXrMtW+pVYh6pB1O7CuzHHSb24AlUOhWwDw
         DvWSkxBieLkx0rwA/1AftNf2Ef0p5GJA85bUP/RY=
Date:   Wed, 8 Jul 2020 14:25:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        edwin.peer@broadcom.com,
        "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 7/9] ixgbe: convert to new udp_tunnel_nic infra
Message-ID: <20200708142545.66057f36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0Udi60-zs08eppC-5roPnpi_r4nAV53xovG8xfnovUtS4A@mail.gmail.com>
References: <20200707212434.3244001-1-kuba@kernel.org>
        <20200707212434.3244001-8-kuba@kernel.org>
        <CAKgT0Udi60-zs08eppC-5roPnpi_r4nAV53xovG8xfnovUtS4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 10:00:36 -0700 Alexander Duyck wrote:
> On Tue, Jul 7, 2020 at 2:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Make use of new common udp_tunnel_nic infra. ixgbe supports
> > IPv4 only, and only single VxLAN and Geneve ports (one each).
> >
> > I'm dropping the confusing piece of code in ixgbe_set_features().
> > ndo_udp_tunnel_add and ndo_udp_tunnel_del did not check if RXCSUM
> > is enabled, so this code was either unnecessary or buggy anyway.  
> 
> The code is unnecessary from what I can tell. I suspect the reason for
> adding the code was because the port values are used when performing
> the Rx checksum offload. However we never disable it in hardware, and
> the software path in ixgbe_rx_checksum will simply disable the related
> code anyway since we cannot set skb->encapsulation if RXCSUM is
> disabled.
> 
> With that said moving this to a separate patch might be preferable as
> it would make the patch more readable.

Ack on all points!

> > -static void ixgbe_clear_udp_tunnel_port(struct ixgbe_adapter *adapter, u32 mask)
> > +static int ixgbe_udp_tunnel_sync(struct net_device *dev, unsigned int table)
> >  {
> > +       struct ixgbe_adapter *adapter = netdev_priv(dev);
> >         struct ixgbe_hw *hw = &adapter->hw;
> > -       u32 vxlanctrl;
> > -
> > -       if (!(adapter->flags & (IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE |
> > -                               IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE)))
> > -               return;
> > +       struct udp_tunnel_info ti;
> >
> > -       vxlanctrl = IXGBE_READ_REG(hw, IXGBE_VXLANCTRL) & ~mask;
> > -       IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL, vxlanctrl);
> > -
> > -       if (mask & IXGBE_VXLANCTRL_VXLAN_UDPPORT_MASK)
> > -               adapter->vxlan_port = 0;
> > +       udp_tunnel_nic_get_port(dev, table, 0, &ti);
> > +       if (!table)
> > +               adapter->vxlan_port = ti.port;
> > +       else
> > +               adapter->geneve_port = ti.port;  
> 
> So this !table thing is a bit hard to read. It might be more useful if
> you had a define that made it clear that the expectation is that entry
> 0 is a VXLAN table and entry 1 is the GENEVE.

How about:

if (ti.type == UDP_TUNNEL_TYPE_VXLAN)

Tunnel info will have the type.

> >
> > -       if (mask & IXGBE_VXLANCTRL_GENEVE_UDPPORT_MASK)
> > -               adapter->geneve_port = 0;
> > +       IXGBE_WRITE_REG(hw, IXGBE_VXLANCTRL,
> > +                       ntohs(adapter->vxlan_port) |
> > +                       ntohs(adapter->geneve_port) <<
> > +                               IXGBE_VXLANCTRL_GENEVE_UDPPORT_SHIFT);
> > +       return 0;
> >  }  
> 
> I'm assuming the new logic will call this for all entries in the
> tables regardless of if they are set or not. If so I suppose this is
> fine.

Yup, I think this is preferred form of sync for devices which just
write registers. I wrote it for NFP initially but it seems to work 
in more places.

The driver can query the entire table and will get either the port 
or 0 if port is not set.

> >  #ifdef CONFIG_IXGBE_DCB
> >  /**
> >   * ixgbe_configure_dcb - Configure DCB hardware
> > @@ -6227,6 +6242,7 @@ static void ixgbe_init_dcb(struct ixgbe_adapter *adapter)
> >  /**
> >   * ixgbe_sw_init - Initialize general software structures (struct ixgbe_adapter)
> >   * @adapter: board private structure to initialize
> > + * @netdev: network interface device structure
> >   * @ii: pointer to ixgbe_info for device
> >   *
> >   * ixgbe_sw_init initializes the Adapter private data structure.
> > @@ -6234,6 +6250,7 @@ static void ixgbe_init_dcb(struct ixgbe_adapter *adapter)
> >   * OS network device settings (MTU size).
> >   **/
> >  static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> > +                        struct net_device *netdev,
> >                          const struct ixgbe_info *ii)
> >  {
> >         struct ixgbe_hw *hw = &adapter->hw;  
> 
> There is no need to add the argument. It should be accessible via
> adapter->netdev, or for that matter you could pass the netdev and drop
> the adapter and just pull it out via netdev_priv since the two are all
> contained in the same structure anyway. Another option would be to
> just pull the logic out of this section and put it in a switch
> statement of its own in the probe function.

Hm, new switch section definitely looks best. I'll do that.

> > @@ -6332,7 +6349,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> >                         adapter->flags2 |= IXGBE_FLAG2_TEMP_SENSOR_CAPABLE;
> >                 break;
> >         case ixgbe_mac_x550em_a:
> > -               adapter->flags |= IXGBE_FLAG_GENEVE_OFFLOAD_CAPABLE;
> > +               netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550em_a;
> >                 switch (hw->device_id) {
> >                 case IXGBE_DEV_ID_X550EM_A_1G_T:
> >                 case IXGBE_DEV_ID_X550EM_A_1G_T_L:
> > @@ -6359,7 +6376,8 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> >  #ifdef CONFIG_IXGBE_DCA
> >                 adapter->flags &= ~IXGBE_FLAG_DCA_CAPABLE;
> >  #endif
> > -               adapter->flags |= IXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
> > +               if (!netdev->udp_tunnel_nic_info)
> > +                       netdev->udp_tunnel_nic_info = &ixgbe_udp_tunnels_x550;
> >                 break;
> >         default:
> >                 break;  
> 
> Not a fan of the !udp_tunnel_nic_info check, but I understand you are
> having to do it because of the fall-through.

Yup.

> > @@ -6798,8 +6816,7 @@ int ixgbe_open(struct net_device *netdev)
> >
> >         ixgbe_up_complete(adapter);
> >
> > -       ixgbe_clear_udp_tunnel_port(adapter, IXGBE_VXLANCTRL_ALL_UDPPORT_MASK);
> > -       udp_tunnel_get_rx_info(netdev);
> > +       udp_tunnel_nic_reset_ntf(netdev);
> >
> >         return 0;  
> 
> So I went looking through the earlier patches for an explanation of
> udp_tunnel_nic_reset_ntf. It might be useful to have some doxygen
> comments with the declaration explaining what it does and when/why we
> should use it.

Looks like I hated the need for this one so much I forgot to document
it :S

I was hoping the core can issue all the callbacks just based on netdev
notifications, but it seems like most drivers have internal resets
procedures which require re-programming the ports :( Hence this helper
was born.

I'll document it like this:

 * Called by the driver to inform the core that the entire UDP tunnel port
 * state has been lost, usually due to device reset. Core will assume device
 * forgot all the ports and issue .set_port and .sync_table callbacks as
 * necessary.


Thanks for the review! I'll post v2 in a couple hours hoping someone
else will find time to review :S
