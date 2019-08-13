Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A3D8B817
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfHMMIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:08:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39545 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfHMMIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:08:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so47507320pfn.6;
        Tue, 13 Aug 2019 05:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/dTb4ClZaN81sXe2USd7VA6EXdy1jkzbTVP88gvsZU=;
        b=hs127bino+aRHv0nBLwWt+DG51I3QDsad9WxE1u2ABfBUc8amtsY19MCmUDSi0lMDn
         wEYGySn1SCZmeAD3FCs5lYA1MIpTozTTkL2+0j3hAWtuTotw2DVyfixMtmr8hHvpVmRA
         xLjG8jNRLiNUw5Jm48gnt8NRtBd/KX5LTZw9n4r9W9eIYEg+5zsP9/ShWNCDcsFXWHVK
         ujVKmE2Dlavd1szTRYywb7yj/c/1/6GDR/mvbdtSrWYIEoHkxXPhyAZcVUzLkLqSPVo9
         jGkKRKXolKBTo/Wi2FdFdzl6GPwCLZf6KnOzswP/F0qRFdVA5fdjnzdLeQvA0QpagOTK
         FwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/dTb4ClZaN81sXe2USd7VA6EXdy1jkzbTVP88gvsZU=;
        b=k6M0AKyLh4DuAElwerxTVGTTdZwGrxXSi9uqqCgCY3GFEDU4FkHXfyRKjm7LzJq162
         NlVic626TwdX/AaGZQUp4uhARWv0As1yu3f7v5FECmocHvFoWaGjFU11EV2JX981aKtE
         DQDatJOOd81wyDrXIhGyPe40LrjKh6fypZT6/dilBZG4hk7C8uLqeIq0wsS5KeoT+uMx
         irJzc+tws4TmWcMtQIdM4BrJ4EvqBJSt6QA/4o8svsCnq/gTqqoE19VIJ3Wb9bvgHpct
         jrG/QsK+39mrEDcRO+bwNhg/T+mjM5xVrlZEB2voZPh/jcVPk9VP4hEzaamr/dBLbJhK
         gZRg==
X-Gm-Message-State: APjAAAXDSfCCHhkro7xpz/+G9Zu3Xpf4If0oBqnvqWZdxNpQ1QxaW4e+
        OEqkMgwlnDR8Cgd26ICAo3Y=
X-Google-Smtp-Source: APXvYqzVtckARatEy2C/6IfJsCE1AauFGEeu/iH3Zoi4a8JcHfi/0kIKIMZY0Giz/EW5ki6DGfUbSQ==
X-Received: by 2002:a17:90a:256f:: with SMTP id j102mr2012310pje.14.1565698089340;
        Tue, 13 Aug 2019 05:08:09 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.08.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:08:08 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 13/14] i40e: prefetch xdp->data before running XDP prog
Date:   Tue, 13 Aug 2019 21:05:57 +0900
Message-Id: <20190813120558.6151-14-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP progs are likely to read/write xdp->data.
This improves the performance of xdp_flow.
This is included in this series just to demonstrate to what extent
xdp_flow performance can increase.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f162252..ea775ae 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2207,6 +2207,7 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 	if (!xdp_prog)
 		goto xdp_out;
 
+	prefetchw(xdp->data);
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
-- 
1.8.3.1

