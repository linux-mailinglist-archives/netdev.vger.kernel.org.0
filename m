Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B796C5BA9
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjCWBEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 21:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWBEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 21:04:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40D27D6A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:04:19 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N0grUF031588
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:04:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=BjQy3aUUufJ+026SPDGyGiUVo6uCwdZYOChPF0HQ8Ko=;
 b=UHgAwnAWWUKt154PIBgd2ILcQVVK3z+I1H3Od+WEqFywEZ/kv5IfW0lOycvGl5f9rSXo
 D6KEHTpOEBqu9Kmz6J7aWho7oYYbij3nocrpIIAKxyAVS9OxQUrr1UzHOs8QT9tVoss+
 PbAUZsmIeJ4ZzgUAZ6ZQ4krw5vGw+XbwRUIa6Ff3GVUb0AVLGR8wSTMlBjJYX/P4I0Eb
 mWTPWDp4mPEc+lUWMpx6fhsOiVh0cZyZDWhSWbux7+tlIgWWXCu/6E6GUpOnq5vTB2VC
 c+OTee6ZOfIOe+zUHSeEGdFtGESviOcSVqNUmpeHkvu4q9Fxh9NYuWXBhMVkw6zkFdce Nw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pfuf6xgq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:04:19 -0700
Received: from twshared34471.14.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 22 Mar 2023 18:04:18 -0700
Received: by devbig931.frc1.facebook.com (Postfix, from userid 460691)
        id 938CA80624A2; Wed, 22 Mar 2023 18:04:10 -0700 (PDT)
From:   Kui-Feng Lee <kuifeng@meta.com>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <kernel-team@meta.com>, <andrii@kernel.org>,
        <sdf@google.com>
CC:     Kui-Feng Lee <kuifeng@meta.com>, <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH bpf-next v11 2/8] net: Update an existing TCP congestion control algorithm.
Date:   Wed, 22 Mar 2023 18:04:03 -0700
Message-ID: <20230323010409.2265383-3-kuifeng@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323010409.2265383-1-kuifeng@meta.com>
References: <20230323010409.2265383-1-kuifeng@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cUJufbNExgrvQ0K5bND19tUumHWKCXMV
X-Proofpoint-GUID: cUJufbNExgrvQ0K5bND19tUumHWKCXMV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This feature lets you immediately transition to another congestion
control algorithm or implementation with the same name.  Once a name
is updated, new connections will apply this new algorithm.

The purpose is to update a customized algorithm implemented in BPF
struct_ops with a new version on the flight.  The following is an
example of using the userspace API implemented in later BPF patches.

   link =3D bpf_map__attach_struct_ops(skel->maps.ca_update_1);
   .......
   err =3D bpf_link__update_map(link, skel->maps.ca_update_2);

We first load and register an algorithm implemented in BPF struct_ops,
then swap it out with a new one using the same name. After that, newly
created connections will apply the updated algorithm, while older ones
retain the previous version already applied.

This patch also takes this chance to refactor the ca validation into
the new tcp_validate_congestion_control() function.

Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
---
 include/net/tcp.h   |  3 +++
 net/ipv4/tcp_cong.c | 65 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..2abb755e6a3a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1117,6 +1117,9 @@ struct tcp_congestion_ops {
=20
 int tcp_register_congestion_control(struct tcp_congestion_ops *type);
 void tcp_unregister_congestion_control(struct tcp_congestion_ops *type);
+int tcp_update_congestion_control(struct tcp_congestion_ops *type,
+				  struct tcp_congestion_ops *old_type);
+int tcp_validate_congestion_control(struct tcp_congestion_ops *ca);
=20
 void tcp_assign_congestion_control(struct sock *sk);
 void tcp_init_congestion_control(struct sock *sk);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db8b4b488c31..e677d0bc12ad 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -75,14 +75,8 @@ struct tcp_congestion_ops *tcp_ca_find_key(u32 key)
 	return NULL;
 }
=20
-/*
- * Attach new congestion control algorithm to the list
- * of available options.
- */
-int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
+int tcp_validate_congestion_control(struct tcp_congestion_ops *ca)
 {
-	int ret =3D 0;
-
 	/* all algorithms must implement these */
 	if (!ca->ssthresh || !ca->undo_cwnd ||
 	    !(ca->cong_avoid || ca->cong_control)) {
@@ -90,6 +84,20 @@ int tcp_register_congestion_control(struct tcp_congest=
ion_ops *ca)
 		return -EINVAL;
 	}
=20
+	return 0;
+}
+
+/* Attach new congestion control algorithm to the list
+ * of available options.
+ */
+int tcp_register_congestion_control(struct tcp_congestion_ops *ca)
+{
+	int ret;
+
+	ret =3D tcp_validate_congestion_control(ca);
+	if (ret)
+		return ret;
+
 	ca->key =3D jhash(ca->name, sizeof(ca->name), strlen(ca->name));
=20
 	spin_lock(&tcp_cong_list_lock);
@@ -130,6 +138,49 @@ void tcp_unregister_congestion_control(struct tcp_co=
ngestion_ops *ca)
 }
 EXPORT_SYMBOL_GPL(tcp_unregister_congestion_control);
=20
+/* Replace a registered old ca with a new one.
+ *
+ * The new ca must have the same name as the old one, that has been
+ * registered.
+ */
+int tcp_update_congestion_control(struct tcp_congestion_ops *ca, struct =
tcp_congestion_ops *old_ca)
+{
+	struct tcp_congestion_ops *existing;
+	int ret;
+
+	ret =3D tcp_validate_congestion_control(ca);
+	if (ret)
+		return ret;
+
+	ca->key =3D jhash(ca->name, sizeof(ca->name), strlen(ca->name));
+
+	spin_lock(&tcp_cong_list_lock);
+	existing =3D tcp_ca_find_key(old_ca->key);
+	if (ca->key =3D=3D TCP_CA_UNSPEC || !existing || strcmp(existing->name,=
 ca->name)) {
+		pr_notice("%s not registered or non-unique key\n",
+			  ca->name);
+		ret =3D -EINVAL;
+	} else if (existing !=3D old_ca) {
+		pr_notice("invalid old congestion control algorithm to replace\n");
+		ret =3D -EINVAL;
+	} else {
+		/* Add the new one before removing the old one to keep
+		 * one implementation available all the time.
+		 */
+		list_add_tail_rcu(&ca->list, &tcp_cong_list);
+		list_del_rcu(&existing->list);
+		pr_debug("%s updated\n", ca->name);
+	}
+	spin_unlock(&tcp_cong_list_lock);
+
+	/* Wait for outstanding readers to complete before the
+	 * module or struct_ops gets removed entirely.
+	 */
+	synchronize_rcu();
+
+	return ret;
+}
+
 u32 tcp_ca_get_key_by_name(struct net *net, const char *name, bool *ecn_=
ca)
 {
 	const struct tcp_congestion_ops *ca;
--=20
2.34.1

