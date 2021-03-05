Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFABC32E512
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCEJlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhCEJl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 04:41:26 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237E5C061574;
        Fri,  5 Mar 2021 01:41:26 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k9so2488966lfo.12;
        Fri, 05 Mar 2021 01:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zUkMZUX9AyOx0RtPoMi/jAtGYWCFGXDYD+xdaqcngtQ=;
        b=eqZ8UJN3OTqASemabvVVmOh2KjdlI4WkQjVVly016+a7BV3jd37QOXe1Eh5c91Mwc+
         gnfY3KDaToxHg4FVK/xXzFPwzoL16vNxv81rIoKNluwcWFuO6CxYjbhUMFV7yzH4MdFH
         od+N3rVR6Ne2lJs4CN7YNcmkOIgoMrZ18gPa603iO66b//uDct7QcfZd3Dk/J5KZQMVg
         ra2Iaz0V3Ji2EQRJ66mgCaSCgE4X5WMnBR0JSM8Kp+ESfehuDM9imo//vJYRFiEHn/eX
         oKbq6m2C5JAsUHSxCtStYPdgOvAdQuZSe0NMZD+HtZClEKC0KXbT5ArQpB55Ibf7qnvI
         pgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zUkMZUX9AyOx0RtPoMi/jAtGYWCFGXDYD+xdaqcngtQ=;
        b=ZYOgnFtEz03bpvvLY3OU1GMWaRpcaaWkig+jvcHiwXmMZ5XGP6EeLyRKKkj3z58Iim
         NiwV3CTpAmBUJzYSUAJ1S7Dl4C4KfenFMVd26pQqy6YblCFDTfkbkEKQMNhJ3a4OBbOC
         QCbXxn5TSL/+IyT/zRPiNFhEj87f8ZvsFbl8wmY1OHt7B6OtdXYD+iBx8byVkXhwR2Yv
         PKG8F86KnOUqLGKD/lI6vPfG1Ui0CykrCo5WM7TFu4e8PNp8ubaDcXjiGZLCLaQl3lUH
         7QRfnBuRBOw4qfMG/pa2vW5Rxjb5qyfpQWtu8UGuthRjYUeKdRdOap5v0/C0ILm2TxlV
         BLTA==
X-Gm-Message-State: AOAM530P9mSyCjrjd5VdVpo0j+qALB7t2Q7wMZ5/HCbZUHHY/fCNPJNo
        n33gRbUy6E9T9T9/AH7uKWU=
X-Google-Smtp-Source: ABdhPJymyCDcf7UtdzoTdbTNIi1+0YyzQFzDZ8BOF7BQUGh/yXLVn2rsQAVh/CITsHG5up9YyyF7zg==
X-Received: by 2002:a19:234b:: with SMTP id j72mr4778121lfj.293.1614937284660;
        Fri, 05 Mar 2021 01:41:24 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id v80sm235371lfa.229.2021.03.05.01.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:41:24 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, andrii@kernel.org,
        toke@redhat.com, will@kernel.org, paulmck@kernel.org,
        stern@rowland.harvard.edu
Subject: [PATCH bpf-next v2 0/2] load-acquire/store-release barriers for AF_XDP rings
Date:   Fri,  5 Mar 2021 10:41:11 +0100
Message-Id: <20210305094113.413544-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This two-patch series introduces load-acquire/store-release barriers
for the AF_XDP rings.

For most contemporary architectures, this is more effective than a
SPSC ring based on smp_{r,w,}mb() barriers. More importantly,
load-acquire/store-release semantics make the ring code easier to
follow.

This is effectively the change done in commit 6c43c091bdc5
("documentation: Update circular buffer for
load-acquire/store-release"), but for the AF_XDP rings.

Both libbpf and the kernel-side are updated.

Full details are outlined in the commits!

Thanks to the LKMM-folks (Paul/Alan/Will) for helping me out in this
complicated matter!

@Andrii I kept the barriers in libbpf_util.h to separate userfacing
        APIs (xsk.h) from internals.

@Toke I kept "barriers" but reworded. Acquire/release are also
      barriers.

@Will I'd really appreciate if you could take a look this change.

Changelog

v1[1]->v2: 
* Expanded the commit message for patch 1, and included the LKMM
  litmus tests. Hopefully this clear things up. (Daniel)

* Clarified why the smp_mb()/smp_load_acquire() is not needed in (A);
  control dependency with load to store. (Toke)

[1] https://lore.kernel.org/bpf/20210301104318.263262-1-bjorn.topel@gmail.com/

Thanks,
Björn


Björn Töpel (2):
  xsk: update rings for load-acquire/store-release barriers
  libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire

 net/xdp/xsk_queue.h         | 30 +++++++---------
 tools/lib/bpf/libbpf_util.h | 72 +++++++++++++++++++++++++------------
 tools/lib/bpf/xsk.h         | 17 +++------
 3 files changed, 68 insertions(+), 51 deletions(-)


base-commit: bce8623135fbe54bd86797df72cb85bfe4118b6e
-- 
2.27.0

