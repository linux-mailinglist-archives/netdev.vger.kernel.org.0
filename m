Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64426560459
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiF2PTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiF2PTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:19:16 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB2E2250A;
        Wed, 29 Jun 2022 08:19:14 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h192so15645077pgc.4;
        Wed, 29 Jun 2022 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0cfmRdAvbEnfKmowk6LCE7SyxN1zSbLIUtfQLJkJW6Y=;
        b=pjtQogg7gt8mwiT+xur+deDAPdeNdXQEG2sDYhvXu2EIXXpYl3VnaNp/PI/GnggDLU
         GSPEBuPq5582VtpEooISWNts6FYsmGAoOBEgJVIpK+f/fV5CEg5oa3hD/5cP056g2Am8
         4BCGbJ/rYGKjFU6ePRb+0ypPhuGpdxDvqV9gFaKXIFwHTz2pEcChCmcBJkyONA5PNxJQ
         Bwz0b7Bz3KMcPcQzt2N6A+Fxo8rjjdb3f2KCktLhd2mS5itYuMz+p+lJYfSi0yZ5mOAH
         Gu0URsOPnAgx5OnEM7gcs9XQ5jfMiE2MS9SYuJzKuF8J0BrJgR26tg5nK2stqZyvhgBl
         kuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0cfmRdAvbEnfKmowk6LCE7SyxN1zSbLIUtfQLJkJW6Y=;
        b=VIXrsltamua+7pQgXC00Nfkz4KV3c++VJyHpd3sEx0E5zNt37RlSf7Lye96c3PEANQ
         a01fmKJTN1c9t7eGc02ZUibd+qPDiMp08Z9P+4BsO8ealOGIuz99lXUMJ+1WvXtCbPl6
         xI25Xv6AzwhHHyxwclObjd7DmFV2n8Y3YAzQXI3yOlFWey7kNUatSgdDSeSlnFKruc09
         zkwZlqpCNFyzRLCWv0RTa2CJjA1RiP1pAOMND8WY3v3+jUPHAIH2z4j3Bu/u96Mxfp5Y
         eOzQIBbL9i0Vvodt05rVlwv2AXZtutuwJTUngXtZMj/+4ps/MOcD8IELhGBdvs/hLYI5
         W9rg==
X-Gm-Message-State: AJIora+PPPLFCqK9yof83E5waHUdEVkiu9Rnsv4NZHE6HyVECPJOfbOE
        EydL93fyFjA7O5QdwDVUsvo=
X-Google-Smtp-Source: AGRyM1tOeiXCU8JbIsgPKDyIeqMIgVx2Jq8CZzCjYH0K+WhHef1aWXImkRainDoXdLBOX5x6ZH8cLw==
X-Received: by 2002:a63:2c0d:0:b0:411:4fd7:ecba with SMTP id s13-20020a632c0d000000b004114fd7ecbamr3317264pgs.64.1656515954404;
        Wed, 29 Jun 2022 08:19:14 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902b41400b001676dac529asm11522657plr.146.2022.06.29.08.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:19:13 -0700 (PDT)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v4 0/3] cleanup the legacy probe_event on failed scenario
Date:   Wed, 29 Jun 2022 23:18:44 +0800
Message-Id: <20220629151848.65587-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A potential scenario, when an error is returned after
add_uprobe_event_legacy() in perf_event_uprobe_open_legacy(), or
bpf_program__attach_perf_event_opts() in
bpf_program__attach_uprobe_opts() returns an error, the uprobe_event
that was previously created is not cleaned.

At the same time, the legacy kprobe_event also have similar problems.

With these patches, whenever an error is returned, it ensures that
the created kprobe_event/uprobe_event is cleaned.

V1 -> v3:

- add detail commits
- call remove_kprobe_event_legacy() on failed bpf_program__attach_perf_event_opts()

v3 -> v4:

- cleanup the legacy kprobe_event on failed add/attach_event

Chuang Wang (3):
  libbpf: cleanup the legacy kprobe_event on failed add/attach_event()
  libbpf: fix wrong variable used in perf_event_uprobe_open_legacy()
  libbpf: cleanup the legacy uprobe_event on failed add/attach_event()

 tools/lib/bpf/libbpf.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

-- 
2.34.1

