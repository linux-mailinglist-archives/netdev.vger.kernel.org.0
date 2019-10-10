Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90007D2FED
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfJJSEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:04:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:36686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbfJJSEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 14:04:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78D69AD69;
        Thu, 10 Oct 2019 18:04:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A6537E378C; Thu, 10 Oct 2019 20:04:01 +0200 (CEST)
Date:   Thu, 10 Oct 2019 20:04:01 +0200
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
Subject: Re: [PATCH net-next v7 09/17] ethtool: generic handlers for GET
 requests
Message-ID: <20191010180401.GD22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <b000e461e348ba1a0af30f2e8493618bce11ec12.1570654310.git.mkubecek@suse.cz>
 <20191010135639.GJ2223@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010135639.GJ2223@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 03:56:39PM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 10:59:27PM CEST, mkubecek@suse.cz wrote:
> >+/**
> >+ * ethnl_std_parse() - Parse request message
> >+ * @req_info:    pointer to structure to put data into
> >+ * @nlhdr:       pointer to request message header
> >+ * @net:         request netns
> >+ * @request_ops: struct request_ops for request type
> >+ * @extack:      netlink extack for error reporting
> >+ * @require_dev: fail if no device identified in header
> >+ *
> >+ * Parse universal request header and call request specific ->parse_request()
> >+ * callback (if defined) to parse the rest of the message.
> >+ *
> >+ * Return: 0 on success or negative error code
> >+ */
> >+static int ethnl_std_parse(struct ethnl_req_info *req_info,
> 
> "std" sounds a bit odd. Perhaps "common"?

It could be "common". The reason I used "standard" was that this parser
is only used by (GET) request types which use the standard doit/dumpit
handlers. Request types using their own (nonstandard) handlers will also
do parsing on their own.

> >+			   const struct nlmsghdr *nlhdr, struct net *net,
> >+			   const struct get_request_ops *request_ops,
> >+			   struct netlink_ext_ack *extack, bool require_dev)
> >+{
> >+	struct nlattr **tb;
> >+	int ret;
> >+
> >+	tb = kmalloc_array(request_ops->max_attr + 1, sizeof(tb[0]),
> >+			   GFP_KERNEL);
> >+	if (!tb)
> >+		return -ENOMEM;
> >+
> >+	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, request_ops->max_attr,
> >+			  request_ops->request_policy, extack);
> >+	if (ret < 0)
> >+		goto out;
> >+	ret = ethnl_parse_header(req_info, tb[request_ops->hdr_attr], net,
> >+				 extack, request_ops->header_policy,
> >+				 require_dev);
> 
> This is odd. It's the other way around in compare what I would expect.
> There is a request-specific header attr that contains common header
> attributes parsed in ethnl_parse_header.
> 
> Why don't you have the common header as a root then then have one nested
> attr that would carry the request-specific attrs?
> 
> Similar to how it is done in rtnl IFLA_INFO_KIND.

To me, what you suggest feels much more odd. I thought about it last
time, I thought about it now and the only reason for such layout I could
come with would be to work around the unfortunate design flaw of the way
validation and parsing is done in genetlink (see below).

The situation with IFLA_INFO_KIND is a bit different, what you suggest
would rather correspond to having only attributes common for all RTNL on
top level and hiding all IFLA_* attributes into a nest (and the same
with attributes specific to "ip addr", "ip route", "ip rule" etc.)

> You can parse the common stuff in pre_doit/start genl ops and you
> don't have to explicitly call ethnl_parse_header.
> Also, that would allow you to benefit from the genl doit/dumpit initial
> attr parsing and save basically this whole function (alloc,parse).
> 
> Code would be much more simple to follow then.
> 
> Still seems to me that you use the generic netlink but you don't like
> the infra too much so you make it up yourself again in parallel - that is
> my feeling reading the code. I get the argument about the similarities
> of the individual requests and why you have this request_ops (alhough I
> don't like it too much).

The only thing I don't like about the genetlink infrastructure is the
design decision that policy and corresponding maxattr is an attribute of
the family rather than a command. This forces anyone who wants to use it
to essentially have one common message format for all commands and if
that is not possible, to do what you suggest above, hide the actual
request into a nest.

Whether you use one common attribute type for "command specific nest" or
different attribute for each request type, you do not actually make
things simpler, you just move the complexity one level lower. You will
still have to do your own (per request) parsing of the actual request,
the only difference is that you will do it in a different place and use
nla_parse_nested() rather than nlmsg_parse().

Rather than bending the message layout to fit into the limitations of
unified genetlink parsing, I prefer to keep the logical message
structure and do the parsing on my own.

> >+static void ethnl_init_reply_data(struct ethnl_reply_data *reply_data,
> >+				  const struct get_request_ops *ops,
> >+				  struct net_device *dev)
> >+{
> >+	memset(reply_data, '\0', ops->reply_data_size);
> 
> Just "0" would do too.

OK

> >+
> >+err_msg:
> >+	WARN_ONCE(ret == -EMSGSIZE,
> 
> No need to wrap here (and in other similar cases)

OK 

> >+		  "calculated message payload length (%d) not sufficient\n",
> >+		  reply_len);
...
> >+ * @prepare_data:
> >+ *	Retrieve and prepare data needed to compose a reply message. Calls to
> >+ *	ethtool_ops handlers should be limited to this callback. Common reply
> >+ *	data (struct ethnl_reply_data) is filled on entry, type specific part
> >+ *	after it is zero initialized. This callback should only modify the
> >+ *	type specific part of reply data. Device identification from struct
> >+ *	ethnl_reply_data is to be used as for dump requests, it iterates
> >+ *	through network devices which common_req_info::dev points to the
> 
> First time I see this notation. Is "::" something common in kernel code?

It's sometimes used to denote a struct member but I don't know if it's
common in kernel documentation. I'll write it explicitly.

> >+struct get_request_ops {
> 
> Could you please have "ethnl_" prefix for things like this.
> "get_request_ops" sounds way to generic.

OK

Michal
