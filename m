Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2874EEFE6
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbiDAObU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242275AbiDAOam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF9228AC59;
        Fri,  1 Apr 2022 07:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C9DA61C4A;
        Fri,  1 Apr 2022 14:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103FCC340F2;
        Fri,  1 Apr 2022 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823250;
        bh=aLld6KZRQXUSWQeHmBhbogz/ELlNHaTEwqpmomHhdk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcgHwhDtooFz/04I8LlPVvlRjGColWEa9f6CNu9dmemfPZASSMTeZuhB5ApXCStJF
         hlEmNrxPuncmvKZHD4kqq3/DeoE7ybus0LZHJgQ4iZUsSCuWbgetSljgT71S2VpMkd
         XFXGMMqeVwPlXEI9/l/Uf2R//9LBFfEdcANVG7P6KxoWWk08PQVqJ2ErQko3OmQsNb
         51fawhtIDL7Vz7t74JCCMjlsCswvbtMFyjpPnWYJdS7/VuVCbHtpFaGtwbthxe1Bd4
         xcP1pH1UBNwqFth1DbA5VNAB1UsVwalXUBP+fA5CLnZ0JU5K5pjkagIlmUcKXAepzO
         IIqbFunBNSERw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Menglong Dong <imagedong@tencent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 034/149] bpf: Make dst_port field in struct bpf_sock 16-bit wide
Date:   Fri,  1 Apr 2022 10:23:41 -0400
Message-Id: <20220401142536.1948161-34-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 4421a582718ab81608d8486734c18083b822390d ]

Menglong Dong reports that the documentation for the dst_port field in
struct bpf_sock is inaccurate and confusing. From the BPF program PoV, the
field is a zero-padded 16-bit integer in network byte order. The value
appears to the BPF user as if laid out in memory as so:

  offsetof(struct bpf_sock, dst_port) + 0  <port MSB>
                                      + 8  <port LSB>
                                      +16  0x00
                                      +24  0x00

32-, 16-, and 8-bit wide loads from the field are all allowed, but only if
the offset into the field is 0.

32-bit wide loads from dst_port are especially confusing. The loaded value,
after converting to host byte order with bpf_ntohl(dst_port), contains the
port number in the upper 16-bits.

Remove the confusion by splitting the field into two 16-bit fields. For
backward compatibility, allow 32-bit wide loads from offsetof(struct
bpf_sock, dst_port).

While at it, allow loads 8-bit loads at offset [0] and [1] from dst_port.

Reported-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20220130115518.213259-2-jakub@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h |  3 ++-
 net/core/filter.c        | 10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..1275b08e9deb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5500,7 +5500,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 :16;		/* zero padding */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/net/core/filter.c b/net/core/filter.c
index 9eb785842258..82fcb7533663 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8033,6 +8033,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 			      struct bpf_insn_access_aux *info)
 {
 	const int size_default = sizeof(__u32);
+	int field_size;
 
 	if (off < 0 || off >= sizeof(struct bpf_sock))
 		return false;
@@ -8044,7 +8045,6 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, family):
 	case offsetof(struct bpf_sock, type):
 	case offsetof(struct bpf_sock, protocol):
-	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
 	case offsetof(struct bpf_sock, rx_queue_mapping):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
@@ -8053,6 +8053,14 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
 		bpf_ctx_record_field_size(info, size_default);
 		return bpf_ctx_narrow_access_ok(off, size, size_default);
+	case bpf_ctx_range(struct bpf_sock, dst_port):
+		field_size = size == size_default ?
+			size_default : sizeof_field(struct bpf_sock, dst_port);
+		bpf_ctx_record_field_size(info, field_size);
+		return bpf_ctx_narrow_access_ok(off, size, field_size);
+	case offsetofend(struct bpf_sock, dst_port) ...
+	     offsetof(struct bpf_sock, dst_ip4) - 1:
+		return false;
 	}
 
 	return size == size_default;
-- 
2.34.1

