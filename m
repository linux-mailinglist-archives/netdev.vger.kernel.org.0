Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06922A7C15
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgKEKmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbgKEKma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:42:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F91C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 02:42:30 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id i19so1893275ejx.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 02:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LczsVk+9KnBIoU2kGVEtIN/d3ykScNgtF9myRWt2BE=;
        b=sxH0VQ9LsmCqBEh36Md+jDI84/cUS6/ExbEeJpMqt25TRt3OdtRoIsEAVH/mMYRCuR
         MDB4MnE5xF5eYdTPzubvU2GJ3XaLgYeaIbA6o+Vg/+hM3sXcnvxqnvLWUTNVaOzcqW4l
         fO0oojmYdSEg0Xteeqh0Px1WgafShCjHI5Ks09lWp4FwzVE0RSrCuSvkN33kSk3HMr4R
         2kbQjefLhUrC9ZC9xy/pnphk63ciIZL48lZcsQBCubUoQ5ZEvw1awHUY5b9xdsGvEpcb
         OPSlKawicSLvejkOn66/dp+eqyk7FMTGd4Na5IcMFcaq2ZXPkaou2nxO/a/1jlNTuvsI
         GNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2LczsVk+9KnBIoU2kGVEtIN/d3ykScNgtF9myRWt2BE=;
        b=krGL+440oiM/5OYigJhCa8XKIsmdEvMSuS8n9N4CrLPFnlRbUBQOJWMKYzu3INn3FZ
         YjTtC7074L2T8KP0a+Q0g9phQn5gd6yLVOftmjicmJHQkXpUb8KMV4LSC5D9k3O+DFJN
         JSDEIrv8xDeCrHSVXPJYVpFfqCePoE3kjf1FTjxvVh06c3tiSLfubAdbm2H1Rsp3TbK3
         d5IgOH58roFkpDZ+qlwEmKhg6SIO8HrF9o/IjVE4En4S0oXpDDUGpu5VYBwxrkA1LJKs
         RU2BX0ANIedarwIyH25KTDPbZYJXe9S4DGLRPH7I5hgPYhUsJJQ586BO7lOzpEfJrMZN
         8Oaw==
X-Gm-Message-State: AOAM530HxHFaKUhugBpSbz07DL+WBQF3WcWDp0DuDxMMQnaa5pAiPONH
        WflSgKU15gswYAZ20uEtPkjpLQ==
X-Google-Smtp-Source: ABdhPJyBMpzU7Ahb1JvtUHQmFY5cw8AkzmV5qvw7WUjZ2egmnOPvYSy3BGzOmbHjtnZA0eINlyloWg==
X-Received: by 2002:a17:906:5247:: with SMTP id y7mr1552389ejm.503.1604572949188;
        Thu, 05 Nov 2020 02:42:29 -0800 (PST)
Received: from ntb.petris.klfree.cz (snat2.klfree.cz. [81.201.48.25])
        by smtp.googlemail.com with ESMTPSA id by8sm648864edb.49.2020.11.05.02.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:42:28 -0800 (PST)
From:   Petr Malat <oss@malat.biz>
To:     linux-sctp@vger.kernel.org
Cc:     Petr Malat <oss@malat.biz>, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sctp: Fix sending when PMTU is less than SCTP_DEFAULT_MINSEGMENT
Date:   Thu,  5 Nov 2020 11:39:47 +0100
Message-Id: <20201105103946.18771-1-oss@malat.biz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function sctp_dst_mtu() never returns lower MTU than
SCTP_TRUNC4(SCTP_DEFAULT_MINSEGMENT) even when the actual MTU is less,
in which case we rely on the IP fragmentation and must enable it.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 net/sctp/output.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 1441eaf460bb..87a96cf6bfa4 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -552,6 +552,7 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	struct sk_buff *head;
 	struct sctphdr *sh;
 	struct sock *sk;
+	u32 pmtu;
 
 	pr_debug("%s: packet:%p\n", __func__, packet);
 	if (list_empty(&packet->chunk_list))
@@ -559,6 +560,13 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	chunk = list_entry(packet->chunk_list.next, struct sctp_chunk, list);
 	sk = chunk->skb->sk;
 
+	/* Fragmentation on the IP level if the actual PMTU could be less
+	 * than SCTP_DEFAULT_MINSEGMENT. See sctp_dst_mtu().
+	 */
+	pmtu = tp->asoc ? tp->asoc->pathmtu : tp->pathmtu;
+	if (pmtu <= SCTP_DEFAULT_MINSEGMENT)
+		packet->ipfragok = 1;
+
 	/* check gso */
 	if (packet->size > tp->pathmtu && !packet->ipfragok) {
 		if (!sk_can_gso(sk)) {
-- 
2.20.1

