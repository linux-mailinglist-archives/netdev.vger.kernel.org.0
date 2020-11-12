Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D42B043B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgKLLqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgKLLmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:42:11 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27B5C061A4B;
        Thu, 12 Nov 2020 03:42:09 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id e21so3934552pgr.11;
        Thu, 12 Nov 2020 03:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=brgLMIxuomJ8n/5jz8DxC5bQTgtlcUM9f2qpFTYsMmE=;
        b=CovtpT1H6uwHawVk1JcqLyr++xBprVGAO7Nzh90vgUS8fdnk8FPo/EwDjPk0tODuzB
         evmEz5zCLB1/lZJklPq3VXIxJvnx9DUEFOILM3BA5+scq3ioI9QKrUSakQN0v9DCPD8n
         qV22M3jKpjNIaVgDJKgu2isiq8bB8aQv3O3cS/zAPLcQte8nha4VphBLmMwEDNioSKqG
         jNC4TpXHa4iG7XHf022608Gb2IXBkktcQ0t/Hk7BAspZCmGYwQWrbolSPSoKupN5Pecx
         +KZitN4Bs99RAnswTZGdsvFPPJtk1b1GE8DXxe+Q6AVegf/EGUVy34JeXIwN0pmL/4pW
         7vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=brgLMIxuomJ8n/5jz8DxC5bQTgtlcUM9f2qpFTYsMmE=;
        b=tCO+L8Z00H+OV00G3B26pEhFDOQsCRTohm+4ndhrndi4AE1mi7toKXgKQMcqnGIwPx
         W52ccxKKz70ezDD3F9xwXu9aVB2eLEWOOBBoIZGFEJG4ZvCfS9mGDRBJaM/PW2Oxbk58
         Kc47HFQ2e3LPVUeWo+GWCCmbRx4iBqrdsgI0NzNIOna6mgnah7b9cDKuA+VuGaaMyCOP
         XDZ4XWysVLYNoel6hT6Kk70uynnPggaYfxOP0hDJgLkXVR1bKA2JuDbyYS9am3v4w4xo
         oY7kyc66TN5xFOoB8QeAo6XX0/RXs2rMK9O7cCZLxd4ZvhaK793E9Y/nEH8ruqhpdsiT
         nl1Q==
X-Gm-Message-State: AOAM530tysHzekWghDBcuRR/EcN0rxnhkGRdJMe8XFlSclwo47NL8QsD
        XOpLs5hoclo3sH6LMg+mIJ5t2EHrHFui5GYG
X-Google-Smtp-Source: ABdhPJzFYZzD6fe0bkLYrWPvwSpTUEJ47RqkKC5VHjBhyIA/8uANZpTuT7iDumC4uApa5EvyswNmLw==
X-Received: by 2002:a17:90a:6283:: with SMTP id d3mr8969246pjj.96.1605181328515;
        Thu, 12 Nov 2020 03:42:08 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:42:07 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 9/9] samples/bpf: add option to set the busy-poll budget
Date:   Thu, 12 Nov 2020 12:40:41 +0100
Message-Id: <20201112114041.131998-10-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112114041.131998-1-bjorn.topel@gmail.com>
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Support for the SO_BUSY_POLL_BUDGET setsockopt, via the batching
option ('b').

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 8ecacbae7682..3f87b931c177 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1482,6 +1482,11 @@ static void apply_setsockopt(struct xsk_socket_info *xsk)
 	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
 		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
 		exit_with_error(errno);
+
+	sock_opt = opt_batch_size;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL_BUDGET,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
 }
 
 int main(int argc, char **argv)
-- 
2.27.0

