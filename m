Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCCA1C349A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgEDIhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:37:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:47080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgEDIhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 04:37:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 376E4AC7D;
        Mon,  4 May 2020 08:37:37 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 143EA604EE; Mon,  4 May 2020 10:37:34 +0200 (CEST)
Date:   Mon, 4 May 2020 10:37:34 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH v5 1/2] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200504083734.GA5989@lion.mk-sys.cz>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
 <20200504071214.5890-2-o.rempel@pengutronix.de>
 <20200504080417.i3d2jsjjpu2zjk4z@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504080417.i3d2jsjjpu2zjk4z@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:04:17AM +0200, Oleksij Rempel wrote:
> @Michal,
> 
> i noticed that linkmodes_fill_reply() some times get not enough
> tailroom.
> if data->peer_empty == 0
> linkmodes_reply_size() size: 476
> linkmodes_fill_reply() skb tailroom: 724
> 
> 
> if data->peer_empty == 1
> linkmodes_reply_size() size: 216                                      
> linkmodes_fill_reply() skb tailroom: 212
> 
> In the last case i won't be able to attach master_lave state and cfg
> fields.
> 
> It looks like this issue was not introduced by my patches. May be you
> have idea, what is missing?

It's my mistake, I'm just not sure why I never ran into this while
testing. Please try the patch below.

Michal

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 0c772318c023..ed5357210193 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -342,7 +342,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret;
+	reply_len = ret + ethnl_reply_header_size();
 	ret = -ENOMEM;
 	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
 				ops->hdr_attr, info, &reply_payload);
@@ -588,7 +588,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret;
+	reply_len = ret + ethnl_reply_header_size();
 	ret = -ENOMEM;
 	skb = genlmsg_new(reply_len, GFP_KERNEL);
 	if (!skb)
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 95eae5c68a52..0eed4e4909ab 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -324,7 +324,6 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 	int len = 0;
 	int ret;
 
-	len += ethnl_reply_header_size();
 	for (i = 0; i < ETH_SS_COUNT; i++) {
 		const struct strset_info *set_info = &data->sets[i];
 
