Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0095EBA4E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJaXYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:24:53 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:53643 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaXYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:24:53 -0400
Received: by mail-vs1-f74.google.com with SMTP id q189so1373177vsb.20
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 16:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Tygc56GxwigtGUqcDPkB5Bi/BqbMfAkwB4mbJxQDgO0=;
        b=EmCG1fFBZWDMQAlxYzKjF+iN7zvFYUh1sR2RxFLFFzy0ZcGNKYkOBvFkRhCOOCA6Pa
         xujf8FxXrrAdIzPeAolGdps7kYG+PPSFJeV+zlOGBhEdu/4At4n4L8J0Wj7ydLMCsKA3
         UdiR0YtQqxAZNovMHYmFWlG4E7uWZdFGFOnL/Ma8cXMyWjAXVuDENy5O8CiJ264ZS+ic
         hM0uXkq1zdAMy+Vf58rTlAJU+1hSCfbQuo6a8hg2kgUEo04XvBAkAUN4IkJcTaJ/MpBM
         /C3u/4RJttmRRUFeVIT/CZfixa4fqsI38jx41AjeSc+oQ4uVNuPfaEMeZEWQ2gj/p5Q2
         Vg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Tygc56GxwigtGUqcDPkB5Bi/BqbMfAkwB4mbJxQDgO0=;
        b=JoLb4ACndeC41yg4AGgcCDJ6ifs4lHiU4c+dvgFmiz8j0hx40Z6kIJ+ID8AIjevQX3
         a8N17HfoVshkpHKT6Xu2MKpKBePyb9/lGvEL7VvG5kg1M/S5tlnoOGQ0qMRQG5aKbD+v
         naqAiZyb5MABVAutfwx2Yc6oYHqRUMH7AMZGBRHVtryuLU9W9KYebFqAK5LqeMScnk29
         Ma4JeHj+B/xxCCgfgA5aCsIjIMayCkJrAulqt7x87t7/MdgmbC4S2BZKHLP+IFwPVf6X
         YWsk9nQBSZMxKvrtd6oPGA5TMGwDSt6g7Q2/eq4Df1UsRa36/7TywZBPemKUVSjPNvs4
         dVpA==
X-Gm-Message-State: APjAAAUAZiqFEwQEHSrLkBQRXt7DXnjKbnNd9h0sRO/yofhS/u6OaVNH
        Utw04Rshq16CXJaTXhDX5TFIryO2syA=
X-Google-Smtp-Source: APXvYqzpAxnFQlsSSxMt6+CTRPMjWP/JUBk7i7XQH0cdz6GGxG78FytLImQKgb3qajcsuFELiJd9uWT9VbY=
X-Received: by 2002:a1f:d7c1:: with SMTP id o184mr3948984vkg.19.1572564292233;
 Thu, 31 Oct 2019 16:24:52 -0700 (PDT)
Date:   Thu, 31 Oct 2019 16:24:36 -0700
Message-Id: <20191031232436.18481-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net] selftests: net: reuseport_dualstack: fix uninitalized parameter
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Craig Gallek <cgallek@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test reports EINVAL for getsockopt(SOL_SOCKET, SO_DOMAIN)
occasionally due to the uninitialized length parameter.
Initialize it to fix this, and also use int for "test_family" to comply
with the API standard.

Fixes: d6a61f80b871 ("soreuseport: test mixed v4/v6 sockets")
Reported-by: Maciej =C5=BBenczykowski <maze@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: Craig Gallek <cgallek@google.com>
---
 tools/testing/selftests/net/reuseport_dualstack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/reuseport_dualstack.c b/tools/test=
ing/selftests/net/reuseport_dualstack.c
index fe3230c55986..fb7a59ed759e 100644
--- a/tools/testing/selftests/net/reuseport_dualstack.c
+++ b/tools/testing/selftests/net/reuseport_dualstack.c
@@ -129,7 +129,7 @@ static void test(int *rcv_fds, int count, int proto)
 {
 	struct epoll_event ev;
 	int epfd, i, test_fd;
-	uint16_t test_family;
+	int test_family;
 	socklen_t len;
=20
 	epfd =3D epoll_create(1);
@@ -146,6 +146,7 @@ static void test(int *rcv_fds, int count, int proto)
 	send_from_v4(proto);
=20
 	test_fd =3D receive_once(epfd, proto);
+	len =3D sizeof(test_family);
 	if (getsockopt(test_fd, SOL_SOCKET, SO_DOMAIN, &test_family, &len))
 		error(1, errno, "failed to read socket domain");
 	if (test_family !=3D AF_INET)
--=20
2.24.0.rc0.303.g954a862665-goog

