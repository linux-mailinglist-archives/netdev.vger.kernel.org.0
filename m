Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7FF4BC799
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 11:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiBSKJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 05:09:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiBSKI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 05:08:59 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16CD160437;
        Sat, 19 Feb 2022 02:08:39 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4tUAJL_1645265316;
Received: from 30.15.223.223(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V4tUAJL_1645265316)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 19 Feb 2022 18:08:37 +0800
Message-ID: <4964f8c3-8349-4fad-e176-8c26840d1a08@linux.alibaba.com>
Date:   Sat, 19 Feb 2022 18:08:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [Issue report] drivers/ftgmac100: DHCP occasionally fails during
 boot up or link down/up
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
 <YgwSAjGN2eWUpamo@lunn.ch>
From:   Heyi Guo <guoheyi@linux.alibaba.com>
In-Reply-To: <YgwSAjGN2eWUpamo@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

The DHCP issue is gone after applying below patch. I put the lock 
statements outside of the pure reset function, for the phydev lock has 
been acquired before calling adjust_link. The lock order in 
ftgmac100_reset_task() was also changed, to make it the same as the lock 
procedure in adjust_link, in which the phydev is locked first and then 
rtnl_lock. I'm not quite sure whether it will bring in any potential 
dead lock. Any advice?

Thanks,

Heyi

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
b/drivers/net/ethernet/faraday/ftgmac100.c
index 1c7912a94e36d..9610b59ca0876 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1002,6 +1002,8 @@ static int ftgmac100_alloc_rx_buffers(struct 
ftgmac100 *priv)
         return 0;
  }

+static void ftgmac100_reset(struct ftgmac100 *priv);
+
  static void ftgmac100_adjust_link(struct net_device *netdev)
  {
         struct ftgmac100 *priv = netdev_priv(netdev);
@@ -1050,8 +1052,14 @@ static void ftgmac100_adjust_link(struct 
net_device *netdev)
         /* Disable all interrupts */
         iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);

-       /* Reset the adapter asynchronously */
-       schedule_work(&priv->reset_task);
+       if (priv->mii_bus)
+               mutex_lock(&priv->mii_bus->mdio_lock);
+       /* Lock the world */
+       rtnl_lock();
+       ftgmac100_reset(priv);
+       rtnl_unlock();
+       if (priv->mii_bus)
+               mutex_unlock(&priv->mii_bus->mdio_lock);
  }

  static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t 
intf)
@@ -1388,26 +1396,17 @@ static int ftgmac100_init_all(struct ftgmac100 
*priv, bool ignore_alloc_err)
         return err;
  }

-static void ftgmac100_reset_task(struct work_struct *work)
+static void ftgmac100_reset(struct ftgmac100 *priv)
  {
-       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
-                                             reset_task);
         struct net_device *netdev = priv->netdev;
         int err;

         netdev_dbg(netdev, "Resetting NIC...\n");

-       /* Lock the world */
-       rtnl_lock();
-       if (netdev->phydev)
-               mutex_lock(&netdev->phydev->lock);
-       if (priv->mii_bus)
-               mutex_lock(&priv->mii_bus->mdio_lock);
-

         /* Check if the interface is still up */
         if (!netif_running(netdev))
-               goto bail;
+               return;

         /* Stop the network stack */
         netif_trans_update(netdev);
@@ -1429,12 +1428,29 @@ static void ftgmac100_reset_task(struct 
work_struct *work)
         ftgmac100_init_all(priv, true);

         netdev_dbg(netdev, "Reset done !\n");
- bail:
+}
+
+static void ftgmac100_reset_task(struct work_struct *work)
+{
+       struct ftgmac100 *priv = container_of(work, struct ftgmac100,
+                                             reset_task);
+       struct net_device *netdev = priv->netdev;
+
+       int err;
+       /* Lock the world */
+       if (netdev->phydev)
+               mutex_lock(&netdev->phydev->lock);
+       if (priv->mii_bus)
+               mutex_lock(&priv->mii_bus->mdio_lock);
+       rtnl_lock();
+
+       ftgmac100_reset(priv);
+
+       rtnl_unlock();
         if (priv->mii_bus)
                 mutex_unlock(&priv->mii_bus->mdio_lock);
         if (netdev->phydev)
                 mutex_unlock(&netdev->phydev->lock);
-       rtnl_unlock();
  }

  static int ftgmac100_open(struct net_device *netdev)

在 2022/2/16 上午4:50, Andrew Lunn 写道:
> On Tue, Feb 15, 2022 at 02:38:51PM +0800, Heyi Guo wrote:
>> Hi,
>>
>> We are using Aspeed 2600 and found DHCP occasionally fails during boot up or
>> link down/up. The DHCP client is systemd 247.6 networkd. Our network device
>> is 2600 MAC4 connected to a RGMII PHY module.
>>
>> Current investigation shows the first DHCP discovery packet sent by
>> systemd-networkd might be corrupted, and sysmtemd-networkd will continue to
>> send DHCP discovery packets with the same XID, but no other packets, as
>> there is no IP obtained at the moment. However the server side will not
>> respond with this serial of DHCP requests, until it receives some other
>> packets. This situation can be recovered by another link down/up, or a "ping
>> -I eth0 xxx.xxx.xxx.xxx" command to insert some other TX packets.
>>
>> Navigating the driver code ftgmac.c, I've some question about the work flow
>> from link down to link up. I think the flow is as below:
>>
>> 1. ftgmac100_open() will enable net interface with ftgmac100_init_all(), and
>> then call phy_start()
>>
>> 2. When PHY is link up, it will call netif_carrier_on() and then adjust_link
>> interface, which is ftgmac100_adjust_link() for ftgmac100
> The order there is questionable. Maybe it should first call the adjust
> link callback, and then the netif_carrier_on(). However...
>
>> 3. In ftgmac100_adjust_link(), it will schedule the reset work
>> (ftgmac100_reset_task)
>>
>> 4. ftgmac100_reset_task() will then reset the MAC
> Because of this delayed reset, changing the order will not help this
> driver.
>
>> I found networkd will start to send DHCP request immediately after
>> netif_carrier_on() called in step 2, but step 4 will reset the MAC, which
>> may potentially corrupt the sending packet.
> What is not clear to my is why it is scheduling the work rather than
> just doing it. At least for adjust_link, it is in a context it can
> sleep. ftgmac100_set_ringparam() should also be able to
> sleep. ftgmac100_interrupt() cannot sleep, so it does need to schedule
> work.
>
> I would suggest you refactor ftgmac100_reset_task() into a function
> that actually does the reset, and a wrapper which takes a
> work_struct. adjust_link can then directly do the reset, which
> probably solves your problem.
>
> 	 Andrew
