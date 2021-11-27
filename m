Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877745FE20
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbhK0KjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 05:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350772AbhK0KhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 05:37:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638009239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhkIYPM1WFszu7T8QclmLtHmBRD8pluP6wK51D9W/Fw=;
        b=PjlpqNB3mfjoGM38ZAdFHpgaAcwIhUbsKR3NVEHz8AR0DyxAyvdhuKAj+uh2DK9YbJpESq
        SXP8D3lvm7Rir53GocN+vfwXF+rUMwVaNUiqo4p0EplnsrIXIIB+v6UQ1Jbd02USvCh2Dq
        q6Urhq2EHZbtCp6abOQWiI6PaEV3ni0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-33-_PqDMwqbNPuO5qQM7fo3pw-1; Sat, 27 Nov 2021 05:33:56 -0500
X-MC-Unique: _PqDMwqbNPuO5qQM7fo3pw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753411006AA0;
        Sat, 27 Nov 2021 10:33:54 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 070F972FA4;
        Sat, 27 Nov 2021 10:33:53 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH nf 1/2] nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit groups
Date:   Sat, 27 Nov 2021 11:33:37 +0100
Message-Id: <5577a613f815575804cb19754f064071b852bbab.1637976889.git.sbrivio@redhat.com>
In-Reply-To: <cover.1637976889.git.sbrivio@redhat.com>
References: <cover.1637976889.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sixth byte of packet data has to be looked up in the sixth group,
not in the seventh one, even if we load the bucket data into ymm6
(and not ymm5, for convenience of tracking stalls).

Without this fix, matching on a MAC address as first field of a set,
if 8-bit groups are selected (due to a small set size) would fail,
that is, the given MAC address would never match.

Reported-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo_avx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index e517663e0cd1..6f4116e72958 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -886,7 +886,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 			NFT_PIPAPO_AVX2_BUCKET_LOAD8(4,  lt, 4, pkt[4], bsize);
 
 			NFT_PIPAPO_AVX2_AND(5, 0, 1);
-			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 6, pkt[5], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 5, pkt[5], bsize);
 			NFT_PIPAPO_AVX2_AND(7, 2, 3);
 
 			/* Stall */
-- 
2.30.2

