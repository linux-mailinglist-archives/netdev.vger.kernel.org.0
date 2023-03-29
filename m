Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BDF6CF1CF
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjC2SIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjC2SIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:08:09 -0400
Received: from mail-ed1-x562.google.com (mail-ed1-x562.google.com [IPv6:2a00:1450:4864:20::562])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7963B527A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:07 -0700 (PDT)
Received: by mail-ed1-x562.google.com with SMTP id ek18so66806877edb.6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680113286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+R9QiPuepS+iN2C03D2RIlNJyKTPRzGWrbYYFW+ChZA=;
        b=AjLMyHny1FrLIzhpx8Wy8ca8Gsf8r9QZwhUNhP2mJ3dj3pRNXAli+exviq/Y1+fy6K
         0DeBtE1yZSTfC/uouv0uCDcp0XWFTmU2qFKmczFSpqNp7xjJH3AsRGdRPYoF+O+XXHK4
         zUje9uyo9T52Tvq967f0DniahDOV2lqY4FLNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+R9QiPuepS+iN2C03D2RIlNJyKTPRzGWrbYYFW+ChZA=;
        b=J1VnoKasj9HbDi2hLPkuHaIhL97fCHHjnJ0TuVEvu+xe5PhkOXlBGR/e3MB2+tl1iv
         aydE8yXH+vzPJX97QDcqSF6OiyMD/MMf+ZSadZTQxuaJQ7HQrThYKWoGDoRnNFVU1RsE
         sZG7U+wavU+ig50y8LUVpB8v+LHx07Dm3cw5+gkuF8gkdhBocY+Z3SGGc71so+Yv0O/9
         P0xe+0FKm119iKcRvB3Ps4DxgwcdV7NLYgVJakmhf5ThE/qXk0vLB5cEzb6EJa4tjnuL
         YtludFN+1dpJQqM734/511uQ3gEFBBR+ECHGzHNVR41wJNRsPiuyq/jVU0Vx0Zr49SFq
         Ow8w==
X-Gm-Message-State: AAQBX9fbiho1MKK+5nzBW6sLAwSrrceLup4yexH5wP84xEgAUZh47l1T
        B5xkBF78mwO8Kmu0DNSRrVkovG/JlgHWwrgsQCBOazCArq46
X-Google-Smtp-Source: AKy350Z8xl29V30bz7kWl/gGI0/sW420P05n1h/ooPNr0SGpSvNFTxzVAm6UCXcBjhThChzQZ/lVXCo9i9an
X-Received: by 2002:a17:906:a107:b0:932:365a:c1e7 with SMTP id t7-20020a170906a10700b00932365ac1e7mr20591941ejy.67.1680113285822;
        Wed, 29 Mar 2023 11:08:05 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m10-20020a1709066d0a00b00920438f59b3sm12072998ejr.154.2023.03.29.11.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 11:08:05 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 04/10] selftests: xsk: Deflakify STATS_RX_DROPPED test
Date:   Wed, 29 Mar 2023 20:04:56 +0200
Message-Id: <20230329180502.1884307-5-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230329180502.1884307-1-kal.conley@dectris.com>
References: <20230329180502.1884307-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix flaky STATS_RX_DROPPED test. The receiver calls getsockopt after
receiving the last (valid) packet which is not the final packet sent in
the test (valid and invalid packets are sent in alternating fashion with
the final packet being invalid). Since the last packet may or may not
have been dropped already, both outcomes must be allowed.

This issue could also be fixed by making sure the last packet sent is
valid. This alternative is left as an exercise to the reader (or the
benevolent maintainers of this file).

This problem was quite visible on certain setups. On one machine this
failure was observed 50% of the time.

Also, remove a redundant assignment of pkt_stream->nb_pkts. This field
is already initialized by __pkt_stream_alloc.

Fixes: 27e934bec35b ("selftests: xsk: make stat tests not spin on getsockopt")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 34a1f32fe752..1a4bdd5aa78c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -633,7 +633,6 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
-	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
 		pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
 			pkt_len);
@@ -1141,7 +1140,14 @@ static int validate_rx_dropped(struct ifobject *ifobject)
 	if (err)
 		return TEST_FAILURE;
 
-	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2)
+	/* The receiver calls getsockopt after receiving the last (valid)
+	 * packet which is not the final packet sent in this test (valid and
+	 * invalid packets are sent in alternating fashion with the final
+	 * packet being invalid). Since the last packet may or may not have
+	 * been dropped already, both outcomes must be allowed.
+	 */
+	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 ||
+	    stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 - 1)
 		return TEST_PASS;
 
 	return TEST_FAILURE;
-- 
2.39.2

