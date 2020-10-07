Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A55285990
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 09:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgJGHbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 03:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgJGHbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 03:31:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FD7C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 00:31:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQ3uW-000krV-W2; Wed, 07 Oct 2020 09:30:53 +0200
Message-ID: <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz,
        Saeed Mahameed <saeedm@nvidia.com>
Date:   Wed, 07 Oct 2020 09:30:51 +0200
In-Reply-To: <20201007062754.GU1874917@unreal>
References: <20201005220739.2581920-1-kuba@kernel.org>
         <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
         <20201006.062618.628708952352439429.davem@davemloft.net>
         <20201007062754.GU1874917@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 09:27 +0300, Leon Romanovsky wrote:
> 
> This series and my guess that it comes from ff419afa4310 ("ethtool: trim policy tables")
> generates the following KASAN out-of-bound error.

Interesting. I guess that is

	req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];

which basically means that before you never actually *use* the
ETHTOOL_A_STRSET_COUNTS_ONLY flag, but of course it shouldn't be doing
this ...

Does this fix it?

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3f5719786b0f..d8efec516d86 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,7 +347,7 @@ extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
-extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_STRINGSETS + 1];
+extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_ONLY + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 0734e83c674c..0baad0ce1832 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -103,6 +103,7 @@ const struct nla_policy ethnl_strset_get_policy[] = {
 	[ETHTOOL_A_STRSET_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STRSET_COUNTS_ONLY]	= { .type = NLA_FLAG },
 };
 
 static const struct nla_policy get_stringset_policy[] = {

johannes

