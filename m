Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504F3270967
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISAUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgISAUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:20:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4D0C0613CE;
        Fri, 18 Sep 2020 17:20:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E58A615B21D28;
        Fri, 18 Sep 2020 17:03:41 -0700 (PDT)
Date:   Fri, 18 Sep 2020 17:20:25 -0700 (PDT)
Message-Id: <20200918.172025.962077344132523092.davem@davemloft.net>
To:     hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Subject: Re: [PATCH v6 0/3] Add 802.1AD protocol support for dsa switch and
 ocelot driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916094845.10782-1-hongbo.wang@nxp.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 17:03:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hongbo.wang@nxp.com
Date: Wed, 16 Sep 2020 17:48:42 +0800

> 1. Overview 
> a) 0001* is for support to set dsa slave into 802.1AD(QinQ) mode.
> b) 0002* is for vlan_proto support for br_switchdev_port_vlan_add and br_switchdev_port_vlan_del.
> c) 0003* is for setting QinQ related registers in ocelot switch driver, after applying this patch, the switch(VSC99599)'s port can enable or disable QinQ mode.

You're going to have to update every single SWITCHDEV_PORT_ADD_OBJ handler
and subsequent helpers to check the validate the protocol value.

You also are going to have to make sure that every instantiated
switchdev_obj_port_vlan object initializes the vlan protocol field
properly.

Basically, now that this structure has a new member, everything that
operates on that object must be updated to handle the new protocol
value.

And I do mean everything.

You can't just add the protocol handling to the locations you care
about for bridging and DSA.

You also have to more fully address the feedback given by Vladimir
in patch #3.  Are the expectations on the user side a Linux based
expectation, or one specific about how this ASIC is expected to
behave by default.  It is very unclear what you are talking about
when you say customer and ISP etc.

Thanks.
