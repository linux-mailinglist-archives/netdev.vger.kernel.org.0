Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8904A6CCB4F
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjC1UQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjC1UQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:16:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30FE3A9C
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680034562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YigewdPBeYqOsJxoAFsWFxZgQfPRMsLTddttN90KAIE=;
        b=XO2Tw0Tf6xFH8OUBAps9wViD87yzdB6KUVb3fJiut0tiB9FljfIn97+UnP+GPVuMiRGVXS
        Xwoi/kwfMTSd9BijDNRVkFA4Fg2ZEWkHt6lXyd7CDlvGfX5rh7jzR+pcqm8ZOGLNPapy8T
        2Njfe0Ys1/b30GrJdopqMJue+1bAAs8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-OoImuCilPmWJnwZP-4tI8Q-1; Tue, 28 Mar 2023 16:15:55 -0400
X-MC-Unique: OoImuCilPmWJnwZP-4tI8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 858DB101A553;
        Tue, 28 Mar 2023 20:15:54 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E8DD440D6;
        Tue, 28 Mar 2023 20:15:54 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 21EE330736C72;
        Tue, 28 Mar 2023 22:15:53 +0200 (CEST)
Subject: [PATCH bpf RFC 0/4] XDP-hints: API change for RX-hash kfunc
 bpf_xdp_metadata_rx_hash
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Date:   Tue, 28 Mar 2023 22:15:53 +0200
Message-ID: <168003451121.3027256.13000250073816770554.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Notice targeted 6.3-rc kernel via bpf git tree.

Current API for bpf_xdp_metadata_rx_hash() returns the raw RSS hash value,
but doesn't provide information on the RSS hash type (part of 6.3-rc).

This patchset proposal is to use the return value from
bpf_xdp_metadata_rx_hash() to provide the RSS hash type.

---

Jesper Dangaard Brouer (4):
      xdp: rss hash types representation
      igc: bpf_xdp_metadata_rx_hash return xdp rss hash type
      veth: bpf_xdp_metadata_rx_hash return xdp rss hash type
      mlx5: bpf_xdp_metadata_rx_hash return xdp rss hash type


 drivers/net/ethernet/intel/igc/igc_main.c     | 22 ++++++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 61 ++++++++++++++++++-
 drivers/net/veth.c                            |  2 +-
 include/linux/mlx5/device.h                   | 14 ++++-
 include/net/xdp.h                             | 54 ++++++++++++++++
 net/core/xdp.c                                |  4 +-
 6 files changed, 150 insertions(+), 7 deletions(-)

--

