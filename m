Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40050232281
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgG2QWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:22:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A9AC061794;
        Wed, 29 Jul 2020 09:22:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id t15so16215730iob.3;
        Wed, 29 Jul 2020 09:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=1EqVIb9BsdjO4rYSsZXqgwp+ZVH+Gjm0Lf044F3bu7M=;
        b=QcbWmzeevs1bU1vWCuHRf1A+ffecp/H8CLVlHKf5bTHUuX/LwxRWj/W5D+WVtUTr70
         /m61RogQi2vspeDWgA0xsV1njVjJNXc4CriL1FeZPXB8OHks/ojphSIxppEnAkIreX9Y
         vveRzoSaCxidnd61IgDrPKWtOOibQKaDqtLy4HTWosywVl4Iwqegk3DbCRNPWwx+20kV
         1AyF7YCMwPYvq/RlHXv7LM5bJ49x4yGHLQEczCbgnLqATNFSzJeY29ElWr8O4l8M6jhS
         O/+JWra0jgUphXBxX50NUbdC4cpZm/PfAtrhGgxTz5cvhPU1ZqIOhix9dxKhrNVk7iX2
         2yoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=1EqVIb9BsdjO4rYSsZXqgwp+ZVH+Gjm0Lf044F3bu7M=;
        b=q1TaS00J/upX/y3vBXjka3NzX1lF1a1xcQmNxvsHZdSWPvy2mXHiw3ghl9nX+nkmBD
         29ruGE5FgzHjDTO5xhoGarq1DQDrIEo4wXOh9iIIYh1HfdbdBqv35DeUiBx6Qtj8Xh1J
         966StvySZd+dUkfzx4nzroZmEVZAs9hms3YcERGSVkGkAqF7wknW2FC/6MsJBwMB3ZQx
         7h3i7W0ghIf6CkhP7LOrOBuDC7DL3LwLDenH9wexqDW0ypqeV2DP3aQi7meRFD1mkwGZ
         hmTBL8IDiEO9+7ZexT/0n5qssa/DSAccTqy5tkfg6L5vKV224EzVHgnXuPUca1kBwY3F
         4sRw==
X-Gm-Message-State: AOAM5321l2tLmH4Vxbsuprph+FcWapy9sIMxQbNwoIQzTjKGYkUd6tdO
        6eRoJsmrC4xwfKAgX9tWLEQ=
X-Google-Smtp-Source: ABdhPJx1iVSptKTNIYoa1wPr0j1LIvJ99SMLVQOQkCJ4lch5jlr0AUqRuP6rEOjGdewCO523dmlJIA==
X-Received: by 2002:a05:6638:27a:: with SMTP id x26mr9155350jaq.43.1596039768749;
        Wed, 29 Jul 2020 09:22:48 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n9sm1194576iox.43.2020.07.29.09.22.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 09:22:48 -0700 (PDT)
Subject: [bpf PATCH v2 0/5] Fix sock_ops field read splat
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 29 Jul 2020 09:22:36 -0700
Message-ID: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing some refactoring resulted in a kernel splat when reading sock_ops
fields.

Patch 1, has the details and proposed fix for sock_ops sk field access.

Patch 2, has the details and proposed fix for reading sock_ops->sk field

Patch 3, Gives a reproducer and test to verify the fix. I used the netcnt
program to test this because I wanted a splat to be generated which can
only be done if we have real traffic exercising the code.

Patch 4, Is an optional patch. While doing above I wanted to also verify
loads were OK. The code looked good, but I wanted some xlated code to
review as well. It seems like a good idea to add it here or at least
shouldn't hurt. I could push it into bpf-next if folks want.

Patch 5, Add reproducers for reading scok_ops->sk field.

I split Patch1 and Patch2 into two two patches because they have different
fixes tags. Seems like this will help with backporting. They could be
squashed though if folks want.

For selftests I was fairly verbose creating three patches each with the
associated xlated code to handle each of the three cases. My hope is this
helps the reader understand issues and review fixes. Its more or less
how I debugged the issue and created reproducers so it at least helped
me to have them logically different patches.

---

John Fastabend (5):
      bpf: sock_ops ctx access may stomp registers in corner case
      bpf: sock_ops sk access may stomp registers when dst_reg = src_reg
      bpf, selftests: Add tests for ctx access in sock_ops with single register
      bpf, selftests: Add tests for sock_ops load with r9,r8.r7 registers
      bpf, selftests: Add tests to sock_ops for loading sk


 net/core/filter.c                                  |   75 +++++++++++++++++---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   41 +++++++++++
 2 files changed, 103 insertions(+), 13 deletions(-)

--
Signature
