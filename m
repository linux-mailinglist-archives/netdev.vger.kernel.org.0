Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E9A466880
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359631AbhLBQob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:44:31 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:37422 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359627AbhLBQoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:44:30 -0500
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 7A5502E143C;
        Thu,  2 Dec 2021 19:41:06 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id APwi7LeRIu-f5NSW3EC;
        Thu, 02 Dec 2021 19:41:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1638463266; bh=W3NKc10IGr3Hi0XYAsi+6sAQtV215tA/ExAaeYoWMC0=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=UMMjM4xA2dNt0Fx5GDPHUWT7sbGmC5RIneymu48w7+fjPVYToJQPxLOD0t62JQSt+
         +L7By4iwzFsgWjmqc/zy2oSoZJTLUl/ZMglXam/C1QccUZS0zF58ttgmaNlX6wV0au
         NzWHyXfSXDyENSFsIvFZuVdXOuQ1PpIEioSbClV8=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id gTxR2E9Wq2-f5PiEsmP;
        Thu, 02 Dec 2021 19:41:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     edumazet@google.com
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru,
        hmukos@yandex-team.ru
Subject: [RFC PATCH v2 net-next 3/4] bpf: Add SO_TXREHASH setsockopt
Date:   Thu,  2 Dec 2021 19:40:30 +0300
Message-Id: <20211202164031.18134-4-hmukos@yandex-team.ru>
In-Reply-To: <20211202164031.18134-1-hmukos@yandex-team.ru>
References: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
 <20211202164031.18134-1-hmukos@yandex-team.ru>
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

