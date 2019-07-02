Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406055CED2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfGBLu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:38958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfGBLu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5C8BB134;
        Tue,  2 Jul 2019 11:50:24 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4E25DE0159; Tue,  2 Jul 2019 13:50:24 +0200 (CEST)
Message-Id: <4faa0ce52dfe02c9cde5a46012b16c9af6764c5e.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 09/15] ethtool: generic handlers for GET requests
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:24 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Significant part of GET request processing is common for most request
types but unfortunately it cannot be easily separated from type specific
code as we need to alternate between common actions (parsing common request
header, allocating message and filling netlink/genetlink headers etc.) and
specific actions (querying the device, composing the reply). The processing
also happens in three different situations: "do" request, "dump" request
and notification, each doing things in slightly different way.

The request specific code is implemented in four or five callbacks defined
in an instance of struct get_request_ops:

  parse_request() - parse incoming message
  prepare_data()  - retrieve data from driver or NIC
  reply_size()    - estimate reply message size
  fill_reply()    - compose reply message
  cleanup()       - (optional) clean up additional data

Other members of struct get_request_ops describe the data structure holding
information from client request and data used to compose the message. The
standard handlers ethnl_get_doit(), ethnl_get_dumpit(), ethnl_get_start()
and ethnl_get_done() can be then used in genl_ops handler. Notification
handler will be introduced in a later patch.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/netlink.c | 337 ++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/netlink.h | 128 ++++++++++++++++
 2 files changed, 465 insertions(+)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index a7a0bfe1818c..6d326cc25aac 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -178,6 +178,343 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 	return NULL;
 }
 
+/* GET request helpers */
+
+/**
+ * struct ethnl_dump_ctx - context structure for generic dumpit() callback
+ * @ops:      request ops of currently processed message type
+ * @req_info: parsed request header of processed request
+ * @pos_hash: saved iteration position - hashbucket
+ * @pos_idx:  saved iteration position - index
+ *
+ * These parameters are kept in struct netlink_callback as context preserved
+ * between iterations. They are initialized by ethnl_get_start() and used in
+ * ethnl_get_dumpit() and ethnl_get_done().
+ */
+struct ethnl_dump_ctx {
+	const struct get_request_ops	*ops;
+	struct ethnl_req_info		*req_info;
+	int				pos_hash;
+	int				pos_idx;
+};
+
+static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {
+};
+
+static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
+{
+	return (struct ethnl_dump_ctx *)cb->ctx;
+}
+
+/**
+ * ethnl_alloc_get_data() - Allocate and initialize data for a GET request
+ * @ops: instance of struct get_request_ops describing size and layout
+ *
+ * This initializes only the first part (req_info), second part (reply_data)
+ * is initialized before filling the reply data into it (which is done for
+ * each iteration in dump requests).
+ *
+ * Return: pointer to allocated and initialized data, NULL on error
+ */
+static struct ethnl_req_info *
+ethnl_alloc_get_data(const struct get_request_ops *ops)
+{
+	struct ethnl_req_info *req_info;
+
+	req_info = kmalloc(ops->data_size, GFP_KERNEL);
+	if (!req_info)
+		return NULL;
+
+	memset(req_info, '\0', ops->repdata_offset);
+	req_info->reply_data =
+		(struct ethnl_reply_data *)((char *)req_info +
+					    ops->repdata_offset);
+
+	return req_info;
+}
+
+/**
+ * ethnl_free_get_data() - free GET request data
+ * @ops: instance of struct get_request_ops describing the layout
+ * @req_info: pointer to embedded struct ethnl_req_info (at offset 0)
+ *
+ * Calls ->cleanup() handler if defined and frees the data block.
+ */
+static void ethnl_free_get_data(const struct get_request_ops *ops,
+				struct ethnl_req_info *req_info)
+{
+	if (ops->cleanup)
+		ops->cleanup(req_info);
+	kfree(req_info);
+}
+
+/**
+ * ethnl_std_parse() - Parse request message
+ * @req_info:    pointer to structure to put data into
+ * @nlhdr:       pointer to request message header
+ * @net:         request netns
+ * @request_ops: struct request_ops for request type
+ * @extack:      netlink extack for error reporting
+ * @require_dev: fail if no device identiified in header
+ *
+ * Parse universal request header and call request specific ->parse_request()
+ * callback (if defined) to parse the rest of the message.
+ *
+ * Return: 0 on success or negative error code
+ */
+static int ethnl_std_parse(struct ethnl_req_info *req_info,
+			   const struct nlmsghdr *nlhdr, struct net *net,
+			   const struct get_request_ops *request_ops,
+			   struct netlink_ext_ack *extack, bool require_dev)
+{
+	struct nlattr **tb;
+	int ret;
+
+	tb = kmalloc_array(request_ops->max_attr + 1, sizeof(tb[0]),
+			   GFP_KERNEL);
+	if (!tb)
+		return -ENOMEM;
+
+	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, request_ops->max_attr,
+			  request_ops->request_policy, extack);
+	if (ret < 0)
+		goto out;
+	ret = ethnl_parse_header(req_info, tb[request_ops->hdr_attr], net,
+				 extack, request_ops->header_policy,
+				 require_dev);
+	if (ret < 0)
+		goto out;
+
+	if (request_ops->parse_request) {
+		ret = request_ops->parse_request(req_info, tb, extack);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (req_info->req_mask == 0)
+		req_info->req_mask = request_ops->default_infomask;
+	if (req_info->req_flags & ~request_ops->all_reqflags) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_HEADER_RFLAGS],
+				    "unsupported request specific flags");
+		goto out;
+	}
+
+	ret = 0;
+out:
+	kfree(tb);
+	return ret;
+}
+
+/**
+ * ethnl_init_reply_data() - Initialize reply data for GET request
+ * @req_info: pointer to embedded struct ethnl_req_info
+ * @ops:      instance of struct get_request_ops describing the layout
+ * @dev:      network device to initialize the reply for
+ *
+ * Fills the reply data part with zeros and sets the dev member. Must be called
+ * before calling the ->fill_reply() callback (for each iteration when handling
+ * dump requests).
+ */
+static void ethnl_init_reply_data(const struct ethnl_req_info *req_info,
+				  const struct get_request_ops *ops,
+				  struct net_device *dev)
+{
+	memset(req_info->reply_data, '\0',
+	       ops->data_size - ops->repdata_offset);
+	req_info->reply_data->dev = dev;
+}
+
+/* generic ->doit() handler for GET type requests */
+static int ethnl_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	const u8 cmd = info->genlhdr->cmd;
+	const struct get_request_ops *ops;
+	struct ethnl_req_info *req_info;
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len;
+	int ret;
+
+	ops = get_requests[cmd];
+	if (WARN_ONCE(!ops, "cmd %u has no get_request_ops\n", cmd))
+		return -EOPNOTSUPP;
+	req_info = ethnl_alloc_get_data(ops);
+	if (!req_info)
+		return -ENOMEM;
+	ret = ethnl_std_parse(req_info, info->nlhdr, genl_info_net(info), ops,
+			      info->extack, !ops->allow_nodev_do);
+	if (ret < 0)
+		goto err_dev;
+	req_info->privileged = ethnl_is_privileged(skb);
+	ethnl_init_reply_data(req_info, ops, req_info->dev);
+
+	rtnl_lock();
+	ret = ops->prepare_data(req_info, info);
+	if (ret < 0)
+		goto err_rtnl;
+	reply_len = ops->reply_size(req_info);
+	if (ret < 0)
+		goto err_cleanup;
+	ret = -ENOMEM;
+	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
+				ops->hdr_attr, info, &reply_payload);
+	if (!rskb)
+		goto err_cleanup;
+	ret = ops->fill_reply(rskb, req_info);
+	if (ret < 0)
+		goto err_msg;
+	rtnl_unlock();
+
+	genlmsg_end(rskb, reply_payload);
+	if (req_info->dev)
+		dev_put(req_info->dev);
+	ethnl_free_get_data(ops, req_info);
+	return genlmsg_reply(rskb, info);
+
+err_msg:
+	WARN_ONCE(ret == -EMSGSIZE,
+		  "calculated message payload length (%d) not sufficient\n",
+		  reply_len);
+	nlmsg_free(rskb);
+err_cleanup:
+	ethnl_free_get_data(ops, req_info);
+err_rtnl:
+	rtnl_unlock();
+err_dev:
+	if (req_info->dev)
+		dev_put(req_info->dev);
+	return ret;
+}
+
+static int ethnl_get_dump_one(struct sk_buff *skb,
+			      struct net_device *dev,
+			      const struct get_request_ops *ops,
+			      struct ethnl_req_info *req_info)
+{
+	int ret;
+
+	ethnl_init_reply_data(req_info, ops, dev);
+	rtnl_lock();
+	ret = ops->prepare_data(req_info, NULL);
+	if (ret < 0)
+		goto out;
+	ret = ethnl_fill_reply_header(skb, dev, ops->hdr_attr);
+	if (ret < 0)
+		goto out_cleanup;
+	ret = ops->fill_reply(skb, req_info);
+
+out_cleanup:
+	if (ops->cleanup)
+		ops->cleanup(req_info);
+out:
+	rtnl_unlock();
+	req_info->reply_data->dev = NULL;
+	return ret;
+}
+
+/* generic ->dumpit() handler for GET requests; device iteration copied from
+ * rtnl_dump_ifinfo()
+ */
+static int ethnl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
+	struct ethnl_req_info *req_info = ctx->req_info;
+	const struct get_request_ops *ops = ctx->ops;
+	struct net *net = sock_net(skb->sk);
+	int s_idx = ctx->pos_idx;
+	struct hlist_head *head;
+	struct net_device *dev;
+	int h, idx = 0;
+	int ret = 0;
+	void *ehdr;
+
+	for (h = ctx->pos_hash; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
+		idx = 0;
+		head = &net->dev_index_head[h];
+		hlist_for_each_entry(dev, head, index_hlist) {
+			if (idx < s_idx)
+				goto cont;
+			ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq,
+					   &ethtool_genl_family, 0,
+					   ops->reply_cmd);
+			ret = ethnl_get_dump_one(skb, dev, ops, req_info);
+			if (ret < 0) {
+				genlmsg_cancel(skb, ehdr);
+				if (ret == -EOPNOTSUPP)
+					goto cont;
+				if (likely(skb->len))
+					goto out;
+				goto out_err;
+			}
+			genlmsg_end(skb, ehdr);
+cont:
+			idx++;
+		}
+	}
+out:
+	ret = skb->len;
+out_err:
+	ctx->pos_hash = h;
+	ctx->pos_idx = idx;
+	cb->seq = net->dev_base_seq;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+
+	return ret;
+}
+
+/* generic ->start() handler for GET requests */
+static int ethnl_get_start(struct netlink_callback *cb)
+{
+	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
+	const struct get_request_ops *ops;
+	struct ethnl_req_info *req_info;
+	struct genlmsghdr *ghdr;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+
+	ghdr = nlmsg_data(cb->nlh);
+	ops = get_requests[ghdr->cmd];
+	if (WARN_ONCE(!ops, "cmd %u has no get_request_ops\n", ghdr->cmd))
+		return -EOPNOTSUPP;
+	req_info = ethnl_alloc_get_data(ops);
+	if (!req_info)
+		return -ENOMEM;
+
+	ret = ethnl_std_parse(req_info, cb->nlh, sock_net(cb->skb->sk), ops,
+			      cb->extack, false);
+	if (req_info->dev) {
+		/* We ignore device specification in dump requests but as the
+		 * same parser as for non-dump (doit) requests is used, it
+		 * would take reference to the device if it finds one
+		 */
+		dev_put(req_info->dev);
+		req_info->dev = NULL;
+	}
+	if (ret < 0)
+		return ret;
+	req_info->privileged = ethnl_is_privileged(cb->skb);
+
+	ctx->ops = ops;
+	ctx->req_info = req_info;
+	ctx->pos_hash = 0;
+	ctx->pos_idx = 0;
+
+	return 0;
+}
+
+/* generic ->done() handler for GET requests */
+static int ethnl_get_done(struct netlink_callback *cb)
+{
+	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
+
+	kfree(ctx->req_info);
+
+	return 0;
+}
+
 /* notifications */
 
 typedef void (*ethnl_notify_handler_t)(struct net_device *dev,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 7f1b9ec1ace7..6a9695c3b0c6 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -143,8 +143,32 @@ static inline unsigned int ethnl_reply_header_size(void)
 			      nla_total_size(IFNAMSIZ));
 }
 
+/* GET request handling */
+
+struct ethnl_reply_data;
+
+/* The structure holding data for unified processing GET requests consists of
+ * two parts: request info and reply data. Request info is related to client
+ * request and for dump request it stays constant through all processing;
+ * reply data contains data for composing a reply message. When processing
+ * a dump request, request info is filled only once but reply data is filled
+ * from scratch for each reply message.
+ *
+ * +-----------------+-----------------+------------------+-----------------+
+ * | common_req_info |  specific info  | ethnl_reply_data |  specific data  |
+ * +-----------------+-----------------+------------------+-----------------+
+ * |<---------- request info --------->|<----------- reply data ----------->|
+ *
+ * Request info always starts at offset 0 with struct ethnl_req_info which
+ * holds information from parsing the common header. It may be followed by
+ * other members for request attributes specific for current message type.
+ * Reply data starts with struct ethnl_reply_data which may be followed by
+ * other members holding data needed to compose a message.
+ */
+
 /**
  * struct ethnl_req_info - base type of request information for GET requests
+ * @reply_data: pointer to reply data within the same block
  * @dev:          network device the request is for (may be null)
  * @req_mask:     request mask, bitmap of requested information
  * @global_flags: request flags common for all request types
@@ -154,6 +178,7 @@ static inline unsigned int ethnl_reply_header_size(void)
  * This is a common base, additional members may follow after this structure.
  */
 struct ethnl_req_info {
+	struct ethnl_reply_data		*reply_data;
 	struct net_device		*dev;
 	u32				req_mask;
 	u32				global_flags;
@@ -161,4 +186,107 @@ struct ethnl_req_info {
 	bool				privileged;
 };
 
+/**
+ * struct ethnl_reply_data - base type of reply data for GET requests
+ * @dev:       device for current reply message; in single shot requests it is
+ *             equal to &ethnl_req_info.dev; in dumps it's different for each
+ *             reply message
+ * @info_mask: bitmap of information actually provided in reply; it is a subset
+ *             of &ethnl_req_info.req_mask with cleared bits corresponding to
+ *             information which cannot be provided
+ *
+ * This structure is usually followed by additional members filled by
+ * ->prepare_data() and used by ->cleanup().
+ */
+struct ethnl_reply_data {
+	struct net_device		*dev;
+	u32				info_mask;
+};
+
+static inline int ethnl_before_ops(struct net_device *dev)
+{
+	if (dev && dev->ethtool_ops->begin)
+		return dev->ethtool_ops->begin(dev);
+	else
+		return 0;
+}
+
+static inline void ethnl_after_ops(struct net_device *dev)
+{
+	if (dev && dev->ethtool_ops->complete)
+		dev->ethtool_ops->complete(dev);
+}
+
+/**
+ * struct get_request_ops - unified handling of GET requests
+ * @request_cmd:      command id for request (GET)
+ * @reply_cmd:        command id for reply (GET_REPLY)
+ * @hdr_attr:         attribute type for request header
+ * @max_attr:         maximum (top level) attribute type
+ * @data_size:        total length of data structure
+ * @repdata_offset:   offset of "reply data" part (struct ethnl_reply_data)
+ * @request_policy:   netlink policy for message contents
+ * @header_policy:    (optional) netlink policy for request header
+ * @default_infomask: default infomask (to use if none specified)
+ * @all_reqflags:     allowed request specific flags
+ * @allow_nodev_do:   allow non-dump request with no device identification
+ * @parse_request:
+ *	Parse request except common header (struct ethnl_req_info). Common
+ *	header is already filled on entry, the rest up to @repdata_offset
+ *	is zero initialized. This callback should only modify type specific
+ *	request info by parsed attributes from request message.
+ * @prepare_data:
+ *	Retrieve and prepare data needed to compose a reply message. Calls to
+ *	ethtool_ops handlers should be limited to this callback. Common reply
+ *	data (struct ethnl_reply_data) is filled on entry, type specific part
+ *	after it is zero initialized. This callback should only modify the
+ *	type specific part of reply data. Device identification from struct
+ *	ethnl_reply_data is to be used as for dump requests, it iterates
+ *	through network devices which common_req_info::dev points to the
+ *	device from client request.
+ * @reply_size:
+ *	Estimate reply message size. Returned value must be sufficient for
+ *	message payload without common reply header. The callback may returned
+ *	estimate higher than actual message size if exact calculation would
+ *	not be worth the saved memory space.
+ * @fill_reply:
+ *	Fill reply message payload (except for common header) from reply data.
+ *	The callback must not generate more payload than previously called
+ *	->reply_size() estimated.
+ * @cleanup:
+ *	Optional cleanup called when reply data is no longer needed. Can be
+ *	used e.g. to free any additional data structures outside the main
+ *	structure which were allocated by ->prepare_data(). When processing
+ *	dump requests, ->cleanup() is called for each message.
+ *
+ * Description of variable parts of GET request handling when using the unified
+ * infrastructure. When used, a pointer to an instance of this structure is to
+ * be added to &get_requests array and generic handlers ethnl_get_doit(),
+ * ethnl_get_dumpit(), ethnl_get_start() and ethnl_get_done() used in
+ * @ethnl_genl_ops
+ */
+struct get_request_ops {
+	u8			request_cmd;
+	u8			reply_cmd;
+	u16			hdr_attr;
+	unsigned int		max_attr;
+	unsigned int		data_size;
+	unsigned int		repdata_offset;
+	const struct nla_policy *request_policy;
+	const struct nla_policy *header_policy;
+	u32			default_infomask;
+	u32			all_reqflags;
+	bool			allow_nodev_do;
+
+	int (*parse_request)(struct ethnl_req_info *req_info,
+			     struct nlattr **tb,
+			     struct netlink_ext_ack *extack);
+	int (*prepare_data)(struct ethnl_req_info *req_info,
+			    struct genl_info *info);
+	int (*reply_size)(const struct ethnl_req_info *req_info);
+	int (*fill_reply)(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_info);
+	void (*cleanup)(struct ethnl_req_info *req_info);
+};
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.22.0

