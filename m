Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209425D451
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfGBQem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:34:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:50740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfGBQel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 12:34:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6524B94B;
        Tue,  2 Jul 2019 16:34:39 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D57E4E0159; Tue,  2 Jul 2019 18:34:37 +0200 (CEST)
Date:   Tue, 2 Jul 2019 18:34:37 +0200
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
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190702163437.GE20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
 <20190702130515.GO2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702130515.GO2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 03:05:15PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 01:50:04PM CEST, mkubecek@suse.cz wrote:
> > 
> >+/* request header */
> >+
> >+/* use compact bitsets in reply */
> >+#define ETHTOOL_RF_COMPACT		(1 << 0)
> 
> "COMPACT_BITSETS"?
> 
> >+/* provide optional reply for SET or ACT requests */
> >+#define ETHTOOL_RF_REPLY		(1 << 1)
> 
> "OPTIONAL_REPLY"?

OK

> >+	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, nest,
> >+			       policy ?: dflt_header_policy, extack);
> >+	if (ret < 0)
> 
> if (ret)
> 
> Same remark goes to the rest of the code (also the rest of the patches),
> in case called function cannot return positive values.

The "if (ret < 0)" idiom for "on error do ..." is so ubiquitous through
the whole kernel that I don't think it's worth it to carefully check
which function can return a positive value and which cannot and risk
that one day I overlook that some function. And yet another question is
what exactly "cannot return" means: is it whenever the function does not
return a positive value or only if it's explicitly documented not to?

Looking at existing networking code, e.g. net/netfilter (except ipvs),
net/sched or net/core/rtnetlink.c are using "if (ret < 0)" rather
uniformly. And (as you objected to the check of genl_register_family()
previous patch) even genetlink itself has

	err = genl_register_family(&genl_ctrl);
	if (err < 0)
		goto problem;

in genl_init().

> 
> 
> >+		return ret;
> >+	devname_attr = tb[ETHTOOL_A_HEADER_DEV_NAME];
> >+
> >+	if (tb[ETHTOOL_A_HEADER_DEV_INDEX]) {
> >+		u32 ifindex = nla_get_u32(tb[ETHTOOL_A_HEADER_DEV_INDEX]);
> >+
> >+		dev = dev_get_by_index(net, ifindex);
> >+		if (!dev) {
> >+			NL_SET_ERR_MSG_ATTR(extack,
> >+					    tb[ETHTOOL_A_HEADER_DEV_INDEX],
> >+					    "no device matches ifindex");
> >+			return -ENODEV;
> >+		}
> >+		/* if both ifindex and ifname are passed, they must match */
> >+		if (devname_attr &&
> >+		    strncmp(dev->name, nla_data(devname_attr), IFNAMSIZ)) {
> >+			dev_put(dev);
> >+			NL_SET_ERR_MSG_ATTR(extack, nest,
> >+					    "ifindex and name do not match");
> >+			return -ENODEV;
> >+		}
> >+	} else if (devname_attr) {
> >+		dev = dev_get_by_name(net, nla_data(devname_attr));
> >+		if (!dev) {
> >+			NL_SET_ERR_MSG_ATTR(extack, devname_attr,
> >+					    "no device matches name");
> >+			return -ENODEV;
> >+		}
> >+	} else if (require_dev) {
> >+		NL_SET_ERR_MSG_ATTR(extack, nest,
> >+				    "neither ifindex nor name specified");
> >+		return -EINVAL;
> >+	}
> >+
> >+	if (dev && !netif_device_present(dev)) {
> >+		dev_put(dev);
> >+		NL_SET_ERR_MSG(extack, "device not present");
> >+		return -ENODEV;
> >+	}
> >+
> >+	req_info->dev = dev;
> >+	ethnl_update_u32(&req_info->req_mask, tb[ETHTOOL_A_HEADER_INFOMASK]);
> >+	ethnl_update_u32(&req_info->global_flags, tb[ETHTOOL_A_HEADER_GFLAGS]);
> >+	ethnl_update_u32(&req_info->req_flags, tb[ETHTOOL_A_HEADER_RFLAGS]);
> 
> Just:
> 	req_info->req_mask = nla_get_u32(tb[ETHTOOL_A_HEADER_INFOMASK];
> 	...
> 
> Not sure what ethnl_update_u32() is good for, but it is not needed here.

That would result in null pointer dereference if the attribute is
missing. So you would need at least

	if (tb[ETHTOOL_A_HEADER_INFOMASK])
		req_info->req_mask = nla_get_u32(tb[ETHTOOL_A_HEADER_INFOMASK]);
	if (tb[ETHTOOL_A_HEADER_GFLAGS])
		req_info->global_flags =
			nla_get_u32(tb[ETHTOOL_A_HEADER_GFLAGS]);
	if (tb[ETHTOOL_A_HEADER_RFLAGS])
		req_info->req_flags = nla_get_u32(tb[ETHTOOL_A_HEADER_RFLAGS]);

I don't think it looks better.

> >+
> >+	return 0;
> >+}
> >+
> >+/**
> >+ * ethnl_fill_reply_header() - Put standard header into a reply message
> >+ * @skb:      skb with the message
> >+ * @dev:      network device to describe in header
> >+ * @attrtype: attribute type to use for the nest
> >+ *
> >+ * Create a nested attribute with attributes describing given network device.
> >+ * Clean up on error.
> 
> Cleanup is obvious, no need to mention it in API docs.

OK

> >+ *
> >+ * Return: 0 on success, error value (-EMSGSIZE only) on error
> >+ */
> >+int ethnl_fill_reply_header(struct sk_buff *skb, struct net_device *dev,
> >+			    u16 attrtype)
> >+{
> >+	struct nlattr *nest;
> >+
> >+	if (!dev)
> >+		return 0;
> >+	nest = nla_nest_start(skb, attrtype);
> >+	if (!nest)
> >+		return -EMSGSIZE;
> >+
> >+	if (nla_put_u32(skb, ETHTOOL_A_HEADER_DEV_INDEX, (u32)dev->ifindex) ||
> >+	    nla_put_string(skb, ETHTOOL_A_HEADER_DEV_NAME, dev->name))
> >+		goto nla_put_failure;
> >+	/* If more attributes are put into reply header, ethnl_header_size()
> >+	 * must be updated to account for them.
> >+	 */
> >+
> >+	nla_nest_end(skb, nest);
> >+	return 0;
> >+
> >+nla_put_failure:
> >+	nla_nest_cancel(skb, nest);
> >+	return -EMSGSIZE;
> >+}
> >+
> >+/**
> >+ * ethnl_reply_init() - Create skb for a reply and fill device identification
> >+ * @payload: payload length (without netlink and genetlink header)
> >+ * @dev:     device the reply is about (may be null)
> >+ * @cmd:     ETHTOOL_MSG_* message type for reply
> >+ * @info:    genetlink info of the received packet we respond to
> >+ * @ehdrp:   place to store payload pointer returned by genlmsg_new()
> >+ *
> >+ * Return: pointer to allocated skb on success, NULL on error
> >+ */
> >+struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
> >+				 u16 hdr_attrtype, struct genl_info *info,
> >+				 void **ehdrp)
> >+{
> >+	struct sk_buff *skb;
> >+
> >+	skb = genlmsg_new(payload, GFP_KERNEL);
> >+	if (!skb)
> >+		goto err;
> >+	*ehdrp = genlmsg_put_reply(skb, info, &ethtool_genl_family, 0, cmd);
> >+	if (!*ehdrp)
> >+		goto err_free;
> >+
> >+	if (dev) {
> >+		int ret;
> >+
> >+		ret = ethnl_fill_reply_header(skb, dev, hdr_attrtype);
> >+		if (ret < 0)
> >+			goto err;
> >+	}
> >+	return skb;
> >+
> >+err_free:
> >+	nlmsg_free(skb);
> >+	if (info)
> >+		GENL_SET_ERR_MSG(info, "failed to setup reply message");
> >+err:
> 
> Why also not fillup extack msg here?

Right, err label should be right below the nlmsg_free(skb), thanks. And
now I noticed another mistake: on ethnl_fill_reply_header() failure, we
should go to err_free, not err.

> >+static inline int ethnl_str_size(const char *s)
> 
> If you really need this helper, put it into netlink code. There's nothing
> ethtool-specific about this.

OK, I'll look into it. I've been already thinking about some kind of
NLA_SIZEOF() macro as about 1/3 of all uses of nla_total_size() follow
the nla_total_size(sizeof(...)) pattern (and lot more should follow it
but are written like e.g. nla_total_size(4) instead). This is another
common pattern.

> >+/* The ethnl_update_* helpers set value pointed to by @dst to the value of
> >+ * netlink attribute @attr (if attr is not null). They return true if *dst
> >+ * value was changed, false if not.
> >+ */
> >+static inline bool ethnl_update_u32(u32 *dst, struct nlattr *attr)
> 
> I'm still not sure I'm convinced about these "update helpers" :)

Just imagine what would e.g.

	if (ethnl_update_u32(&data.rx_pending, tb[ETHTOOL_A_RING_RX_PENDING]))
		mod = true;
	if (ethnl_update_u32(&data.rx_mini_pending,
			     tb[ETHTOOL_A_RING_RX_MINI_PENDING]))
		mod = true;
	if (ethnl_update_u32(&data.rx_jumbo_pending,
			     tb[ETHTOOL_A_RING_RX_JUMBO_PENDING]))
		mod = true;
	if (ethnl_update_u32(&data.tx_pending, tb[ETHTOOL_A_RING_TX_PENDING]))
		mod = true;
	if (!mod)
		return 0;

look like without them. And coalescing parameters would be much worse
(22 attributes / struct members).

> >+{
> >+	u32 val;
> >+
> >+	if (!attr)
> >+		return false;
> >+	val = nla_get_u32(attr);
> >+	if (*dst == val)
> >+		return false;
> >+
> >+	*dst = val;
> >+	return true;
> >+}
...
> >+static inline bool ethnl_update_binary(u8 *dst, unsigned int len,
> 
> void *dst

OK.

> >+/**
> >+ * ethnl_is_privileged() - check if request has sufficient privileges
> >+ * @skb: skb with client request
> >+ *
> >+ * Checks if client request has CAP_NET_ADMIN in its netns. Unlike the flags
> >+ * in genl_ops, this allows finer access control, e.g. allowing or denying
> >+ * the request based on its contents or witholding only part of the data
> >+ * from unprivileged users.
> >+ *
> >+ * Return: true if request is privileged, false if not
> >+ */
> >+static inline bool ethnl_is_privileged(struct sk_buff *skb)
> 
> I wonder why you need this helper. Genetlink uses
> ops->flags & GENL_ADMIN_PERM for this. 

It's explained in the function description. Sometimes we need finer
control than by request message type. An example is the WoL password:
ETHTOOL_GWOL is privileged because of it but I believe there si no
reason why unprivileged user couldn't see enabled WoL modes, we can
simply omit the password for him. (Also, it allows to combine query for
WoL settings with other unprivileged settings.)

> >+/**
> >+ * ethnl_reply_header_size() - total size of reply header
> >+ *
> >+ * This is an upper estimate so that we do not need to hold RTNL lock longer
> >+ * than necessary (to prevent rename between size estimate and composing the
> 
> I guess this description is not relevant anymore. I don't see why to
> hold rtnl mutex for this function...

You don't need it for this function, it's the other way around: unless
you hold RTNL lock for the whole time covering both checking needed
message size and filling the message - and we don't - the device could
be renamed in between. Thus if we returned size based on current device
name, it might not be sufficient at the time the header is filled.
That's why this function returns maximum possible size (which is
actually a constant).

Michal

> >+ * message). Accounts only for device ifindex and name as those are the only
> >+ * attributes ethnl_fill_reply_header() puts into the reply header.
> >+ */
> >+static inline unsigned int ethnl_reply_header_size(void)
> >+{
> >+	return nla_total_size(nla_total_size(sizeof(u32)) +
> >+			      nla_total_size(IFNAMSIZ));
> >+}
