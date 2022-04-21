Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12F4509445
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383488AbiDUAmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383557AbiDUAmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:36 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68239C15;
        Wed, 20 Apr 2022 17:39:48 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501586;
        bh=OfNKhPyskwu1Q+3O0NrPPcm3lyoLjqwkLF7TAXF+zrM=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=Gv76EDdwK9liHoTdSS5w4HVGCnBoPqoi3KllzNoPJOPyTIw/8Wv6ASNOOEnAaaiV7
         USoT99Z/UgYq7jIIHonFsaWa295GFVDledCPqvv3mz7wzzRaM9oi7RZGOTMwP/80Lv
         +CJeuYfL8NoE16JL/srqKP5qB3g3DZShwM0RmOEnc7Si7lfo2mrbjnj9Dfrcjasi3W
         FIPRcZY2BdqZJo73Tjn/lEAio+PldaIxuztKQQ8UvgQ+ImRZ/HhuoMp9mWCKdRHTxt
         Fdfv7fMtgrfHze1/IHWmrEvY+i9eObYepH/YJIb/LcRSJGQI05eT+pPIjO35jDwWWK
         LSsqxigXJRV/w==
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
Subject: [PATCH v2 bpf 08/11] samples/bpf: fix false-positive right-shift underflow warnings
Message-ID: <20220421003152.339542-9-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32 bit systems, shifting an unsigned long by 32 positions
yields the following warning:

samples/bpf/tracex2_kern.c:60:23: warning: shift count >=3D width of type [=
-Wshift-count-overflow]
        unsigned int hi =3D v >> 32;
                            ^  ~~

sizeof(long) is always 8 for the BPF architecture, so this is not
correct, but the BPF samples Makefile still uses the Clang native +
LLC combo which enforces that.
Until the samples are switched to `-target bpf`, do it the usual
way: shift by 16 two times (see upper_32_bits() macro in the
kernel).

Fixes: d822a1926849 ("samples/bpf: Add counting example for kfree_skb() fun=
ction calls and the write() syscall")
Fixes: 0fb1170ee68a ("bpf: BPF based latency tracing")
Fixes: f74599f7c530 ("bpf: Add tests and samples for LWT-BPF")
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/lathist_kern.c      | 2 +-
 samples/bpf/lwt_len_hist_kern.c | 2 +-
 samples/bpf/tracex2_kern.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/lathist_kern.c b/samples/bpf/lathist_kern.c
index 4adfcbbe6ef4..9744ed547abe 100644
--- a/samples/bpf/lathist_kern.c
+++ b/samples/bpf/lathist_kern.c
@@ -53,7 +53,7 @@ static unsigned int log2(unsigned int v)

 static unsigned int log2l(unsigned long v)
 {
-=09unsigned int hi =3D v >> 32;
+=09unsigned int hi =3D (v >> 16) >> 16;

 =09if (hi)
 =09=09return log2(hi) + 32;
diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist_ker=
n.c
index 1fa14c54963a..bf32fa04c91f 100644
--- a/samples/bpf/lwt_len_hist_kern.c
+++ b/samples/bpf/lwt_len_hist_kern.c
@@ -49,7 +49,7 @@ static unsigned int log2(unsigned int v)

 static unsigned int log2l(unsigned long v)
 {
-=09unsigned int hi =3D v >> 32;
+=09unsigned int hi =3D (v >> 16) >> 16;
 =09if (hi)
 =09=09return log2(hi) + 32;
 =09else
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 5bc696bac27d..6bf22056ff95 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -57,7 +57,7 @@ static unsigned int log2(unsigned int v)

 static unsigned int log2l(unsigned long v)
 {
-=09unsigned int hi =3D v >> 32;
+=09unsigned int hi =3D (v >> 16) >> 16;
 =09if (hi)
 =09=09return log2(hi) + 32;
 =09else
--
2.36.0


