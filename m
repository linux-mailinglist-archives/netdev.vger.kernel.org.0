Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A7A5E644
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfGCOQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:16:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:38702 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726217AbfGCOQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:16:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 22072AF2C;
        Wed,  3 Jul 2019 14:16:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E765CE0159; Wed,  3 Jul 2019 16:16:14 +0200 (CEST)
Date:   Wed, 3 Jul 2019 16:16:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 07/15] ethtool: support for netlink
 notifications
Message-ID: <20190703141614.GL20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
 <20190703133352.GY2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703133352.GY2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 03:33:52PM +0200, Jiri Pirko wrote:
> >+/* notifications */
> >+
> >+typedef void (*ethnl_notify_handler_t)(struct net_device *dev,
> >+				       struct netlink_ext_ack *extack,
> >+				       unsigned int cmd, u32 req_mask,
> >+				       const void *data);
> >+
> >+static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
> >+};
> >+
> >+void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
> >+		    unsigned int cmd, u32 req_mask, const void *data)
> 
> What's "req_mask" ?

It's infomask to interpret the same way as if it came from request
header (the notification triggered by a SET request or its ioctl
equivalent uses the same format as corresponding GET_REPLY message and
is created by the same code). But it could be called infomask, I have no
strong opinion about that.

> >+{
> >+	if (unlikely(!ethnl_ok))
> >+		return;
> >+	ASSERT_RTNL();
> >+
> >+	if (likely(cmd < ARRAY_SIZE(ethnl_notify_handlers) &&
> >+		   ethnl_notify_handlers[cmd]))
> 
> How it could be null?

Notification message types share the enum with other kernel messages:

/* message types - kernel to userspace */
enum {
	ETHTOOL_MSG_KERNEL_NONE,
	ETHTOOL_MSG_STRSET_GET_REPLY,
	ETHTOOL_MSG_SETTINGS_GET_REPLY,
	ETHTOOL_MSG_SETTINGS_NTF,
	ETHTOOL_MSG_SETTINGS_SET_REPLY,
	ETHTOOL_MSG_INFO_GET_REPLY,
	ETHTOOL_MSG_PARAMS_GET_REPLY,
	ETHTOOL_MSG_PARAMS_NTF,
	ETHTOOL_MSG_NWAYRST_NTF,
	ETHTOOL_MSG_PHYSID_NTF,
	ETHTOOL_MSG_RESET_NTF,
	ETHTOOL_MSG_RESET_ACT_REPLY,
	ETHTOOL_MSG_RXFLOW_GET_REPLY,
	ETHTOOL_MSG_RXFLOW_NTF,
	ETHTOOL_MSG_RXFLOW_SET_REPLY,

	/* add new constants above here */
	__ETHTOOL_MSG_KERNEL_CNT,
	ETHTOOL_MSG_KERNEL_MAX = (__ETHTOOL_MSG_KERNEL_CNT - 1)
};

Only entries for *_NTF types are non-null in ethnl_notify_handlers[]:

static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
	[ETHTOOL_MSG_SETTINGS_NTF]	= ethnl_std_notify,
	[ETHTOOL_MSG_PARAMS_NTF]	= ethnl_std_notify,
	[ETHTOOL_MSG_NWAYRST_NTF]	= ethnl_nwayrst_notify,
	[ETHTOOL_MSG_PHYSID_NTF]	= ethnl_physid_notify,
	[ETHTOOL_MSG_RESET_NTF]		= ethnl_reset_notify,
	[ETHTOOL_MSG_RXFLOW_NTF]	= ethnl_rxflow_notify,
};

If the check above fails, it means that kernel code tried to send
a notification with type which does not exist or is not a notification,
i.e. a bug in kernel; that's why the WARN_ONCE.

Michal

> >+		ethnl_notify_handlers[cmd](dev, extack, cmd, req_mask, data);
> >+	else
> >+		WARN_ONCE(1, "notification %u not implemented (dev=%s, req_mask=0x%x)\n",
> >+			  cmd, netdev_name(dev), req_mask);
> >+}
> >+EXPORT_SYMBOL(ethtool_notify);
