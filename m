Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1549D45815A
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 01:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhKUAe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 19:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbhKUAe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 19:34:57 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6201FC06173E
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 16:31:53 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id g18so12534463pfk.5
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 16:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XxGWmTZwHsm0RN01kjRmL3HzDw86SFLpP/0ZpXpaZRc=;
        b=mqLPe+mzN9Dl/E2s2wRLW9ghNZxzkxV9cQ7rzDcRi9/vEWM/1M/T9ZtHoNE4KsrZ5j
         0dUrpsPnoEXXwUde09T2wZxbStgM88DZvGgmc0978ncxOd0TJDgINT5vSKtNkNjbTJUo
         9aK6twgJ7kHLOHU+XH7Ad1bYAiBkodz9okdE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XxGWmTZwHsm0RN01kjRmL3HzDw86SFLpP/0ZpXpaZRc=;
        b=EA4FMcxQa1pW86AxmhO2Dq47cltwUwEZ+UHBe8L9L8F+CQONN2c5SvX+FRmhxS/B5m
         mW2isCQk/4HsKbJ9pK3TUl8w8pjYRRnKu024SJLbV8nPShx6VzCg7qXHZrbmMQVcRXr6
         k3XngmwYRAoQqjJ+nROlWb+gZZFBJz7OKq7nMPg9OPz/SPPI/Hq0dgvJSL57TauenleJ
         HPpWHR2mZjIa2bMbuaTnnXrmj9qXKfg7t+WLyLB0Pn5ROGrnSvgP/DiiBE0aqclYEGfu
         cofpa8rSavN5B02LdcDrdZolmwXzuY5lZDtIM3JT+FgxvWjkdBMn0hMSA7kpTC8bqhr8
         2IpQ==
X-Gm-Message-State: AOAM533I3NMouQl2ksFwqxmvEX5PMf8+YorUlNkxct/62oOiodEllL2S
        3Fn3beFh9v0Pc4wyAP3s173QvA==
X-Google-Smtp-Source: ABdhPJx48K+tBtBfbJQf3sSRXIucI8Y6zCrUy5h3//aCrSN9nw8UbzVlU9gBgDoTvSGJtDP7M2mUdg==
X-Received: by 2002:a05:6a00:2351:b0:47b:d092:d2e4 with SMTP id j17-20020a056a00235100b0047bd092d2e4mr73088775pfj.76.1637454712802;
        Sat, 20 Nov 2021 16:31:52 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j127sm3932775pfg.14.2021.11.20.16.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 16:31:52 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] skbuff: Switch structure bounds to struct_group()
Date:   Sat, 20 Nov 2021 16:31:47 -0800
Message-Id: <20211121003149.28397-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=654; h=from:subject; bh=JyIoux+3mSqRrP5c5yAm1k2PCuE3ujZ9X+hh+TTSdkw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhmZN06M3ei451eaMBJ4tlO/hieAlz+BhYFDkIdlX1 eX61FpWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZmTdAAKCRCJcvTf3G3AJtbrD/ 9eR2KNvgCn/YPwypnUGU/RNNqA4O4bYEFLj4ElzB1qqQlG2RgJdcz+rq2yQisqqs16klI6tC11SBhN W7udXMhGJ+Py7w1vVEBAjVNZmGKGlJXE5U8WAHjfZcQac0sOe4DaoyxEKDhZ4dVEtfM9n+INWySh7M uDr1c3vaP+cgXlX5lMFiVoFtjG416sLde9ZZ8i/AAoEtj13SqOYM69cCvB3ZV5sD6z171ju8LuL8V0 0/gPsQggl4r2PI9mSi0ATgA4nL9uxPXZ+WimwvtpoW3euJOXl3R5qx7YEJpMVEhQb+h7bsHU8+554G Mr/5XtAumV32/xkgbaaZzuXsqDpE7wlAaVucANa3AQEj21s9tjkelAJu7HA0AlFNxD1vdytn7CWZlk pZMaqvAW5drzcrEzYLOo+fXRjVbz/qGY1eHIl8O1AdM1Yl5bxOyoHeJ6+Bh5Bgajfi3DtMZFSy3y9b OpoS11g+KF4T5o4t9R3wBjQCyP+hGBmGNCpm6N3kBHTnOLW1hoF9P7WSGHblOL5gn/lWS1rXatOn5H Vacu7NXyluL8MFDh6ynTM7+DGECqimJOIry6vmwHNkpv8jjqqF+jTWDoJGkFAn2/aA49Zpg/XonIcy 94jGLJObRNcJnXtDPIWtQUQA7/UNnVofu/gJMtbIHUh4j4L/74FL/AmwVMfg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a pair of patches to add struct_group() to struct sk_buff. The
first is needed to work around sparse-specific complaints, and is new
for v2. The second patch is the same as originally sent as v1.

-Kees

Kees Cook (2):
  skbuff: Move conditional preprocessor directives out of struct sk_buff
  skbuff: Switch structure bounds to struct_group()

 drivers/net/wireguard/queueing.h |  4 +--
 include/linux/skbuff.h           | 46 +++++++++++++++-----------------
 net/core/filter.c                | 10 +++----
 net/core/skbuff.c                | 14 ++++------
 4 files changed, 33 insertions(+), 41 deletions(-)

-- 
2.30.2

