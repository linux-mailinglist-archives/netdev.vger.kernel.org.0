Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B69E56008C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiF2MuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiF2MuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:50:16 -0400
Received: from out28-73.mail.aliyun.com (out28-73.mail.aliyun.com [115.124.28.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C7C30F72;
        Wed, 29 Jun 2022 05:50:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07440299|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.460961-0.000591807-0.538448;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.OFWkWUa_1656506959;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.OFWkWUa_1656506959)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 20:49:33 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     yinghong.zhang@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>
Subject: Re: Re: [PATCH v2] net: phy: Add driver for Motorcomm yt8521 gigabit
Date:   Wed, 29 Jun 2022 20:48:48 +0800
Message-Id: <20220629124848.142-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.31.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
	Thanks for your comments.
	This driver is for an utp-fiber combo phy and sometimes, it has to
switch register spaces between utp and fiber for same operation. That is why it
looks that there are duplicated operations. 

> > + * yt8521_soft_reset() - called to issue a PHY software reset
> > + * @phydev: a pointer to a &struct phy_device
> > + *
> > + * returns 0 or negative errno code
> > + */
> > +int yt8521_soft_reset(struct phy_device *phydev)
> > +{
> > + int old_page;
> > + int ret = 0;
> > +
> > + old_page = phy_save_page(phydev);
> > + if (old_page < 0)
> > +  goto err_restore_page;
> > +
> > + ret = yt8521_modify_UTP_FIBER_BMCR(phydev, 0, BMCR_RESET);
> > + if (ret < 0)
> > +  goto err_restore_page;
> 
> You should wait for the reset to completed. Can you actually use the
> core helper? Is the BMCR in the usual place? So long as you hold the
> lock, nothing is going to change the page, so you should be able to
> use the helper.
> 

yes, you said it. we will add codes to check if the reset is completed at all.

> 
> > +int yt8521_config_aneg(struct phy_device *phydev)
> > +{
> > + struct yt8521_priv *priv = phydev->priv;
> > + u8 polling_mode = priv->polling_mode;
> > + int old_page;
> > + int ret;
> > +
> > + old_page = yt8521_read_page_with_lock(phydev);
> > + if (old_page)
> > +  return old_page;
> > +
> > + if (polling_mode == YT8521_MODE_FIBER ||
> > +     polling_mode == YT8521_MODE_POLL) {
> > +  ret = yt8521_write_page_with_lock(phydev,
> > +        YT8521_RSSR_FIBER_SPACE);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > +
> > +  ret = genphy_config_aneg(phydev);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > + }
> > +
> > + if (polling_mode == YT8521_MODE_UTP ||
> > +     polling_mode == YT8521_MODE_POLL) {
> > +  ret = yt8521_write_page_with_lock(phydev,
> > +        YT8521_RSSR_UTP_SPACE);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > +
> > +  ret = genphy_config_aneg(phydev);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > + }
> 
> Looks like this could be refactored to reduce duplication.
> 

sure, as the reason said above, the same operation is required in both utp and
fiber spaces.

> 
> > +int yt8521_aneg_done(struct phy_device *phydev)
> > +{
> > + struct yt8521_priv *priv = phydev->priv;
> > + u8 polling_mode = priv->polling_mode;
> > + int link_fiber = 0;
> > + int link_utp = 0;
> > + int old_page;
> > + int ret = 0;
> > +
> > + old_page = phy_save_page(phydev);
> > + if (old_page < 0)
> > +  goto err_restore_page;
> > +
> > + if (polling_mode == YT8521_MODE_FIBER ||
> > +     polling_mode == YT8521_MODE_POLL) {
> > +  /* switch to FIBER reg space*/
> > +  ret = yt8521_write_page(phydev, YT8521_RSSR_FIBER_SPACE);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > +
> > +  ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > +
> > +  link_fiber = !!(ret & YTPHY_SSR_LINK);
> > + }
> > +
> > + if (polling_mode == YT8521_MODE_UTP ||
> > +     polling_mode == YT8521_MODE_POLL) {
> > +  /* switch to UTP reg space */
> > +  ret = yt8521_write_page(phydev, YT8521_RSSR_UTP_SPACE);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > +
> > +  ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
> > +  if (ret < 0)
> > +   goto err_restore_page;
> > +
> > +  link_utp = !!(ret & YTPHY_SSR_LINK);
> > + }
> > +
> > + ret = !!(link_fiber | link_utp);
> 
> Does this mean it can do both copper and fibre at the same time. And
> whichever gives up first wins?

Sure, the phy supports utp, fiber, and both. In the case of both, this driver
supposes that fiber is of priority.

Thaks again and we will chnaged codes based on your comments.

Cheers and BR,
Frank

-- 
2.31.0.windows.1

