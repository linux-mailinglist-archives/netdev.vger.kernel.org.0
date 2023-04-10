Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDEA6DC572
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjDJKAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjDJKAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:00:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9B62724
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681120753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=uJvOa7LFM2bOkuHwfjLxa7GJKZjAwokz30/dDQKsN38=;
        b=HMJ/bsd9xt2kEDW+V5N5cC1hvrZzbU7GHJYsVAu4IknAXTN4QLvmDn+LSZrvV30ZakY0fP
        SRQk/Dt83t9su1DFopA2tRaWxBswS/nCkPJJBTaI6jtpJopjDnpMKl2LRjNIRDxpaMGaVD
        DLMaHxShFVv21c0fL0cZixCduNcU4Bg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-N9UAmqIOOo2Yc5kah93uZg-1; Mon, 10 Apr 2023 05:59:11 -0400
X-MC-Unique: N9UAmqIOOo2Yc5kah93uZg-1
Received: by mail-wm1-f70.google.com with SMTP id l36-20020a05600c1d2400b003edd119ec9eso1230074wms.0
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681120750;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uJvOa7LFM2bOkuHwfjLxa7GJKZjAwokz30/dDQKsN38=;
        b=4KBBAfNcG4+uU4v6r9VF1R5Sdjw2EBQsw0NoZ+9M5GvzinQbo2EXX7e60PrNqlR6bs
         t5H49hW2/+A0w/8N+CChDsa/6VssIe6LaeEa3t8OSwxBqQbpfCqF5We4Is1Km0DXGTgv
         +rAi4S8KvhhgW77dtMPWbfjobA4XZKTEESf13T6WWU4t7sxVhIZF9KBlpECqY76fMFNY
         Mc8YhUUcHd28h4zl3G3w5Uy9xgxVlQnLUbPNrBGZ4AwFpketmS/jIYOVH+ldfozMoEHv
         CZCG5ZxPicJFLWrbCCJyx9+veSfZqSIW00ozR9xiNIoYW5lxGIjtq/NlOe4WhIrIlk+A
         7f2w==
X-Gm-Message-State: AAQBX9fbowO6G0Inx3a4v+/5WugAGoMCRZD2+j3EEkOOe4cv6tYT6ngw
        QQB6kK8XjuH7SQmfgY9CUM0sic9TG9D6D6Zt1p78WaY7JNRv2CtLc5fDrwBR6JzlLjWHbqVUQqs
        CNtcOt9KY5qzgvpbz
X-Received: by 2002:a05:600c:2943:b0:3ef:7584:9896 with SMTP id n3-20020a05600c294300b003ef75849896mr6959663wmd.26.1681120750450;
        Mon, 10 Apr 2023 02:59:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z30LdFNxP5ZQi1zfpPyj3+VkS0rk+HJ/ivJkKnkBzKZggmXuWGnhpVaBiJ6bt8dTXMSJpqug==
X-Received: by 2002:a05:600c:2943:b0:3ef:7584:9896 with SMTP id n3-20020a05600c294300b003ef75849896mr6959648wmd.26.1681120750180;
        Mon, 10 Apr 2023 02:59:10 -0700 (PDT)
Received: from redhat.com ([2.52.31.213])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c4fcb00b003ebff290a52sm16987302wmq.28.2023.04.10.02.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 02:59:09 -0700 (PDT)
Date:   Mon, 10 Apr 2023 05:59:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.fomichev@wdc.com, elic@nvidia.com, jasowang@redhat.com,
        michael.christie@oracle.com, mst@redhat.com, sgarzare@redhat.com,
        stable@vger.kernel.org, zwisler@chromium.org, zwisler@google.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20230410055906-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 7e364e56293bb98cae1b55fd835f5991c4e96e7d:

  Linux 6.3-rc5 (2023-04-02 14:29:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 9da667e50c7e62266f3c2f8ad57b32fca40716b1:

  vdpa_sim_net: complete the initialization before register the device (2023-04-04 14:22:12 -0400)

----------------------------------------------------------------
virtio: last minute fixes

Some last minute fixes - most of them for regressions.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dmitry Fomichev (2):
      virtio-blk: fix to match virtio spec
      virtio-blk: fix ZBD probe in kernels without ZBD support

Eli Cohen (1):
      vdpa/mlx5: Add and remove debugfs in setup/teardown driver

Mike Christie (2):
      vhost-scsi: Fix vhost_scsi struct use after free
      vhost-scsi: Fix crash during LUN unmapping

Ross Zwisler (1):
      tools/virtio: fix typo in README instructions

Stefano Garzarella (1):
      vdpa_sim_net: complete the initialization before register the device

 drivers/block/virtio_blk.c           | 269 ++++++++++++++++++++++-------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   8 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  13 +-
 drivers/vhost/scsi.c                 |  39 +----
 include/uapi/linux/virtio_blk.h      |  18 +--
 tools/virtio/virtio-trace/README     |   2 +-
 6 files changed, 205 insertions(+), 144 deletions(-)

