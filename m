Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D91344EC89
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbhKLSW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbhKLSWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 13:22:50 -0500
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EB2C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 10:19:58 -0800 (PST)
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 175452E1272;
        Fri, 12 Nov 2021 21:19:56 +0300 (MSK)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [2a02:6b8:c08:bd1e:0:640:7470:3316])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id lBgv67h1ro-JtsOsX2o;
        Fri, 12 Nov 2021 21:19:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1636741196; bh=W3NKc10IGr3Hi0XYAsi+6sAQtV215tA/ExAaeYoWMC0=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=Gxcwgc3JmItEputpCjj2TlwQ8KxyO/bohYfrKuXuL468Ais+/Ty9wUD6Y34bWjJrj
         +fR+qxwmn+wPUGq503bZiMiOkjlNPJgdVuFoOn3MQmIp6nIKnlJMB/Etunk7IcNgfC
         Mv+jCkCo1QHiiEL/3APo/O2R4e+VqzAfO0s3zAMw=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id vuM7zSALw5-Jtxq3QKi;
        Fri, 12 Nov 2021 21:19:55 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     hmukos@yandex-team.ru
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v2 net-next 3/4] bpf: Add SO_TXREHASH setsockopt
Date:   Fri, 12 Nov 2021 21:19:38 +0300
Message-Id: <20211112181939.11329-4-hmukos@yandex-team.ru>
In-Reply-To: <20211112181939.11329-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211112181939.11329-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf socket option to override rehash behaviour from userspace or from bpf.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 net/core/filter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..889ba86f7cf0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4808,6 +4808,13 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		case SO_REUSEPORT:
 			sk->sk_reuseport = valbool;
 			break;
+		case SO_TXREHASH:
+			if (val < -1 || val > 1) {
+				ret = -EINVAL;
+				break;
+			}
+			sk->sk_txrehash = val;
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -4980,6 +4987,9 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
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

