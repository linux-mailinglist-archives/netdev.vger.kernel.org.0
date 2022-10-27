Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C040610424
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbiJ0VMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiJ0VLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:11:33 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD782A979
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:10:20 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id l9so2094115qkk.11
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AKE7LY39bknY+Vn90USSAH/VdWTNyhcvC5Api5/jXk0=;
        b=M8/N10pAjtySxYGACwBM4tAF5NjmCyXAfkMQoO9eqIrpNI449fIXNQAlfz6A8FghfY
         xYJvfaXDnMuO0vaNdZaFm/h/Av8uqVNd9OedqkLn86d7CsKMBlcsnpmTX9Zd+vusz+82
         q785tlzxSgcURFwaqdEVh7MsmeQKVhlyLCm2l4HKkTCdB7BUB3pVtyaQgnvHargPlq8g
         lf135SzQtnI4cQwBEHULfJpx1f2q9Cg6P4fQcUmV4pmupR6EqSW7jRryZZFn9ml5Pvvv
         ZIbj1rTs0zx5yXKlEWZrszg4FpAg9Wtra7DT9FQ12TRQ8Y7Gjh7E95nC34N8Epm6unsA
         NvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AKE7LY39bknY+Vn90USSAH/VdWTNyhcvC5Api5/jXk0=;
        b=PQ7nUYU2VvxBD0ydG0KvgO9weFX1IPWmvJeWmdcjrSlljXP1lKlshe16NcsNHPz0qp
         sHNIwdKYkKHd6LS4vd7syhK6LuU98lkxdu1hcl6yqrZnbnglS47P3f0fpoWyFx9Yo3dF
         wiWjadjra7Mn0pVZpuFa5hs+UdSYIEFTZkgmhcaH7xvcO9lbKQVcHyQVykh0oTQl6lu6
         IByDMamOYcxra2OzKT0uoBocuwdis7U5lbTMo+Lcx++f2ybP0OZMLbkORZlpQiOi1IKm
         KougWQfCXx5qadvoBLkHDpYhlPWt4amBxmxU1DW2jAzplInMIgTz6FsTLCp8WYUOxFrD
         o0nA==
X-Gm-Message-State: ACrzQf0qyVoshp9bkXwtjhRKPARNrpWbRvFN7oJTOsK0D9MNbHtjoTHE
        KgO3XHFWSHSVBrMgQYdSK51StLDXW5PHgw==
X-Google-Smtp-Source: AMsMyM62VG+mBhQ6VhZSYPPK2Brs4fPZdS3cNRTT+1/5w452twSApO7f9ptS8f3IplMf+vsi4gZRsg==
X-Received: by 2002:a37:9a43:0:b0:6fa:64:b3be with SMTP id c64-20020a379a43000000b006fa0064b3bemr2545524qke.336.1666905019136;
        Thu, 27 Oct 2022 14:10:19 -0700 (PDT)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id fa13-20020a05622a4ccd00b0039492d503cdsm1425909qtb.51.2022.10.27.14.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:10:18 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vincent.whitchurch@axis.com, cpascoe@google.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] net/packet: add PACKET_FANOUT_FLAG_IGNORE_OUTGOING
Date:   Thu, 27 Oct 2022 17:10:14 -0400
Message-Id: <20221027211014.3581513-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Extend packet socket option PACKET_IGNORE_OUTGOING to fanout groups.

The socket option sets ptype.ignore_outgoing, which makes
dev_queue_xmit_nit skip the socket.

When the socket joins a fanout group, the option is not reflected in
the struct ptype of the group. dev_queue_xmit_nit only tests the
fanout ptype, so the flag is ignored once a socket joins a
fanout group.

Inheriting the option from a socket would change established behavior.
Different sockets in the group can set different flags, and can also
change them at runtime.

Testing in packet_rcv_fanout defeats the purpose of the original
patch, which is to avoid skb_clone in dev_queue_xmit_nit (esp. for
MSG_ZEROCOPY packets).

Instead, introduce a new fanout group flag with the same behavior.

Tested with https://github.com/wdebruij/kerneltools/blob/master/tests/test_psock_fanout_ignore_outgoing.c

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/uapi/linux/if_packet.h | 1 +
 net/packet/af_packet.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index c07caf7b40db6..a8516b3594a44 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -70,6 +70,7 @@ struct sockaddr_ll {
 #define PACKET_FANOUT_EBPF		7
 #define PACKET_FANOUT_FLAG_ROLLOVER	0x1000
 #define PACKET_FANOUT_FLAG_UNIQUEID	0x2000
+#define PACKET_FANOUT_FLAG_IGNORE_OUTGOING     0x4000
 #define PACKET_FANOUT_FLAG_DEFRAG	0x8000
 
 struct tpacket_stats {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8c5b3da0c29f6..44f20cf8a0c0e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1777,6 +1777,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		match->prot_hook.af_packet_net = read_pnet(&match->net);
 		match->prot_hook.id_match = match_fanout_group;
 		match->max_num_members = args->max_num_members;
+		match->prot_hook.ignore_outgoing = type_flags & PACKET_FANOUT_FLAG_IGNORE_OUTGOING;
 		list_add(&match->list, &fanout_list);
 	}
 	err = -EINVAL;
-- 
2.38.1.273.g43a17bfeac-goog

