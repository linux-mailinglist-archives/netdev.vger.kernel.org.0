Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1314833F2
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiACPIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:08:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233869AbiACPIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641222509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGlVjG9u8jJMDdtq/pUyG8OIadV06H5nUns87f244fk=;
        b=NZUhJV0QbvVjX4F/mpSC/XBGL4Rdyn7w4Zvn8RP1gFIpxc8nzbyozgo0vLJ749eoVp19l9
        Ys/7g91JJnkZmxrM2PZ8vVzpUq25N5DeK/yzMsZj0Hwr7agsxSv49vwspXzstoIwXJxlAa
        XSnnlwehHnx7FtfELPJJwsA41Si4eC4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-jvuEIYYBMDmOlpdCnin2RA-1; Mon, 03 Jan 2022 10:08:28 -0500
X-MC-Unique: jvuEIYYBMDmOlpdCnin2RA-1
Received: by mail-ed1-f71.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso16224769edb.7
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 07:08:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGlVjG9u8jJMDdtq/pUyG8OIadV06H5nUns87f244fk=;
        b=D1abBnLV3WvUUnyIbJyzqIgV4zxzEq9s/fd1xB7sn4SML7Ehv6RMjJMts4s6USymYp
         5qW6YQmtaMujtaP8dCLKPo2bs2UAd7XwUXY+fhS78Tpe32HTJfQasfYiNeUgwVuKVYrw
         eg4i9tkB2AjW2EKLHDsTGihRkC/xDsBgjOK4efmbpOH8Xg63izpjEWcmnolZ/rooAdwd
         o4KyPuU7QGhcT1cKhi9YoH7zaTHmtP5+2hiPYIjnC6l6NXCVhDyA3yUJKDR0ZCUp0bUY
         zdo9NSbrqDnwpGFu6jHVNb2jcmgOdA4a2VoJB9Afb5XJHQO1clmHw/VOB6l6w4Cswta0
         XVbw==
X-Gm-Message-State: AOAM530EhYDVlV/tlTH+2/pFp2+S1oym+DrYumPk6Hh/cJ9/9ucWhd8p
        g4lN5XEUNy0ljk9U4RXI3/ariSH4CeXEjqYZCzag09Vy+U+vsWJMxGkAu/GmuUV7SDpVfEzqXTy
        PsYO9RBMTuI94a+5r
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr37638651ejr.435.1641222505438;
        Mon, 03 Jan 2022 07:08:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrOCi0fyye1AEKcpCPxzHe5FwTTrTTgYNDB1QzJYEp4ptU4OnyPfwpJNZGM5XlsNCsx4yWlQ==
X-Received: by 2002:a17:906:2cd5:: with SMTP id r21mr37638524ejr.435.1641222503428;
        Mon, 03 Jan 2022 07:08:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v19sm13856217edx.75.2022.01.03.07.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 07:08:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 67865181F2B; Mon,  3 Jan 2022 16:08:21 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v5 5/7] xdp: add xdp_do_redirect_frame() for pre-computed xdp_frames
Date:   Mon,  3 Jan 2022 16:08:10 +0100
Message-Id: <20220103150812.87914-6-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103150812.87914-1-toke@redhat.com>
References: <20220103150812.87914-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an xdp_do_redirect_frame() variant which supports pre-computed
xdp_frame structures. This will be used in bpf_prog_run() to avoid having
to write to the xdp_frame structure when the XDP program doesn't modify the
frame boundaries.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/filter.h |  4 +++
 net/core/filter.c      | 65 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 60eec80fa1d4..71fa57b88bfc 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1019,6 +1019,10 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 int xdp_do_redirect(struct net_device *dev,
 		    struct xdp_buff *xdp,
 		    struct bpf_prog *prog);
+int xdp_do_redirect_frame(struct net_device *dev,
+			  struct xdp_buff *xdp,
+			  struct xdp_frame *xdpf,
+			  struct bpf_prog *prog);
 void xdp_do_flush(void);
 
 /* The xdp_do_flush_map() helper has been renamed to drop the _map suffix, as
diff --git a/net/core/filter.c b/net/core/filter.c
index 81b57ea9ad35..cceb4cf52519 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3957,26 +3957,44 @@ u32 xdp_master_redirect(struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL_GPL(xdp_master_redirect);
 
-int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
-		    struct bpf_prog *xdp_prog)
+static inline int __xdp_do_redirect_xsk(struct bpf_redirect_info *ri,
+					struct net_device *dev,
+					struct xdp_buff *xdp,
+					struct bpf_prog *xdp_prog)
 {
-	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
-	struct xdp_frame *xdpf;
-	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-	if (map_type == BPF_MAP_TYPE_XSKMAP) {
-		err = __xsk_map_redirect(fwd, xdp);
-		goto out;
-	}
+	err = __xsk_map_redirect(fwd, xdp);
+	if (unlikely(err))
+		goto err;
+
+	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);
+	return 0;
+err:
+	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
+	return err;
+}
+
+static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
+						   struct net_device *dev,
+						   struct xdp_frame *xdpf,
+						   struct bpf_prog *xdp_prog)
+{
+	enum bpf_map_type map_type = ri->map_type;
+	void *fwd = ri->tgt_value;
+	u32 map_id = ri->map_id;
+	struct bpf_map *map;
+	int err;
+
+	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf)) {
 		err = -EOVERFLOW;
 		goto err;
@@ -4013,7 +4031,6 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		err = -EBADRQC;
 	}
 
-out:
 	if (unlikely(err))
 		goto err;
 
@@ -4023,8 +4040,34 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
 	return err;
 }
+
+int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+		    struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+
+	if (map_type == BPF_MAP_TYPE_XSKMAP)
+		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+
+	return __xdp_do_redirect_frame(ri, dev, xdp_convert_buff_to_frame(xdp),
+				       xdp_prog);
+}
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
+int xdp_do_redirect_frame(struct net_device *dev, struct xdp_buff *xdp,
+			  struct xdp_frame *xdpf, struct bpf_prog *xdp_prog)
+{
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	enum bpf_map_type map_type = ri->map_type;
+
+	if (map_type == BPF_MAP_TYPE_XSKMAP)
+		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
+
+	return __xdp_do_redirect_frame(ri, dev, xdpf, xdp_prog);
+}
+EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
+
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
-- 
2.34.1

