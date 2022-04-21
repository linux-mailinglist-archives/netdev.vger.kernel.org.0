Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5960509467
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383494AbiDUAoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383604AbiDUAmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:46 -0400
Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C87C9FC8
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:39:58 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501597;
        bh=cRAvzrtALX1sJ8J18VhyO/LgCTRMCMTwVnkRTlhgHHY=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=bN7ztdhb3R7z9ftStNO+xmJOuI0eX/7lvHTuEM2FKXprSN+QoX55kjLXacGPAQZie
         Q6+6KndDKQXPh6LnZRm8KXOCmmuf9lTgJ6ZSleFF6gZhhY3RIb0/mIbjYr9otNNF9e
         p7R9alTrgJBCQpd9NR1SsnREpEiU/TBe0kJ3DMQZ+1Ra2+hijoJWupRVJnWpByn2V2
         kv2KdfVYAjzWNQr6zmnO0AQotqWT7FYitJt0NzzPIceDSobra7m+xX2DwP3+Jm0D0v
         IDXVWOf56J/SRdfhggn4zDph4Brp15HVph3qnyIz/4a0xZHX0444Lqz97WjDRwRmGC
         Vk7flGjRnNrsA==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf 10/11] samples/bpf: fix -Wsequence-point
Message-ID: <20220421003152.339542-11-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some libc implementations, CPU_SET() may utilize its first
argument several times. When combined with a post-increment,
it leads to:

samples/bpf/test_lru_dist.c:233:36: warning: operation on 'next_to_try' may=
 be undefined [-Wsequence-point]
  233 |                 CPU_SET(next_to_try++, &cpuset);
      |                                    ^

Macros must always define local copies of arguments to avoid
reusing, but since several libc versions already and still have
that, split the sentence into two standalone operations to fix
this.

Fixes: 5db58faf989f ("bpf: Add tests for the LRU bpf_htab")
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/test_lru_dist.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index 75e877853596..d09ccd5370e8 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -230,7 +230,8 @@ static int sched_next_online(int pid, int next_to_try)

 =09while (next_to_try < nr_cpus) {
 =09=09CPU_ZERO(&cpuset);
-=09=09CPU_SET(next_to_try++, &cpuset);
+=09=09CPU_SET(next_to_try, &cpuset);
+=09=09next_to_try++;
 =09=09if (!sched_setaffinity(pid, sizeof(cpuset), &cpuset))
 =09=09=09break;
 =09}
--
2.36.0


