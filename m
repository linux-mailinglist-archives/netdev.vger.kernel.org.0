Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE95E8000
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIWQkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWQkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:40:24 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B45E66132;
        Fri, 23 Sep 2022 09:40:23 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r3-20020a05600c35c300b003b4b5f6c6bdso324784wmq.2;
        Fri, 23 Sep 2022 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ztanNduUnGSd7dD7GDwGomWb/rDw7QbXu95GTvi4NF0=;
        b=Dhj86Nu8sys2qFmqK/V06KlGFM2Xk5QRqvHqBbWESeHJK9IBEpXdsYMqurS6oqL8sh
         BCTS7yoYRCIOdEjH+HTth7f3xzp+tPFJMKJrZyfMTCwEe1xcXyHNGSlDHVZnY+FKP+2m
         jTA5CspELwx9Zv2Wi4x2gjsEAscYjvZZkNMx2OqKEsIRXgRxAA94lCgWqyO22rNYSFKN
         QfOhOg05PssrfrtXTvYS+CM0qNdZNrzBccmM/798kaCfBPfgbAsGyHs9/gg98+tbhByt
         p5Y4WKhyD05rBc2YBOQOA0iDfLR24IG7sBHDko59ezP0BaeeJm/r8uUkUePTM869Q0fs
         WSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ztanNduUnGSd7dD7GDwGomWb/rDw7QbXu95GTvi4NF0=;
        b=RM4h6gkRZHRlwN6tqdBym35folsUnSYl5q/xJ6SYLaldg8vIk5O2DHHej+YGJ5g5iP
         qB3jbLz6YRKyjyQmdKaRNQO06g4cwTNlsdZREu/41I+ZXg6ctj7KWiYGebg0ZMnKIkV8
         G6XlRxfPYu2OOLE7ks7KLww25hJ5fQHURziQ7NZZB8ETlaNowxx030ATbDKzEUcykN/W
         TrZHO/xgkZtUumSnpL8xTlz94JwXQEIRggF/uC92lSHnG/Bbkb0e0YSLqiuKAI6jaTD4
         en6fsdl0/xeQsmPUBWvJTMTNlyRyU0v8IC1fwJrUIYJJijtZoH8BePS4I4wqNIhiKcyj
         hsIA==
X-Gm-Message-State: ACrzQf3BCaz1nd6DexCLNMGru5Yfk9pquMjt6mPwPF/3OW+VPMpRPf8Z
        GhhgEN9Uv4Pks43Q8pn3yvxfqG9NZEA=
X-Google-Smtp-Source: AMsMyM4C/qvRMCrjlrQA/eLAYcbH57QXfOy2gaKCJNxGZjqOxXCGU/x4mo6mBgMbZcqI31K1kHtZHw==
X-Received: by 2002:a1c:7716:0:b0:3b4:b2ba:d190 with SMTP id t22-20020a1c7716000000b003b4b2bad190mr6595467wmi.35.1663951221338;
        Fri, 23 Sep 2022 09:40:21 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id x13-20020a5d60cd000000b0022af6c93340sm7717399wrt.17.2022.09.23.09.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:40:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 0/4] shrink struct ubuf_info
Date:   Fri, 23 Sep 2022 17:39:00 +0100
Message-Id: <cover.1663892211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ubuf_info is large but not all fields are needed for all
cases. We have limited space in io_uring for it and large ubuf_info
prevents some struct embedding, even though we use only a subset
of the fields. It's also not very clean trying to use this typeless
extra space.

Shrink struct ubuf_info to only necessary fields used in generic paths,
namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
make MSG_ZEROCOPY and some other users to embed it into a larger struct
ubuf_info_msgzc mimicking the former ubuf_info.

Note, xen/vhost may also have some cleaning on top by creating
new structs containing ubuf_info but with proper types.

Pavel Begunkov (4):
  net: introduce struct ubuf_info_msgzc
  xen/netback: use struct ubuf_info_msgzc
  vhost/net: use struct ubuf_info_msgzc
  net: shrink struct ubuf_info

 drivers/net/xen-netback/common.h    |  2 +-
 drivers/net/xen-netback/interface.c |  4 +--
 drivers/net/xen-netback/netback.c   |  7 +++---
 drivers/vhost/net.c                 | 15 ++++++------
 include/linux/skbuff.h              | 11 +++++++--
 net/core/skbuff.c                   | 38 ++++++++++++++++-------------
 net/ipv4/ip_output.c                |  2 +-
 net/ipv4/tcp.c                      |  2 +-
 net/ipv6/ip6_output.c               |  2 +-
 9 files changed, 48 insertions(+), 35 deletions(-)

-- 
2.37.2

