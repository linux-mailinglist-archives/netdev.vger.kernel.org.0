Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634594A483A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244762AbiAaNdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379061AbiAaNcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:32:17 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57ACC061751;
        Mon, 31 Jan 2022 05:31:57 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 22F932E0DD2;
        Mon, 31 Jan 2022 16:31:55 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id hMFP4kA7qK-VrGi3IJj;
        Mon, 31 Jan 2022 16:31:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643635915; bh=oXOYcrDzmyDbcFDeGJMbfnxSZJ2Ws/US38vXX1dmEPg=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=YPdUoa1BWQxPPVj9H+uSoGXcXkdlylQwBn8lFyjiFMJ93cBAKnWeOPwPbyo4ZaC3P
         eIksvVhYfBmHkYjJwojai6++cJYb6JiDO1vDWgCblSMKZRwp+4C9Omg3lRHiXxmJyl
         JTD9vuZ62cC1yG7juGAuIxbGT6oTzAmMpqia3owQ=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KT3glRaQ9Z-VrIO059D;
        Mon, 31 Jan 2022 16:31:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v5 4/5] bpf: Add SO_TXREHASH setsockopt
Date:   Mon, 31 Jan 2022 16:31:24 +0300
Message-Id: <20220131133125.32007-5-hmukos@yandex-team.ru>
In-Reply-To: <20220131133125.32007-1-hmukos@yandex-team.ru>
References: <20220131133125.32007-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf socket option to override rehash behaviour from userspace or from bpf.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/filter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index a06931c27eeb..9615ae1ab530 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5091,6 +5091,13 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		case SO_REUSEPORT:
 			sk->sk_reuseport = valbool;
 			break;
+		case SO_TXREHASH:
+			if (val < -1 || val > 1) {
+				ret = -EINVAL;
+				break;
+			}
+			sk->sk_txrehash = (u8)val;
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -5269,6 +5276,9 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 		case SO_REUSEPORT:
 			*((int *)optval) = sk->sk_reuseport;
 			break;
+		case SO_TXREHASH:
+			*((int *)optval) = sk->sk_txrehash;
+			break;
 		default:
 			goto err_clear;
 		}
-- 
2.17.1

