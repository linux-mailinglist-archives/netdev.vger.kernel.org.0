Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341DB4B1B17
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346705AbiBKBTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:19:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243679AbiBKBTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:19:07 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1420A262B
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:19:07 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id l9so1782827plg.0
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NolPYqkwQ/GcaAkm5/nUC8s+JKE9vCE/lwXFzF6PT4Y=;
        b=A2qFaanwgAJf4oBFOBsyvSi2wfRBvIUIFD1U4ueouj4Z2I9FVNOn+f91s6gl+ZG+Oe
         Ethlq+pA4f3dEJHtUv2keBMnrGClA9YvqhxCv3gprlabD9bwDPQixbijtiSum7DDykLb
         rBOLQqnZJFzgIuF/wheiOvH32oFfVpaCbBb1mQu6jeVo0vXt4sYuDP5JB8Kg2Lb9ixm3
         PI/+b1v273eEgEWo3uvyJ4DtWdhpU2k6ezcvzPJuDcMXM/iZU0X8nP6UozHwC73R3fbw
         4UUM/DBzPAWAz2lE0wGSImegT/4LiIUwuxOG235SrbR5g2t/hemdmwRfDVsXItTNmFQ0
         mHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NolPYqkwQ/GcaAkm5/nUC8s+JKE9vCE/lwXFzF6PT4Y=;
        b=xrafTNsghUN/8Ws/6OwKwx083KBJW616rZ60kFQqewpzJ+PX+W28jsEX5th2Q2cITm
         9HCLnJBd+/U6ChkoN95GQv+eIOD7S+dZvbVC0xmqksB6vRULkVucvIgPhzkeZM+O93UR
         fom1UCmjOhxlTM62g9F+IB79xAVlGc/dNeA9kbV9da6qKyhHD1XwhYzgWW+vE+aHY9L1
         7C67qN6lR/1lnt/rMTUqCm0dnSoTPpaHS/MPZkdukE23HBk2qwRb90xX10hy5S12esvj
         DLay/szLzesMCdkg+44eWLozWmEpMi64saCIyEt0agJsAOmoO8UFlZuIh5KMHAZYieBh
         ApDg==
X-Gm-Message-State: AOAM5325+/iecugEzCzqw1fgpj6/QPgX9+FOH2x/7VkA8ZPA6Gtvy5FI
        L6310CCAPA+T2rkKtdjfHLa4Fb867ARx/Sfe
X-Google-Smtp-Source: ABdhPJwjYTv6ZcTok/AbUpsH+tfRg8VsYy3G3RPk0kE7LU0WzJBGETKR/mCwWTEkd23gLRKGi7zmWw==
X-Received: by 2002:a17:90a:af97:: with SMTP id w23mr137729pjq.237.1644542346578;
        Thu, 10 Feb 2022 17:19:06 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id oc17sm3934303pjb.10.2022.02.10.17.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 17:19:06 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:19:03 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] libnetlink: fix socket leak in
 rtnl_open_byproto()
Message-ID: <20220210171903.66f35b6c@hermes.local>
In-Reply-To: <d376d06b-d1e3-c462-3a60-cc2e8ed7a147@gmail.com>
References: <d376d06b-d1e3-c462-3a60-cc2e8ed7a147@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Feb 2022 20:20:45 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> rtnl_open_byproto() does not close the opened socket in case of errors, and the
> socket is returned to the caller in the `fd` field of the struct. However, none
> of the callers care about the socket, so close it in the function immediately to
> avoid any potential resource leaks.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Can do the same thing without introducing a goto

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 7e977a6762f8..0ed6d68b5c08 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -226,29 +226,26 @@ int rtnl_open_byproto(struct rtnl_handle *rth, unsigned int subscriptions,
 	memset(&rth->local, 0, sizeof(rth->local));
 	rth->local.nl_family = AF_NETLINK;
 	rth->local.nl_groups = subscriptions;
+	addr_len = sizeof(rth->local);
 
 	if (bind(rth->fd, (struct sockaddr *)&rth->local,
 		 sizeof(rth->local)) < 0) {
 		perror("Cannot bind netlink socket");
-		return -1;
-	}
-	addr_len = sizeof(rth->local);
-	if (getsockname(rth->fd, (struct sockaddr *)&rth->local,
+	} else if (getsockname(rth->fd, (struct sockaddr *)&rth->local,
 			&addr_len) < 0) {
 		perror("Cannot getsockname");
-		return -1;
-	}
-	if (addr_len != sizeof(rth->local)) {
+	} else if (addr_len != sizeof(rth->local)) {
 		fprintf(stderr, "Wrong address length %d\n", addr_len);
-		return -1;
-	}
-	if (rth->local.nl_family != AF_NETLINK) {
+	} else if (rth->local.nl_family != AF_NETLINK) {
 		fprintf(stderr, "Wrong address family %d\n",
 			rth->local.nl_family);
-		return -1;
+	} else {
+		rth->seq = time(NULL);
+		return 0;
 	}
-	rth->seq = time(NULL);
-	return 0;
+
+	rtnl_close(rth);
+	return -1;
 }
 
 int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
-- 
2.34.1


