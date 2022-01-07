Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7944879AA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiAGP03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239726AbiAGP03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 10:26:29 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB7AC06173E
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 07:26:28 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id hu2so5745495qvb.8
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 07:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vGt+owIlTcGsf36iCyr2fuZ50uj0j7pktyV5lENxl60=;
        b=BsSs3Sf0PUcYCsfnc2cET0b7KSTLKjqELvqmmkYXLRIU7I0n0/CBH2fMqbYPc6y3ut
         Qf5aXIX0x7U/CuVi0682ceKeM85KIzxTGH5Zx4AxhpQjpseKLqVBC6LllOzwdVpYfkcX
         etxOGMz7MpDURFO3WXYXvKFtAnYkHFFPa6u4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vGt+owIlTcGsf36iCyr2fuZ50uj0j7pktyV5lENxl60=;
        b=6Z81YBIKF3GHEtFxsgx9F2HhYOA/Xw01y8rkPyfAfgAsYYPJRdU2zuwDSuuV7DCfig
         Tl35Yzi6ELq7uaXStIdBU8Wb/V1pFBwf0GejBLYpyv1AhEKvLHVnKnA7V+go+z5AwhW3
         nvP0qgpotIzZZ6PgP86BOHlBCk11/6BOXjkPOfNUA5hmqSPVdhW/7Ga9RpXvkL/2qDuE
         fK3R0ASfOrhCxPWxE9LyRiYo/UW5Tycyw/GnJ7wOn9ZWhElmhYP69VrPurgxJ3INB6qm
         nCGUJwpzxRTbXvx8+YshyhKQlOZHx/YAGt90Fqr6KOzMJeAuxiEL2C5MsxLg37W1Q/PL
         U6sA==
X-Gm-Message-State: AOAM531fLH5j/AxXh/gR2kNBgWGyM28O2akG6vT002EQnZyt3bKPTVhf
        UVOET9OJkEfC3f3kR16ffL3lUC5pbj2OHs+ZL3tfvdZbtYyJ7Hs2MPRQamzBfkKZ0kb7uF/8oYe
        5j67OJPB+TqrtjVI01OpMvsGEyF+JWfzuws0WGqkDhIzwlhlNjw/3SqfwQjOfPhbux4CuDQ==
X-Google-Smtp-Source: ABdhPJwVk7agXiz7QnVNq9n1H0hekc/TGGK4YAap4uIyx26BeWy/IoJ1LN2f3uQ1HovNcFME09MT1Q==
X-Received: by 2002:ad4:5b8f:: with SMTP id 15mr32201544qvp.112.1641569186094;
        Fri, 07 Jan 2022 07:26:26 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h9sm3441494qkp.106.2022.01.07.07.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 07:26:25 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] libbpf: Use IS_ERR_OR_NULL() in hashmap__free()
Date:   Fri,  7 Jan 2022 10:26:19 -0500
Message-Id: <20220107152620.192327-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hashmap__new() uses ERR_PTR() to return an error so it's better to
use IS_ERR_OR_NULL() in order to check the pointer before calling
free(). This will prevent freeing an invalid pointer if somebody calls
hashmap__free() with the result of a failed hashmap__new() call.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
---
 tools/lib/bpf/hashmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index 3c20b126d60d..aeb09c288716 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -75,7 +75,7 @@ void hashmap__clear(struct hashmap *map)
 
 void hashmap__free(struct hashmap *map)
 {
-	if (!map)
+	if (IS_ERR_OR_NULL(map))
 		return;
 
 	hashmap__clear(map);
@@ -238,4 +238,3 @@ bool hashmap__delete(struct hashmap *map, const void *key,
 
 	return true;
 }
-
-- 
2.25.1

