Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A965E35D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 04:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjAEDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 22:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjAEDVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 22:21:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF2B4880D
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 19:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1760A6010F
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 03:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AB2C433EF;
        Thu,  5 Jan 2023 03:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672888867;
        bh=xtXm8P94pjmcLNRQAHB/pqeY1gKONzuhlMwXIH/W7UY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YEfcFoe/SdBAWt/mPzlIXuKTwQvf/awTXe5kiAxP0eAdH7rpk194DWStPi5HDV/Wl
         SVhSMNSToGKIkEDlZzo9QEEPUiALixA9IXBUHJ5rkqM0XEf3AJT2qqaO5/QlRrA6q3
         UImynQPFnP1UWhpLI2hXUfUydnXWb9d5Bye3CwR+NrIdTMugJG8Pl97shaLI7szLo1
         m5GV0jJXhdKbRA4oiGwKff7X9xBq4l3BytgmCWqesoQAQqnklqo6rt1AdoaUqiZKJy
         osR2nnLeNSzdm2FdevTqaIcw21rxTTwlOXk1TlKj9dMBRbBDM9vhqx7rQ8Uys5BUDN
         q/b2bnuPrAs4A==
Date:   Wed, 4 Jan 2023 19:21:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 09/14] devlink: restart dump based on devlink
 instance ids (simple)
Message-ID: <20230104192106.2f3b4f98@kernel.org>
In-Reply-To: <Y7WKzkKe69TDfKEM@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-10-kuba@kernel.org>
        <Y7WKzkKe69TDfKEM@nanopsycho>
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

On Wed, 4 Jan 2023 15:18:54 +0100 Jiri Pirko wrote:
> >@@ -117,6 +122,15 @@ struct devlink_nl_dump_state {
> > 	};
> > };
> > 
> >+/* Iterate over devlink pointers which were possible to get reference to.
> >+ * devlink_put() needs to be called for each iterated devlink pointer
> >+ * in loop body in order to release the reference.
> >+ */
> >+#define devlink_dump_for_each_instance_get(msg, dump, devlink)		\
> >+	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\  
> 
> I undestand that the "dump" is zeroed at the beginning of dumpit call,
> however, if you call this helper multiple times, the second iteration
> would't not work.
> 
> Perhaps better to initialize instance=0 at the beginning of the loop to
> make this helper calls behaviour independent on context.

Mmm. dump is zeroed when the operation starts. If there are multiple
->dumpit calls / skbs - the dump will not get re-started.

Restarting the instance walk would be tricky in practice (the
subsequent ->dumpit calls would need to know if they are pre- or post-
restarted) - so I don't think we should anticipate having to do this.

Let me rewrite to comment to make the dumpit-only-ness explicit.

> >+					       &dump->instance, xa_find)); \
> >+	     dump->instance++)
> >+
> > extern const struct genl_small_ops devlink_nl_ops[56];
> > 
> > struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
> >diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> >index e3cfb64990b4..0f24b321b0bb 100644
> >--- a/net/devlink/leftover.c
> >+++ b/net/devlink/leftover.c
> >@@ -1319,17 +1319,9 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
> > {
> > 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
> > 	struct devlink *devlink;
> >-	unsigned long index;
> >-	int idx = 0;
> > 	int err;
> > 
> >-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
> >-		if (idx < dump->idx) {
> >-			idx++;
> >-			devlink_put(devlink);
> >-			continue;
> >-		}
> >-
> >+	devlink_dump_for_each_instance_get(msg, dump, devlink) {  
> 
> The name suggests on the first sight that you are iterating some dump,
> which is slightly confusing. Perhaps better to have
> "devlinks_xa_for_each_" in the prefix somehow?
> 
> 	devlinks_xa_for_each_registered_get_dumping()
> 
> I know it is long :)

It's only usable in netlink dumps and with clear semantic implications.
More generic name is not appropriate IMO.
Maybe after you remove the line card locks we could remove the macro
completely? It only has 3 users after my patches - on in the generic
dump handling and one for the subobjects which have their own locks.
