Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB11B5F596
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfGDJ23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:28:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:43034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727222AbfGDJ22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 05:28:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85189AC8E;
        Thu,  4 Jul 2019 09:28:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D7360E0159; Thu,  4 Jul 2019 11:28:24 +0200 (CEST)
Date:   Thu, 4 Jul 2019 11:28:24 +0200
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
Subject: Re: [PATCH net-next v6 09/15] ethtool: generic handlers for GET
 requests
Message-ID: <20190704092824.GQ20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4faa0ce52dfe02c9cde5a46012b16c9af6764c5e.1562067622.git.mkubecek@suse.cz>
 <20190704084913.GA18546@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704084913.GA18546@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 10:49:13AM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 01:50:24PM CEST, mkubecek@suse.cz wrote:
> 
> [...]
> 
> 
> >+/* The structure holding data for unified processing GET requests consists of
> >+ * two parts: request info and reply data. Request info is related to client
> >+ * request and for dump request it stays constant through all processing;
> >+ * reply data contains data for composing a reply message. When processing
> >+ * a dump request, request info is filled only once but reply data is filled
> >+ * from scratch for each reply message.
> >+ *
> >+ * +-----------------+-----------------+------------------+-----------------+
> >+ * | common_req_info |  specific info  | ethnl_reply_data |  specific data  |
> >+ * +-----------------+-----------------+------------------+-----------------+
> >+ * |<---------- request info --------->|<----------- reply data ----------->|
> >+ *
> >+ * Request info always starts at offset 0 with struct ethnl_req_info which
> >+ * holds information from parsing the common header. It may be followed by
> >+ * other members for request attributes specific for current message type.
> >+ * Reply data starts with struct ethnl_reply_data which may be followed by
> >+ * other members holding data needed to compose a message.
> >+ */
> >+
> 
> [...]
> 
> 
> >+/**
> >+ * struct get_request_ops - unified handling of GET requests
> >+ * @request_cmd:      command id for request (GET)
> >+ * @reply_cmd:        command id for reply (GET_REPLY)
> >+ * @hdr_attr:         attribute type for request header
> >+ * @max_attr:         maximum (top level) attribute type
> >+ * @data_size:        total length of data structure
> >+ * @repdata_offset:   offset of "reply data" part (struct ethnl_reply_data)
> 
> For example, this looks quite scarry for me. You have one big chunk of
> data (according to the scheme above) specific for cmd with reply starting
> at arbitrary offset.

We can split it into two structures, one for request related data with
struct ethnl_req_info embedded at offset 0 and one for reply related
data with struct ethnl_reply_data embedded at offset 0. It would be
probably more convenient to have pointer to request info from reply data
then. The code would get a bit simpler in few places at the expense of
an extra kmalloc().

Michal
