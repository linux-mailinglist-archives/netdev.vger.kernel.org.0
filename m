Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF12F3EFC55
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbhHRGY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbhHRGYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D99C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so8216824pjb.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wNrSyu18+TQvxqozBk6dKmc83xjPuqXEkZM9+CZkQs8=;
        b=hq0RZc8pvhUdG6LQCrGBNQbN7VTMq2CkOF4QQtsj4WrxV2UTBN34Md8Gi7LkipMBy6
         xL7jSFJnNHOowLO3Jca2aK8bMlaJLC+laeAIEoH1LMm2sWoMULTrkMcKoRbBAsM8UOpd
         ihsdkkeDmGTdleDP1YZNWHcSi4UiGfzn3DsyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wNrSyu18+TQvxqozBk6dKmc83xjPuqXEkZM9+CZkQs8=;
        b=SUZuMZ8QWi56/L5Z7FiI6mY3iv9+gUz/1dkFvOS7/aJQjf11LhFMOuFkvVxYmz3WN6
         lcFaT8yHYevVEUa2IOPzjK3gYuwGgS3Afd+vQcq6YGd2MoQRyj6g7rXY/AdXB0AKPKki
         Wzqd08vTaNK2UlacA9eKbSCq9Z9AkJO6WXENt1FOEHFFTBSeMftVPJDORiCqJAn2F56O
         0T/7AParbMrFFbuZZ1inQxPPn0XB+xrbw8fE91Oud6AF0UJZulbZwvUeJOajlaHDx2Vk
         xB3l8ymoOhGYkkUz9X06IOna1UV2hzfAH60l5fLVqp81LmUpCCLSZZM9ZTl0HiKm86hy
         NMhA==
X-Gm-Message-State: AOAM5339qYrMAIlhHPTmQ+KOS9piW3ZLTV402U4xj4desfCwbg/QX2/N
        uMd5z924ExMy8KaFf5IgugrjsQ==
X-Google-Smtp-Source: ABdhPJxMkEdSe0VUFwn+z4vxkdsUFqJ2UwImPieDkAd2A7unXagJo2uR8zh40lbVDVJdC8iJXw8UiA==
X-Received: by 2002:a17:902:cec3:b0:12d:92c4:1ea6 with SMTP id d3-20020a170902cec300b0012d92c41ea6mr5911733plg.36.1629267853392;
        Tue, 17 Aug 2021 23:24:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y13sm2710073pjr.50.2021.08.17.23.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:12 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 49/63] btrfs: Use memset_startat() to clear end of struct
Date:   Tue, 17 Aug 2021 23:05:19 -0700
Message-Id: <20210818060533.3569517-50-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1202; h=from:subject; bh=j07ODF9kjbRRiHohObgJ1N/RHPZCTrQAmspnQvku4YA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMpNf/1TOA8EHO13yPM2WoVQcddjcJSpXNg/q95 NGD5Kx+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKQAKCRCJcvTf3G3AJiFDD/ 43YRq8chsycAfEPzeH3ODP8oX8vzyejO0KZxGwB29jISLONkndclAADo87JB841bplfSqHF4g/N0Yr 9BPUFM/u9aD6MYInBsgRcfvidkMVdvLwJHJroTXouReKf+wENJpCE42XqDFb6/OHW+qszfq48l2ZsZ vlrJcOJH5B/7MGz2vGlPOqarS6QPhKxELyHgWma5US/BF+fmqXoGyLI96PzJHBVwD8Fv1vRW+FZyYX mS0c778XSYdo50TMLiLEeybc58/w6WbytsuOe2gDRaDra0L+tnQU3bUemlEwF/otdXngLgjznL3aHr 03wBbU/uuuYnsF2VxKSH3eTmyOXxM0Fc0gfhMAHlPYOx3FWaj25UujliZBiwYTeajzJsMlNaMxhyYC CNKnLKNfyeqkcnmjrNFG0fLVNoy2o0OR5zMuoedsu9e9ywbM82GfxRkHbOU9ZMZ5GgY2NMQXjzSHXm JS7ECNId/+w48q42Qz1RDDbkk71kX5clz/7ywEULnxcdaVF9VLida+SAjBnEmtDTTT5a3LFsbnweA7 31UgpReo5DWgV9+9dvXi/NGJgP+uufVyB7FGtNrTHKNpqkfmCVfC6YFh7uVwrtuLat1U/8LUy3Rdgf RT0NM3pRRzNQ/fI9ZSg5+8wsIv5qwbvYlgUlhc046qXy22//QbKOPQkqvAQQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/btrfs/root-tree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 702dc5441f03..12ceb14a1141 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -39,10 +39,8 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 		need_reset = 1;
 	}
 	if (need_reset) {
-		memset(&item->generation_v2, 0,
-			sizeof(*item) - offsetof(struct btrfs_root_item,
-					generation_v2));
-
+		/* Clear all members from generation_v2 onwards. */
+		memset_startat(item, 0, generation_v2);
 		generate_random_guid(item->uuid);
 	}
 }
-- 
2.30.2

