Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134F4D31DA
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfJJUPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:15:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:58054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfJJUPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 16:15:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 45019AF0B;
        Thu, 10 Oct 2019 20:15:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E9B3BE378C; Thu, 10 Oct 2019 22:15:44 +0200 (CEST)
Date:   Thu, 10 Oct 2019 22:15:44 +0200
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
Subject: Re: [PATCH net-next v7 12/17] ethtool: provide link settings with
 LINKINFO_GET request
Message-ID: <20191010201544.GI22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <1568f00bf7275f1a872c177e29d5800cd73e50c8.1570654310.git.mkubecek@suse.cz>
 <20191010155955.GB2901@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010155955.GB2901@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 05:59:55PM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 10:59:37PM CEST, mkubecek@suse.cz wrote:
> 
> [...]
> 
> >+/* prepare_data() handler */
> 
> Not sure how valuable are comments like this...

I'll drop them.

> >+static int linkinfo_prepare(const struct ethnl_req_info *req_base,
> >+			    struct ethnl_reply_data *reply_base,
> >+			    struct genl_info *info)
> >+{
> >+	struct linkinfo_reply_data *data =
> >+		container_of(reply_base, struct linkinfo_reply_data, base);
> 
> A helper would be nice for this. For req_info too.

Good point.

> >+	struct net_device *dev = reply_base->dev;
> >+	int ret;
> >+
> >+	data->lsettings = &data->ksettings.base;
> >+
> >+	ret = ethnl_before_ops(dev);
> 
> "before_ops"/"after_ops" sounds odd. Maybe:
> ethnl_ops_begin
> ethnl_ops_complete
> 
> To me in-line with ethtool_ops names?

OK

> I guess you don't want the caller (ethnl_get_doit/ethnl_get_dumpit)
> to call this because it might not be needed down in prepare_data()
> callback, right?

Yes, there are some which do not call any ethtool_ops callbacks, e.g.
netdev features (ethtool -k / -K).

> >+const struct get_request_ops linkinfo_request_ops = {
> >+	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
> >+	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
> >+	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
> >+	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
> >+	.req_info_size		= sizeof(struct linkinfo_req_info),
> >+	.reply_data_size	= sizeof(struct linkinfo_reply_data),
> >+	.request_policy		= linkinfo_get_policy,
> >+	.all_reqflags		= ETHTOOL_RFLAG_LINKINFO_ALL,
> >+
> >+	.prepare_data		= linkinfo_prepare,
> 
> Please have the ops with the same name/suffix:
> 	.request_policy		= linkinfo_reques_policy,
> 	.prepare_data		= linkinfo_prepare_data,
> 	.reply_size		= linkinfo_reply_size,
> 	.fill_reply		= linkinfo_fill_reply,
> 
> Same applies of course to the other patches.

OK

Michal
