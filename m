Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F836BAE46
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjCOK4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjCOK4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:56:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337834BEBD;
        Wed, 15 Mar 2023 03:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678877775; x=1710413775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SfWoz0ZiPRKNB9h/FyiFLW0v6vSMHdAFxkAxVk70Vqo=;
  b=g5n1eINzewFaT1MPlHsqfwama8FWmDEcFJtIbgXzyLUMw99m1is/7wwd
   9JkFES48aXLCI3zaiIP0gBe7fetZ+rS0MUgwPniutFM1I6jqDf3GbC9op
   /ixoVN988vIx2VyFX5DmvGqZdoyMRulOMIVOdsid6KqXQwZ8m+JDKwGcw
   PqS5HEzhAYZ41HrIDqN4xA6IdkJSBYSeD0sye03OyXB6TY9ZUYIZ2buzT
   cfG8+kdeEQabXYMtzR67TfiOsbm8eyPWvBVE9lyaUOT+SOeA7KzW/iLKQ
   ErRwzPlRh1ZA+xGAq2JYV9USnBXORTCGPlyyY8ucIYniu56i6DA3O4iPx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317324582"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="317324582"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:55:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803240335"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803240335"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2023 03:55:38 -0700
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built from XDP frames
Date:   Wed, 15 Mar 2023 11:54:11 +0100
Message-Id: <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com> <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com> <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com> <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com> <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Wed, 15 Mar 2023 10:56:25 +0100

> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date: Tue, 14 Mar 2023 16:54:25 -0700
> 
>> On Tue, Mar 14, 2023 at 11:52 AM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
> 
> [...]
> 
>> test_xdp_do_redirect:PASS:prog_run 0 nsec
>> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc: actual
>> 220 != expected 9998
>> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
>> close_netns:PASS:setns 0 nsec
>> #289 xdp_do_redirect:FAIL
>> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
>>
>> Alex,
>> could you please take a look at why it's happening?
>>
>> I suspect it's an endianness issue in:
>>         if (*metadata != 0x42)
>>                 return XDP_ABORTED;
>> but your patch didn't change that,
>> so I'm not sure why it worked before.
> 
> Sure, lemme fix it real quick.

Hi Ilya,

Do you have s390 testing setups? Maybe you could take a look, since I
don't have one and can't debug it? Doesn't seem to be Endianness issue.
I mean, I have this (the below patch), but not sure it will fix
anything -- IIRC eBPF arch always matches the host arch ._.
I can't figure out from the code what does happen wrongly :s And it
happens only on s390.

Thanks,
Olek
---
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 662b6c6c5ed7..b21371668447 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -107,7 +107,7 @@ void test_xdp_do_redirect(void)
 			    .attach_point = BPF_TC_INGRESS);
 
 	memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
-	*((__u32 *)data) = 0x42; /* metadata test value */
+	*((__u32 *)data) = htonl(0x42); /* metadata test value */
 
 	skel = test_xdp_do_redirect__open();
 	if (!ASSERT_OK_PTR(skel, "skel"))
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
index cd2d4e3258b8..2475bc30ced2 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <vmlinux.h>
+#include <bpf/bpf_endian.h>
 #include <bpf/bpf_helpers.h>
 
 #define ETH_ALEN 6
@@ -28,7 +29,7 @@ volatile int retcode = XDP_REDIRECT;
 SEC("xdp")
 int xdp_redirect(struct xdp_md *xdp)
 {
-	__u32 *metadata = (void *)(long)xdp->data_meta;
+	__be32 *metadata = (void *)(long)xdp->data_meta;
 	void *data_end = (void *)(long)xdp->data_end;
 	void *data = (void *)(long)xdp->data;
 
@@ -44,7 +45,7 @@ int xdp_redirect(struct xdp_md *xdp)
 	if (metadata + 1 > data)
 		return XDP_ABORTED;
 
-	if (*metadata != 0x42)
+	if (*metadata != __bpf_htonl(0x42))
 		return XDP_ABORTED;
 
 	if (*payload == MARK_XMIT)
