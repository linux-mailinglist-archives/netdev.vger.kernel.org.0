Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0886A6E11EE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjDMQNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDMQNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:13:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A77CF;
        Thu, 13 Apr 2023 09:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFD5863E84;
        Thu, 13 Apr 2023 16:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E4FC433D2;
        Thu, 13 Apr 2023 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681402391;
        bh=WFL8bYhH3x0BIzgVY6RGVd6JNmx2NXv89vVV8SM0+cc=;
        h=From:To:Cc:Subject:Date:From;
        b=ThGUbHOH8fqQ+2zNkNTFew5Daiu/16iKwtGhCiJa3mdSq9GK1jjfl3i26AEGxN1xl
         stauklDJV00CGpkYFObty05OakcsWF7SeYW2d2C+zslEYIw8HlIP2cf8LaAs6hO+rx
         LHyAK76qlfW640Tqg1JgQMhIeYu8J2Py8/AaCxz6k01NN0tQj7U2lmpCJyC0wOfLuD
         7reyfktCTyVCS3uIAmJGhPV+cyKqywoldTdf8YDPPMCbjM8/aXlckX8GeH9AGj1CeN
         +BrRwsDu9pnCDjuvk33IaQnhuSsXwYHnxEzn8aOxuyf5FzLPlo2WneMvM0ZDrDMymT
         FbcU4tgE6RN/w==
From:   broonie@kernel.org
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Christian Ehrig <cehrig@cloudflare.com>,
        Gavin Li <gavinl@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the net-next tree
Date:   Thu, 13 Apr 2023 17:12:35 +0100
Message-Id: <20230413161235.4093777-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  include/net/ip_tunnels.h

between commit:

  bc9d003dc48c3 ("ip_tunnel: Preserve pointer const in ip_tunnel_info_opts")

from the net-next tree and commit:

  ac931d4cdec3d ("ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc include/net/ip_tunnels.h
index 255b32a90850a,7912f53caae0b..0000000000000
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@@ -66,15 -73,9 +73,16 @@@ struct ip_tunnel_encap 
  #define IP_TUNNEL_OPTS_MAX					\
  	GENMASK((sizeof_field(struct ip_tunnel_info,		\
  			      options_len) * BITS_PER_BYTE) - 1, 0)
 +
 +#define ip_tunnel_info_opts(info)				\
 +	_Generic(info,						\
 +		 const struct ip_tunnel_info * : ((const void *)((info) + 1)),\
 +		 struct ip_tunnel_info * : ((void *)((info) + 1))\
 +	)
 +
  struct ip_tunnel_info {
  	struct ip_tunnel_key	key;
+ 	struct ip_tunnel_encap	encap;
  #ifdef CONFIG_DST_CACHE
  	struct dst_cache	dst_cache;
  #endif
