Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25D34DC441
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiCQKvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiCQKvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:51:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A220D1753AF
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647514203; x=1679050203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iD+rh169aWqAo5JARYnCoCA0xvIJHQT2hhDnpu24lKs=;
  b=u3aaWZ7axbiFkr8/GZJhJxmyd6l2JBOSQfHiMNTTgAU7ANKgVkun7CYH
   qunOw+HsWt3n2sFdxHdsH9ZM0/K2r8uAARwMxciUbEnbqe3UtXjsZMMQQ
   QF7iAMlPaydnH+NPpUltlCsGMdOMAC4+fJrAKEKkGONLoqcs5gKYstJpJ
   UX3WIIxWW/4znC3cBiP5z+JvzdtBCF5uJ1T4mKA3xDc70sZCaHTh3tlis
   77t3VAlj4ZuGJhxXzPWMYGRjm/oP9Bp9BeU8QIwqyioE7vH7fIxBB1ld3
   qVhXvWITsc9PzmET+B+vU01rqi1HZ8osNX6teig+/JQIOuhjA9O6eol/Z
   A==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="156782715"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:50:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:50:03 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 17 Mar 2022 03:50:02 -0700
Date:   Thu, 17 Mar 2022 16:19:56 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 2/5] net: lan743x: Add support for EEPROM
Message-ID: <20220317104956.4fhf3xjgrznm5tcv@microsemi.com>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
 <20220315061701.3006-3-Raju.Lakkaraju@microchip.com>
 <YjD6Hdjz78aZL/Wz@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YjD6Hdjz78aZL/Wz@lunn.ch>
User-Agent: NeoMutt/20180716-255-141487
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments

The 03/15/2022 21:42, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > +static int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter,
> > +                                   u16 timeout)
> > +{
> > +     u16 timeout_cnt = 0;
> > +     u32 val;
> > +
> > +     do {
> > +             spin_lock(&adapter->eth_syslock_spinlock);
> > +             if (adapter->eth_syslock_acquire_cnt == 0) {
> > +                     lan743x_csr_write(adapter, ETH_SYSTEM_SYS_LOCK_REG,
> > +                                       SYS_LOCK_REG_ENET_SS_LOCK_);
> > +                     val = lan743x_csr_read(adapter, ETH_SYSTEM_SYS_LOCK_REG);
> > +                     if (val & SYS_LOCK_REG_ENET_SS_LOCK_) {
> > +                             adapter->eth_syslock_acquire_cnt++;
> > +                             WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
> > +                             spin_unlock(&adapter->eth_syslock_spinlock);
> > +                             break;
> > +                     }
> > +             } else {
> > +                     adapter->eth_syslock_acquire_cnt++;
> > +                     WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
> > +                     spin_unlock(&adapter->eth_syslock_spinlock);
> > +                     break;
> > +             }
> > +
> > +             spin_unlock(&adapter->eth_syslock_spinlock);
> > +
> > +             if (timeout_cnt++ < timeout)
> > +                     usleep_range(10000, 11000);
> > +             else
> > +                     return -EINVAL;
> 
> ETIMEDOUT should be used for a timeout.
> 

Accpeted. Fix in V1 patches

> > +static int lan743x_hs_eeprom_cmd_cmplt_chk(struct lan743x_adapter *adapter)
> > +{
> > +     unsigned long start_time = jiffies;
> > +     u32 val;
> > +
> > +     do {
> > +             val = lan743x_csr_read(adapter, HS_E2P_CMD);
> > +             if (!(val & HS_E2P_CMD_EPC_BUSY_) ||
> > +                 (val & HS_E2P_CMD_EPC_TIMEOUT_))
> > +                     break;
> > +
> > +             usleep_range(50, 60);
> > +     } while (!time_after(jiffies, start_time + HZ));
> > +
> > +     if (val & (HS_E2P_CMD_EPC_TIMEOUT_ | HS_E2P_CMD_EPC_BUSY_)) {
> > +             netif_warn(adapter, drv, adapter->netdev,
> > +                        "HS EEPROM operation timeout/busy\n");
> > +             return -ETIMEDOUT;
> > +     }
> 
> It looks like iopoll.h should be used here.
> 

Accepted. Fix in V1 patches

> > +static int lan743x_hs_eeprom_write(struct lan743x_adapter *adapter,
> > +                                u32 offset, u32 length, u8 *data)
> > +{
> > +     int retval;
> > +     u32 val;
> > +     int i;
> > +
> > +     if (offset + length > MAX_EEPROM_SIZE)
> > +             return -EINVAL;
> 
> The core should of already checked this. Look at net/ethtool/ioctl.c
> 
>     Andrew

Accepted. Fix in V1 patches

-- 

Thanks,
Raju

