Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459946BEB5D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjCQOeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCQOeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA46BCB92
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679063594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FGq8hRY38mG0oGag1o8GCpq4u2BKR4UVG2BtfYvnhxM=;
        b=GRb5WbgUM05h6Wnp5vYSxxsyeY6yxibUb15+XSgyRvs+URFJdtOjxDJtECZ//coBmcQun3
        ZYm6ocrSrm7jpfyxkNcirhkZpU12Dbwb/ewLfEvDEhznBobvoBIjyd33TrjAj+ID3o0CFW
        D4JUOsQUHwlnmDpq9GJMWtS2pT0q9LU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-YqaPIojxNCipCvb45uQ81Q-1; Fri, 17 Mar 2023 10:33:12 -0400
X-MC-Unique: YqaPIojxNCipCvb45uQ81Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1467C889058;
        Fri, 17 Mar 2023 14:33:12 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B593D2166B26;
        Fri, 17 Mar 2023 14:33:11 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B482730721A6C;
        Fri, 17 Mar 2023 15:33:10 +0100 (CET)
Subject: [PATCH bpf-next V1 0/7] XDP-hints kfuncs for Intel driver igc
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com
Date:   Fri, 17 Mar 2023 15:33:10 +0100
Message-ID: <167906343576.2706833.17489167761084071890.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

Jesper Dangaard Brouer (7):
      xdp: bpf_xdp_metadata use EOPNOTSUPP for no driver support
      igc: enable and fix RX hash usage by netstack
      selftests/bpf: xdp_hw_metadata track more timestamps
      selftests/bpf: xdp_hw_metadata RX hash return code info
      igc: add igc_xdp_buff wrapper for xdp_buff in driver
      igc: add XDP hints kfuncs for RX timestamp
      igc: add XDP hints kfuncs for RX hash


 Documentation/networking/xdp-rx-metadata.rst  |  7 +-
 drivers/net/ethernet/intel/igc/igc.h          | 35 +++++++
 drivers/net/ethernet/intel/igc/igc_main.c     | 94 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 +-
 drivers/net/veth.c                            |  4 +-
 net/core/xdp.c                                | 10 +-
 .../selftests/bpf/progs/xdp_hw_metadata.c     | 17 ++--
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 51 ++++++++--
 tools/testing/selftests/bpf/xdp_metadata.h    |  1 +
 10 files changed, 194 insertions(+), 33 deletions(-)

--
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

