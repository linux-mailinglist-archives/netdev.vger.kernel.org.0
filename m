Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D17D1AF5C0
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgDRWzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:55:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A24C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:55:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90E8A1277F96C;
        Sat, 18 Apr 2020 15:55:32 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:55:32 -0700 (PDT)
Message-Id: <20200418.155532.274453802309324339.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net-next] enetc: permit configuration of rx-vlan-filter
 with ethtool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417190755.1394-1-olteanv@gmail.com>
References: <20200417190755.1394-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:55:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 17 Apr 2020 22:07:55 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Each ENETC station interface (SI) has a VLAN filter list and a port
> flag (PSIPVMR) by which it can be put in "VLAN promiscuous" mode, which
> enables the reception of VLAN-tagged traffic even if it is not in the
> VLAN filtering list.
> 
> Currently the handling of this setting works like this: the port starts
> off as VLAN promiscuous, then it switches to enabling VLAN filtering as
> soon as the first VLAN is installed in its filter via
> .ndo_vlan_rx_add_vid. In practice that does not work out very well,
> because more often than not, the first VLAN to be installed is out of
> the control of the user: the 8021q module, if loaded, adds its rule for
> 802.1p (VID 0) traffic upon bringing the interface up.
> 
> What the user is currently seeing in ethtool is this:
> ethtool -k eno2
> rx-vlan-filter: on [fixed]
> 
> which doesn't match the intention of the code, but the practical reality
> of having the 8021q module install its VID which has the side-effect of
> turning on VLAN filtering in this driver. All in all, a slightly
> confusing experience.
> 
> So instead of letting this driver switch the VLAN filtering state by
> itself, just wire it up with the rx-vlan-filter feature from ethtool,
> and let it be user-configurable just through that knob, except for one
> case, see below.
> 
> In promiscuous mode, it is more intuitive that all traffic is received,
> including VLAN tagged traffic. It appears that it is necessary to set
> the flag in PSIPVMR for that to be the case, so VLAN promiscuous mode is
> also temporarily enabled. On exit from promiscuous mode, the setting
> made by ethtool is restored.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
