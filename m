Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2869949D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjBPMnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBPMnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:43:46 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CAAA7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:43:43 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id qw12so4890162ejc.2
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DSfesCx/ronYqqne2Ppxe227eNk7mktBrMXr0hmsJmU=;
        b=D0lCndrsRknoVk8R90x/5536U0GWjhkCz7nX+UL8L0DbACswJNLHPhg7nGi+XPTvjX
         6gZniP0dg/NtMbNFDXl11kIij4ibktWTo07K65+0q0q6B5TMzVhKU2QHxL1qKD9CcFBd
         F5m5QZItisOKRMUEcq5HJsZ8VzHOGyFMP/N+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DSfesCx/ronYqqne2Ppxe227eNk7mktBrMXr0hmsJmU=;
        b=QDTQgo+j+zkIpPLZ/rB4HByEs/1UZ64dw8R7BFB+sfjIKT0Q0ov2lk9FuszIQEotYb
         qLCK5ekfek8M8PHhl0OCGT3zcM3EGiFF8pHo3zFdZUzSBOp7xuxoTHn2P4LhaD9AjFDS
         L/CaW8aNKb86Is2Yl09E4B9damMXbw9241NkCtC9ZN1ynCSzNA2pkTxxJDi7hkBRcBFQ
         6onMf/riV8JDMrSfoBBLaCAzTk1SgG69meJ/ulbWXEPFJgd6LpAMWJ47ULx+JmuXM8mY
         GWtrYOaYzA2+JeLzlHczgUZyPQn6iirOOi1LvQ7PaNo+VF1ORK9IgjnXj5FookNiUG2G
         9ZzQ==
X-Gm-Message-State: AO0yUKWsGKhnJAojm4fIwIm/DzR3ntKSClCJqonVWCqcg0k4rYMhzOpC
        z7mI8wsTTezNQ+gVfJWLcCFqK68p2nez28RmZD0DJg==
X-Google-Smtp-Source: AK7set97jpvi6UeS/pUCWI0+VafptPvUL9+AtAhv1RfCgy4BK1/h+YFaffYGUtL/g8shJhSoQcLlOQ==
X-Received: by 2002:a17:906:55c6:b0:88d:697d:a3d2 with SMTP id z6-20020a17090655c600b0088d697da3d2mr5592862ejp.54.1676551422028;
        Thu, 16 Feb 2023 04:43:42 -0800 (PST)
Received: from cloudflare.com (79.184.206.151.ipv4.supernova.orange.pl. [79.184.206.151])
        by smtp.gmail.com with ESMTPSA id j25-20020a170906255900b008b1392da8d8sm763620ejb.155.2023.02.16.04.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 04:43:41 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com
Subject: [PATCH net] selftests/net: Interpret UDP_GRO cmsg data as an int value
Date:   Thu, 16 Feb 2023 13:43:40 +0100
Message-Id: <20230216124340.875338-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Data passed to user-space with a (SOL_UDP, UDP_GRO) cmsg carries an
int (see udp_cmsg_recv), not a u16 value, as strace confirms:

  recvmsg(8, {msg_name=...,
              msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
              msg_iovlen=1,
              msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
                            cmsg_level=SOL_UDP,
                            cmsg_type=0x68}],    <-- UDP_GRO
                            msg_controllen=24,
                            msg_flags=0}, 0) = 11200

Interpreting the data as an u16 value won't work on big-endian platforms.
Since it is too late to back out of this API decision [1], fix the test.

[1]: https://lore.kernel.org/netdev/20230131174601.203127-1-jakub@cloudflare.com/

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 4058c7451e70..f35a924d4a30 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -214,11 +214,10 @@ static void do_verify_udp(const char *data, int len)
 
 static int recv_msg(int fd, char *buf, int len, int *gso_size)
 {
-	char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
+	char control[CMSG_SPACE(sizeof(int))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 	struct cmsghdr *cmsg;
-	uint16_t *gsosizeptr;
 	int ret;
 
 	iov.iov_base = buf;
@@ -237,8 +236,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 		     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
 			if (cmsg->cmsg_level == SOL_UDP
 			    && cmsg->cmsg_type == UDP_GRO) {
-				gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
-				*gso_size = *gsosizeptr;
+				*gso_size = *(int *)CMSG_DATA(cmsg);
 				break;
 			}
 		}
-- 
2.39.1

