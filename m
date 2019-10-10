Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC6D318C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfJJToC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:44:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:43698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbfJJToC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 15:44:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36BD2AD54;
        Thu, 10 Oct 2019 19:30:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C62E6E378C; Thu, 10 Oct 2019 21:30:44 +0200 (CEST)
Date:   Thu, 10 Oct 2019 21:30:44 +0200
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
Subject: Re: [PATCH net-next v7 14/17] ethtool: set link settings with
 LINKINFO_SET request
Message-ID: <20191010193044.GG22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
 <20191010153754.GA2901@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010153754.GA2901@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 05:37:54PM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 10:59:43PM CEST, mkubecek@suse.cz wrote:
> >Implement LINKINFO_SET netlink request to set link settings queried by
> >LINKINFO_GET message.
> >
> >Only physical port, phy MDIO address and MDI(-X) control can be set,
> >attempt to modify MDI(-X) status and transceiver is rejected.
> >
> >When any data is modified, ETHTOOL_MSG_LINKINFO_NTF message in the same
> >format as reply to LINKINFO_GET request is sent to notify userspace about
> >the changes. The same notification is also sent when these settings are
> >modified using the ioctl interface.
> >
> 
> It is a bit confusing and harder to follow when you have set and notify
> code in the same patch. Could you please split?

As the notification is composed and sent by ethnl_std_notify() with help
of the callback functions used to generate the reply to GET request, the
only notification related changes in this patch are the three calls to
ethtool_notify() (one in netlink code, two in ioctl code) and the entry
added to ethnl_notify_handlers[].

But I have no objection to splitting these out into a separate patch,
except for having sacrifice some of the patches actually implementing
something so that the series doesn't get too long.

> 
> [...]
> 
> 
> >+/* LINKINFO_SET */
> >+
> >+static const struct nla_policy linkinfo_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
> >+	[ETHTOOL_A_HEADER_UNSPEC]		= { .type = NLA_REJECT },
> >+	[ETHTOOL_A_HEADER_DEV_INDEX]		= { .type = NLA_U32 },
> >+	[ETHTOOL_A_HEADER_DEV_NAME]		= { .type = NLA_NUL_STRING,
> >+						    .len = IFNAMSIZ - 1 },
> >+	[ETHTOOL_A_HEADER_GFLAGS]		= { .type = NLA_U32 },
> >+	[ETHTOOL_A_HEADER_RFLAGS]		= { .type = NLA_REJECT },
> >+};
> 
> This is what I was talking about in the other email. These common attrs
> should have common policy and should be parsed by generic netlink code
> by default and be available for ethnl_set_linkinfo() in info->attrs.

NLA_REJECT for ETHTOOL_A_HEADER_RFLAGS is probably an overkill here. If
I just check that client does not set flags we do not know, I can have
one universal header policy as well. I'll probably do that.

> >+int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
> >+{
> >+	struct nlattr *tb[ETHTOOL_A_LINKINFO_MAX + 1];
> >+	struct ethtool_link_ksettings ksettings = {};
> >+	struct ethtool_link_settings *lsettings;
> >+	struct ethnl_req_info req_info = {};
> >+	struct net_device *dev;
> >+	bool mod = false;
> >+	int ret;
> >+
> >+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
> >+			  ETHTOOL_A_LINKINFO_MAX, linkinfo_set_policy,
> >+			  info->extack);
> 
> Yeah, genl code should do this parse..

Not really. It would only parse the top level - which, in your design,
would only be the common header. In other words, it would do what is now
done by the call to nla_parse_nested() inside ethnl_parse_header(). For
equivalent of this parse, you would still have to call your own
nla_parse_nested() on the "request specific data" nested attribute.

> >+	if (ret < 0)
> >+		return ret;
> >+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_LINKINFO_HEADER],
> >+				 genl_info_net(info), info->extack,
> >+				 linkinfo_hdr_policy, true);
> 
> and pre_doit should do this one.

...and also (each) start(). Which means you would either duplicate the
code or introduce the same helper. All you would save would be that one
call of nla_parse_nested() in ethnl_parse_header().

> >+
> >+	ret = 0;
> >+	if (mod) {
> 
> 	if (!mod)
> 		goto out_ops;
> 
> ?

OK

> >+		ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
> >+		if (ret < 0)
> >+			GENL_SET_ERR_MSG(info, "link settings update failed");
> >+		else
> >+			ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
> >+	}
> >+
> >+out_ops:
> >+	ethnl_after_ops(dev);
> >+out_rtnl:
> >+	rtnl_unlock();
> >+	dev_put(dev);
> >+	return ret;
> >+}
...
> >@@ -683,6 +688,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
> > 				       const void *data);
> > 
> > static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
> >+	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_std_notify,
> 
> Correct me if I'm wrong, but this is the only notification I found in
> this patchset. Do you expect other then ethnl_std_notify() handler?
> Bacause otherwise this can ba simplified down to just a single table
> similar you have for GET.

Yes, there will be other handlers; ethnl_std_notify() can only handle
the simplest (even if most common) type of notification where caller
does not pass any information except the device, the notification
message is exactly the same as reply to corresponding GET request would
be and that GET request does not have any attributes (so that it can be
handled with ethnl_get_doit()).

There will be notifications which will need their own handlers, e.g. all
notifications triggered by an action request (e.g. renegotiation or
device reset) or notifications triggered by "ethtool -X".

Michal
