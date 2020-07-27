Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB222E40A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 04:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgG0CgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 22:36:24 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:52248 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgG0CgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 22:36:24 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CE3522A9;
        Mon, 27 Jul 2020 04:36:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595817375;
        bh=iD1NH57tNRXMaorT4JzF8Nq63CmU/y/5Qo7Tv8/eHOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kdpczhk4eUP8NGaJ00VTbDCBiEE437y3pXfQ+5o6kcVlb7L3wcJd1Z/xipcSoW0eo
         Q8sXI1w2MJ3ZonDKlZkti1IbLIE1OgiUQcfEaEdT3Yhuc/344ZzIGXtjO7l3ow+fxk
         BsUxgO0Hg4vyuWq6H4kv13be4HAieKAzsHubEF0Y=
Date:   Mon, 27 Jul 2020 05:36:07 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727023607.GB23988@pendragon.ideasonboard.com>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <CAFXsbZrc4kLQPDRXo7zLXV-p6=eLQfiZo6o4o_dK6iDCyJP+AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFXsbZrc4kLQPDRXo7zLXV-p6=eLQfiZo6o4o_dK6iDCyJP+AA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Sun, Jul 26, 2020 at 07:13:20PM -0700, Chris Healy wrote:
> On Sun, Jul 26, 2020 at 7:06 PM Laurent Pinchart wrote:
> > On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> >> On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> >>> This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> >>>
> >>> The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> >>> i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> >>> rootfs will be failed with the commit.
> >>
> >> I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> >> is configured to boot over NFS root with IP autoconfiguration through
> >> DHCP. The DHCP request goes out, the reply it sent back by the server,
> >> but never noticed by the fec driver.
> >>
> >> v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> >> during the v5.8 merge window, I suspect something else cropped in
> >> between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> >> needs to be reverted too. We're close to v5.8 and it would be annoying
> >> to see this regression ending up in the released kernel. I can test
> >> patches, but I'm not familiar enough with the driver (or the networking
> >> subsystem) to fix the issue myself.
> >
> > If it can be of any help, I've confirmed that, to get the network back
> > to usable state from v5.8-rc6, I have to revert all patches up to this
> > one. This is the top of my branch, on top of v5.8-rc6:
> >
> > 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> > 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> > 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> > bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> > 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"
> 
> I just fired up net-next on my i.MX7d based design (not NFS root
> though).  I can bring up the network interface with a gigabit
> connection but ALL RX traffic is failing with CRC errors.  Now, my
> design is using a Micrel KSZ9031 which might be part of the problem
> for me as there were some recent KSZ9031 changes made so take what I'm
> seeing with a grain of salt.

I'm using the same PHY (KSZ9031RNXIA to be precise).

> Laurent, couple questions:
> 
> 1) Are you able to boot without NFS root and communicate correctly or
> is this issue just when doing an NFS root?
> 2) If you are able to boot up without NFS root, can you check the
> ethtool statistics and see the same RX CRC errors I'm seeing?

I'll try this next. This particular board isn't flashed with a root FS,
but it shouldn't be hard to do so. Just need to add ethtool to my
buildroot FS.

> >>> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> >>>
> >>> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> >>> index a6cdd5b..e74dd1f 100644
> >>> --- a/drivers/net/ethernet/freescale/fec.h
> >>> +++ b/drivers/net/ethernet/freescale/fec.h
> >>> @@ -376,7 +376,8 @@ struct bufdesc_ex {
> >>>  #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
> >>>  #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
> >>>
> >>> -#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
> >>> +#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII)
> >>> +#define FEC_NAPI_IMASK     FEC_ENET_MII
> >>>  #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
> >>>
> >>>  /* ENET interrupt coalescing macro define */
> >>> @@ -542,6 +543,7 @@ struct fec_enet_private {
> >>>     int     link;
> >>>     int     full_duplex;
> >>>     int     speed;
> >>> +   struct  completion mdio_done;
> >>>     int     irq[FEC_IRQ_NUM];
> >>>     bool    bufdesc_ex;
> >>>     int     pause_flag;
> >>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> >>> index 1ae075a..c7b84bb 100644
> >>> --- a/drivers/net/ethernet/freescale/fec_main.c
> >>> +++ b/drivers/net/ethernet/freescale/fec_main.c
> >>> @@ -976,8 +976,8 @@ fec_restart(struct net_device *ndev)
> >>>     writel((__force u32)cpu_to_be32(temp_mac[1]),
> >>>            fep->hwp + FEC_ADDR_HIGH);
> >>>
> >>> -   /* Clear any outstanding interrupt, except MDIO. */
> >>> -   writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
> >>> +   /* Clear any outstanding interrupt. */
> >>> +   writel(0xffffffff, fep->hwp + FEC_IEVENT);
> >>>
> >>>     fec_enet_bd_init(ndev);
> >>>
> >>> @@ -1123,7 +1123,7 @@ fec_restart(struct net_device *ndev)
> >>>     if (fep->link)
> >>>             writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
> >>>     else
> >>> -           writel(0, fep->hwp + FEC_IMASK);
> >>> +           writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
> >>>
> >>>     /* Init the interrupt coalescing */
> >>>     fec_enet_itr_coal_init(ndev);
> >>> @@ -1652,10 +1652,6 @@ fec_enet_interrupt(int irq, void *dev_id)
> >>>     irqreturn_t ret = IRQ_NONE;
> >>>
> >>>     int_events = readl(fep->hwp + FEC_IEVENT);
> >>> -
> >>> -   /* Don't clear MDIO events, we poll for those */
> >>> -   int_events &= ~FEC_ENET_MII;
> >>> -
> >>>     writel(int_events, fep->hwp + FEC_IEVENT);
> >>>     fec_enet_collect_events(fep, int_events);
> >>>
> >>> @@ -1663,12 +1659,16 @@ fec_enet_interrupt(int irq, void *dev_id)
> >>>             ret = IRQ_HANDLED;
> >>>
> >>>             if (napi_schedule_prep(&fep->napi)) {
> >>> -                   /* Disable interrupts */
> >>> -                   writel(0, fep->hwp + FEC_IMASK);
> >>> +                   /* Disable the NAPI interrupts */
> >>> +                   writel(FEC_NAPI_IMASK, fep->hwp + FEC_IMASK);
> >>>                     __napi_schedule(&fep->napi);
> >>>             }
> >>>     }
> >>>
> >>> +   if (int_events & FEC_ENET_MII) {
> >>> +           ret = IRQ_HANDLED;
> >>> +           complete(&fep->mdio_done);
> >>> +   }
> >>>     return ret;
> >>>  }
> >>>
> >>> @@ -1818,24 +1818,11 @@ static void fec_enet_adjust_link(struct net_device *ndev)
> >>>             phy_print_status(phy_dev);
> >>>  }
> >>>
> >>> -static int fec_enet_mdio_wait(struct fec_enet_private *fep)
> >>> -{
> >>> -   uint ievent;
> >>> -   int ret;
> >>> -
> >>> -   ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
> >>> -                                   ievent & FEC_ENET_MII, 2, 30000);
> >>> -
> >>> -   if (!ret)
> >>> -           writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> >>> -
> >>> -   return ret;
> >>> -}
> >>> -
> >>>  static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> >>>  {
> >>>     struct fec_enet_private *fep = bus->priv;
> >>>     struct device *dev = &fep->pdev->dev;
> >>> +   unsigned long time_left;
> >>>     int ret = 0, frame_start, frame_addr, frame_op;
> >>>     bool is_c45 = !!(regnum & MII_ADDR_C45);
> >>>
> >>> @@ -1843,6 +1830,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> >>>     if (ret < 0)
> >>>             return ret;
> >>>
> >>> +   reinit_completion(&fep->mdio_done);
> >>> +
> >>>     if (is_c45) {
> >>>             frame_start = FEC_MMFR_ST_C45;
> >>>
> >>> @@ -1854,9 +1843,11 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> >>>                    fep->hwp + FEC_MII_DATA);
> >>>
> >>>             /* wait for end of transfer */
> >>> -           ret = fec_enet_mdio_wait(fep);
> >>> -           if (ret) {
> >>> +           time_left = wait_for_completion_timeout(&fep->mdio_done,
> >>> +                           usecs_to_jiffies(FEC_MII_TIMEOUT));
> >>> +           if (time_left == 0) {
> >>>                     netdev_err(fep->netdev, "MDIO address write timeout\n");
> >>> +                   ret = -ETIMEDOUT;
> >>>                     goto out;
> >>>             }
> >>>
> >>> @@ -1875,9 +1866,11 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> >>>             FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
> >>>
> >>>     /* wait for end of transfer */
> >>> -   ret = fec_enet_mdio_wait(fep);
> >>> -   if (ret) {
> >>> +   time_left = wait_for_completion_timeout(&fep->mdio_done,
> >>> +                   usecs_to_jiffies(FEC_MII_TIMEOUT));
> >>> +   if (time_left == 0) {
> >>>             netdev_err(fep->netdev, "MDIO read timeout\n");
> >>> +           ret = -ETIMEDOUT;
> >>>             goto out;
> >>>     }
> >>>
> >>> @@ -1895,6 +1888,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >>>  {
> >>>     struct fec_enet_private *fep = bus->priv;
> >>>     struct device *dev = &fep->pdev->dev;
> >>> +   unsigned long time_left;
> >>>     int ret, frame_start, frame_addr;
> >>>     bool is_c45 = !!(regnum & MII_ADDR_C45);
> >>>
> >>> @@ -1904,6 +1898,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >>>     else
> >>>             ret = 0;
> >>>
> >>> +   reinit_completion(&fep->mdio_done);
> >>> +
> >>>     if (is_c45) {
> >>>             frame_start = FEC_MMFR_ST_C45;
> >>>
> >>> @@ -1915,9 +1911,11 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >>>                    fep->hwp + FEC_MII_DATA);
> >>>
> >>>             /* wait for end of transfer */
> >>> -           ret = fec_enet_mdio_wait(fep);
> >>> -           if (ret) {
> >>> +           time_left = wait_for_completion_timeout(&fep->mdio_done,
> >>> +                   usecs_to_jiffies(FEC_MII_TIMEOUT));
> >>> +           if (time_left == 0) {
> >>>                     netdev_err(fep->netdev, "MDIO address write timeout\n");
> >>> +                   ret = -ETIMEDOUT;
> >>>                     goto out;
> >>>             }
> >>>     } else {
> >>> @@ -1933,9 +1931,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >>>             fep->hwp + FEC_MII_DATA);
> >>>
> >>>     /* wait for end of transfer */
> >>> -   ret = fec_enet_mdio_wait(fep);
> >>> -   if (ret)
> >>> +   time_left = wait_for_completion_timeout(&fep->mdio_done,
> >>> +                   usecs_to_jiffies(FEC_MII_TIMEOUT));
> >>> +   if (time_left == 0) {
> >>>             netdev_err(fep->netdev, "MDIO write timeout\n");
> >>> +           ret  = -ETIMEDOUT;
> >>> +   }
> >>>
> >>>  out:
> >>>     pm_runtime_mark_last_busy(dev);
> >>> @@ -2144,9 +2145,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
> >>>
> >>>     writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
> >>>
> >>> -   /* Clear any pending transaction complete indication */
> >>> -   writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> >>> -
> >>>     fep->mii_bus = mdiobus_alloc();
> >>>     if (fep->mii_bus == NULL) {
> >>>             err = -ENOMEM;
> >>> @@ -3688,6 +3686,7 @@ fec_probe(struct platform_device *pdev)
> >>>             fep->irq[i] = irq;
> >>>     }
> >>>
> >>> +   init_completion(&fep->mdio_done);
> >>>     ret = fec_enet_mii_init(pdev);
> >>>     if (ret)
> >>>             goto failed_mii_init;

-- 
Regards,

Laurent Pinchart
