Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FDF4A6F50
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiBBLBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343616AbiBBLBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:01:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB859C06173D
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 03:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68983B82FB3
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 11:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68865C004E1;
        Wed,  2 Feb 2022 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643799701;
        bh=m5pYUoF1Fw0KGwOlD2HPzQ/GM/AgNDPDO+utmIC0ctw=;
        h=From:To:Cc:Subject:Date:From;
        b=APKrw6UQKv3hpDqA1qwLplOzy42CbCnB/crHzGHXNRluRA0KKSZEYxko+BXzK+165
         hXhRXtvQjlPtKWofQ+xmF0ibtXu4wDVI2cUBNVd+rjkFi4fV0rMH5PGmrzmq8/O6jD
         C3XEYcTy2IQELq39+W+EGEDuR8XjodSc5wp474HJOhkTyOD741qtukk8qh6NGLeAe0
         mSVQ8A96f44XGDbsAUq5a+a57dHBFGJdjz/JWxb69Ano4xk+EgvhVN7z9lgdD5POHm
         UTQ2HjxmPNI59uk2mtG2H6wBWjJzqkTB5SKTkHkowBS/p3beg7WoA7iNMV5K/7i0L4
         TS3B4YceEixcw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net 0/2] net: fix issues when uncloning an skb dst+metadata
Date:   Wed,  2 Feb 2022 12:01:35 +0100
Message-Id: <20220202110137.470850-1-atenart@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This fixes two issues when uncloning an skb dst+metadata in
tun_dst_unclone; this was initially reported by Vlad Buslov[1]. Because
of the memory leak fixed by patch 2, the issue in patch 1 never happened
in practice.

tun_dst_unclone is called from two different places, one in geneve/vxlan
to handle PMTU and one in net/openvswitch/actions.c where it is used to
retrieve tunnel information. While both Vlad and I tested the former, we
could not for the latter. I did spend quite some time trying to, but
that code path is not easy to trigger. Code inspection shows this should
be fine, the tunnel information (dst+metadata) is uncloned and the skb
it is referenced from is only consumed after all accesses to the tunnel
information are done:

  do_execute_actions
    output_userspace
      dev_fill_metadata_dst         <- dst+metadata is uncloned
      ovs_dp_upcall
        queue_userspace_packet
          ovs_nla_put_tunnel_info   <- metadata (tunnel info) is accessed
    consume_skb                     <- dst+metadata is freed

Thanks!
Antoine

[1] https://lore.kernel.org/all/ygnhh79yluw2.fsf@nvidia.com/T/#m2f814614a4f5424cea66bbff7297f692b59b69a0

Antoine Tenart (2):
  net: do not keep the dst cache when uncloning an skb dst and its
    metadata
  net: fix a memleak when uncloning an skb dst and its metadata

 include/net/dst_metadata.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.34.1

