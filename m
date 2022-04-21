Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43624509449
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346941AbiDUAob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383530AbiDUAmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:25 -0400
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DB82A262;
        Wed, 20 Apr 2022 17:39:37 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501575;
        bh=0PStfJn/A30V4r63nD53fw6U9MRSxUFeg0SQxYCDl8o=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=ha5O7GsYjAxVIWUiwEWS6Wh5ksolr7RWStN0fdNIJ4VKKHWIRQCtr+M06ZWxebTuW
         vhPVsPi2kytoKb9p90Ziwj2ZT+KPMZ1jXcVqqHchqse4S/0jcOUPyM7PM5N+qZ4WkU
         4k4dlSRssuF+OIoMhDXH4fKm/4l4HLB1pl+nLsAmFildlGsK4XKckGPjUQOve0rsk7
         cwaEtCPHImlTgg6dDkMdKMls+EjdbjJZ/VD/AxWg1Wfauq2sy4zdW4DaNttbPEM5FV
         davbM8BIOnKyQl6s3wJgCNuNXlP1GHlHIehk2M4F60+Y0ixcbzaqgkz+G32ZZKp6AW
         Vg8LiqmlPGU7Q==
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
Subject: [PATCH v2 bpf 07/11] samples/bpf: fix uin64_t format literals
Message-ID: <20220421003152.339542-8-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a couple places where uin64_t is being passed as an %lu
format argument. That type is defined as unsigned long on 64-bit
systems and as unsigned long long on 32-bit, so neither %lu nor
%llu are not universal.
One of the options is %PRIu64, but since it's always 8-byte long,
just cast it to the _proper_ __u64 and print as %llu.

Fixes: 51570a5ab2b7 ("A Sample of using socket cookie and uid for traffic m=
onitoring")
Fixes: 00f660eaf378 ("Sample program using SO_COOKIE")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/cookie_uid_helper_example.c | 12 ++++++------
 samples/bpf/lwt_len_hist_user.c         |  7 ++++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_u=
id_helper_example.c
index f0df3dda4b1f..269fac58fd5c 100644
--- a/samples/bpf/cookie_uid_helper_example.c
+++ b/samples/bpf/cookie_uid_helper_example.c
@@ -207,9 +207,9 @@ static void print_table(void)
 =09=09=09error(1, errno, "fail to get entry value of Key: %u\n",
 =09=09=09=09curN);
 =09=09} else {
-=09=09=09printf("cookie: %u, uid: 0x%x, Packet Count: %lu,"
-=09=09=09=09" Bytes Count: %lu\n", curN, curEntry.uid,
-=09=09=09=09curEntry.packets, curEntry.bytes);
+=09=09=09printf("cookie: %u, uid: 0x%x, Packet Count: %llu, Bytes Count: %=
llu\n",
+=09=09=09       curN, curEntry.uid, (__u64)curEntry.packets,
+=09=09=09       (__u64)curEntry.bytes);
 =09=09}
 =09}
 }
@@ -265,9 +265,9 @@ static void udp_client(void)
 =09=09if (res < 0)
 =09=09=09error(1, errno, "lookup sk stat failed, cookie: %lu\n",
 =09=09=09      cookie);
-=09=09printf("cookie: %lu, uid: 0x%x, Packet Count: %lu,"
-=09=09=09" Bytes Count: %lu\n\n", cookie, dataEntry.uid,
-=09=09=09dataEntry.packets, dataEntry.bytes);
+=09=09printf("cookie: %llu, uid: 0x%x, Packet Count: %llu, Bytes Count: %l=
lu\n\n",
+=09=09       (__u64)cookie, dataEntry.uid, (__u64)dataEntry.packets,
+=09=09       (__u64)dataEntry.bytes);
 =09}
 =09close(s_send);
 =09close(s_rcv);
diff --git a/samples/bpf/lwt_len_hist_user.c b/samples/bpf/lwt_len_hist_use=
r.c
index 430a4b7e353e..c682faa75a2b 100644
--- a/samples/bpf/lwt_len_hist_user.c
+++ b/samples/bpf/lwt_len_hist_user.c
@@ -44,7 +44,8 @@ int main(int argc, char **argv)

 =09while (bpf_map_get_next_key(map_fd, &key, &next_key) =3D=3D 0) {
 =09=09if (next_key >=3D MAX_INDEX) {
-=09=09=09fprintf(stderr, "Key %lu out of bounds\n", next_key);
+=09=09=09fprintf(stderr, "Key %llu out of bounds\n",
+=09=09=09=09(__u64)next_key);
 =09=09=09continue;
 =09=09}

@@ -66,8 +67,8 @@ int main(int argc, char **argv)

 =09for (i =3D 1; i <=3D max_key + 1; i++) {
 =09=09stars(starstr, data[i - 1], max_value, MAX_STARS);
-=09=09printf("%8ld -> %-8ld : %-8ld |%-*s|\n",
-=09=09       (1l << i) >> 1, (1l << i) - 1, data[i - 1],
+=09=09printf("%8ld -> %-8ld : %-8lld |%-*s|\n",
+=09=09       (1l << i) >> 1, (1l << i) - 1, (__u64)data[i - 1],
 =09=09       MAX_STARS, starstr);
 =09}

--
2.36.0


