Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D00161F26
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBRDA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:00:57 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:52450 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgBRDA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:00:57 -0500
Received: by mail-pj1-f42.google.com with SMTP id ep11so356180pjb.2
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 19:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8TQW2MMPyzSIqUDhFwAM22VWp8oXFENVG+pkQxcxX7Q=;
        b=Fzwj3DXF7d8c35GJ3uhvP/tpOaWXQNvRsGR7siWhQL7a4m4nmITOIMI1IHFnxm/mY6
         TlJUN1MZsuS3tBZasp6WgYrgPvbvc3tEvJ3MpBUuy/1qUM0x/t45Cbc9JzeOrbt7PP3e
         x8KZxqCbvQrOHFfQ+5kRsjNWEJAP/cjFi2gVA+gyvkQ7JL3OssrnSgSYd8O5mHANtWTx
         lfl5z/r0Vq6PB4Secj0BUDOXuqJtBfkoAQ/IrdAzyieVWIGCITGSbbQk7gSeYy/l6QOk
         ADV+BK7ikpHTDIR1xhodm/Ayo6ds5yFJ3R3NMls0ePEXk9OGSAAThheI18BTGGXWCWxV
         hvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8TQW2MMPyzSIqUDhFwAM22VWp8oXFENVG+pkQxcxX7Q=;
        b=W22g+u0IsedY13l8iLH79cePOaKQv+jdy7tT45QeCpTNNNAMEjVzq7uSIBA29QCstp
         rC2J/1z39DBXrWQcc9h5LLiPvqtuAiCrgYYp37Yv2Rx+3VDyptVjjcCOhNIKOcnb1pKu
         m26XhAMYEB0/fUOKMMEfaIAa3KU0SbOokMAZjTfmlnZhtpECX4FI4qHe6xyZRkFp9pLU
         DgF1OV3LJTb4vXeUcbhxypdgElT8dAXmjnwaeZ5Xs9miCyhvGt058GU8Q4PGcbSiveby
         VzAV5ZwqQLiUWrvsCyWaMd+gHgep9j9l3outUOtQ/viuo/eWd7GiSaanO5ZUYDrWwsYH
         AgAw==
X-Gm-Message-State: APjAAAXF5BAKlkTvo/DiwICqEiSf+6/Yrk3okcvPinGQ9wev3hg7EYI8
        PN9EnMDfQFXoXm0U6wjjTmJUjGHXWNc=
X-Google-Smtp-Source: APXvYqx78Y6OC3HB6BOVRM2+JAEjQXhcqmHvLRdlyvFVeSvFV1Pj5E6A+mfvim30T5h8wAhRLmcXEQ==
X-Received: by 2002:a17:902:aa49:: with SMTP id c9mr19353340plr.145.1581994856696;
        Mon, 17 Feb 2020 19:00:56 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm1736783pfg.17.2020.02.17.19.00.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 19:00:56 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     William Tu <u9012063@gmail.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCHv2 iproute2] erspan: set erspan_ver to 1 by default
Date:   Tue, 18 Feb 2020 11:00:48 +0800
Message-Id: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581994848.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 289763626721 ("erspan: add erspan version II support")
breaks the command:

 # ip link add erspan1 type erspan key 1 seq erspan 123 \
    local 10.1.0.2 remote 10.1.0.1

as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
won't be set in gre_parse_opt().

  # ip -d link show erspan1
    ...
    erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
                                              ^^^^^^^^^^^^^^

This patch is to change to set erspan_ver to 1 by default.

Fixes: 289763626721 ("erspan: add erspan version II support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/link_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index 15beb73..e42f21a 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 metadata = 0;
 	__u32 fwmark = 0;
 	__u32 erspan_idx = 0;
-	__u8 erspan_ver = 0;
+	__u8 erspan_ver = 1;
 	__u8 erspan_dir = 0;
 	__u16 erspan_hwid = 0;
 
-- 
2.1.0

