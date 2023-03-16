Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE086BD3EB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjCPPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjCPPgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:36:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8951AB06DB
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so2206562ybg.21
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bBK0SE2nSPdeHNhKbgxpJakkNR3dT93wOSXdyQ1c+ZM=;
        b=kjl/6wFxktZ2m5+qczdSlPaLasSxo7g2H7R+jcnPFZYfGi39HBJwLAM+XJ4xOql+ox
         g+LtNd3gH/hZ/WVcbJz22JNd3uc9hyJSkGE06GmHqEn55/FMiXD3XXSeM/Enpo5m2Udz
         0Y04wtI83OipZ/ky9sgiKTpxX9UiKSyhV4t+L+M7WBy8jVPz/CnsBnG3IIW4RDis3UCW
         yXjhl+hrUpTPEuefYz99LOO65agZv+LBDFTP4DaiR5iz67/3lhNN/6S+gpWx9iChIiXM
         ELq7GGi+X/7VeofgRnA4EI6KASImrv1rlSO0aeeL5jj0uYbAJ7CZL+8gi9XWL7RzmMqM
         d0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bBK0SE2nSPdeHNhKbgxpJakkNR3dT93wOSXdyQ1c+ZM=;
        b=0szmuM3+cg4Lzmd2lZGF1+KWZnKz8LMgiBBNuVgVCmPZUCzFwl0zoG6R3+eYXf4eTd
         dkQukS3/tM2uUz/MNAzOBtPBM1sLBT+mXZYofVHV6XmVFxZAQgdzHPqYe0M46h2evawo
         eCclJk/DM2dRYjb0DGLgAbjomZ5l/u8gf0p5TBoa4ka5c7S1A1zkuxMktvSARw1OCs62
         OYaiDDxmt6qWEFa4qY/eCgwBJ4YFqtkvfIFHh54Ct7/BtzBGY7GylC+o5GvbV+fGNRY5
         MM7jxZglE6sdW7KuYVwE1Cxa74sxdimCyzf75wuqE5XUT+e3R4RiHehauXsdHVqgZSOa
         X/Vw==
X-Gm-Message-State: AO0yUKVMMFmnwJHLRE/eDVCIPyClSq0Sf3q/qAr1u87mAz3Fu9BMPQj/
        aC+YsMd8pv2CvR04+8GA2/5Dc1xOzkppmg==
X-Google-Smtp-Source: AK7set9BlbCDuNFwrxMQTHZKkrMvWvMU9tKMzy6tz7osiyKpJFaKWNC6uC2/ZxoRrew7VbihvQJdlEbUx+dNFw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1024:b0:b4a:3896:bc17 with SMTP
 id x4-20020a056902102400b00b4a3896bc17mr4401834ybt.0.1678980727098; Thu, 16
 Mar 2023 08:32:07 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:31:56 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-3-edumazet@google.com>
Subject: [PATCH v2 net-next 2/8] ipv4: constify ip_mc_sf_allow() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies ip_mc_sf_allow() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/linux/igmp.h | 2 +-
 net/ipv4/igmp.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index b19d3284551f083d0eec3353cd8ec1f486ae4b42..ebf4349a53af7888104e8c5fe0d7af0e5604ae69 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -122,7 +122,7 @@ extern int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 			sockptr_t optval, sockptr_t optlen);
 extern int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 			sockptr_t optval, size_t offset);
-extern int ip_mc_sf_allow(struct sock *sk, __be32 local, __be32 rmt,
+extern int ip_mc_sf_allow(const struct sock *sk, __be32 local, __be32 rmt,
 			  int dif, int sdif);
 extern void ip_mc_init_dev(struct in_device *);
 extern void ip_mc_destroy_dev(struct in_device *);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index c920aa9a62a988bf91a5420e59eb5878c271bf9a..48ff5f13e7979dc00da60b466ee2e74ddce0891b 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2638,10 +2638,10 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 /*
  * check if a multicast source filter allows delivery for a given <src,dst,intf>
  */
-int ip_mc_sf_allow(struct sock *sk, __be32 loc_addr, __be32 rmt_addr,
+int ip_mc_sf_allow(const struct sock *sk, __be32 loc_addr, __be32 rmt_addr,
 		   int dif, int sdif)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 	struct ip_mc_socklist *pmc;
 	struct ip_sf_socklist *psl;
 	int i;
-- 
2.40.0.rc2.332.ga46443480c-goog

