Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7908156014E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiF2NbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiF2NbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:31:22 -0400
Received: from out28-4.mail.aliyun.com (out28-4.mail.aliyun.com [115.124.28.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8D535DF1;
        Wed, 29 Jun 2022 06:31:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08042336|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.398995-0.00148957-0.599516;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.OFYoJ3Y_1656509443;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.OFYoJ3Y_1656509443)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 21:31:07 +0800
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
Date:   Wed, 29 Jun 2022 21:30:12 +0800
Message-Id: <20220629133012.1840-1-Frank.Sae@motor-comm.com>
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

The poll mode of yt8521 phy is not support utp and fiber at same time, In other
words, only utp or fiber can be connected at one time, and you can change to
fiber or utp at next time. so in poll mode need to do both ( utp and fiber )
operation

> > > > +int yt8521_config_aneg(struct phy_device *phydev)
> > > > +{
> > > > + struct yt8521_priv *priv = phydev->priv;
> > > > + u8 polling_mode = priv->polling_mode;
> > > > + int old_page;
> > > > + int ret;
> > > > +
> > > > + old_page = yt8521_read_page_with_lock(phydev);
> > > > + if (old_page)
> > > > +  return old_page;
> > > > +
> > > > + if (polling_mode == YT8521_MODE_FIBER ||
> > > > +     polling_mode == YT8521_MODE_POLL) {
> > > > +  ret = yt8521_write_page_with_lock(phydev,
> > > > +        YT8521_RSSR_FIBER_SPACE);
> > > > +  if (ret < 0)
> > > > +   goto err_restore_page;
> > > > +
> > > > +  ret = genphy_config_aneg(phydev);
> > > > +  if (ret < 0)
> > > > +   goto err_restore_page;
> > > > + }
> > > > +
> > > > + if (polling_mode == YT8521_MODE_UTP ||
> > > > +     polling_mode == YT8521_MODE_POLL) {
> > > > +  ret = yt8521_write_page_with_lock(phydev,
> > > > +        YT8521_RSSR_UTP_SPACE);
> > > > +  if (ret < 0)
> > > > +   goto err_restore_page;
> > > > +
> > > > +  ret = genphy_config_aneg(phydev);
> > > > +  if (ret < 0)
> > > > +   goto err_restore_page;
> > > > + }
> > >
> > > Looks like this could be refactored to reduce duplication.
> > >
> >
> > sure, as the reason said above, the same operation is required in both utp and
> > fiber spaces.
> 
> So you can probably pull the 'core' of this function out into a
> helper, and then call it either with YT8521_RSSR_UTP_SPACE or
> YT8521_RSSR_FIBER_SPACE.
> 
> > > > + ret = !!(link_fiber | link_utp);
> > >
> > > Does this mean it can do both copper and fibre at the same time. And
> > > whichever gives up first wins?
> >
> > Sure, the phy supports utp, fiber, and both. In the case of both, this driver
> > supposes that fiber is of priority.
> 
> It is generally not that simple. Fibre, you probably want 1000BaseX,
> unless the fibre module is actually copper, and then you want
> SGMII. So you need something to talk to the fibre module and ask it
> what it is. That something is phylink. Phylink does not support both
> copper and fibre at the same time for one MAC.

Cheers and BR,
Frank

-- 
2.31.0.windows.1

