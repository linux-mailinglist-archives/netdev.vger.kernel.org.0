Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DA12843F8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 04:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJFCPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 22:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgJFCPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 22:15:07 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F1AC0613CE;
        Mon,  5 Oct 2020 19:15:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x5so169403pjv.3;
        Mon, 05 Oct 2020 19:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lP1tkQbtnPwmXAX9tmMpE8Th6rG3O93ne0ATmGBdyFc=;
        b=OEayVGq1gbN67B31SzjmKdMKSZgeZnTe5xHjhTOkNraZkS5DObpP3TQIH5inC9KO7s
         1Xx6wbpkH6rLGoTdYqH9K/74hsX0mWlUn/8guNh47cWRV7KSaYxqWJ0BGUm0Q5VniP2x
         ZHKY3yCQZ51JlhjO47dfbwJPywhVZuf7MC2MoeAzTNt7EFI+m2WO7RbOuZXQxtl4l8Xg
         qnQKkm65V+H16TNT2fmiMj+qHL56Xf7vPtnGp/WWV7Kkr6ywaP1kCZEIEVeu5gQDxZnw
         d+ryL+saaGNVPMJGG66ZJpmkPOUnY4rNZDnNyWPYvodnF6g2m/eQGM0LrOTuD12kahvM
         46Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lP1tkQbtnPwmXAX9tmMpE8Th6rG3O93ne0ATmGBdyFc=;
        b=Rpuw+KDpRPTx8zTsVYxqdd3POZ5W0ykFndkuyCAQQTDEcD88vvfSe41j/0u/ABnqGN
         mDNUKiaAmvtlXO/hjojmqnkRNEQSW7NE9DDu+Tq9AemOvGeqSbllCp1rxR3/ou2EMW91
         z138EjwT70C6PCekEvogK6gc2MeuZXBWsDbQeQHYWWKbiUN6eOnTnMYd7H/xYLvV3y3Z
         b8J+tQB2YIGUOmZybBkuVTh5x4IDFDODW8yh2jSQdDIn8cxPluGkqt5sgwnkHnk+LJyk
         cSQzJi6yZG/6OJEC9WUEhNEs4pCChiGOfkcJVjZNlEXjrTZioeRlwoj884znUIHBwgeI
         5TyQ==
X-Gm-Message-State: AOAM532XmS8jfYNV8VMsOesSggQihRon/6HpfnIVRSQga+4v2n+Zt93S
        /oy3XrYQ3qSSjkBM1AEXEabtcUEAYCCXhQ==
X-Google-Smtp-Source: ABdhPJxl0wlSCPqadHsnfTloCNQTOcc6UMz7YjCkfv6IrTyw6cavTwEDBG3bjtF+GqNn3ZBptu7EIg==
X-Received: by 2002:a17:902:be0c:b029:d2:8ceb:f39c with SMTP id r12-20020a170902be0cb02900d28cebf39cmr1215429pls.71.1601950506094;
        Mon, 05 Oct 2020 19:15:06 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1301594pfc.96.2020.10.05.19.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 19:15:05 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf 0/3] Fix pining maps after reuse map fd
Date:   Tue,  6 Oct 2020 10:13:42 +0800
Message-Id: <20201006021345.3817033-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201003085505.3388332-1-liuhangbin@gmail.com>
References: <20201003085505.3388332-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user reuse map fd after creating a map manually and set the
pin_path, then load the object via libbpf. bpf_object__create_maps()
will skip pinning map if map fd exist. Fix it by add moving bpf creation
to else condition and go on checking map pin_path after that.

v3:
for selftest: use CHECK() for bpf_object__open_file() and close map fd on error

v2:
a) close map fd if init map slots failed
b) add bpf selftest for this scenario


Hangbin Liu (3):
  libbpf: close map fd if init map slots failed
  libbpf: check if pin_path was set even map fd exist
  selftest/bpf: test pinning map with reused map fd

 tools/lib/bpf/libbpf.c                        | 80 +++++++++++--------
 .../selftests/bpf/prog_tests/pinning.c        | 49 +++++++++++-
 2 files changed, 94 insertions(+), 35 deletions(-)

-- 
2.25.4

