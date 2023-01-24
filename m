Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79DE6790F5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjAXGbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjAXGbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:31:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DFD3D091;
        Mon, 23 Jan 2023 22:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4CA5B810C5;
        Tue, 24 Jan 2023 06:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5CCC433D2;
        Tue, 24 Jan 2023 06:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674541835;
        bh=+nylqb23RsekYjZaEz4YjxAk0FDyNRQBbyNOuKbKgkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iHzKRBEW+L96YHB0cE5ZKxJoxyTaXoOYsaAHeOxxg3HCttaDxKZXEXZMj5BPsf9FP
         6KBlxQ1ejkOCyDITJkcmIbzffn5W6Zy5/LtSFFgOmdsz/r3Q5O9X8OenFdU4PTTl+2
         Rq1mmRaxHGGQaBci9APpWXvnErolw0IKvYS4bhlQArMRKyLFqHb3XtCxsNuYRrKTJH
         nznEAb6dw10L4SDFKdwJ9sPphnXbYLvxFwSq6V/FAIE5am/no+K3hpNEWcexfbkn+Q
         klHvhBak8LiOf0AryX8HKUSH8PRI7neHb6E8TMMgMb6sm7z04+/1yTLp/LXjV/8Y7c
         fENEWqYsMqN7w==
Date:   Mon, 23 Jan 2023 22:30:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v4 net-next 04/12] net: ethtool: netlink: retrieve stats
 from multiple sources (eMAC, pMAC)
Message-ID: <20230123223033.3ad37ccc@kernel.org>
In-Reply-To: <CANn89i+-Vp3Za=T8kgU6o_RuQHoT7sC=-i_EZCHcsUoJKqeG9g@mail.gmail.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
        <20230119122705.73054-5-vladimir.oltean@nxp.com>
        <CANn89i+-Vp3Za=T8kgU6o_RuQHoT7sC=-i_EZCHcsUoJKqeG9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 07:20:20 +0100 Eric Dumazet wrote:
> >  static int pause_prepare_data(const struct ethnl_req_info *req_base,
> >                               struct ethnl_reply_data *reply_base,
> >                               struct genl_info *info)
> >  {
> > +       const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
> >         struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
> > +       enum ethtool_mac_stats_src src = req_info->src;
> > +       struct netlink_ext_ack *extack = info->extack;  
> 
> info can be NULL when called from ethnl_default_dump_one()

Second time in a month, I think..

Should we make a fake info to pass here? (until someone finds the time 
to combine the do/dump infos more thoroughly, at least)
