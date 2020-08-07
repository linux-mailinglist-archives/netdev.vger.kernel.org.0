Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD823F4EB
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHGWit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgHGWis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 18:38:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF09C061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 15:38:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 7so4596221ybl.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 15:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Qj9/TfNVp3NnjEs+9soDUF8jF3QB3TPNXKn9Up++SLE=;
        b=nyYdVL66yoiwemUxRvTq0TQ5ULgyJJZTEAHH6A/RQhVc/lb7h3CMG7X+xuebEH2QeR
         F85qgArjLtIuSJwPHlHRmJDfe25JtNfDs+oQ1nHvbqdnn+Nho2kKI/1I9xhfRp01PUF7
         V5/CK7Uf0zr5lEjEO943VxDEsyX9mrzGNuqotlPS0bulwGqTnJoIWWLkS6+PUX1EnW1/
         Ng+GdRiGDZszrIXinrh/kmE8IFoJ0tO8GOp6TAnCoh0J6aEb10RJzABIwjGtvfLbRQzm
         bAo40sLwg1qfheUPZ+9YOtkM53HYp2cHuprUsKD9Bl65d19gjsHqcePWo6g9jt17w1Ud
         QfBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Qj9/TfNVp3NnjEs+9soDUF8jF3QB3TPNXKn9Up++SLE=;
        b=MMFfsqFRMqJi65e9t5ZY4J+foP2bvvdh3xJSwwnuYWA/svKE2NobnYO7mk9dteWK5L
         lukyz40S+ASdvDlbpKRvyKXT7pCdpzwXAmcolwFGutevxBk3Q5OnjBR8CJQ6CbAOQy7U
         2rOsR1Fn9daFeFTWbFl+umDRNBgGDATVv6cCb3ACIrVY/8EINjN0lZutEU7rhfxKnkqo
         9NRlIHvAEviFAKcBPK6azKIUaj/UaxgsK4oMYUl42OJQoNZnm53YkB+EYI5cHmDIUEEC
         IKxPy/7Llek1urbxFBfeH4qTyuEcP+zZVsGaXqmcWv2xjdY1o1cWdYt2B4IdPDVYf5tL
         v14w==
X-Gm-Message-State: AOAM5333pRhAKrri4Mlps5rQ+PYyS0bDEa0amDyreFRuySVua6lMn/cs
        zVXGflTd+3Ax+uefrJiEazCPheSFBmirN0GHJAuNJ31AawrHiQs7jjDjz8aknozjiekctSvTffT
        cpftopgQl3q2vejH7FcDU6HYsxURTG0NPgVhZp/8fzxEsjQZ2cWssBw==
X-Google-Smtp-Source: ABdhPJxokK2Y7pEiBU2Yy1s63CaOnAOkZ7Yo6nyeWm9GAyH4RV+nvlML6Nz6s5eQGEd4Tp5BaipE4X8=
X-Received: by 2002:a25:3785:: with SMTP id e127mr26142705yba.191.1596839927685;
 Fri, 07 Aug 2020 15:38:47 -0700 (PDT)
Date:   Fri,  7 Aug 2020 15:38:46 -0700
Message-Id: <20200807223846.4190917-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH bpf] selftests/bpf: fix v4_to_v6 in sk_lookup
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm getting some garbage in bytes 8 and 9 when doing conversion
from sockaddr_in to sockaddr_in6 (leftover from AF_INET?).
Let's explicitly clear the higher bytes.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index c571584c00f5..9ff0412e1fd3 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -309,6 +309,7 @@ static void v4_to_v6(struct sockaddr_storage *ss)
 	v6->sin6_addr.s6_addr[10] = 0xff;
 	v6->sin6_addr.s6_addr[11] = 0xff;
 	memcpy(&v6->sin6_addr.s6_addr[12], &v4.sin_addr.s_addr, 4);
+	memset(&v6->sin6_addr.s6_addr[0], 0, 10);
 }
 
 static int udp_recv_send(int server_fd)
-- 
2.28.0.236.gb10cc79966-goog

