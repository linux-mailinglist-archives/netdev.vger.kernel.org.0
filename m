Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081B51F023
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 13:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbfEOLk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 07:40:58 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:40668 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732491AbfEOLk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 07:40:57 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 225C12E0464;
        Wed, 15 May 2019 14:40:54 +0300 (MSK)
Received: from smtpcorp1j.mail.yandex.net (smtpcorp1j.mail.yandex.net [2a02:6b8:0:1619::137])
        by mxbackcorp1o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 08gEU9pJ8f-er0GLCfw;
        Wed, 15 May 2019 14:40:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1557920454; bh=OSHZ1+IwIacwVlIgWbLEW2/VGId4KBozS/H+7QUKVY0=;
        h=Message-ID:Date:To:From:Subject;
        b=V5lqzoByyCilaEh1pURelX2t3ayYGtJn4oGqQJB0r26wOsNxalgH/GtFCbT40cmct
         nZe9YLXlz7duPOMJCDloVh0zRUQ7Z76bVTWUmSJD10XP0aqopsDZ+VUZ4qsKx93mdi
         OLGDd+vYSKm6wxxXMXRej09kinTtg2NGl8xxyzr8=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:ed19:3833:7ce1:2324])
        by smtpcorp1j.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id cPqsRtmpGc-er8ePror;
        Wed, 15 May 2019 14:40:53 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] net: bpfilter: fallback to netfilter if failed to load
 bpfilter kernel module
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 15 May 2019 14:40:52 +0300
Message-ID: <155792045295.940.7526963251434168966.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bpfilter is not available return ENOPROTOOPT to fallback to netfilter.

Function request_module() returns both errors and userspace exit codes.
Just ignore them. Rechecking bpfilter_ops is enough.

Fixes: d2ba09c17a06 ("net: add skeleton of bpfilter kernel module")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 net/ipv4/bpfilter/sockopt.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 15427163a041..0480918bfc7c 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -30,13 +30,11 @@ static int bpfilter_mbox_request(struct sock *sk, int optname,
 	mutex_lock(&bpfilter_ops.lock);
 	if (!bpfilter_ops.sockopt) {
 		mutex_unlock(&bpfilter_ops.lock);
-		err = request_module("bpfilter");
+		request_module("bpfilter");
 		mutex_lock(&bpfilter_ops.lock);
 
-		if (err)
-			goto out;
 		if (!bpfilter_ops.sockopt) {
-			err = -ECHILD;
+			err = -ENOPROTOOPT;
 			goto out;
 		}
 	}

