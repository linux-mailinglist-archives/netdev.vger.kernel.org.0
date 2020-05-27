Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145F11E4DC4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgE0S7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbgE0S5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:57:37 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3921DC08C5C1;
        Wed, 27 May 2020 11:57:37 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id x22so415352otq.4;
        Wed, 27 May 2020 11:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eW6ryn1rOfnt2FF7cISQz6U787vY1TgBbRYE31eh+Uw=;
        b=DFl0fF7dcBxB5zqV1ix3II/kS7GQWkr6h7MlBOIRyyX9w/lmsBDVqgZKwMtq0L4M9H
         JTBc6t/jarulee9eP3RPJKMS2NvII2IvXAT0SjYl2xUHexw2iLgQZVQwSUPKlmY5/tYu
         blnENDtu+hHIbyK+fWHgVFD2xWYKMl0dQlHidD4j3U3cRAYEdixqEZsEMbCUaOiO6Iem
         AaZO+xMLT7bai9YdpZ8wEx6wvizd+XffPHmevaIB/n/EpgKdqo1WI7hkfxe32wVQeBOf
         UFz9ZFZlvdfXGql8cPsqCC4q63jmWoSjd5QqXTYzEdiKuCUTHUkLidSnDhGYt0Y9Sh8U
         cFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eW6ryn1rOfnt2FF7cISQz6U787vY1TgBbRYE31eh+Uw=;
        b=LZ78mXkLqXZvW1PqKUgBHFUBx/MvKDMDC4Qm9+ZhiYzssPBbfTBtDjIcty0DZmQ4pE
         fwx3iv4/de8yBOM7vACUzK8dUpM4N18JXTja1kx6QoBxniGDbaVfPx2xxnn+nAGC5l0/
         O7HGgHMs9+e8qxKifvWdb8ZIGqBCS/+c1LyN5tINW0NwHolCgOEZkT0DDhe8mBE290dE
         an/y7bna+GcgWiCD2W6oouxANX02/mWi+WyntD3LU3UFnPJAqbvH47BB/QP1RNIr8+sV
         nNONuh416mdRNz8am9nusoLfbskgpXKHdljr0VNzzapkRvYxzhhhB1ycXCwFOVTvQjse
         Hj3A==
X-Gm-Message-State: AOAM533pk8tM+prv1mkdjWCfJdlIhLUUe9xkeZrSr/m9pl2u6Wp9+V3m
        A+zDVORpW/IAUrKgJZ9cN2s=
X-Google-Smtp-Source: ABdhPJy0KJw3sf9zmT1G+HDG+6Q0TCF/0gOW2ku15pcSyJcP5yU5cr/zlnwmgb0j4Gon70V/ZXqnNw==
X-Received: by 2002:a9d:4807:: with SMTP id c7mr5327778otf.279.1590605856664;
        Wed, 27 May 2020 11:57:36 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:92ff:fe3e:1759])
        by smtp.gmail.com with ESMTPSA id i127sm1074596oih.38.2020.05.27.11.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:57:35 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <shuah@kernel.org>
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 2/5] selftests/bpf: cleanup some file descriptors in test_maps
Date:   Wed, 27 May 2020 18:56:57 +0000
Message-Id: <20200527185700.14658-3-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527185700.14658-2-a.s.protopopov@gmail.com>
References: <20200527185700.14658-1-a.s.protopopov@gmail.com>
 <20200527185700.14658-2-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_map_rdonly and test_map_wronly tests should close file descriptors
which they open.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/testing/selftests/bpf/test_maps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index f717acc0c68d..46cf2c232964 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1401,6 +1401,8 @@ static void test_map_rdonly(void)
 	/* Check that key=2 is not found. */
 	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == ENOENT);
 	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == ENOENT);
+
+	close(fd);
 }
 
 static void test_map_wronly(void)
@@ -1423,6 +1425,8 @@ static void test_map_wronly(void)
 	/* Check that key=2 is not found. */
 	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == EPERM);
 	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == EPERM);
+
+	close(fd);
 }
 
 static void prepare_reuseport_grp(int type, int map_fd, size_t map_elem_size,
-- 
2.20.1

