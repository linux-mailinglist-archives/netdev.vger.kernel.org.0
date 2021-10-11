Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10664293E6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbhJKP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhJKP6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:58:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437CDC06161C
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:56:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s66-20020a252c45000000b005ba35261459so23198877ybs.7
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7TXPmPVY27k7pyNLuFw60xr5tLPqyGfPBHdD9J36DsI=;
        b=e5VGEZDkxA+p6Vsk3Y8CF6kcvLxf20TRniWIZOO96EEJ5Hn/TmXZ4ifDXGXoPTo8KK
         CA8Ec/iFhK83F1t1n5GlycUqw3B17u+1Vba7PEUMxIWXIyd+4ljsTZGktgbEr61vDEKO
         cIvAJcJDc73zwECR/6CaQNVnQ/4w1lUS/mKfheJCZjxY+KCGR4MdfmcmsWfKmeK+x6Pt
         En2wPn+uku4fyrLJWYtLdXEDxf7exFeHcaWUeVCxsdGOHxwuhNolYD/IHRynl6THjDPj
         NBclCDl5mejDretY/qvPcOIilTi7ZfMQtFzgtCpfAqh++igl+F+TswelIu10WprN4cbT
         iNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7TXPmPVY27k7pyNLuFw60xr5tLPqyGfPBHdD9J36DsI=;
        b=L7YwIVW2P0PttDk1VdvZxMvIVYEECKWteUkyeZunfuIAbuytYXdulZDH6H6zdtS2iF
         VGpMEXMqIZZdF44qtBAIxXjGLHxxjtRqADYPZGo3sVR7JMV4MqpiZU4uii82Fl9/oQTN
         ol6Rn8b/alWAvXEjbMZAVWnO73bJN//dK7WLyvD6pPS1rTLIQg1uPGPNy9FYgDEh19kN
         FYUXndiEy8p6Wh/sQV2fUuV8hqLmFl3vMAwJoqdv0op7j9yHCeiRANw6qcXXMkM+AZ9O
         XaEHTYlwQy5WsdnnmXkBNh5vQZY8BonVlsImP7vO5J+guVB1fY3iMz4cGsLkHgsZJK8M
         4bPg==
X-Gm-Message-State: AOAM533J2cpRzwIb+yB7V8DtXn54qcUmHgNeka2Wo4cfo+ybbsjHQnIt
        Wj1C5YnRsgwUI5ePmDZghwKmaZDjMPbpLMpeDTTWXWGtvgM3I88NUrX/PjdDHDYKeB/wKnLFYsu
        BAht1WaUDyVY2asWAExbLt0BIczlX5+frV2wLv0+dT9OolVpJF60o5w==
X-Google-Smtp-Source: ABdhPJx8nVcIE7gIFaT38NBHovcGBJWLQzEFsOUT5vQ1z/l7ncgX3MhqW7LLOE1Z+Q6TIGZS33z7AwY=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:8bf5:656e:8f83:7b2d])
 (user=sdf job=sendgmr) by 2002:a25:ca8c:: with SMTP id a134mr23058238ybg.542.1633967799376;
 Mon, 11 Oct 2021 08:56:39 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:56:34 -0700
Message-Id: <20211011155636.2666408-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH bpf-next 1/3] libbpf: use func name when pinning programs with LIBBPF_STRICT_SEC_NAME
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't use section name anymore because it's not unique
and pinning objects with multiple programs with the same
progtype/secname will fail.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/libbpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ae0889bebe32..0373ca86a54c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -285,7 +285,8 @@ struct bpf_program {
 	size_t sub_insn_off;
 
 	char *name;
-	/* sec_name with / replaced by _; makes recursive pinning
+	/* sec_name (or name when using LIBBPF_STRICT_SEC_NAME)
+	 * with / replaced by _; makes recursive pinning
 	 * in bpf_object__pin_programs easier
 	 */
 	char *pin_name;
@@ -614,7 +615,11 @@ static char *__bpf_program__pin_name(struct bpf_program *prog)
 {
 	char *name, *p;
 
-	name = p = strdup(prog->sec_name);
+	if (libbpf_mode & LIBBPF_STRICT_SEC_NAME)
+		name = p = strdup(prog->name);
+	else
+		name = p = strdup(prog->sec_name);
+
 	while ((p = strchr(p, '/')))
 		*p = '_';
 
-- 
2.33.0.882.g93a45727a2-goog

