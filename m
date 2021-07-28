Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151283D85F3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 04:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhG1ClZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 22:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbhG1ClY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 22:41:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163B6C061757;
        Tue, 27 Jul 2021 19:41:23 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j18-20020a17090aeb12b029017737e6c349so1464741pjz.0;
        Tue, 27 Jul 2021 19:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6RdL6nwImuKMM37S/M+3oGe4BBmhE2+RAltqDswkTR0=;
        b=FnDKSSXXWRl1x8tti0f0qCd1e+96fPcLU3rAuDBJS7cXBrZYMpHWsTYYIzXvwWXsz8
         jHBUTa9viEoGS6IRV44wcKlkvs6j1ZoKnMX8sc3In71BTHSDrorQcwSx3+iTWtBiTe4Q
         /5I1EoeEyZ3WkrSCiMzsbI8ZeKGrZTtHAFLq2hYc9WG4+2AglxMAWfEAG+aw7uLMvoFb
         U07H8s2LC0aKfOMoCobRCym897D1AZAGRsKHBY+wvjiqWrg2LSsJqp8H5gAc0VCObeqe
         sAndNAjFNrV6PiXm5vSLuAOU/gXyiKqWxB5iSBzmxJaK3LO4zqCMUMF3wDipOWgsHRL6
         ZRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6RdL6nwImuKMM37S/M+3oGe4BBmhE2+RAltqDswkTR0=;
        b=Si74exkeHz7GCaoZnP574TzLIOkWSlYV9csxhaq6FeHH7zik1G+LE6SeS4lwq718Nb
         EK5HDly7pDzJeuD/lE4cRZ2BYHcerQd+hYN1KarNoYeVuwpiC8SRk/04dEkpabHjbWKr
         qHi7ryz2RsxEf4xWPJiezV4KCt0HiPcHDdEd/2i6lKrHO4fpWNocoBB9zZIv+gjMK7V7
         6IQyRqYSRN9gffVgMh3K3kPjzWuqDJpZhxhv08d1f0kvfhZxUr46FFlwLZ/3sjZOs4RQ
         Uk25KUBjRKzO1e+dPuwljcvB8REBhVN00EL9grHxJcj2Y//EZQBJgIsMQvp1M8Ry/QSf
         oJcg==
X-Gm-Message-State: AOAM531N1FmFXWkEStEK4h/lVLraKbcdT1h5ACdqKSVypVfaact3BprZ
        8B82NzGnNT06pY0qS7rFrxQ=
X-Google-Smtp-Source: ABdhPJwhUWfbVJovctXOYIuT6p4M24DkL2rjo6bfbQkf0PXc2BIPSAxjiP+j4T5Y+4G8H08WXPIY6g==
X-Received: by 2002:aa7:95a1:0:b029:359:ca4e:d25d with SMTP id a1-20020aa795a10000b0290359ca4ed25dmr26329971pfk.51.1627440082410;
        Tue, 27 Jul 2021 19:41:22 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:f16f:b372:2c19:4b6d:33e0])
        by smtp.gmail.com with ESMTPSA id ns18sm4185989pjb.31.2021.07.27.19.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 19:41:21 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 6286FC0A48; Tue, 27 Jul 2021 23:41:19 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        carnil@debian.org, Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net] sctp: fix return value check in __sctp_rcv_asconf_lookup
Date:   Tue, 27 Jul 2021 23:40:54 -0300
Message-Id: <599e6c1fdcc50f16597380118c9b3b6790241d50.1627439903.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Ben Hutchings noticed, this check should have been inverted: the call
returns true in case of success.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 0c5dc070ff3d ("sctp: validate from_addr_param return")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index eb3c2a34a31c64d5322f326613f4a4a02f8c902e..5ef86fdb11769d9c8a32219c5c7361fc34217b02 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1203,7 +1203,7 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	if (unlikely(!af))
 		return NULL;
 
-	if (af->from_addr_param(&paddr, param, peer_port, 0))
+	if (!af->from_addr_param(&paddr, param, peer_port, 0))
 		return NULL;
 
 	return __sctp_lookup_association(net, laddr, &paddr, transportp);
-- 
2.31.1

