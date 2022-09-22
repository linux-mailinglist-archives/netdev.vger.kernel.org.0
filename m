Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982D15E593D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiIVDME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiIVDL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:11:26 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED9B6CF45
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:30 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v1so7526783plo.9
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TDASAml4kCnGP6A0dhCkNjKPm18x/T6dZyC75aPZacc=;
        b=WPgEF+jupR4SGB4DLno2k2bBCbZ8b8f+ZrlxKcIQeEbCtj5WBgsCFhiT+NIX1Fpq8q
         RVzdxz0WZY9Xy+TjHVDvowfkPuPW/OFy/IlUhIW+WjLJlx/oYe632OrUVLWT43o6LOap
         J1uHENSlV+a7neJtjBRovZ5eH4VN/4Sv8DcCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TDASAml4kCnGP6A0dhCkNjKPm18x/T6dZyC75aPZacc=;
        b=VqN2D7RdS60jrHgyqgJAdO3xOLlFmBQR7ce3V0jjRBDxiuoHS7nOYqSPdMBAbSIXTv
         +5gUk9XZ9FUdCOIBiyzfxlYZU5U+0jRTNqmvZY/wlPnT2EJN8AAVCb6EhI3RkPTVeoCm
         GdGrJ8iFRKxsYuFIFaTmvaudC/b1wLy/vBiSyC+gDoxc2jvc4qPNf6+9++gvwBsBcgh5
         KESq+fmWuuJOIqLayy/lTIgCz2qppeKfhRH7SQITUWTP3ckMt7GtbGQ9Kd/RZZ0uegwh
         9R/yJ08BqySiE5d+o7I/pwW3JR2FXH9TRnxxDNC+iyUZRo8ZFuHv0YtxoOl5U4fmT20V
         Sf4A==
X-Gm-Message-State: ACrzQf3+3YwJbHeg2bbhDok+xAVzwTt/czWiGTRKJIAJSc0NsgXgrL5l
        OYq/m9NpAREnWO1Uv6PTd71QFQ==
X-Google-Smtp-Source: AMsMyM6FwJ0f+Bofi6cEtpiWEB7NdUhtmrkt85vC8m03N7qUc6HActCoKwZbZiJ520VUx/+qozuRZA==
X-Received: by 2002:a17:902:ec85:b0:178:8a69:45fb with SMTP id x5-20020a170902ec8500b001788a6945fbmr1346743plg.130.1663816229473;
        Wed, 21 Sep 2022 20:10:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b001782a6fbcacsm2768353plg.101.2022.09.21.20.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH 08/12] openvswitch: Proactively round up to kmalloc bucket size
Date:   Wed, 21 Sep 2022 20:10:09 -0700
Message-Id: <20220922031013.2150682-9-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1419; h=from:subject; bh=BnVOhrGnWnn0qmsrneuatz5VZroW3iZYMrlDdw6WzZA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9ITSglsXN14oMtyaHSvyKAfYqb/jU+ua3WQ3QDI +BCEy4WJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSEwAKCRCJcvTf3G3AJuckD/ 0fC2DD7jgGoKpFD7s52Imf5skay/p4qVmK0rvZNjkGAmNGvUFsTnir5GI3TMV3p/FWB9oxlzjn3lRJ YbQuqElrhpv1aHtZF5nq2pNe2WeidRtExDsumfRW/9rwf58N/wfxbElAY9GHoqVRc3lUIV9oQYeOhK 1kJwstuo1zV2TYN4g0iYTTSXNQhbPXQ513gM0PP9l/YiITmzLOgjZgDFaN+QjDNsRclDp6Yt0t3KK0 u44yaM81Tj4s/G/cazw7Jsf6TLb2WBPqCt8tdGe27UEsHIqsFjpRY7nmsAAp8iG8Xem8x+/oYI/Wbk HgMgUuw1m5UkfchSrwCJfeis+j1yNloKfOqqnWkCkG+hSthHxri16TT3gYtEK81SyX7qdZEi0YzWC1 HzPQNdrH6o3PN6vMQOI+fCDeICkvey7UrPwFg21Eqq5d0i1Q/IjdJkPIS5rxpe10rGou2R7M83TPCj g7LmoCyTxmRqFzEzRuBHtLLGVMHa5PjJy+FD8ubMoYHOzgg+Mw1qV+65O4LUccNAhythMxiYUkwGsA 5/JlFokXB6JtqWVHa5OTlymJF5c70uDllOyQsXSHJV/6Th+1UpurayKJIgQFsm/OxxbzV0XgUK3Dam UhsIlzfHslsALppIqri1WH09qAL4uxlG1Se3WTFKlmYiDtPENjS7L1iOMWDg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having a mismatch between the requested allocation size and
the actual kmalloc bucket size, which is examined later via ksize(),
round up proactively so the allocation is explicitly made for the full
size, allowing the compiler to correctly reason about the resulting size
of the buffer through the existing __alloc_size() hint.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: dev@openvswitch.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/openvswitch/flow_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4c09cf8a0ab2..11b2e2c94c7e 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2306,10 +2306,12 @@ int ovs_nla_put_mask(const struct sw_flow *flow, struct sk_buff *skb)
 static struct sw_flow_actions *nla_alloc_flow_actions(int size)
 {
 	struct sw_flow_actions *sfa;
+	int alloc_size;
 
 	WARN_ON_ONCE(size > MAX_ACTIONS_BUFSIZE);
 
-	sfa = kmalloc(sizeof(*sfa) + size, GFP_KERNEL);
+	alloc_size = kmalloc_size_roundup(sizeof(*sfa) + size);
+	sfa = kmalloc(alloc_size, GFP_KERNEL);
 	if (!sfa)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.34.1

