Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5722651CBE1
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 00:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386164AbiEEWKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 18:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbiEEWKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 18:10:07 -0400
Received: from posti.softwille.fi (posti.softwille.fi [84.20.137.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A8435DD38;
        Thu,  5 May 2022 15:06:22 -0700 (PDT)
Received: from w530 (unknown [192.168.0.57])
        by posti.softwille.fi (Postfix) with ESMTPSA id 60992BFBE;
        Fri,  6 May 2022 01:06:21 +0300 (EEST)
From:   "Wille Kuutti" <wille.kuutti@kuutti.com>
To:     "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Eric Dumazet'" <edumazet@google.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Paolo Abeni'" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/core: Make bpf_skb_adjust_room BPF helper available for packets with non IPv4 or IPv6 payload
Date:   Fri, 6 May 2022 01:06:20 +0300
Message-ID: <00fd01d860cc$59d5fa60$0d81ef20$@kuutti.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdhgzElv/yEbhyXvR9OrydhkBONgSg==
Content-Language: fi
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network traffic is not limited to only IPv4 and IPv6 protocols, but several
other L3 networking protocols are in common use in several
applications and deployment scenarios which also could utilize BPF. This
change enables the bpf_skb_adjust_room BPF helper to adjust the
room after the MAC header using BPF_ADJ_ROOM_MAC option for packets with any
L3 payload. For BPF_ADJ_ROOM_NET option only IPv4 and IPv6 are
still supported as each L3 protocol would need it's own logic to determine
the length of the L3 header to enable adjustment after the L3
headers.

Signed-off-by: Wille Kuutti <wille.kuutti@kuutti.com>
---
net/core/filter.c | 5 +++--
1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 64470a727ef7..c6790a763c9b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3362,7 +3362,7 @@ static u32 bpf_skb_net_base_len(const struct sk_buff
*skb)
        case htons(ETH_P_IPV6):
                return sizeof(struct ipv6hdr);
        default:
-               return ~0U;
+               return 0U;
        }
}

@@ -3582,7 +3582,8 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb,
s32, len_diff,
        if (unlikely(len_diff_abs > 0xfffU))
                return -EFAULT;
        if (unlikely(proto != htons(ETH_P_IP) &&
-                    proto != htons(ETH_P_IPV6)))
+                       proto != htons(ETH_P_IPV6) &&
+                       mode != BPF_ADJ_ROOM_MAC))
                return -ENOTSUPP;

        off = skb_mac_header_len(skb);
--
2.32.0


