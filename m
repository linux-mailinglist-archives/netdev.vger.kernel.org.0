Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946793B8DE
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391401AbfFJQDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:03:33 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42358 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfFJQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:03:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id l19so2673892pgh.9;
        Mon, 10 Jun 2019 09:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rSt4ak1wDGUVfgKpJqeN6cTqjOmJDwwl2xF7xB1elb8=;
        b=rIBgqrbJJ06GyeRr3zH+fqA4CkL1Zr1vG0tb3B8/3Tfs2yn6imrGK7RPOXZO5qdak3
         yLimx98fy7VebIl0QaE3P1jrZp3qeTPWhKr3BECkD7nHNJ4pPzApPc2DaW/wvlnhRq8p
         SRcLJ6/AxsgTnwaS9ziA5XR/KPvoZK2jeN6/wY2am1+dO9kRMF12VB0SVfOwMeCrf9N9
         3LW/ZApcB9KDNmKo+I/83dK08JvzQXdVek19tsVUvjNTkhAtcQQgsvrEM8eUTydJVpnI
         dw6ab9tqg80hSfJjvSSHeI9eoFT52tgt3FczLbc6r3K24VZDjtgDTmU2jqNm0NXsq2L0
         mPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rSt4ak1wDGUVfgKpJqeN6cTqjOmJDwwl2xF7xB1elb8=;
        b=G16coghJKhmEsVc8SHzjCZVxj4IZ4Yz7wFHwAK30lWGdXrGpERRfjX5SJJiDKt0ykS
         sm0/azwi06W6TkARpy/lZgao57S4LOq76p6a1mYA+M7ceOnaHB/7wUx6jdAu86LgIsIa
         QcasM5GgPpOk5uxjuHowa/xGWfD4BXXMWQBCYj5X4RkcoQe02uYKjKgO1OJjwVHJPg0M
         79mbso1S6oaSC41JNVyCdjqspqXjUTtSiB0vsC75VIyNiMzfFq5O8eMYyg+hPXSyoUat
         qXYI7cVl42NUlGfFvE/+KwIRrtjtp9thFH2+dfp7zw4suHWgH8ZJqmfoXu4LFUIpPgwn
         XEAA==
X-Gm-Message-State: APjAAAXkEatKPDbTcx4/sgigTyGv7t8/58UuI1IzFdS0m554qHk/SIr/
        0TguB3+wa9t5M8Yd3/5zDx8=
X-Google-Smtp-Source: APXvYqySUin3DaoOFC62ZJpRDE4uqWBNJVXBJiHig/d/+1yBqxlWWtVUQQr2s/JZZFZ0xMcHMWC2IQ==
X-Received: by 2002:a17:90a:ab0c:: with SMTP id m12mr22299526pjq.87.1560182612530;
        Mon, 10 Jun 2019 09:03:32 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id f5sm10574118pfn.161.2019.06.10.09.03.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:03:32 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bpf@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com
Subject: [PATCH bpf-next v3 4/5] net: xdp: refactor XDP flags checking
Date:   Mon, 10 Jun 2019 18:02:33 +0200
Message-Id: <20190610160234.4070-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610160234.4070-1-bjorn.topel@gmail.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Similar to query a driver for a loaded XDP program, each driver need
to check the attachment flags when a program is loaded.

E.g., if an XDP program was loaded without explicit flags (fallback
mode), it must be reloaded/removed without explicit flags.

This commit moves that check to generic code as well.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/core/dev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8e9f5693a7da..bb5fbb395596 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8075,8 +8075,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	xdp_query_prog_t query, check;
 	struct bpf_prog *prog = NULL;
+	bool offload, expl;
 	bpf_op_t bpf_op;
-	bool offload;
 	int err;
 
 	ASSERT_RTNL();
@@ -8124,6 +8124,14 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 
+	expl = dev->xdp.explicit_mode;
+	if (!offload && query(dev) && !!expl ^ !!(flags & XDP_FLAGS_MODES)) {
+		NL_SET_ERR_MSG(extack, "program loaded with different flags");
+		if (prog)
+			bpf_prog_put(prog);
+		return -EBUSY;
+	}
+
 	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
-- 
2.20.1

