Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F3025DAA9
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgIDNzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730504AbgIDNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD48C061244;
        Fri,  4 Sep 2020 06:54:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id np15so5235830pjb.0;
        Fri, 04 Sep 2020 06:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9z4cRfJn8UcZ/9frCTkEjGN764ybO6hPefQpHU5TmI=;
        b=bK3iNa4A/UEw1MU4mezHth5dLxzdli+bEgNfEwtdEWI7IUOhw4S1wwu8BH3kcP1d0J
         rsfeBwNGMswAm/Rlv2BvFHNUkuG6l4QHhuzL3PANSlg0vUv6bQphl7N54K9spydzSPD6
         ajDD+Q1uf8UAZXp6XMuUoSqw6jUxZA3nuvmUV8GdnAYb2jTR9Qm5TbIjCp3LT3kWXjNM
         /cxxVDEDMFdWVWmiE/mcZMbI17ASZ4yN7KVLNzqPlwJ+SFF79rqmQYpJe1dGq4qJYzK5
         gVJRNAN1dUHkn8tyDGQCXyW4QulPcGPEgrgbGmpb7QxS5UviAP0k/HqhSvS/+vhVMlEe
         DCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9z4cRfJn8UcZ/9frCTkEjGN764ybO6hPefQpHU5TmI=;
        b=QpsMmUEPLaObl1L3OpvL0FQl4aH2KPbo1zJWnmh8C7+5A2wmtbtUCErsW+VacVQ0lH
         k0fksWATQ928OwuDHatleCHfSjTHNIHwC3uA/ubsXPC0wOOEd9Zexg0ZqKzfAgEFxujE
         8Zy8SC1il0H5R/02+DAwWX21saFM+X4LnMjjVu6cHJJ8wMfgMxkQ5lOhzBtDk6hLTZQW
         EpLt5Z3nPjpzYzTtc12Mw2rXCV3QHWDZTaouRj43Zu6g+ALcyoNGK+UJ0lixT6l9b1BU
         vF00X6vfQWlBy/kgO5SXFQlCJXHK3UIoRJtywqSZ0FARqrlppSpn2KHwH909tpfm3+AH
         b8DQ==
X-Gm-Message-State: AOAM532i3HwpvuTwykleLFEEbZ/5G+lAoCdRx2vYoahe0Mtt/jcuu2oc
        CnEb2IW6GWnBUtBPZL4E1Cg=
X-Google-Smtp-Source: ABdhPJwJ8TlaOVV3wCqW/daU3Hy40stCQrDheIx0EIvFRROBLU822+X3TsrXxGs4jJ/3wpxjw+F59g==
X-Received: by 2002:a17:902:848a:: with SMTP id c10mr8598273plo.8.1599227659617;
        Fri, 04 Sep 2020 06:54:19 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:19 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 2/6] xdp: introduce xdp_do_redirect_ext() function
Date:   Fri,  4 Sep 2020 15:53:27 +0200
Message-Id: <20200904135332.60259-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904135332.60259-1-bjorn.topel@gmail.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Introduce the xdp_do_redirect_ext() which returns additional
information to the caller. For now, it is the type of map that the
packet was redirected to.

This enables the driver to have more fine-grained control, e.g. is the
redirect fails due to full AF_XDP Rx queue (error code ENOBUFS and map
is XSKMAP), a zero-copy enabled driver should yield to userland as
soon as possible.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/filter.h |  2 ++
 net/core/filter.c      | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 995625950cc1..0060c2c8abc3 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -942,6 +942,8 @@ static inline int xdp_ok_fwd_dev(const struct net_device *fwd,
  */
 int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 			    struct xdp_buff *xdp, struct bpf_prog *prog);
+int xdp_do_redirect_ext(struct net_device *dev, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog, enum bpf_map_type *map_type);
 int xdp_do_redirect(struct net_device *dev,
 		    struct xdp_buff *xdp,
 		    struct bpf_prog *prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index 47eef9a0be6a..ce6098210a23 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3596,8 +3596,8 @@ void bpf_clear_redirect_map(struct bpf_map *map)
 	}
 }
 
-int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
-		    struct bpf_prog *xdp_prog)
+int xdp_do_redirect_ext(struct net_device *dev, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog, enum bpf_map_type *map_type)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct bpf_map *map = READ_ONCE(ri->map);
@@ -3609,6 +3609,8 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	ri->tgt_value = NULL;
 	WRITE_ONCE(ri->map, NULL);
 
+	*map_type = BPF_MAP_TYPE_UNSPEC;
+
 	if (unlikely(!map)) {
 		fwd = dev_get_by_index_rcu(dev_net(dev), index);
 		if (unlikely(!fwd)) {
@@ -3618,6 +3620,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
+		*map_type = map->map_type;
 		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
 	}
 
@@ -3630,6 +3633,15 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
 	return err;
 }
+EXPORT_SYMBOL_GPL(xdp_do_redirect_ext);
+
+int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
+		    struct bpf_prog *xdp_prog)
+{
+	enum bpf_map_type dummy;
+
+	return xdp_do_redirect_ext(dev, xdp, xdp_prog, &dummy);
+}
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
 static int xdp_do_generic_redirect_map(struct net_device *dev,
-- 
2.25.1

