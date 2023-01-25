Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678FE67A79B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbjAYAZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbjAYAZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:25:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A000B4DCDF
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:24:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC0D9B8172F
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEC3C433EF;
        Wed, 25 Jan 2023 00:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674606228;
        bh=/LeIaz9yPs1aBbw0hRtqbXWzUF0roXTEb6fERE9eFSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9dDde9q2NqypmgTZTKINLlPOmJG3022m6uxBy7TfrTY/p1vV2X+s/9gr+xDWGNDc
         7ey7x/uObI2i4K8OkpTm6Xla+sghllnPzYPCD1+uKBMBlmMILbaw49aIit5sn6vAcZ
         YRFHnWKyTfcPQM2zXV701o9S/+0RopUeltULqxNpFVw8UWTctOIvBBdE6YTfsBefSn
         w5GfkmsdkeIU/fRTi3gJhtPC4TGzdx1fjJQ5CrLUDv8NuVa59cLGeXFIv6TZzlxU2P
         iXs+ZoCbA7dDSBQozrVAtgE3QgV2iljMLm7ie0YHs4RjH3C/KVkZTAF1fhgEBNbIQz
         LGZnwBH9WT/fg==
Date:   Tue, 24 Jan 2023 16:23:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
Message-ID: <20230124162347.48bdae92@kernel.org>
In-Reply-To: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
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

On Tue, 24 Jan 2023 13:08:01 +0200 Vladimir Oltean wrote:
> In the following call path:
> 
> ethnl_default_dumpit
> -> ethnl_default_dump_one
>    -> ctx->ops->prepare_data
>       -> stats_prepare_data  
> 
> struct genl_info *info will be passed as NULL, and stats_prepare_data()
> dereferences it while getting the extended ack pointer.
> 
> To avoid that, just set the extack to NULL if "info" is NULL, since the
> netlink extack handling messages know how to deal with that.
> 
> The pattern "info ? info->extack : NULL" is present in quite a few other
> "prepare_data" implementations, so it's clear that it's a more general
> problem to be dealt with at a higher level, but the code should have at
> least adhered to the current conventions to avoid the NULL dereference.

Choose one:
 - you disagree with my comment on the report
 - you don't think that we should mix the immediate fix with the
   structural change
 - you agree but "don't have the time" to fix this properly
