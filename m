Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905EA46A563
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348276AbhLFTPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:15:14 -0500
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:43038 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348273AbhLFTPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:15:14 -0500
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 170A52E09E6;
        Mon,  6 Dec 2021 22:11:44 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id CaQ118I32l-BhN8LM2R;
        Mon, 06 Dec 2021 22:11:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1638817904; bh=Ul2Diq5Lm/qpvIjgdaf1C1Ez37gi3uCsjP0AKjTC+Ms=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=spbL4LiNzz9nypCVi71g1u67qL4ipAVcLvga1N8HvHauSIXdXbCqeMV8a1iheVUBG
         SPilGqcyroADzYSrORPqiN/07XGyGs7fgZQ5Or5ZNQkoxbbb47aCR406e+XNXNfvOM
         Ko9/EOoq8aY5X1gv4/xd4EnGaRHz5SVzgC7uk0iw=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id U4ua9e2Xs9-BhPOovIE;
        Mon, 06 Dec 2021 22:11:43 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     hmukos@yandex-team.ru, edumazet@google.com, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v3 net-next 3/4] bpf: Add SO_TXREHASH setsockopt
Date:   Mon,  6 Dec 2021 22:11:10 +0300
Message-Id: <20211206191111.14376-4-hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211206191111.14376-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf socket option to override rehash behaviour from userspace or from bpf.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 net/core/filter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..de68763f3c51 100644
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
+			sk->sk_txrehash = (u8)val;
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

