Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C736285A74
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgJGI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgJGI3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 04:29:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79E5C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 01:29:11 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQ4oo-000mUR-Ri; Wed, 07 Oct 2020 10:29:02 +0200
Message-ID: <7f26de5605d4d19eda19f35b2a239d7098fad7b3.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz,
        Saeed Mahameed <saeedm@nvidia.com>
Date:   Wed, 07 Oct 2020 10:29:01 +0200
In-Reply-To: <20201007082437.GV1874917@unreal>
References: <20201005220739.2581920-1-kuba@kernel.org>
         <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
         <20201006.062618.628708952352439429.davem@davemloft.net>
         <20201007062754.GU1874917@unreal>
         <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
         <20201007082437.GV1874917@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 11:24 +0300, Leon Romanovsky wrote:
> On Wed, Oct 07, 2020 at 09:30:51AM +0200, Johannes Berg wrote:
> > On Wed, 2020-10-07 at 09:27 +0300, Leon Romanovsky wrote:
> > > This series and my guess that it comes from ff419afa4310 ("ethtool: trim policy tables")
> > > generates the following KASAN out-of-bound error.
> > 
> > Interesting. I guess that is
> > 
> > 	req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
> > 
> > which basically means that before you never actually *use* the
> > ETHTOOL_A_STRSET_COUNTS_ONLY flag, but of course it shouldn't be doing
> > this ...
> > 
> > Does this fix it?
> 
> Yes, it fixed KASAN, but it we got new failure after that.

Good.

I'm not very familiar with ethtool netlink tbh :)

> 11:07:51 player_id: 1 shell.py:62 [LinuxEthtoolAgent] DEBUG : running command(/opt/mellanox/ethtool/sbin/ethtool --set-channels eth2 combined 3) with pid: 13409
> 11:07:51 player_id: 1 protocol.py:605 [OpSetChannels] ERROR : RC:1, STDERR:
> netlink error: Unknown attribute type (offset 36)
> netlink error: Invalid argument

That's even stranger, since strict validation should've meant this was
always rejected? Hmm.

Oh, copy/paste error I guess, try this:

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 8a85a4e6be9b..50d3c8896f91 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -830,8 +830,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_channels,
-		.policy = ethnl_channels_get_policy,
-		.maxattr = ARRAY_SIZE(ethnl_channels_get_policy) - 1,
+		.policy = ethnl_channels_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_channels_set_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_COALESCE_GET,

johannes

