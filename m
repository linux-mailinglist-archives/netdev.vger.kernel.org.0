Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62D35E83F4
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiIWUfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiIWUcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:39 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810DA14B85D
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a80so1185510pfa.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=X/Yo0q+LJh3/rts6UXiCkFsErG60vpqgZ/L53wodJpE=;
        b=ZUb4dJcl9kyY0JCMIbSxhNelqg+q4A2wjd4CgDikdt5aQnXIoCAm64UQW+1n3wlzIC
         pAnpD7T83tfvNJ+uFbkJeFi1y8cQ0gxyzoEmIemLuV7nFZspJ2KQU5mmAB4gcKBwfFdP
         Er1yFNuC2cHt2der8y8JOYqcnXvTsxoObkuAY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=X/Yo0q+LJh3/rts6UXiCkFsErG60vpqgZ/L53wodJpE=;
        b=GzM325MCU6VylqdX29q0NQK0euqZny3Cei4rxb310sW80i0lu/1ripFkxEkbzKnfoN
         Lz78WcvEAhJ/KHQxMtWGTHUCTC+lX8q0AvKIFH4qUVzZ8e68MAXJs0pi2enaUyyYXAS5
         J73fwP+KKaVjo747HDY6Uob7lJ/Q8ncE4pNlc9PFoGX2MylAPwJdPOEneNgAJsW22ecC
         s88RzJdHjT2d9WL0+Ku0Lc9ETrCN+PvjWUUe843M+afYGE4glSOLolA4Ku50xbGJlOEU
         NLXSMF1/gF+r/3iTH6BfJceFiake+srAmY7qby2b+tOQ1ICV3omrCWQRbtt+8IOFDl04
         ZCfw==
X-Gm-Message-State: ACrzQf3jVo7UR2IP4mCS458xXmssc3uhQBiIJgIdMftLoDSb3Ofka/JP
        RRvh2HoNQQWcvuI5CxdtdFRL/Q==
X-Google-Smtp-Source: AMsMyM56PrOnj3O75SoOzdxaUyKZ0YbIXH0yPGDqg6UOnADEm1wpBRmS/rl1dQfty4+94PufpVyEyg==
X-Received: by 2002:a63:4b1d:0:b0:439:e6a4:e902 with SMTP id y29-20020a634b1d000000b00439e6a4e902mr9335669pga.212.1663964911544;
        Fri, 23 Sep 2022 13:28:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090a0d5600b001ef81574355sm2000341pju.12.2022.09.23.13.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
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
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, x86@kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH v2 10/16] openvswitch: Use kmalloc_size_roundup() to match ksize() usage
Date:   Fri, 23 Sep 2022 13:28:16 -0700
Message-Id: <20220923202822.2667581-11-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114; h=from:subject; bh=34QBkIPlID/8bnVmUZjxBAD5CQnxKEZULyryTOgjniU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhblCci+wGv8iOvuMA8kL10auMgCdSAnR8YUMoXu podrrfKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5QAKCRCJcvTf3G3AJqB8D/ 4wCq8GoLp593BnoMNdwJoYvf4etLZwZGsXZQsb2VBiy0skIZlwiVr3PlOgTBYZgIzLvlvUxdUJ5nlX Bi7PnNee9K0Li5LxtO1cZdKiafC2g2Bwno2il0Lo40rZNh8zuXtHkOL9Ch6MatzIqZvHirzYXgdFYa kL+5yKCw2OQwWbSzxN2JM/vbJJUQqWo3IuvGbHZNr3neCmsRvYQL9SENnZqNlmEN0oWzba5MOArXOo /gL8NjrYcXMqpUjBsVYY3y9nJYmkYPHuf/2GpJoU3H8aNnc9kL8Pnb6DwPQil/tk64OQkt0b7ZcjrC G0P1WN75ngaL4hyDGzvdTSyhbfeaPY233mJqTfNH5oCljXV1jN8j7JHWKIlijEpvh+rgmsD8oUU7cT LaZlaPifCbnZzop1KYF9cjTfQ6B1FwHfcaDukW/X9RDudAeKfjA6FDVNBvMvz6dQzkfSaJU4YlVLat mUOaeTfq4RLXR/1FfCnYLeQzvwlAmM6D2JIyw+FADeIZXNcc0kh8AWEtFVPrlaFoC7ofIyB/PaclI7 AeUp4jht1HTcepzxMUGZ3tJxRqUFmKdqW/dmu2F5hihUeoxfrDraNFqeBygde5JGfInhtRyFE314eo nj0zrS6Q1+iCwTFGvr/2/6qclufX48XSB7HUF/kPBPaTwX4S6IGvnRi92exg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Round up allocations with kmalloc_size_roundup() so that openvswitch's
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: dev@openvswitch.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4c09cf8a0ab2..6621873abde2 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2309,7 +2309,7 @@ static struct sw_flow_actions *nla_alloc_flow_actions(int size)
 
 	WARN_ON_ONCE(size > MAX_ACTIONS_BUFSIZE);
 
-	sfa = kmalloc(sizeof(*sfa) + size, GFP_KERNEL);
+	sfa = kmalloc(kmalloc_size_roundup(sizeof(*sfa) + size), GFP_KERNEL);
 	if (!sfa)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.34.1

