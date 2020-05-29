Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F7E1E8BBA
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgE2XGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgE2XGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:06:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54A5C03E969;
        Fri, 29 May 2020 16:06:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 64so536140pfg.8;
        Fri, 29 May 2020 16:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Dv99wc4oneeV++Xt/D6Qz05PNabmk1yN+6Cw9gD7T7I=;
        b=c1rcg1D8viKOREBKo2W/dRoAnXyRSpAYJ7nnuASBtAD3EITve6uEaKl7G4j1zEajq6
         +l71M49a4Gdeoh8/aSqIph1J6CID9lOtD4M6TKdiWLLu4g6/9q2U3WKaQrnGDpWiuqW4
         aVcKX5LwczwG6e8LvHLUSYKvD44yVrFOcmr8z4sJ96hRQNTlYFiYucXwyl4W7uWiBhVG
         06YNy1WLngcWxZK5yY3IBaKPdS/oB74FrqAI9uwOYrnmS5lS7KmNKrMF0UOYPjRX9iKV
         ygFsV640vJcNnMw4PGA9Q3m4vSwYiuEiTcQXBg3+tHJch8lB06I/6pudKsfd19sc9okN
         SAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Dv99wc4oneeV++Xt/D6Qz05PNabmk1yN+6Cw9gD7T7I=;
        b=QkCcv1PzCdLukS2S/iGr3THrPAcW4RvPYGMCM8nzampg4n2ep2rDD6HICt+RkUJOjH
         1JreslSGNuihCDdRaXKfhqOo4cJWhhJNzMfes3omDYQ6jhPucyarwcOynZl3GiNYbBiE
         7YjAz8erNEPQL5ZjHGvKos83XlFcmA8ISXXRfvZXOTRNLMJDlqzY9Knb54j+ZyxIvQpd
         Cvba8piSgM14h71CdCfvX+LnZwknEDsLrg70OJto6mp2GRjz5wxsYlrAjrx0WGkuDwfj
         gUeFHqswy12sa6+Iru0ooOLF59M1nYdFnmBx1IltnN762MQ1mas5NKwI9DELdxcNQIro
         egUg==
X-Gm-Message-State: AOAM5333bxr+vnvDtbyasSCHfy6n9b5+F++wur6C3NP/3mXfRCHbIxDQ
        +wHit5mkK7hbBqMjt6YUrOR7WftZL64=
X-Google-Smtp-Source: ABdhPJwNU64b2VrDzs8l9YwhIzpYt74zJ48y7VhHJXAQqJd6ppVaTp5fC1qN4u8aaYjK6uhJ1/e56g==
X-Received: by 2002:a62:780c:: with SMTP id t12mr10588621pfc.235.1590793594156;
        Fri, 29 May 2020 16:06:34 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j16sm7871133pfa.179.2020.05.29.16.06.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 May 2020 16:06:32 -0700 (PDT)
Subject: [bpf-next PATCH 0/3] fix ktls with sk_skb_verdict programs
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Fri, 29 May 2020 16:06:20 -0700
Message-ID: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a socket is running a BPF_SK_SKB_SREAM_VERDICT program and KTLS is
enabled the data stream may be broken if both TLS stream parser and
BPF stream parser try to handle data. Fix this here by making KTLS
stream parser run first to ensure TLS messages are received correctly
and then calling the verdict program. This analogous to how we handle
a similar conflict on the TX side.

Note, this is a fix but it doesn't make sense to push this late to
bpf tree so targeting bpf-next and keeping fixes tags.

---

John Fastabend (3):
      bpf: refactor sockmap redirect code so its easy to reuse
      bpf: fix running sk_skb program types with ktls
      bpf, selftests: add test for ktls with skb bpf ingress policy


 include/linux/skmsg.h                              |    8 +
 include/net/tls.h                                  |    9 +
 net/core/skmsg.c                                   |   98 +++++++++---
 net/tls/tls_sw.c                                   |   20 ++
 .../selftests/bpf/progs/test_sockmap_kern.h        |   46 ++++++
 tools/testing/selftests/bpf/test_sockmap.c         |  163 +++++++++++++++++---
 6 files changed, 296 insertions(+), 48 deletions(-)

--
Signature
