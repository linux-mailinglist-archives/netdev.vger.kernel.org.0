Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D79A2DD5FC
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgLQRYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgLQRYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:24:07 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35265C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 09:23:27 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x17so17898290ybs.12
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 09:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=jzYMmW6juKzvxHSLq/5hwBc5kF7GCeBG4ufj8Bugw9M=;
        b=RWwQyODvZZM+uyf/toQAhYiCkNTOndjUkABM0xt0Z5R3lQx1W/9RPSdseEAET05Z+t
         BUxSjp5MrU9RLheL6xAm0b/gKYX0Cqx+FMpe2XHxWP1WRJe8S15jKt0p9sEJwp7/A1u2
         cUC6ZdwVIWfnAI56H309uhh0FKzmbqTE7slv3fbvGKexw7oYkom1cIluOtkQtwSChIxr
         ISpvJtvplBaPnM0WiRn7zXFG2ZvbUOLUT2+fKSnBmcrnOf4tY+TqMsIj7B0yB1oA7fv/
         wI3UKYRPPURrM/RdvLqOjjFuMv6LSZRY1btIEqfey1pxJWpPZ5ig6aJUa0FCMP64bylH
         TdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=jzYMmW6juKzvxHSLq/5hwBc5kF7GCeBG4ufj8Bugw9M=;
        b=og9JaRpt/zkZ0x1eK9/tvQFHLdd939hUxWyNRn/QSzWqxBQ0ei3LKekKEtPgYHEm+9
         uMron7LM4vkXQGWvVYY9EByiK5/sgmt+j+188ghMwmuVxaEm79lkXK1jkcDHcasRiB4e
         rJYlVTop2ydfQ3dfFQxu/oQhf0Eur2xTILKdkKdjoK6QBvKckPkM4crGZliBT38Y3BL+
         ZM3PZRsSUHaY+/rUnI0MOnAn3X2oIyQ08NaKY4ccDCDq7CqSItaGl0TvZRoD5ACP4Bqw
         CkUPzoeu49Q06m4K9os7YIUV4K+8roSiO2B2cQINKISc3f8c+a68J4P4980Oi8eq71tW
         xwSQ==
X-Gm-Message-State: AOAM533EwXyrPgxuW8NuZI1/7KUKv18KwXu+2ONXxDRPjhvCcpfH2BWz
        gC9wXplhxH4mt5yx6SB6HytaLrFpxE4UzKsLeAzUfMkKDJdmtMF0nV782AL1Y7FNfO3Mirsq/Y3
        db1+jC1UgXXbUEHZIIxg4kRFMMUffEMfoQZj5YJQHomeRvCj3GPHOhQ==
X-Google-Smtp-Source: ABdhPJzAiTxJQ0EyXMtBNXBGGGzrVyDi8x2AnhE4f33zXzrHus2TvD8QLRz2VxYZ9rJlc8p8JdM4V0w=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a5b:4d2:: with SMTP id u18mr230847ybp.71.1608225806251;
 Thu, 17 Dec 2020 09:23:26 -0800 (PST)
Date:   Thu, 17 Dec 2020 09:23:22 -0800
Message-Id: <20201217172324.2121488-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH bpf-next 0/2] bpf: misc performance improvements for cgroup hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch tries to remove kzalloc/kfree from getsockopt for the
common cases.

Second patch switches cgroup_bpf_enabled to be per-attach to
to add only overhead for the cgroup attach types used on the system.

No visible user-side changes.

Stanislav Fomichev (2):
  bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
  bpf: split cgroup_bpf_enabled per attach type

 include/linux/bpf-cgroup.h | 36 +++++++++++++------------
 include/linux/filter.h     |  3 +++
 kernel/bpf/cgroup.c        | 55 +++++++++++++++++++++++++++++++-------
 net/ipv4/af_inet.c         |  9 ++++---
 net/ipv4/udp.c             |  7 +++--
 net/ipv6/af_inet6.c        |  9 ++++---
 net/ipv6/udp.c             |  7 +++--
 7 files changed, 83 insertions(+), 43 deletions(-)

-- 
2.29.2.729.g45daf8777d-goog

