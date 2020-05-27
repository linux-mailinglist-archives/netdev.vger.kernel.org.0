Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154F31E4DBC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbgE0S6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE0S5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:57:40 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3815EC08C5C1;
        Wed, 27 May 2020 11:57:40 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id x17so1243749oog.6;
        Wed, 27 May 2020 11:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/bi2v/w881kTu6aWVQghMQWdHo/A6/i+CwZouKlxmms=;
        b=CQIL3L9QuGAGDOch3ZMsrDWOowK34i8Dzmn0YPcOlbVnRAkpWIkm5klrZ7exR8KX2V
         yvoM1/mwIx6c32q4jY+hff50T+XO+4+RwrlJH5VzZ1+9hud0QAGUzzTtnb3Zpyr2n2tV
         tp1gO7TsKr3QnvY49tvhWCjqbHBmI4cchjZq/CNphEyjEv5bceDjxftzbADAsOUXbZ2u
         RN4T2b7SqMfyAnp4JyjgbAilvaycZNST78JZEBc4Y9S57yNkJcIaC7Gcs4ppj47iB/Ky
         qXwwXupF+FcBY/udgJBgefsgsVBNHDPDve4jiF9V9DcOQLcmKyQZzCaNpT5l6cCWS/xL
         7D1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/bi2v/w881kTu6aWVQghMQWdHo/A6/i+CwZouKlxmms=;
        b=nWgasd1qg/E/bb6gkrjIy8qFYjpnzlb/Bke2TQcaWooxHtqdY2ddNNH9/mj6an0Hzu
         YcpCDfD1PGqgEeW31hYrRqSsH+Rza+z1M2bpJuMtbWxEU5e0pRRiUF4+N88qhwXMzgTa
         s4m6SSJPtEFrybnK/tD9JoqzR08BS6F4lJsoO+CcmI88/Ej1ho5BMKz5eoTh8OBuSKPP
         9tXcvP5RpCem4cVqtKE+N8AeA8mouOgwy3wvwtholqs1UpXm9N2YMpwt2GNK0rLDyJIX
         Xy6+34HpDggVLdA4+4xsTBUiOAkRI3u9gS1bFRu+BRyx0f1gc0tbkvXu0FcJYHLhc6Gu
         /1Kw==
X-Gm-Message-State: AOAM533DRdpP+leTPuXHwR+NrjcOGFz+obovEl0lUB9kwaGXxMTMW3WE
        vZG288V/50k5V8xoghoFjO8=
X-Google-Smtp-Source: ABdhPJyzzRIMTL2FQqJKEg9svGszotkEOxIapfGj9shfnfRkXZ8OYl6TxV8aHgl0uRVzP+PIFoUAhQ==
X-Received: by 2002:a4a:5548:: with SMTP id e69mr4198269oob.23.1590605859440;
        Wed, 27 May 2020 11:57:39 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:92ff:fe3e:1759])
        by smtp.gmail.com with ESMTPSA id i127sm1074596oih.38.2020.05.27.11.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:57:38 -0700 (PDT)
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
Subject: [PATCH bpf 4/5] bpf: fix map permissions check
Date:   Wed, 27 May 2020 18:56:59 +0000
Message-Id: <20200527185700.14658-5-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527185700.14658-4-a.s.protopopov@gmail.com>
References: <20200527185700.14658-1-a.s.protopopov@gmail.com>
 <20200527185700.14658-2-a.s.protopopov@gmail.com>
 <20200527185700.14658-3-a.s.protopopov@gmail.com>
 <20200527185700.14658-4-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The map_lookup_and_delete_elem() function should check for both FMODE_CAN_WRITE
and FMODE_CAN_READ permissions because it returns a map element to user space.

Fixes: bd513cd08f10 ("bpf: add MAP_LOOKUP_AND_DELETE_ELEM syscall")

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 kernel/bpf/syscall.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e6dee19a668..5e52765161f9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1468,7 +1468,8 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	if (!(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
+	if (!(map_get_sys_perms(map, f) & FMODE_CAN_READ) ||
+	    !(map_get_sys_perms(map, f) & FMODE_CAN_WRITE)) {
 		err = -EPERM;
 		goto err_put;
 	}
-- 
2.20.1

