Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34604ABFD1
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388043AbiBGNqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449004AbiBGNPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:15:04 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3D7C043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 05:15:03 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z20so19532810ljo.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 05:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ogTHEJ6u2M62tUs2AjfjDpWnGrLDSdZkHRs0/05Ftio=;
        b=IcucMnOntR53bFU9rFuJNUllXAos1otMSmN+SCvxVFHf77e2OHIhJJYbY5CKnsChN7
         xgoCeHz7NBRTmyXx6Fo2+YDc3JQU3RgeyVwpN+0E2zrbaKurY+z0rTlrvAhZY/4yrNWQ
         4Tftbk7WksSPA42zgpq7rlE6MoPkPuk9jahog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ogTHEJ6u2M62tUs2AjfjDpWnGrLDSdZkHRs0/05Ftio=;
        b=7ggSHmx4iXF3+zJ2+kNGDOTgUYug0Tjn6NG/Elox3ANwWy3DfIp7ZgTCCDzEX/XqFJ
         OAKBm4RgyuLzf3UNodlInt5lvr6IsHWaNRzfW+gMfTqtUWlM7BFexarheFmMAawNZ5oh
         C529H1sIdlSlSvZJSGSVGW5eXM1CS9c2HumlLDNkWr8OwXaDkcb8AePTwaQqS3mZoN4t
         HjO6ajKO4d6qvYaIWUzUSJrWyzUR4LCL2O3KBSaL9Ff1INQmTNa40Y4USui1+mh2wV9k
         R8+QyRSzICmKKsv66oBnSfAIL3Axg6d4bqyGGVrXA6nRGEIfeIX0PRxbGT9laYEGG7lW
         lBgg==
X-Gm-Message-State: AOAM531PCUnE3ABUFGQXsAFhTTa+nALl413WPvVgYD9OLHWgesCPSH2p
        h4OM+WdqFcBKHG1Pv8L/npS+dwRuNbh5Tg==
X-Google-Smtp-Source: ABdhPJxmwcxQe/2G1oOhTH9jv/pfwdnFtMio0JqRY44WvhOAjdpwfOKMwD3WKiw0bTLOVcb/u4fDxg==
X-Received: by 2002:a2e:8948:: with SMTP id b8mr3398982ljk.36.1644239700826;
        Mon, 07 Feb 2022 05:15:00 -0800 (PST)
Received: from cloudflare.com (user-5-173-137-68.play-internet.pl. [5.173.137.68])
        by smtp.gmail.com with ESMTPSA id z5sm657415lft.210.2022.02.07.05.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 05:15:00 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 0/2] Split bpf_sk_lookup remote_port field
Date:   Mon,  7 Feb 2022 14:14:57 +0100
Message-Id: <20220207131459.504292-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the recent split-up of the bpf_sock dst_port field, apply the same to
technique to the bpf_sk_lookup remote_port field to make uAPI more user
friendly.

Jakub Sitnicki (2):
  bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
  selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup

 include/uapi/linux/bpf.h                           | 3 ++-
 net/core/filter.c                                  | 3 ++-
 tools/include/uapi/linux/bpf.h                     | 3 ++-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c | 6 ++++++
 4 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.31.1

