Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219974AC71E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiBGRSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378435AbiBGRNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:13:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78096C0401D6
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:13:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12BC26114D
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 17:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16E4C340ED;
        Mon,  7 Feb 2022 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644254002;
        bh=jQ5kviTUSLwJrejxRYxarfCVLhwoXR2PzuEQXkk7nf0=;
        h=From:To:Cc:Subject:Date:From;
        b=EcITQtO/khxQ122seozhb5Zb011M5qPzL5vdQak+kE/8spUqNbTCFTFBp53Wx11+S
         gDry+KJHapGnkqQ7jC4cyRdLmFgrJAoUWhh1gua46FAdc9Bbca3fTxQ3V3EeRuxXxi
         sdEsVESh9J9X4fwY3uVelX6L66F3n6HO+7e2WBLlz6BOXtIkf80XKwiviIgRvqOCv9
         2wF/8P2VWLQO0YQFQHZ+kuRhEZ+TGVjgsAkMVUdNxLUoM/NMS1IJp5i3RO02sNlfN3
         gfDmltH3x5RCa2sAhFDi+jYS+h8ExJtGJtIaojRUkRmL4tJANFO/WzME4+yFTbkjjn
         WmMFp6E05F4tA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org,
        daniel@iogearbox.net
Subject: [PATCH net v2 0/2] net: fix issues when uncloning an skb dst+metadata
Date:   Mon,  7 Feb 2022 18:13:17 +0100
Message-Id: <20220207171319.157775-1-atenart@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Since v1:
- Only allocate a dst cache if there is one already.
- Use metadata_dst_free in the dst_cache_init error path. This is OK as
  the dst_cache is zeroed on error.
- Protect the ret variable definition with CONFIG_DST_CACHE.
- Kept Vlad's Tested-by as the changes are minor.

Thanks!
Antoine

Antoine Tenart (2):
  net: do not keep the dst cache when uncloning an skb dst and its
    metadata
  net: fix a memleak when uncloning an skb dst and its metadata

 include/net/dst_metadata.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
2.34.1

