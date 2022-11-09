Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610B4623628
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiKIVxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiKIVxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:53:30 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FED3C6D4;
        Wed,  9 Nov 2022 13:52:45 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l6so142011pjj.0;
        Wed, 09 Nov 2022 13:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+pEds6xbqwO7ZXoU8W3gHnIf1FWaQAruuWLiKMGCYv4=;
        b=noWKz8oim+7TAut/OpvNfUAgB0AkG9Tqpy9pvoP3Tlb+G6BuTjdd5OSH6colst1uQV
         w1CZK9NfLgzTmkXVeECCX194Vk3lZclqPJKv5dnrpqJ689SdWhqEWtlS2/hMh9y64m3r
         C0zS7WYShkWRTJjds0RK5hS3J83TETqF3HB/XSLQhLOkqBLYyNZ28vxiiuRHDSp99ilE
         SIQpTiHhek6XRCoHiqL/id9DwkqeRywi1KaEqnFvpWqzWokmK2iQUU+zIu2jtYdBYzvo
         HrasUxJlmAZXRTziz9WDKqeJCoNjbuin1K6/XoEGVLRnoZJ6qASSUfovrqQX95Ab4WXI
         V15Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+pEds6xbqwO7ZXoU8W3gHnIf1FWaQAruuWLiKMGCYv4=;
        b=Bj1F1rpFLEy5i8fYZDrlu4jpMCOw7mmfStZFajcsuJz4MSYw4Agafl5UjGKG6UEN5V
         gVwdo7GlsXhfvzpTWry5ImgH9HuQON8D2A4shnQyQNcs79OahrapY2cMK4jWnHfPTIDd
         5pEqrGp/vj4HtyebQdrjuIO5iFgHyKgBMpf4YpYWi49ysBLRSOAYCXnNWyVRStLgs5ow
         MtzUK/Ro8FjkLPgdvaQF6EwyfVl6Yd6/DcvqsTrjeHYHx+9lzP3+UVDQYf35v+T1/85p
         Z3WOA/QI9rHFufmYpb9nwwZqtXfmzHgl94+Ve8MNroy6hRP3IortbX17j5bUeKLaGVio
         uAng==
X-Gm-Message-State: ACrzQf3R6d0A2ksalVYwt1I0enr1+cS0n2PQqcvKighYM9PCm7+S3p0z
        Y3AfnKKIcvAUUjSu8cpfTve8+g4LBJ4=
X-Google-Smtp-Source: AMsMyM7neTbb3h1g/UqwjocBOeWvSnDGRv645zNWHAQsfF+nxUVmQgcn/AOxD7w+4XRzFkW2vy+plA==
X-Received: by 2002:a17:902:b284:b0:187:a99:8178 with SMTP id u4-20020a170902b28400b001870a998178mr61038510plr.98.1668030765118;
        Wed, 09 Nov 2022 13:52:45 -0800 (PST)
Received: from john.lan ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id h3-20020aa796c3000000b0056246403534sm8727802pfq.88.2022.11.09.13.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 13:52:44 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     hawk@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, sdf@google.com
Subject: [0/2 bpf-next] Expose netdev in XDP progs with BTF_ID
Date:   Wed,  9 Nov 2022 13:52:40 -0800
Message-Id: <20221109215242.1279993-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
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

In one of our network monitoring tools we collect metadata about the
interfaces. This is done in a map and then userspace can read the
stats out as needed. Currently, this is done through kprobes but
it causes unnecessary overhead (we have an XDP program running and
its slower than XDP anyways) and extra complexity as we have two
programs instead of one. The main hook we use to chase down the
needed data is the net_device. From this we can get the name of
the interface, its network namespace (and eventually pod in K8s
world), qdisc information, etc.

Because some of the data is per packet data, e.g. getting a unique
key for the ifindex+inum, we can't simply do it with an iterator.

Patch1 exposes the net_device in the xdp_md and patch 2 adds some
tests to walk the net_device to report name, ifindex, and inum.

John Fastabend (2):
  bpf: expose net_device from xdp for additional metadata
  bpf: add selftest to read xdp_md fields

 include/uapi/linux/bpf.h                      |  1 +
 net/core/filter.c                             | 19 ++++++++++
 tools/include/uapi/linux/bpf.h                |  1 +
 .../testing/selftests/bpf/prog_tests/xdp_md.c | 35 +++++++++++++++++++
 .../testing/selftests/bpf/progs/test_xdp_md.c | 25 +++++++++++++
 5 files changed, 81 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_md.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_md.c

-- 
2.33.0

