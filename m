Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B73869799C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjBOKQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBOKQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:16:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF2520D38
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676456117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XgPatfmnXvPgz1VIUbvWbCW+gSRBDQUM/MeNF32Ay4Q=;
        b=QOdK1Z5Gc6e/2kLc7mxQsO7CW/hcwmaR7qZVqugSBSoqWLXnf9+LDU86dD8Gs0I4UfLHpH
        TEmZx/H5BVchIiHZKSgGPqkAPX9oOFL6uvXhy08vQ8qHRDN1CC/o93VjaGdOLNbGedx/Za
        MB87MOxp6bSqL+4avTB+rPceyH5FPN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-TUeTzcxcOwW8WzKo6K8dPw-1; Wed, 15 Feb 2023 05:15:14 -0500
X-MC-Unique: TUeTzcxcOwW8WzKo6K8dPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D8881C06ED3;
        Wed, 15 Feb 2023 10:15:13 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-25.brq.redhat.com [10.40.208.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB480C15BA0;
        Wed, 15 Feb 2023 10:15:12 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2B20430000306;
        Wed, 15 Feb 2023 11:09:36 +0100 (CET)
Subject: [PATCH bpf-next V1] xdp: bpf_xdp_metadata use NODEV for no device
 support
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        xdp-hints@xdp-project.net
Date:   Wed, 15 Feb 2023 11:09:36 +0100
Message-ID: <167645577609.1860229.12489295285473044895.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With our XDP-hints kfunc approach, where individual drivers overload the
default implementation, it can be hard for API users to determine
whether or not the current device driver have this kfunc available.

Change the default implementations to use an errno (ENODEV), that
drivers shouldn't return, to make it possible for BPF runtime to
determine if bpf kfunc for xdp metadata isn't implemented by driver.

This is intended to ease supporting and troubleshooting setups. E.g.
when users on mailing list report -19 (ENODEV) as an error, then we can
immediately tell them their kernel is too old.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/xdp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 26483935b7a4..7bb5984ae4f7 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -722,10 +722,12 @@ __diag_ignore_all("-Wmissing-prototypes",
  * @timestamp: Return value pointer.
  *
  * Returns 0 on success or ``-errno`` on error.
+ *
+ *  -ENODEV (19): means device driver doesn't implement kfunc
  */
 __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
 {
-	return -EOPNOTSUPP;
+	return -ENODEV;
 }
 
 /**
@@ -734,10 +736,12 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
  * @hash: Return value pointer.
  *
  * Returns 0 on success or ``-errno`` on error.
+ *
+ *  -ENODEV (19): means device driver doesn't implement kfunc
  */
 __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
 {
-	return -EOPNOTSUPP;
+	return -ENODEV;
 }
 
 __diag_pop();


