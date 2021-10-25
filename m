Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B2F43A4CC
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhJYUkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhJYUj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:39:56 -0400
X-Greylist: delayed 86 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Oct 2021 13:37:33 PDT
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35931C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:37:30 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 183762E0DAE;
        Mon, 25 Oct 2021 23:36:02 +0300 (MSK)
Received: from sas1-db2fca0e44c8.qloud-c.yandex.net (2a02:6b8:c14:6696:0:640:db2f:ca0e [2a02:6b8:c14:6696:0:640:db2f:ca0e])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id tfTCHPipT3-a1uCr91w;
        Mon, 25 Oct 2021 23:36:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635194162; bh=W3NKc10IGr3Hi0XYAsi+6sAQtV215tA/ExAaeYoWMC0=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=hCmD2UlheJVP+YYvQFKfqYlzIE4UirW2DGRUl/cXf57ri14XmnLiLTqRQ31fnlNLi
         XATWYNtT+mv/jcRVzF9eAdbZIXICBeR2uTNCzqWZRar5ojulwWRxgQanRV9bdihWNs
         2eeuQK+7cdeEBJmLJo60EghoVkiCCi0AF+jUcylU=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (2a02:6b8:c07:895:0:696:abd4:0 [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-db2fca0e44c8.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id mklMLk28bQ-a10aJR0X;
        Mon, 25 Oct 2021 23:36:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, tom@herbertland.com,
        mitradir@yandex-team.ru, zeil@yandex-team.ru, hmukos@yandex-team.ru
Subject: [RFC PATCH net-next 3/4] bpf: Add SO_TXREHASH setsockopt
Date:   Mon, 25 Oct 2021 23:35:20 +0300
Message-Id: <20211025203521.13507-4-hmukos@yandex-team.ru>
In-Reply-To: <20211025203521.13507-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
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

