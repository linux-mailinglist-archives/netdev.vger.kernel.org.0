Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA8367A7E0
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjAYAh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjAYAh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:37:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7847F3E608
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 661C2B8171E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE07C433D2;
        Wed, 25 Jan 2023 00:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674607041;
        bh=MMRTmH/tAO0y9xSZxsHUBdJcOzRgJ9+FlcMvMmJ+xQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nO2nWQCwyGgabgjTCGcq/Lz1BxtKWuCnhFG/J34HSOzEX6OYCH6crWvhz/fks8IKd
         cytcEhZHMhzQA64jxCXIt7BaWLl7fSrIZa1gf5CddOxXtvjyBCy1VpwrnQCB3piDgd
         Y41hEMnsbhZiIvp7U6OveWtlKpR2FIXBcP6HmUh3HgLlmFI33GKRWGlw2cAa8xM0gl
         kzR1ES7evVph43TwAPLeWLmcC3ReRU+5Q7xmmA9U3W2g56xeCufUGqXN3cFXzKTraM
         mxLEh6/VQPbBb9mYmi3B2SvckH42BfNKWEppf4KgjsO/p8PG5XMmZo04scYf5aBJE4
         sZgug2azfIYOw==
Date:   Tue, 24 Jan 2023 16:37:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next 1/2] ethtool: netlink: handle SET intro/outro
 in the common code
Message-ID: <20230124163719.46faf7fa@kernel.org>
In-Reply-To: <ddb7520869c8143ea6bf3fc99716e4369d2518db.camel@redhat.com>
References: <20230121054430.642280-1-kuba@kernel.org>
        <ddb7520869c8143ea6bf3fc99716e4369d2518db.camel@redhat.com>
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

On Tue, 24 Jan 2023 12:34:23 +0100 Paolo Abeni wrote:
> On Fri, 2023-01-20 at 21:44 -0800, Jakub Kicinski wrote:
> > diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
> > index a8c113d244db..8e9aced3eeec 100644
> > --- a/net/ethtool/pause.c
> > +++ b/net/ethtool/pause.c
> > @@ -114,18 +114,6 @@ static int pause_fill_reply(struct sk_buff *skb,
> >  	return 0;
> >  }
> >  
> > -const struct ethnl_request_ops ethnl_pause_request_ops = {
> > -	.request_cmd		= ETHTOOL_MSG_PAUSE_GET,
> > -	.reply_cmd		= ETHTOOL_MSG_PAUSE_GET_REPLY,
> > -	.hdr_attr		= ETHTOOL_A_PAUSE_HEADER,
> > -	.req_info_size		= sizeof(struct pause_req_info),
> > -	.reply_data_size	= sizeof(struct pause_reply_data),
> > -
> > -	.prepare_data		= pause_prepare_data,
> > -	.reply_size		= pause_reply_size,
> > -	.fill_reply		= pause_fill_reply,
> > -};
> > -
> >  /* PAUSE_SET */
> >  
> >  const struct nla_policy ethnl_pause_set_policy[] = {  
> 
> This chunk does not apply cleanly due to commit 04692c9020b7 ("net:
> ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
> 
> Could you please rebase?

Ah, sorry, didn't realize that series was changing request_ops.

I'll repost once Vladimir's fixes are in, because I think we should
add attrs and extack to req_info. That way we avoid all the bugs
with people expecting info to not be NULL and also one fewer param
for all the functions.
