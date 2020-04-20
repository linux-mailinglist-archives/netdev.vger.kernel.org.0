Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282E31B1490
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgDTSeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgDTSeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:34:23 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3AAC061A0C;
        Mon, 20 Apr 2020 11:34:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j7so1920079pgj.13;
        Mon, 20 Apr 2020 11:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZMXNXOn18ztbuDgZhLYqZA8C0KLTfCYAabuhHQdVEgc=;
        b=bRQ+zQcNerLNraD0+K3XcVBhR8In6GYgzcEMJFJy3EM54s+7VpeUkpewJywI7Dlu1C
         0NV6aw+rdb72SW046ScVrndy1qT+OWeSe3F3WSs53I1INh7jHAF9cPmu3fl1IcxNn52n
         AnetC47v2j8aUaRMwfkjEOPqArnLCpBIEJNTtwh61lLv79b4b7JFaI9clE8aL+U+Ar3O
         x3fwGUBvZHP9tg20oIWd7+Fc+GOkI4AmMoUl0RWU1xZy2Sxts3XpSJxE3WTfbl4weMcc
         bctl/oKZj8sU83vRHoR7vEpuR1MqVevHmTrqEuHJMDIpyrkau/6SCqN4O4gIZ5qHWM5E
         q/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZMXNXOn18ztbuDgZhLYqZA8C0KLTfCYAabuhHQdVEgc=;
        b=dNrossLpumFVEvv1x9ZT6UpqDWdb98xqsEyjUfwnnzuOQlf8++iG/AYDjEQfyluB7W
         cOmluDD+5Y+dahCSxCiIVY5zCKeBZxFCoFNZaQCSjUg+OcN9qP/QZU+LLKMOTVA0C1Jc
         +1dMwycNoWDpukYkodRoeZPrQ9++6k/bFjCDze/ATTBIz2iqunxm8NAs5iytIZSDo6zU
         1lAC69AXaEBSFukG8/2KIUeafRHVSvmGTvgknw9g9qUR4anF2FXb1oLE0inAdl6Yagjm
         YynxcGzM5SxwvZ4jejlBmffHty35dC8jqZ6FKCPkr+DxLgMnatIM0j5NNowEhVt7VQxg
         sASw==
X-Gm-Message-State: AGi0PuZUHX2gnk1vTdJocqBV34BykNo6PQ381Y7bMRhdgDCeRsqWG+L6
        GQg+eEsg1T03QQolg/j/g+4=
X-Google-Smtp-Source: APiQypLLXx1+KoTFJBQwTmqbsymwlQm5i4LeHNqlSUAsMlO3wtSMB/tpw2gZ7VXql4tTCRNgPnJaxQ==
X-Received: by 2002:a62:880f:: with SMTP id l15mr17900763pfd.218.1587407662356;
        Mon, 20 Apr 2020 11:34:22 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id mq6sm51661pjb.38.2020.04.20.11.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:34:21 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] net: bpf: Allow TC programs to call BPF_FUNC_skb_change_head
Date:   Mon, 20 Apr 2020 11:34:08 -0700
Message-Id: <20200420183409.210660-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Colitti <lorenzo@google.com>

This allows TC eBPF programs to modify and forward (redirect) packets
from interfaces without ethernet headers (for example cellular)
to interfaces with (for example ethernet/wifi).

The lack of this appears to simply be an oversight.

Tested:
  in active use in Android R on 4.14+ devices for ipv6
  cellular to wifi tethering offload.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7d6ceaa54d21..755867867e57 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6213,6 +6213,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_adjust_room_proto;
 	case BPF_FUNC_skb_change_tail:
 		return &bpf_skb_change_tail_proto;
+	case BPF_FUNC_skb_change_head:
+		return &bpf_skb_change_head_proto;
 	case BPF_FUNC_skb_get_tunnel_key:
 		return &bpf_skb_get_tunnel_key_proto;
 	case BPF_FUNC_skb_set_tunnel_key:
-- 
2.26.1.301.g55bc3eb7cb9-goog

