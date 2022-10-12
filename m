Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153BB5FC008
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 07:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJLFDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 01:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLFC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 01:02:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D83A99FF;
        Tue, 11 Oct 2022 22:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665550977; x=1697086977;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V30PcvxJ1tNlm2h33sP6C+hjL+U7LyaTmDXN8Wxr/pg=;
  b=gR0psYir61geTEsUmu/lfYqQygzO/FNLjyi1ksxmCvxX3dsOpALgXKhy
   HJBGzBUDwwUACqZ30fChsuAC2hV7if0nh0qBwi4VMdk/kjbzNC/sL629r
   kKU99245B9iwNLYfiXk43wRzztZbUBWq3GZ6gZQ1Bb5uBi4enBcnJQltp
   zOE7pnJv8Cuz6WdBqqTX2REpwAGdyQZFykgr9VFafMPVXzy2NQ4UBQXqN
   Wx2AjTk18nfifbtPaPoAPXQQvEPDzks/zD+8EHIx0c9AbeFt7BJ9DH992
   DQTAfMfby9kAcKNUG30mLJmQjfKKqZWPXnqB57hvsFThPj9wKmoGgyoKb
   w==;
X-IronPort-AV: E=Sophos;i="5.95,178,1661842800"; 
   d="scan'208";a="194986426"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2022 22:02:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 11 Oct 2022 22:02:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 11 Oct 2022 22:02:53 -0700
Date:   Wed, 12 Oct 2022 10:32:52 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next V3] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221012050252.GA70729@raju-project-pc>
References: <20221003103821.4356-1-Raju.Lakkaraju@microchip.com>
 <Y0R0B0sOzjOTIM66@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Y0R0B0sOzjOTIM66@lunn.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for review comments.

The 10/10/2022 21:35, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> >  static int lan743x_get_regs_len(struct net_device *dev)
> >  {
> > -     return MAX_LAN743X_ETH_REGS * sizeof(u32);
> > +     struct lan743x_adapter *adapter = netdev_priv(dev);
> > +     u32 num_regs = MAX_LAN743X_ETH_COMMON_REGS;
> > +
> > +     if (adapter->is_sgmii_en)
> > +             num_regs += MAX_LAN743X_ETH_SGMII_REGS;
> > +
> > +     return num_regs * sizeof(u32);
> >  }
> >
> >  static void lan743x_get_regs(struct net_device *dev,
> >                            struct ethtool_regs *regs, void *p)
> >  {
> > +     struct lan743x_adapter *adapter = netdev_priv(dev);
> > +     int regs_len;
> > +
> > +     regs_len = lan743x_get_regs_len(dev);
> > +     memset(p, 0, regs_len);
> > +
> >       regs->version = LAN743X_ETH_REG_VERSION;
> > +     regs->len = regs_len;
> > +
> > +     lan743x_common_regs(dev, p);
> > +     p = (u32 *)p + MAX_LAN743X_ETH_COMMON_REGS;
> >
> > -     lan743x_common_regs(dev, regs, p);
> > +     if (adapter->is_sgmii_en) {
> > +             lan743x_sgmii_regs(dev, p);
> > +             p = (u32 *)p + MAX_LAN743X_ETH_SGMII_REGS;
> > +     }
> 
> This seems O.K. for the moment, but how does it work when you add the
> next set of optional registers? Say you want to add the PTP registers?

Yes. 
For other modules (i.e. PTP etc) register dumps, i would like
implement ethtool -w/-W option to configure dump flag.
Existing private flag use for EEPROM/OTP access which we don't use same
flag for register dumps to avoid accidental changes which may damage
EEPROM/OTP sensitive data.

> 
> One idea might be to use the LAN743X_ETH_REG_VERSION as a
> bitfield. Bit 0 indicates the common registers are present. Bit 1
> indicates the SGMII registers are present. Bit 2 is for whatever next
> set of optional registers you add, say PTP.

OK. 
Otherwise, I will create LAN743X_ETH_REG_FLAGS and follow your
suggestion.

> 
>     Andrew

--------
Thanks,
Raju
