Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB75965E43E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 04:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjAEDsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 22:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjAEDsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 22:48:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28364FD63
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 19:46:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93993B80D75
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 03:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1263CC433D2;
        Thu,  5 Jan 2023 03:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672890365;
        bh=vv2rNeVfBhfVckq4GeHi9EG0KR76zWJ81X9ZgQ6KssM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OW5IDV4Fc72wR9K6PklKQ/zsVDHD26N0C4kYZoSUabp/FHqWKZYYS8p0IyWsiUeI5
         OkkfQyMZxnd+EX4SxkAHB6ibqhVmsnhXaz0nw6ScAHg++6SPkyZ/Kwyo/wWf0dkX+d
         /6XAG4k9xtgxkdmHKi+lbBHymn9iVVgGGvRQLtdAGtrukiZizC2efrueGUct8ps6zC
         rdWNc8SDXYMag+qcu8Prjsbm/TnLqra+98975e8GIxDWAgrUcnM5euEpZ0gFnSQzv2
         38OxrTyOfzGN4oIpW5hU7S4eCES3tdVbidIIpwgy1noZWiG9fMHOxuGuDpW6s2Jdwg
         e+vWVwVPlt3AA==
Date:   Wed, 4 Jan 2023 19:46:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 13/14] devlink: add by-instance dump infra
Message-ID: <20230104194604.545646c5@kernel.org>
In-Reply-To: <Y7WuWd2jfifQ3E8A@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-14-kuba@kernel.org>
        <Y7WuWd2jfifQ3E8A@nanopsycho>
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

On Wed, 4 Jan 2023 17:50:33 +0100 Jiri Pirko wrote:
> Wed, Jan 04, 2023 at 05:16:35AM CET, kuba@kernel.org wrote:
> >Most dumpit implementations walk the devlink instances.
> >This requires careful lock taking and reference dropping.
> >Factor the loop out and provide just a callback to handle
> >a single instance dump.
> >
> >Convert one user as an example, other users converted
> >in the next change.
> >
> >Slightly inspired by ethtool netlink code.

> >diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> >index 5adac38454fd..e49b82dd77cd 100644
> >--- a/net/devlink/devl_internal.h
> >+++ b/net/devlink/devl_internal.h
> >@@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
> > 	};
> > };
> > 
> >+struct devlink_gen_cmd {  
> 
> What is "gen"? Generic netlink?

Generic devlink command. In other words the implementation 
is straightforward enough to factor out the common parts.

> Not sure why perhaps "nl" would be fine to be consistent with the
> rest of the code? Why "cmd"? That looks a bit odd to me.
> 
> >+	int (*dump_one)(struct sk_buff *msg, struct devlink
> >*devlink,
> >+			struct netlink_callback *cb);  
> 
> Do you plan to have more callbacks here? If no, wouldn't it be better
> to just have typedef and assign the pointer to the dump_one in
> devl_gen_cmds array?

If I find the time - yes, more refactoring is possible.

> >+};
> >+
> > /* Iterate over devlink pointers which were possible to get
> > reference to.
> >  * devlink_put() needs to be called for each iterated devlink
> > pointer
> >  * in loop body in order to release the reference.
> >@@ -138,6 +143,9 @@ struct devlink *devlink_get_from_attrs(struct
> >net *net, struct nlattr **attrs);
> > void devlink_notify_unregister(struct devlink *devlink);
> > void devlink_notify_register(struct devlink *devlink);
> > 
> >+int devlink_instance_iter_dump(struct sk_buff *msg,
> >+			       struct netlink_callback *cb);
> >+
> > static inline struct devlink_nl_dump_state *
> > devl_dump_state(struct netlink_callback *cb)
> > {
> >@@ -173,6 +181,8 @@ devlink_linecard_get_from_info(struct devlink
> >*devlink, struct genl_info *info);
> > void devlink_linecard_put(struct devlink_linecard *linecard);
> > 
> > /* Rates */
> >+extern const struct devlink_gen_cmd devl_gen_rate_get;  
> 
> The struct name is *_cmd, not sure why the variable name is *_get
> Shouldn't it be rather devl_gen_cmd_rate?

It is the implementation of get.. there's also a set command.. 
which would be under a different index...

> >+			dump->idx = idx;
> >+			break;
> >+		}
> >+		idx++;
> > 	}
> >-out:
> >-	if (err != -EMSGSIZE)
> >-		return err;
> > 
> >-	return msg->len;
> >+	return err;
> > }
> > 
> >+const struct devlink_gen_cmd devl_gen_rate_get = {
> >+	.dump_one		=
> >devlink_nl_cmd_rate_get_dumpinst,  
> 
> dump_one/dumpinst inconsistency in names

Sure...

> >+};
> >+
> > static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
> > 					struct genl_info *info)
> > {
> >@@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56]
> >= {
> > 	{
> > 		.cmd = DEVLINK_CMD_RATE_GET,
> > 		.doit = devlink_nl_cmd_rate_get_doit,
> >-		.dumpit = devlink_nl_cmd_rate_get_dumpit,
> >+		.dumpit = devlink_instance_iter_dump,  
> 
> again, inconsistency:
> devlink_instance_iter_dumpit

You mean it doesn't have nl, cmd, dump_one in the name?
Could you *please* at least say what you want the names to be if you're
sending all those subjective nit picks? :/

I'll call it devlink_nl_instance_iter_dump

> > 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
> > 		/* can be retrieved by unprivileged users */  
> 
> Unrelated to this patch, I wonder, why you didn't move devlink_nl_ops
> along with the rest of the netlink code to netlink.c?

It's explained in the commit message for patch 3 :/

> > 	},
> >diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
> >index ce1a7d674d14..fcf10c288480 100644
> >--- a/net/devlink/netlink.c
> >+++ b/net/devlink/netlink.c
> >@@ -5,6 +5,7 @@
> >  */
> > 
> > #include <net/genetlink.h>
> >+#include <net/sock.h>
> > 
> > #include "devl_internal.h"
> > 
> >@@ -177,6 +178,38 @@ static void devlink_nl_post_doit(const struct
> >genl_split_ops *ops,
> > 	devlink_put(devlink);
> > }
> > 
> >+static const struct devlink_gen_cmd *devl_gen_cmds[] = {
> >+	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
> > 
> 
> static const devlink_nl_dump_one_t *devlink_nl_dump_one[] = {
> 	[DEVLINK_CMD_RATE_GET]	= &devl_nl_rate_dump_one,
> }
> Maybe? (not sure how the devlink/devl should be used here though)

Nope.
