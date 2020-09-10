Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F56263FE5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgIJIcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730533AbgIJIb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:31:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21552C061757;
        Thu, 10 Sep 2020 01:31:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk9so2688012pjb.2;
        Thu, 10 Sep 2020 01:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DR5bYLJNAjyREK9wIlSLcrbAvH4kMtjbkkaPEja+364=;
        b=Av7QYZFWs/sh8ixaUfmwP+XDBgCJ97sokGpFvz4pfe9ZD/9MxvUCA+1wFiYKJLHHZX
         42lGau2X9JXTvKOWvLIHlcMxviPOir054xQ6dl2N3/kYVrmMf0j9T+ZuFWzLSo/Y5tfB
         6hhjiJB7zbeI2bn7Kpwtyje4T0MTJ9sdhLsL2ENHSNfNWuOvdlHFM4KRB7lohS9oKZQo
         sSfGthuNUV0ZaxLV7X3znDPrYblt+ta9gWzEA2eP+qzezFosrbAN0y6H2axvRCgkl9CS
         OX5Jj0t2pEcJSNddPNh3zEcaVbYnwLnJqzLMduHKvutl/19oD4aIoZ0Jkrm3HOD29IT/
         p3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DR5bYLJNAjyREK9wIlSLcrbAvH4kMtjbkkaPEja+364=;
        b=H1AkXB1aQI8t44hUOe4JGenk2FGSWPeEB+TFEB0wqc76/qC+7ZLYlplLK86ebPzdwA
         y7frQwAsPAAZZLRL6j/uGZkijNOIkgvAVZDuSz/MZW5iwgEH0mv3ulgIEnMwFT4ai8Ux
         c1VHRAtP/DlBRfV1IJy56jlIeyZnK4Se5kadp/vhoKJlk13F99ZJLfp4T+f3M7Axh1eO
         cJGG1VHgLjt21La2coku5WdseXKUeQ1x2Pd47Vd8afF6rnNjifE6CfEICy62sA6LrUKY
         D8WfJzVb5ykLdGc7H0AMyrlb4hJxVkNpnli+JFuWFU38JxCmidjAJ1qn8hcv3gIIoD/3
         m8fQ==
X-Gm-Message-State: AOAM533tq5XrrBItnhFyNIBElqYQO5UyRknlebS+2kC+GBHwiB95GC/Y
        5/Rd80T2zxhmYg8Pp5TxRS4=
X-Google-Smtp-Source: ABdhPJzqEoRjHVftj4VeNsfwfqHt6vWtZQdsxb6T42tZaB8OWKUt22czG8j0QsqDLgCJU/Rn3PD/nA==
X-Received: by 2002:a17:90a:644b:: with SMTP id y11mr4438798pjm.13.1599726685702;
        Thu, 10 Sep 2020 01:31:25 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c7sm5183438pfj.100.2020.09.10.01.31.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 01:31:25 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/3] samples/bpf: fix possible deadlock in xdpsock
Date:   Thu, 10 Sep 2020 10:31:05 +0200
Message-Id: <1599726666-8431-3-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
References: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a possible deadlock in the l2fwd application in xdpsock that can
occur when there is no space in the Tx ring. There are two ways to get
the kernel to consume entries in the Tx ring: calling sendto() to make
it send packets and freeing entries from the completion ring, as the
kernel will not send a packet if there is no space for it to add a
completion entry in the completion ring. The Tx loop in l2fwd only
used to call sendto(). This patches adds cleaning the completion ring
in that loop.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index b6175cb..b60bf4e 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1125,6 +1125,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
+		complete_tx_l2fwd(xsk, fds);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 			kick_tx(xsk);
 		ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
-- 
2.7.4

