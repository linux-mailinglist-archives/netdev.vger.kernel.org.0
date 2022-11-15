Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008F26292EB
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiKOIGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiKOIGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:06:02 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C6C140EB;
        Tue, 15 Nov 2022 00:06:01 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id z14so22689176wrn.7;
        Tue, 15 Nov 2022 00:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rw+qA6J1D1NyQ++JwfxDQ83Mz+tZaKarkxCeUc7QZ1A=;
        b=WEaRQh733IrM035SiDcpAg2KpFRVynjynZjPmzCvJfUzjqrqawR2aFNkHazKpuVxr5
         KgAGMoB75W3t/GhJ9cpYjnT5Vt74glUFLJ75tscDEtEnhF/IXPpagf+Aq+7T7pBKNvUH
         8dw+ITdJOY/n8te7nhzsJ6ceFvXb8nNXfCcpxV25QiTl82+wjFwLZnszu/mO2qXcfHc/
         pL+NhK8nuqaeGpcvHW3KfVq69joa12LJt7xnhbSiHfhiPOylsxHXL2wCXPPGQLcla+65
         KRdPfHcwSALnPhmNPr/M583ty4gpnkDV2wdBEFLWp1K2cTLt2uqfsLZhcBU50cjfa5Ru
         z+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rw+qA6J1D1NyQ++JwfxDQ83Mz+tZaKarkxCeUc7QZ1A=;
        b=IQ82fYGUDeAqNHQ12q1bEo4FhhipLfj1tYcFeVS5GUjHFUDW22P1LkN8JH73CarMLr
         nwooVkhudpONtUpuoqtm4r4VB+fpM7AnxWygv23AIh1z9KezqQfaJYI0BS8OUFW+/zIZ
         gaDREjGssbGILO32dfG1rnT2atO7zPo0R5uKdedGNvGPYhpNsCu3q4CLA6hj3GCs7ZLN
         XZ6BuU9+GP6O8KEv7Rxckl60ki1pMgbCOpOA10EHfM+qe3oMyv2MS4PQMq68/F9zbY35
         ojEOUo0bOJtDCwvHxtWq5ICNJwrZqPP0u3FVeemjHnnYXyWrpLQxXvQ8cCiYryU3dz/d
         11iA==
X-Gm-Message-State: ANoB5pllL4HLnc4TcKEmgDVwTFnMpP4VJyDY9w50b0bs8dEIRnzOcVK6
        FEe8kqtf8sDMiwtuGk9RFr8=
X-Google-Smtp-Source: AA0mqf6EOaiTglODbKHLxV+1e1UaJ2SWlog/esN76N2EZhAUN/e7IAkiE+WF38WMcEzikGfA+0N+jA==
X-Received: by 2002:a5d:538e:0:b0:236:71fe:c9c6 with SMTP id d14-20020a5d538e000000b0023671fec9c6mr9306803wrv.501.1668499559932;
        Tue, 15 Nov 2022 00:05:59 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id cy6-20020a056000400600b002416ecb8c33sm11464190wrb.105.2022.11.15.00.05.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 00:05:59 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf 1/3] selftests/xsk: print correct payload for packet dump
Date:   Tue, 15 Nov 2022 09:05:36 +0100
Message-Id: <20221115080538.18503-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115080538.18503-1-magnus.karlsson@gmail.com>
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Print the correct payload when the packet dump option is selected. The
network to host conversion was forgotten and the payload was
erronously declared to be an int instead of an unsigned int. Changed
the loop index i too, as it does not need to be an int and was
declared on the same row.

The printout looks something like this after the fix:

DEBUG>> L2: dst mac: 000A569EEE62
DEBUG>> L2: src mac: 000A569EEE61
DEBUG>> L3: ip_hdr->ihl: 05
DEBUG>> L3: ip_hdr->saddr: 192.168.100.161
DEBUG>> L3: ip_hdr->daddr: 192.168.100.162
DEBUG>> L4: udp_hdr->src: 2121
DEBUG>> L4: udp_hdr->dst: 2020
DEBUG>> L5: payload: 4
---------------------------------------

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 681a5db80dae..51e693318b3f 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -767,7 +767,7 @@ static void pkt_dump(void *pkt, u32 len)
 	struct ethhdr *ethhdr;
 	struct udphdr *udphdr;
 	struct iphdr *iphdr;
-	int payload, i;
+	u32 payload, i;
 
 	ethhdr = pkt;
 	iphdr = pkt + sizeof(*ethhdr);
@@ -792,7 +792,7 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
 	fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
 	/*extract L5 frame */
-	payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
+	payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
 
 	fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
 	fprintf(stdout, "---------------------------------------\n");
-- 
2.34.1

