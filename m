Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCE649FCA3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbiA1PRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240716AbiA1PRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:17:02 -0500
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563BC06173B;
        Fri, 28 Jan 2022 07:17:01 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 1CAC52E1268;
        Fri, 28 Jan 2022 18:17:00 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 275RH3JAka-GvHirBSE;
        Fri, 28 Jan 2022 18:17:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643383020; bh=oFxp7SuG1ak+QYNkc53QIl5/LtA7+Z+h2luwiKOrVfs=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=mbAL5YsKx6J9D1CxvhryXUrCm/SjpHDmRHlvxniQUd2pJYRr9b3i4CHerA9bOADWZ
         Td5Sh9OMA3cSk4t1DCrGF/oAHcUMUESELIbpmWuTlkbc3O4Dz+YFGEo6OWjioQfwnB
         pXcVLi9Pr2qh6lm0kcJcQ3TxuoOKCJxr3PDYh7Bk=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IrjHL3bpzz-GvIOpFHo;
        Fri, 28 Jan 2022 18:16:57 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v3 3/4] bpf: Add SO_TXREHASH setsockopt
Date:   Fri, 28 Jan 2022 18:16:01 +0300
Message-Id: <20220128151602.2748-4-hmukos@yandex-team.ru>
In-Reply-To: <20220128151602.2748-1-hmukos@yandex-team.ru>
References: <20220128151602.2748-1-hmukos@yandex-team.ru>
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

