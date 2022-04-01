Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915724EE846
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 08:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245423AbiDAGgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 02:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbiDAGgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 02:36:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0306158549
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 23:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648794880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hp4E3bTHEjuyTCPAc1mCFKq3Aifz4Jdz9FaGKbFLuNA=;
        b=aJARE3N1clEWd1MUXhNZJbRoGBgwiQVSJSnDN78smY1I4/W6cy/HLqfaUw74XTUc/gEiVh
        ZlQpI1HQTbIgg5bxZVw9FRwtNlQBFv6Qk8LM/sKOxlLzh92h7W8zR1pnDxJepJUif6B5aK
        +MSkdXA2tYkcr4yyNRXuIQcL/Kn+q0A=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-2_AR3ezXPYqYctN7hFWfnw-1; Fri, 01 Apr 2022 02:34:39 -0400
X-MC-Unique: 2_AR3ezXPYqYctN7hFWfnw-1
Received: by mail-pg1-f200.google.com with SMTP id t24-20020a632258000000b003988eed18b2so1157664pgm.22
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 23:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hp4E3bTHEjuyTCPAc1mCFKq3Aifz4Jdz9FaGKbFLuNA=;
        b=3TmMzvgobgi/DFHz0fuNOzm3vJnU9gYYVt8imalxuGaQClypkRr32otmZ+nt+6Xtuk
         4D+Kj2zDjPhXopvC4yiVwHkmRjuqrKB/TMVN4gdTSX1oFuvpy7g5v6p9B99OOnoN/a2R
         oU43o+aouYZvYfVaxNKXvSQJX/24uJAMkmm/i2az91mhyeiNahUuox81v5fpGb4QPkkQ
         75AwB2oyxSHeI0p+w8C6ovMLYhfFhniuSBNgFkcXoZHarOJzRKkNUGWWdF6iaFguXv+G
         ck3QqOxxkz2AHShHL0iLVybJ5pivL1t6tYAblgJVYhBWfCWCSbdAWQFoFgQfJgOvPWra
         Pv/Q==
X-Gm-Message-State: AOAM5318uVTUHFClN5Ti8+l++a9iEroGObz69ExmhzvaqZxJOXxllY/6
        di/m0z5X098S+sp90rLuX4kPPyTVP2LqEnETrz0gRhLbWoB4FukbS6eNIRVWpl1gVPIm4TVr7W5
        ZFHlBSthfit5+iU8HJJqTN+vZ+DBa6DQcmkUfSPqNjsSmdbPZlSjXYu2Rpdh71dBVi0bP
X-Received: by 2002:a17:90a:930b:b0:1bf:ac1f:6585 with SMTP id p11-20020a17090a930b00b001bfac1f6585mr10014904pjo.88.1648794878283;
        Thu, 31 Mar 2022 23:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMDvGiSVaLbGdW3eGb2Jpau6ASKm54lT3s5IsGzidPQnr4bHQ9OWh0d9cLmz1UgsVz1pe47A==
X-Received: by 2002:a17:90a:930b:b0:1bf:ac1f:6585 with SMTP id p11-20020a17090a930b00b001bfac1f6585mr10014878pjo.88.1648794877933;
        Thu, 31 Mar 2022 23:34:37 -0700 (PDT)
Received: from fedora19.redhat.com (2403-5804-6c4-aa-7079-8927-5a0f-bb55.ip6.aussiebb.net. [2403:5804:6c4:aa:7079:8927:5a0f:bb55])
        by smtp.gmail.com with ESMTPSA id pj9-20020a17090b4f4900b001c744034e7csm12675749pjb.2.2022.03.31.23.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 23:34:37 -0700 (PDT)
From:   Ian Wienand <iwienand@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ian Wienand <iwienand@redhat.com>
Subject: [PATCH] net/ethernet : set default assignment identifier to NET_NAME_ENUM
Date:   Fri,  1 Apr 2022 17:34:30 +1100
Message-Id: <20220401063430.1189533-1-iwienand@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the original commit 685343fc3ba6 ("net: add
name_assign_type netdev attribute")

  ... when the kernel has given the interface a name using global
  device enumeration based on order of discovery (ethX, wlanY, etc)
  ... are labelled NET_NAME_ENUM.

That describes this case, so set the default for the devices here to
NET_NAME_ENUM to better help userspace tools to know if they might
like to rename them.

Signed-off-by: Ian Wienand <iwienand@redhat.com>
---
 net/ethernet/eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index ebcc812735a4..62b89d6f54fd 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -391,7 +391,7 @@ EXPORT_SYMBOL(ether_setup);
 struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
 				      unsigned int rxqs)
 {
-	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
+	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_ENUM,
 				ether_setup, txqs, rxqs);
 }
 EXPORT_SYMBOL(alloc_etherdev_mqs);
-- 
2.35.1

