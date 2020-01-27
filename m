Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4414A62C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgA0ObY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:31:24 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:44864 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbgA0ObY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:31:24 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 62FCE20569
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 15:31:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Na8MTqnNV2Qk for <netdev@vger.kernel.org>;
        Mon, 27 Jan 2020 15:31:22 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F27D820561
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 15:31:22 +0100 (CET)
Received: from [10.182.7.178] (10.182.7.178) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 27 Jan
 2020 15:31:22 +0100
From:   Thomas Egerer <thomas.egerer@secunet.com>
Subject: [PATCH net] xfrm: Interpret XFRM_INF as 32 bit value for non-ESN
 states
To:     <netdev@vger.kernel.org>
Openpgp: preference=signencrypt
Message-ID: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
Date:   Mon, 27 Jan 2020 15:31:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when left unconfigured, hard and soft packet limit are set to
XFRM_INF ((__u64)~0). This can be problematic for non-ESN states, as
their 'natural' packet limit is 2^32 - 1 packets. When reached, instead
of creating an expire event, the states become unusable and increase
their respective 'state expired' counter in the xfrm statistics. The
only way for them to actually expire is based on their lifetime limits.

This patch reduces the packet limit of non-ESN states with XFRM_INF as
their soft/hard packet limit to their maximum achievable sequence
number in order to trigger an expire, which can then be used by an IKE
daemon to reestablish the connection.

Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
---
 net/xfrm/xfrm_user.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b88ba45..84d4008 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -505,6 +505,13 @@ static void copy_from_user_state(struct xfrm_state *x, struct xfrm_usersa_info *
 
 	if (!x->sel.family && !(p->flags & XFRM_STATE_AF_UNSPEC))
 		x->sel.family = p->family;
+
+	if ((x->props.flags & XFRM_STATE_ESN) == 0 {
+		if (x->lft.soft_packet_limit == XFRM_INF)
+			x->lft.soft_packet_limit == (__u32)~0;
+		if (x->lft.hard_packet_limit == XFRM_INF)
+			x->lft.hard_packet_limit == (__u32)~0;
+	}
 }
 
 /*
-- 
2.6.4

