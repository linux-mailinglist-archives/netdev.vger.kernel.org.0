Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E213D818A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhG0VTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhG0VQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:56 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF494C061799
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ca5so1833541pjb.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DGTay7iAWSyVSQKDJdUkixgvUstnCPUf4gCx6hmeZFg=;
        b=dNYQWvNnvzIA2X1XyugwcYlkkWjvJM3Vr3U1hCAtNIdHPOPlyGNYt6+nUriTVJE1MY
         iZgmYH0qJz+aQ+mXI12gMaGW3TxvwmtxZIYqXUw/22X3My9fPAG+Pxwau+0K9PSBrncN
         iFPA2Fm2fkDwZ73RqhbPCUL3LZE0YvDxxcwSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DGTay7iAWSyVSQKDJdUkixgvUstnCPUf4gCx6hmeZFg=;
        b=A4FLM4gxd2mvDJz0ggbqGMWyk4LQoSJDGlh01VW6nSzXTBaRIV/A2g8S92yYjFNsho
         PjboGgaKvyKVN5ioMNqWfe0ICTjsQhd5+Ay6GeGSphtMz1NuM1n+WIJ74AOqrezgqMuY
         4FJGCOC7CG2Hp1v9hPncYjqXFDxgWAsFGM9l77KUIUJZABTRLXVq+fn5NiZyu3ydaY7T
         ABa0H1rElls0dHwTDKGvShEJr3moYidjJlsiFSVvAeHhHQ8bDWCZMbJxsVZiXQjZZvhP
         WcFO1YlBZ5dqZO0J+Lfx4/hteT2UgilnXNs6Qs4KfQxhStCGqJy+qRMisjNaPBl25ycu
         2saw==
X-Gm-Message-State: AOAM53230wa9C4JnkfGkK2lUNCQQ9SOUc+WKnrwBLQ2vE/TJFR4rHLUc
        sHUEI/b5B12M6pH4q6Gfz9Zzfw==
X-Google-Smtp-Source: ABdhPJy6DyjMlXCxT3T2XebScQyyxEXTMu8TCjUAq1vEYKkzbYwWyNRsUTrVbClktjUGmOBVunhffg==
X-Received: by 2002:a65:64c4:: with SMTP id t4mr25559293pgv.222.1627420615303;
        Tue, 27 Jul 2021 14:16:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j187sm4758930pfb.132.2021.07.27.14.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:54 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 45/64] intel_th: msu: Use memset_after() for clearing hw header
Date:   Tue, 27 Jul 2021 13:58:36 -0700
Message-Id: <20210727205855.411487-46-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1172; h=from:subject; bh=4YDV077FmH9lemmMexWp8eMo9bjnp2d96nCsgVn4crc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOK9ttF+ksljVKBeZVm/usaI00laWjD4Unf8h1d eoh1+beJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzigAKCRCJcvTf3G3AJhvxD/ 0XZptAWWII5Sd1eI6hMq+jc4oUfLp5M5OPVb2emcgAAU0hAdSFxWDSUreT7263Ke3iOrhK498DJ36F DFKeXG2Kgg+H8VsBs/8iBRv3fcGi9/Ws4R5EVR3wO8T1tGxps7guCF9Qt6VBQ1s4MJ6uP1WduVwPNZ ZlByIdd7bbTAOVP0DQkaoixkgPdZnttNUp6Rr9N82rM1ej3G08+KapIFaiYMmhQSc7X5eCVxNKiziy OaiXcQBIN39iFbSTkPqmGWB/O8O9gN3mx3NTI/59TdmWDsSIEA0nZvbfdngpv2IWvghbSAnYrPfRoP PgSUX4wsUmyVbVKlsPRTFFnPc//4u4ziXfaO+NBESwrPcAmCy46pnKciUhYP1HH9VEi+ZCFb+SruMD MadjaGn2+3NdXFhWFV8895TTZ9u2+OKWtOQfqo11ynnlTm/DCGHvWB/AFn/6JdmHikaEpmcDR35+C+ Egf9o3kqDZ/B2qBqmcNmBMEV+0x48LZBOC/a5eqPn2bWsV9AJA1QV8ZZ/okfq56/5BwWZsW3rb5Jgy w2lr+ZeijJNIcye0PRUUdx3g1rzpx5+DXlN5Ntxi5rE5nrCFrcdyM6t9z+TbSBsR3Gd5kdMjV62eDG arvpuLcVrVwUegzp+aFtKOIzZCN084P4qbo3Isqj7ayth3CARHq/kmH7pGPQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_after() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/hwtracing/intel_th/msu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 432ade0842f6..f3e266b0756c 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -658,13 +658,11 @@ static void msc_buffer_clear_hw_header(struct msc *msc)
 
 	list_for_each_entry(win, &msc->win_list, entry) {
 		unsigned int blk;
-		size_t hw_sz = sizeof(struct msc_block_desc) -
-			offsetof(struct msc_block_desc, hw_tag);
 
 		for_each_sg(win->sgt->sgl, sg, win->nr_segs, blk) {
 			struct msc_block_desc *bdesc = sg_virt(sg);
 
-			memset(&bdesc->hw_tag, 0, hw_sz);
+			memset_after(bdesc, 0, res0);
 		}
 	}
 }
-- 
2.30.2

