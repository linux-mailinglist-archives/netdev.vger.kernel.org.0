Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C1E12B55D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfL0Ozn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:55:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:42690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbfL0Ozm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:55:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8BDCEAEC1;
        Fri, 27 Dec 2019 14:55:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 34F4BE008A; Fri, 27 Dec 2019 15:55:38 +0100 (CET)
Message-Id: <e771bece36edda5dbcda274b36dbe744c916b0be.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 05/14] ethtool: default handlers for GET requests
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:55:38 +0100 (CET)
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
  cleanup_data()  - (optional) clean up additional data

Other members of struct get_request_ops describe the data structure holding
information from client request and data used to compose the message. The
default handlers ethnl_default_doit(), ethnl_default_dumpit(),
ethnl_default_start() and ethnl_default_done() can be then used in genl_ops
handler. Notification handler will be introduced in a later patch.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/ethtool/netlink.c | 321 ++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/netlink.h | 116 ++++++++++++++-
 2 files changed, 436 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index c0f25c8f3565..ae63e8423072 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -171,6 +171,327 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
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
+ * between iterations. They are initialized by ethnl_default_start() and used
+ * in ethnl_default_dumpit() and ethnl_default_done().
+ */
+struct ethnl_dump_ctx {
+	const struct ethnl_request_ops	*ops;
+	struct ethnl_req_info		*req_info;
+	struct ethnl_reply_data		*reply_data;
+	int				pos_hash;
+	int				pos_idx;
+};
+
+static const struct ethnl_request_ops *
+ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
+};
+
+static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
+{
+	return (struct ethnl_dump_ctx *)cb->ctx;
+}
+
+/**
+ * ethnl_default_parse() - Parse request message
+ * @req_info:    pointer to structure to put data into
+ * @nlhdr:       pointer to request message header
+ * @net:         request netns
+ * @request_ops: struct request_ops for request type
+ * @extack:      netlink extack for error reporting
+ * @require_dev: fail if no device identified in header
+ *
+ * Parse universal request header and call request specific ->parse_request()
+ * callback (if defined) to parse the rest of the message.
+ *
+ * Return: 0 on success or negative error code
+ */
+static int ethnl_default_parse(struct ethnl_req_info *req_info,
+			       const struct nlmsghdr *nlhdr, struct net *net,
+			       const struct ethnl_request_ops *request_ops,
+			       struct netlink_ext_ack *extack, bool require_dev)
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
+				 extack, require_dev);
+	if (ret < 0)
+		goto out;
+
+	if (request_ops->parse_request) {
+		ret = request_ops->parse_request(req_info, tb, extack);
+		if (ret < 0)
+			goto out;
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
+ * @ops:      instance of struct ethnl_request_ops describing the layout
+ * @dev:      network device to initialize the reply for
+ *
+ * Fills the reply data part with zeros and sets the dev member. Must be called
+ * before calling the ->fill_reply() callback (for each iteration when handling
+ * dump requests).
+ */
+static void ethnl_init_reply_data(struct ethnl_reply_data *reply_data,
+				  const struct ethnl_request_ops *ops,
+				  struct net_device *dev)
+{
+	memset(reply_data, 0, ops->reply_data_size);
+	reply_data->dev = dev;
+}
+
+/* default ->doit() handler for GET type requests */
+static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ethnl_reply_data *reply_data = NULL;
+	struct ethnl_req_info *req_info = NULL;
+	const u8 cmd = info->genlhdr->cmd;
+	const struct ethnl_request_ops *ops;
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len;
+	int ret;
+
+	ops = ethnl_default_requests[cmd];
+	if (WARN_ONCE(!ops, "cmd %u has no ethnl_request_ops\n", cmd))
+		return -EOPNOTSUPP;
+	req_info = kzalloc(ops->req_info_size, GFP_KERNEL);
+	if (!req_info)
+		return -ENOMEM;
+	reply_data = kmalloc(ops->reply_data_size, GFP_KERNEL);
+	if (!reply_data) {
+		kfree(req_info);
+		return -ENOMEM;
+	}
+
+	ret = ethnl_default_parse(req_info, info->nlhdr, genl_info_net(info), ops,
+				  info->extack, !ops->allow_nodev_do);
+	if (ret < 0)
+		goto err_dev;
+	ethnl_init_reply_data(reply_data, ops, req_info->dev);
+
+	rtnl_lock();
+	ret = ops->prepare_data(req_info, reply_data, info);
+	rtnl_unlock();
+	if (ret < 0)
+		goto err_cleanup;
+	reply_len = ops->reply_size(req_info, reply_data);
+	if (ret < 0)
+		goto err_cleanup;
+	ret = -ENOMEM;
+	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
+				ops->hdr_attr, info, &reply_payload);
+	if (!rskb)
+		goto err_cleanup;
+	ret = ops->fill_reply(rskb, req_info, reply_data);
+	if (ret < 0)
+		goto err_msg;
+	if (ops->cleanup_data)
+		ops->cleanup_data(reply_data);
+
+	genlmsg_end(rskb, reply_payload);
+	if (req_info->dev)
+		dev_put(req_info->dev);
+	kfree(reply_data);
+	kfree(req_info);
+	return genlmsg_reply(rskb, info);
+
+err_msg:
+	WARN_ONCE(ret == -EMSGSIZE, "calculated message payload length (%d) not sufficient\n", reply_len);
+	nlmsg_free(rskb);
+err_cleanup:
+	if (ops->cleanup_data)
+		ops->cleanup_data(reply_data);
+err_dev:
+	if (req_info->dev)
+		dev_put(req_info->dev);
+	kfree(reply_data);
+	kfree(req_info);
+	return ret;
+}
+
+static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
+				  const struct ethnl_dump_ctx *ctx)
+{
+	int ret;
+
+	ethnl_init_reply_data(ctx->reply_data, ctx->ops, dev);
+	rtnl_lock();
+	ret = ctx->ops->prepare_data(ctx->req_info, ctx->reply_data, NULL);
+	rtnl_unlock();
+	if (ret < 0)
+		goto out;
+	ret = ethnl_fill_reply_header(skb, dev, ctx->ops->hdr_attr);
+	if (ret < 0)
+		goto out;
+	ret = ctx->ops->fill_reply(skb, ctx->req_info, ctx->reply_data);
+
+out:
+	if (ctx->ops->cleanup_data)
+		ctx->ops->cleanup_data(ctx->reply_data);
+	ctx->reply_data->dev = NULL;
+	return ret;
+}
+
+/* Default ->dumpit() handler for GET requests. Device iteration copied from
+ * rtnl_dump_ifinfo(); we have to be more careful about device hashtable
+ * persistence as we cannot guarantee to hold RTNL lock through the whole
+ * function as rtnetnlink does.
+ */
+static int ethnl_default_dumpit(struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
+	struct net *net = sock_net(skb->sk);
+	int s_idx = ctx->pos_idx;
+	int h, idx = 0;
+	int ret = 0;
+	void *ehdr;
+
+	rtnl_lock();
+	for (h = ctx->pos_hash; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
+		struct hlist_head *head;
+		struct net_device *dev;
+		unsigned int seq;
+
+		head = &net->dev_index_head[h];
+
+restart_chain:
+		seq = net->dev_base_seq;
+		cb->seq = seq;
+		idx = 0;
+		hlist_for_each_entry(dev, head, index_hlist) {
+			if (idx < s_idx)
+				goto cont;
+			dev_hold(dev);
+			rtnl_unlock();
+
+			ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq,
+					   &ethtool_genl_family, 0,
+					   ctx->ops->reply_cmd);
+			if (!ehdr) {
+				dev_put(dev);
+				ret = -EMSGSIZE;
+				goto out;
+			}
+			ret = ethnl_default_dump_one(skb, dev, ctx);
+			dev_put(dev);
+			if (ret < 0) {
+				genlmsg_cancel(skb, ehdr);
+				if (ret == -EOPNOTSUPP)
+					goto lock_and_cont;
+				if (likely(skb->len))
+					ret = skb->len;
+				goto out;
+			}
+			genlmsg_end(skb, ehdr);
+lock_and_cont:
+			rtnl_lock();
+			if (net->dev_base_seq != seq) {
+				s_idx = idx + 1;
+				goto restart_chain;
+			}
+cont:
+			idx++;
+		}
+
+	}
+	rtnl_unlock();
+
+out:
+	ctx->pos_hash = h;
+	ctx->pos_idx = idx;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+
+	return ret;
+}
+
+/* generic ->start() handler for GET requests */
+static int ethnl_default_start(struct netlink_callback *cb)
+{
+	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
+	struct ethnl_reply_data *reply_data;
+	const struct ethnl_request_ops *ops;
+	struct ethnl_req_info *req_info;
+	struct genlmsghdr *ghdr;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+
+	ghdr = nlmsg_data(cb->nlh);
+	ops = ethnl_default_requests[ghdr->cmd];
+	if (WARN_ONCE(!ops, "cmd %u has no ethnl_request_ops\n", ghdr->cmd))
+		return -EOPNOTSUPP;
+	req_info = kzalloc(ops->req_info_size, GFP_KERNEL);
+	if (!req_info)
+		return -ENOMEM;
+	reply_data = kmalloc(ops->reply_data_size, GFP_KERNEL);
+	if (!reply_data) {
+		kfree(req_info);
+		return -ENOMEM;
+	}
+
+	ret = ethnl_default_parse(req_info, cb->nlh, sock_net(cb->skb->sk), ops,
+				  cb->extack, false);
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
+
+	ctx->ops = ops;
+	ctx->req_info = req_info;
+	ctx->reply_data = reply_data;
+	ctx->pos_hash = 0;
+	ctx->pos_idx = 0;
+
+	return 0;
+}
+
+/* default ->done() handler for GET requests */
+static int ethnl_default_done(struct netlink_callback *cb)
+{
+	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
+
+	kfree(ctx->reply_data);
+	kfree(ctx->req_info);
+
+	return 0;
+}
+
 /* notifications */
 
 typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 05d7183da894..6ec0dd06277f 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -200,16 +200,130 @@ static inline unsigned int ethnl_reply_header_size(void)
 			      nla_total_size(IFNAMSIZ));
 }
 
+/* GET request handling */
+
+/* Unified processing of GET requests uses two data structures: request info
+ * and reply data. Request info holds information parsed from client request
+ * and its stays constant through all request processing. Reply data holds data
+ * retrieved from ethtool_ops callbacks or other internal sources which is used
+ * to compose the reply. When processing a dump request, request info is filled
+ * only once (when the request message is parsed) but reply data is filled for
+ * each reply message.
+ *
+ * Both structures consist of part common for all request types (struct
+ * ethnl_req_info and struct ethnl_reply_data defined below) and optional
+ * parts specific for each request type. Common part always starts at offset 0.
+ */
+
 /**
  * struct ethnl_req_info - base type of request information for GET requests
  * @dev:   network device the request is for (may be null)
  * @flags: request flags common for all request types
  *
- * This is a common base, additional members may follow after this structure.
+ * This is a common base for request specific structures holding data from
+ * parsed userspace request. These always embed struct ethnl_req_info at
+ * zero offset.
  */
 struct ethnl_req_info {
 	struct net_device	*dev;
 	u32			flags;
 };
 
+/**
+ * struct ethnl_reply_data - base type of reply data for GET requests
+ * @dev:       device for current reply message; in single shot requests it is
+ *             equal to &ethnl_req_info.dev; in dumps it's different for each
+ *             reply message
+ *
+ * This is a common base for request specific structures holding data for
+ * kernel reply message. These always embed struct ethnl_reply_data at zero
+ * offset.
+ */
+struct ethnl_reply_data {
+	struct net_device		*dev;
+};
+
+static inline int ethnl_ops_begin(struct net_device *dev)
+{
+	if (dev && dev->ethtool_ops->begin)
+		return dev->ethtool_ops->begin(dev);
+	else
+		return 0;
+}
+
+static inline void ethnl_ops_complete(struct net_device *dev)
+{
+	if (dev && dev->ethtool_ops->complete)
+		dev->ethtool_ops->complete(dev);
+}
+
+/**
+ * struct ethnl_request_ops - unified handling of GET requests
+ * @request_cmd:      command id for request (GET)
+ * @reply_cmd:        command id for reply (GET_REPLY)
+ * @hdr_attr:         attribute type for request header
+ * @max_attr:         maximum (top level) attribute type
+ * @req_info_size:    size of request info
+ * @reply_data_size:  size of reply data
+ * @request_policy:   netlink policy for message contents
+ * @allow_nodev_do:   allow non-dump request with no device identification
+ * @parse_request:
+ *	Parse request except common header (struct ethnl_req_info). Common
+ *	header is already filled on entry, the rest up to @repdata_offset
+ *	is zero initialized. This callback should only modify type specific
+ *	request info by parsed attributes from request message.
+ * @prepare_data:
+ *	Retrieve and prepare data needed to compose a reply message. Calls to
+ *	ethtool_ops handlers are limited to this callback. Common reply data
+ *	(struct ethnl_reply_data) is filled on entry, type specific part after
+ *	it is zero initialized. This callback should only modify the type
+ *	specific part of reply data. Device identification from struct
+ *	ethnl_reply_data is to be used as for dump requests, it iterates
+ *	through network devices while dev member of struct ethnl_req_info
+ *	points to the device from client request.
+ * @reply_size:
+ *	Estimate reply message size. Returned value must be sufficient for
+ *	message payload without common reply header. The callback may returned
+ *	estimate higher than actual message size if exact calculation would
+ *	not be worth the saved memory space.
+ * @fill_reply:
+ *	Fill reply message payload (except for common header) from reply data.
+ *	The callback must not generate more payload than previously called
+ *	->reply_size() estimated.
+ * @cleanup_data:
+ *	Optional cleanup called when reply data is no longer needed. Can be
+ *	used e.g. to free any additional data structures outside the main
+ *	structure which were allocated by ->prepare_data(). When processing
+ *	dump requests, ->cleanup() is called for each message.
+ *
+ * Description of variable parts of GET request handling when using the
+ * unified infrastructure. When used, a pointer to an instance of this
+ * structure is to be added to &ethnl_default_requests array and generic
+ * handlers ethnl_default_doit(), ethnl_default_dumpit(),
+ * ethnl_default_start() and ethnl_default_done() used in @ethtool_genl_ops.
+ */
+struct ethnl_request_ops {
+	u8			request_cmd;
+	u8			reply_cmd;
+	u16			hdr_attr;
+	unsigned int		max_attr;
+	unsigned int		req_info_size;
+	unsigned int		reply_data_size;
+	const struct nla_policy *request_policy;
+	bool			allow_nodev_do;
+
+	int (*parse_request)(struct ethnl_req_info *req_info,
+			     struct nlattr **tb,
+			     struct netlink_ext_ack *extack);
+	int (*prepare_data)(const struct ethnl_req_info *req_info,
+			    struct ethnl_reply_data *reply_data,
+			    struct genl_info *info);
+	int (*reply_size)(const struct ethnl_req_info *req_info,
+			  const struct ethnl_reply_data *reply_data);
+	int (*fill_reply)(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_info,
+			  const struct ethnl_reply_data *reply_data);
+	void (*cleanup_data)(struct ethnl_reply_data *reply_data);
+};
+
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.24.1

