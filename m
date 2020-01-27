Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519B1149DF3
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgA0AOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:14:42 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50519 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA0AOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 19:14:41 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so2271747pjb.0;
        Sun, 26 Jan 2020 16:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g9j0lMDO8NoNU4KTbS42+2WezLD8kVVyGGPJ2HPGp/M=;
        b=b2/IUtdu18/t4bYGGOQ7x5MWjXe0RvXpuaSe36Y2GK8n+4PhxfH23p2ePlTepBHC9q
         S8WwMTyHRkmfSV2OdzyW3aFwb+4DtzOHYElM/CD1yDEf0LsPZx5tGnVFtQ1dcYGvHcvY
         mkW33Ggd1dL5n5llbrjzKwY/XwY4vp614NKRj8GEAdYgdk6AdmzRjpw+bnm+x2kjGiJ2
         egbuub+FkmL4vIA4kFXkT8zFuJGpOtTJV++TOTFCDBw3/YgOg41GcfikeSQcARLRKikC
         k1ySwv6tKO2uiFp37lJvVdTeT8WmHBjTX4R8p5uZw/0JFUsK+7pW5YIetVQ7eiY7hXTE
         vf4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g9j0lMDO8NoNU4KTbS42+2WezLD8kVVyGGPJ2HPGp/M=;
        b=BTJbTO04uLtwUN2QK8R2ecEBBXBTif3dW/yFbIHloo3fdGtFgxe1N1IZ8oCJBXHhi2
         lKDkjciR2ca0ZKHRGCm9uYrYIQDW5PzwhJ8kvocb67tYHaub+vLufvQ4XI6bOHmhMYMk
         TTSCavNLYB7KLJdJ3r5Z7IRwfgsPfxFPFpb7EPQ8hu8gzNQG4yl0fKLDen1AxjcawZrh
         hhT2NfnFQhD0Klk8IG+ukexhEd26IwIey29++2DewDFTgrNZYgE7XZmMrq+NFiQMRE+9
         lcIUXvXWQ+dCRvz0k1nYcZpcBccUA4dPkj/9vSVq3x4ZlCmouv03XdHt6ba65McRjDYg
         TRtQ==
X-Gm-Message-State: APjAAAUKnZaGZOZn/VVSQWS6VULJfl46SJPn8C1k+zQaZ8+JrmOEdl4+
        bpJEgjvD+zIbST+KegQdUBsjnpGA
X-Google-Smtp-Source: APXvYqztDq2yJzJ1c3OzJhrSUTP0qhBn1h/Gxq5DXts3xNuqVcULO20YQ5lUODekPeFyzBao8+iGUA==
X-Received: by 2002:a17:902:8f8a:: with SMTP id z10mr15532830plo.169.1580084080980;
        Sun, 26 Jan 2020 16:14:40 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i23sm13326949pfo.11.2020.01.26.16.14.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 Jan 2020 16:14:40 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 2/3] bpf: xdp, virtio_net use access ptr macro for xdp enable check
Date:   Sun, 26 Jan 2020 16:14:01 -0800
Message-Id: <1580084042-11598-3-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
References: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_net currently relies on rcu critical section to access the xdp
program in its xdp_xmit handler. However, the pointer to the xdp program
is only used to do a NULL pointer comparison to determine if xdp is
enabled or not.

Use rcu_access_pointer() instead of rcu_dereference() to reflect this.
Then later when we drop rcu_read critical section virtio_net will not
need in special handling.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434..945eabc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -501,7 +501,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
 	 * indicate XDP resources have been successfully allocated.
 	 */
-	xdp_prog = rcu_dereference(rq->xdp_prog);
+	xdp_prog = rcu_access_pointer(rq->xdp_prog);
 	if (!xdp_prog)
 		return -ENXIO;
 
-- 
2.7.4

