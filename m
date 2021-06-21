Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657353AF6A9
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 22:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhFUULK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 16:11:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhFUULK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 16:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624306135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=IBJQbTRS2kXZTDVvSBIp/s/7lt1F+H7jwdZf6kGnxmM=;
        b=SV2pJykJ1sPCWLfs+Q9aWrFd0J5n9WL4xDGjeFTJnGvXUkqmiNWC5/Lz0ZiYDt5llRFJvO
        Z+mOkgJZfntaKwZEIbuiEWrKyW1VtdB+HA36/ysnhnL/1edjZbIWg7MkC9zvJNuIMXTJ6g
        uoYBMKL7toc2qDTQQd5OuqD2UJJBcnY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-37QffSD9Nuqtz2U22GYo2A-1; Mon, 21 Jun 2021 16:08:53 -0400
X-MC-Unique: 37QffSD9Nuqtz2U22GYo2A-1
Received: by mail-wm1-f71.google.com with SMTP id g14-20020a05600c4eceb02901b609849650so94451wmq.6
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 13:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=IBJQbTRS2kXZTDVvSBIp/s/7lt1F+H7jwdZf6kGnxmM=;
        b=YnJ25IKtOeB0AQgYIFhwMYO4EbL2Mk6Za56cjHvcAqMvjyWxY1CaX0BL8gStFm9XgV
         6k3urHXCxoeS68Vzk3sj/KGPMK7EpNitVLwWrQszFbPzxa9k+PonaE8/UuBqaB0uyc03
         TnrR4rSu6yQ1JAWMk4pFgsLT4ZsmTLcvd43tVVa2xslxfBhNNQH/G4DWl41yU9qlA8We
         vb9sdTTWtCIPjxF7huSodZbiXm3fCAAqXo+tyhgwG5hMX0f+9upZq4BY0Cfn4SAgucQ/
         a2XDsyHvrsjFvmofhYCAWRaBR49wKgH2AK1DOBU84YmwuC1kM3TNIBl6+cCHjmAmV7ml
         fL9Q==
X-Gm-Message-State: AOAM530sE18SBICb+06pIxRWuLPuWlULmgV1weZE7fc05BdrnMZQc5+R
        gEiFxU22JMBO5z9EE7vPFj15pOjzj62t+moSNd/VQnzODf5h53qH/d5QAyVpAOYtlOkUV7uAQSg
        qjg3NbhHYDIl4pwtd
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr151647wrt.295.1624306132003;
        Mon, 21 Jun 2021 13:08:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLPlPr2mymIDWmXBhdsc/abT7MkFpnHRPaec9B6hwatwk+fD5dRJNRpDGyTG0UCKwrha3DjQ==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr151627wrt.295.1624306131800;
        Mon, 21 Jun 2021 13:08:51 -0700 (PDT)
Received: from pc-23.home (2a01cb058d44a7001b6d03f4d258668b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d44:a700:1b6d:3f4:d258:668b])
        by smtp.gmail.com with ESMTPSA id b11sm88439wmj.25.2021.06.21.13.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 13:08:51 -0700 (PDT)
Date:   Mon, 21 Jun 2021 22:08:49 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next] net: handle ARPHRD_IP6GRE in
 dev_is_mac_header_xmit()
Message-ID: <5f9a7d9f535e3fa9be60fdc5b10f273fc2e8f7e8.1624306000.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 3b707c3008ca ("net: dev_is_mac_header_xmit() true for
ARPHRD_RAWIP"), add ARPHRD_IP6GRE to dev_is_mac_header_xmit(), to make
ip6gre compatible with act_mirred and __bpf_redirect().

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/linux/if_arp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
index bf5c5f32c65e..b712217f7030 100644
--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -48,6 +48,7 @@ static inline bool dev_is_mac_header_xmit(const struct net_device *dev)
 	case ARPHRD_TUNNEL6:
 	case ARPHRD_SIT:
 	case ARPHRD_IPGRE:
+	case ARPHRD_IP6GRE:
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 	case ARPHRD_RAWIP:
-- 
2.21.3

