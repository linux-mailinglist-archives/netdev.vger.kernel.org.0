Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274A42CEC3E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgLDKav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729787AbgLDKau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:30:50 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8656C061A52;
        Fri,  4 Dec 2020 02:30:04 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u18so6946979lfd.9;
        Fri, 04 Dec 2020 02:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YRI79nwoijzX/iWn8fymlgJV8Mx6+kl0OyDyYdcy5/8=;
        b=sTXJuBWQ02jH1eABWxylyUBObW+swfrv1FjDsO7D2TYQVHzjtUJsoG8/syUsGhDzIO
         ZKbCwtyMnJFuUo1KVhcbL/1DUfPvwFHzv+WZ4enQGFb2GtJWsXqI8+0nTVywMNbUba19
         st7aIDI9Og3jGGBhc5XcrDSb8U7SP4tcF42gvL+YeJJlVZGFzGkuiv9iGVhB/4Ny0UqH
         iv6NqUdCbcykijH2N45I5LgyXqvAHEyJcY87UVLceE/0a5CeSBgzeypYOnxJm+toq3fx
         yx7H6PfDZbUkmawtAB92w6gpVg6G3JH1UE20xFsQTGcY5NGXEdjAOa2jiIFfSwNxwG1C
         FLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YRI79nwoijzX/iWn8fymlgJV8Mx6+kl0OyDyYdcy5/8=;
        b=aa+mhTE3gQCyzqx/lG6DfmT0lwn25rPBnji6NoFQXuGhyEL/j3xhoIl5cKLPogA323
         0830himrhXcCaocwuO+e0lSvYpsBWW1vJGnAtEFc1rHlw399jjqzxmrWdz8IylVWty/5
         QM2DvVk0rZlop2c7XsN9LX3Ch23n1dAC8iGVbLhF7fl3133MFx78OM5ziOMiAc0YXnAH
         k3ZOiUCeskxSuFiuZZ8K8Ef43XFY6SU2ZvlFw/jrJqSzYtUmS4K9eZODkm8OC5RkStJr
         rka5S/yhT7gM81jlfRIhUK/YXaZV7i56BD6cYHyZ8Vzg27TM5IXJ13eBsYIN0arY5cMV
         HC6A==
X-Gm-Message-State: AOAM531xKD1LX/kKlpHHrYWNhabHc+cHa8cD36IBeO1mRax5BjleiZdB
        gl0CbWDN/OxKCCaBAR+kKtQ=
X-Google-Smtp-Source: ABdhPJyL4Zxxy4VJ+kDP9SxTw7GsB2K5yVjMnvQrn0j2zNyGIMrCEz6yAxTfizyhhoPJ9FAbQtO5mQ==
X-Received: by 2002:a19:cb52:: with SMTP id b79mr2901032lfg.223.1607077803308;
        Fri, 04 Dec 2020 02:30:03 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id d9sm62738lfj.228.2020.12.04.02.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 02:30:02 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH v2 bpf 3/5] xsk: add usage of xdp properties flags
Date:   Fri,  4 Dec 2020 11:28:59 +0100
Message-Id: <20201204102901.109709-4-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201204102901.109709-1-marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Change necessary condition check for XSK from ndo functions to
xdp properties flags.

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 net/xdp/xsk_buff_pool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 96bb607853ad..7ff82e2b2b43 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -158,8 +158,7 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 		/* For copy-mode, we are done. */
 		return 0;
 
-	if (!netdev->netdev_ops->ndo_bpf ||
-	    !netdev->netdev_ops->ndo_xsk_wakeup) {
+	if ((netdev->xdp_properties & XDP_F_FULL_ZC) != XDP_F_FULL_ZC) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_pool;
 	}
-- 
2.27.0

