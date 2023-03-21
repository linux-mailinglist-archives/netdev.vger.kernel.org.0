Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618AE6C3331
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCUNrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCUNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:47:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E1237B40
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679406427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=u0vcj8yQCVSq1K7a3xv3DSDoQVn1iGPLpiir1Gw25As=;
        b=WuFs+6ttkbrHFSU0/BH1lngFzyVF6qOk45BL6PG20zsaidsaPxs2wSKej1G5dQq0mpLPXT
        7+Ho3RFQ1OHehXnf3hliGu77V8NO6cb09NSt4iDFqhoSWuLZYr3tWeJOge6b+rGvgDqEXT
        Z9/1SkvSUYRGxjWGhW8HZLEX2t9u3vs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-RJS224pMPayh0XBeCSSY6Q-1; Tue, 21 Mar 2023 09:47:04 -0400
X-MC-Unique: RJS224pMPayh0XBeCSSY6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0C1F3815F79;
        Tue, 21 Mar 2023 13:47:02 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62BA040C6E68;
        Tue, 21 Mar 2023 13:47:02 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 809E8300000D0;
        Tue, 21 Mar 2023 14:47:01 +0100 (CET)
Subject: [PATCH bpf-next V2 0/6] XDP-hints kfuncs for Intel driver igc
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
Date:   Tue, 21 Mar 2023 14:47:01 +0100
Message-ID: <167940634187.2718137.10209374282891218398.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implemented XDP-hints metadata kfuncs for Intel driver igc.

Primarily used the tool in tools/testing/selftests/bpf/ xdp_hw_metadata,
when doing driver development of these features. Recommend other driver
developers to do the same. In the process xdp_hw_metadata was updated to
help assist development. I've documented my practical experience with igc
and tool here[1].

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/hints/xdp_hints_kfuncs02_driver_igc.org

This patchset implement RX-hash as a simple u32 value (as this is the
current kfunc API), but my experience with RX-hash is that we will also
need to provide the Hash-type for this raw value to be useful to
BPF-developers. This will be addressed in followup work once this patchset
lands.

---

Jesper Dangaard Brouer (6):
      igc: enable and fix RX hash usage by netstack
      selftests/bpf: xdp_hw_metadata track more timestamps
      selftests/bpf: xdp_hw_metadata RX hash return code info
      igc: add igc_xdp_buff wrapper for xdp_buff in driver
      igc: add XDP hints kfuncs for RX timestamp
      igc: add XDP hints kfuncs for RX hash


 drivers/net/ethernet/intel/igc/igc.h          | 35 +++++++
 drivers/net/ethernet/intel/igc/igc_main.c     | 94 ++++++++++++++++---
 .../selftests/bpf/progs/xdp_hw_metadata.c     | 18 ++--
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 51 ++++++++--
 tools/testing/selftests/bpf/xdp_metadata.h    |  1 +
 5 files changed, 176 insertions(+), 23 deletions(-)

--


