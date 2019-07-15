Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5025C69930
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbfGOQkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 12:40:04 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:46054 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731061AbfGOQkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 12:40:04 -0400
Received: by mail-pl1-f201.google.com with SMTP id y9so8555264plp.12
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 09:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jnpOHMGVpVBT4U8hx7UMa8ffCebxTNA6BN/DaIbAs5A=;
        b=RvGoHW2MRV9EfhZeAXcBXkPbrToaAE17mk3FLUDKStKkL0zMCH9eCsiYK6fNFLY9Yq
         le4PNOH63MqUeX7C4feXRCDUtFloasWKQ1ma2CkUC9FDyxT1SOlXMBy2loQnQSrIAKOU
         HZusIMl/FM+zwKouuwRd6bxqy0kc3GPNIRT2RER7IXXjXg2d0A320QX2vBeWbncbqgO4
         W3tRF5NYEmjh4FCewpHYjZZ3gBv7v6DdtkOAYb16dflsTAn1UV4vbEZwJM0qV4HO1e/B
         QBlqe8kQyTpn8Pbwk/dOQYCWWJrfRl3u4mW/A3ckYSDZrkGTA9K0SSboPyxZPkhkNVPa
         1pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jnpOHMGVpVBT4U8hx7UMa8ffCebxTNA6BN/DaIbAs5A=;
        b=ml4ervs5F18V5kY0K993DCtTbTGVUp2LRUL0c85I10qmKuisgb5sjq2bClNC0ku/eW
         CzAdPjskCh8h0E3MeZLrDSuQHOpLlZQmk8Yya8eyU/7qGnPTu/euSMLDlMfuJBaEDGuH
         U3/9qNzM7Q7CSGGfxQDgTQqsz+NxbHAXTdpzDhA/IjApozz+CmY9LMBDGoyvHNEki8iN
         dZRyh2/MB9IkJQ0rAR33/9pF2oWtFYp3FVrjFB6oZKoIxcsFxvCL99iWPs9GzQ7blxYv
         SJLu0f8N84BLEuLJ8FGuvCycp7lxyAyaqhhkYQLG6OS/FIeGJg2JOwwrZyFVxcnO2lGG
         GOjQ==
X-Gm-Message-State: APjAAAUnHtva7Gkaxxrn1ucbaVxL6yUShP7D2cdxCFSiEv0aR0qo9HXf
        ZwwVq9gaLkmeGMenLrtjYK0rZyer8wSObZUGBnon/t46qWdQnwG1ZqASdph/ob6Wmte+HqES5jk
        6J1l+4RjLwr7KOica+CKnAe52xEYhDzNlmt3xWpThhpxUX1DaPN6asg==
X-Google-Smtp-Source: APXvYqzruxPG34Ah1jjK/JlegpomzwcaFX6tT3691S3LwXsS9UQWc0vIaf4m9g1Ec+z6TUFKHOSUfDg=
X-Received: by 2002:a63:ec03:: with SMTP id j3mr493975pgh.325.1563208803356;
 Mon, 15 Jul 2019 09:40:03 -0700 (PDT)
Date:   Mon, 15 Jul 2019 09:39:53 -0700
In-Reply-To: <20190715163956.204061-1-sdf@google.com>
Message-Id: <20190715163956.204061-3-sdf@google.com>
Mime-Version: 1.0
References: <20190715163956.204061-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH bpf 2/5] bpf: allow wide aligned loads for bpf_sock_addr
 user_ip6 and msg_src_ip6
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add explicit check for u64 loads of user_ip6 and msg_src_ip6 and
update the comment.

Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h |  4 ++--
 net/core/filter.c        | 12 +++++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6f68438aa4ed..81be929b89fc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3248,7 +3248,7 @@ struct bpf_sock_addr {
 	__u32 user_ip4;		/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 user_ip6[4];	/* Allows 1,2,4-byte read and 4,8-byte write.
+	__u32 user_ip6[4];	/* Allows 1,2,4,8-byte read and 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__u32 user_port;	/* Allows 4-byte read and write.
@@ -3260,7 +3260,7 @@ struct bpf_sock_addr {
 	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read and 4,8-byte write.
+	__u32 msg_src_ip6[4];	/* Allows 1,2,4,8-byte read and 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__bpf_md_ptr(struct bpf_sock *, sk);
diff --git a/net/core/filter.c b/net/core/filter.c
index c5983ddb1a9f..0f6854ccf894 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6884,9 +6884,19 @@ static bool sock_addr_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct bpf_sock_addr, msg_src_ip4):
 	case bpf_ctx_range_till(struct bpf_sock_addr, msg_src_ip6[0],
 				msg_src_ip6[3]):
-		/* Only narrow read access allowed for now. */
 		if (type == BPF_READ) {
 			bpf_ctx_record_field_size(info, size_default);
+
+			if (bpf_ctx_wide_access_ok(off, size,
+						   struct bpf_sock_addr,
+						   user_ip6))
+				return true;
+
+			if (bpf_ctx_wide_access_ok(off, size,
+						   struct bpf_sock_addr,
+						   msg_src_ip6))
+				return true;
+
 			if (!bpf_ctx_narrow_access_ok(off, size, size_default))
 				return false;
 		} else {
-- 
2.22.0.510.g264f2c817a-goog

