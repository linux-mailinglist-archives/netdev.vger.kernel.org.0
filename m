Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD420C9002
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfJBReD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:34:03 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:37338 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfJBReC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:34:02 -0400
Received: by mail-qk1-f202.google.com with SMTP id o133so19260769qke.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 10:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LCLLRHRqh5eDd/+AOwIrEOhvR2+XuRvYX6if88062Ec=;
        b=XfhIFnWgdn/7czF/MbMf9RFlAwx6xltTqS+edMHXHHwuOLs+nwCLXZrvFk6PjnE2j/
         UkJNv6mSHILbrycrOEgfat+Jphl+qK39Nl4MaldlUiqPJ7w/YfuSIez8FVW2j6iNUtm1
         VpPJViIiCDIhUoEBnXY1pKcCvyXE/YR47tncZpCVeMjPQ5GWQipX+3Kt2hl7QtU9qn07
         YWXHiCo+/yT8mH8ZWAWAlScbhr7SdwRtBuajpdG4DAs/l8+KkJ3U4Zes3aHrvvF0gRWD
         X/xhmqBTM6O6Q09gqj34cl367cexQsL8jvQs29G5En3+/P1zpYeAwDnj/YI6gze7qdbA
         kxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LCLLRHRqh5eDd/+AOwIrEOhvR2+XuRvYX6if88062Ec=;
        b=ZI3PC27b6KPYQhMBL/YKiN+PZv42DEy+sXy9HKZazi4CFSlhpacehtvxuyCepaQoPt
         09gIfzeOBH0JZbmB+htx40G8FiGyx2g0mMaX0jdThK/wvBeMjhdPZIvCqEe3NMqEKX8l
         4P4AO8wJw+j8ZufI9Nc9DgaYrA3iZ3biW/dx7SHD+Pi7iHWGh0GLHjWRK0jVdbfu/bSS
         nJ1AhOskEEGSDaJ7YEK1TfXaUoT90z+fKyDUmz47+4CM5LYTDDnXppkwXZ+06GIDQFQX
         sRMBeFCfZEplrp7m6Kv5Z70zYgnkA8jOPYMciswJ0/FwcMeOzNhdrOilOhlAHI1Ecyut
         6V1g==
X-Gm-Message-State: APjAAAVHUW3QkUjSfOs4XLFcgxOP8C2pytH/d5vOv902FazEcRscHKfq
        EYKutqEjpl/903Wf/dKDyu80cGKumujKOEGkyrDB+W5BUsz8FaJz53n4Bqc3fM98+jghS1R8K0z
        J6m4aFXmsYi4y6RIj2rBRyk5g67ZjtyBDf09WF1hB3hCuvduXOiOBnw==
X-Google-Smtp-Source: APXvYqwesAzQXb+pDDcFzHFZaa/1FLKUuQE5iCGv8xR9RwgCJq8EeN1ef/rTmL0AMcKF+f1k7Dbqc/M=
X-Received: by 2002:a05:6214:452:: with SMTP id cc18mr4124598qvb.41.1570037640285;
 Wed, 02 Oct 2019 10:34:00 -0700 (PDT)
Date:   Wed,  2 Oct 2019 10:33:55 -0700
Message-Id: <20191002173357.253643-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH bpf-next 0/2] bpf/flow_dissector: add mode to enforce global
 BPF flow dissector
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While having a per-net-ns flow dissector programs is convenient for
testing, security-wise it's better to have only one vetted global
flow dissector implementation.

Let's have a convention that when BPF flow dissector is installed
in the root namespace, child namespaces can't override it.

Note, that it's totally possible to attach flow_dissector programs
to several namespaces and then switch to a global one. In this case,
only the root one will trigger; users are still able to detach
flow_dissector programs from non-root namespaces.

Alternative solution might be something like a sysctl to enable
the global mode.

Cc: Petar Penkov <ppenkov@google.com>

Stanislav Fomichev (2):
  bpf/flow_dissector: add mode to enforce global BPF flow dissector
  selftests/bpf: add test for BPF flow dissector in the root namespace

 Documentation/bpf/prog_flow_dissector.rst     |  3 ++
 net/core/flow_dissector.c                     | 11 ++++-
 .../selftests/bpf/test_flow_dissector.sh      | 48 ++++++++++++++++---
 3 files changed, 55 insertions(+), 7 deletions(-)

-- 
2.23.0.444.g18eeb5a265-goog
