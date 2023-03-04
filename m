Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145BA6AAC1B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjCDT0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjCDT0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:26:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4125B97
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 11:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFEC60A4C
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 19:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F3DC433D2;
        Sat,  4 Mar 2023 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677957977;
        bh=Bj+QEpUiQCAZ1OOyBhwvXUIPnuHfS89Qmpncrem8DOI=;
        h=From:To:Cc:Subject:Date:From;
        b=fU7AGsLM7G4jle5Ol909wb/DI55h+hUhfLK+5zeiaHU3f55X2QdOtqbOXEVXD0wTj
         wmn92G2XQ0VlB+jMVHyTAZbDLpkFo7DdeFrhWnehN1qH35maRvrzqe0bKkmLv//IWv
         ADWmSMEobhP3bo8XXzeT7vVhRxVrZeoP5rwiGEzLQ5Tn1i0mFpburC60Ag9mFubax0
         rMI+UTbv2paFm18Zb0dGNvM5OZ4ZcPuMGQrgcxf52vJ03e/nNeyzcGYmrhl/HvsR6C
         2lcYUmOFZamuQC1zrFjsPQkr18Wy/DVCdzcwRedxtllAX6+V2PUn/uAZ7X0pJjPmqM
         pMvMNgwIrzUpw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Adrien Moulin <amoulin@corp.free.fr>, borisp@nvidia.com,
        john.fastabend@gmail.com, tariqt@nvidia.com, maximmi@nvidia.com,
        maxtram95@gmail.com
Subject: [PATCH net] net: tls: fix device-offloaded sendpage straddling records
Date:   Sat,  4 Mar 2023 11:26:10 -0800
Message-Id: <20230304192610.3818098-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adrien reports that incorrect data is transmitted when a single
page straddles multiple records. We would transmit the same
data in all iterations of the loop.

Reported-by: Adrien Moulin <amoulin@corp.free.fr>
Link: https://lore.kernel.org/all/61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr
Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
CC: tariqt@nvidia.com
CC: maximmi@nvidia.com
CC: maxtram95@gmail.com

Adrien, would you mind sending an official Tested-by: tag
in reply to this patch?

Maxim, can I add a .mailmap entry for you? get_maintainers
will complain if I don't CC your @nvidia address :(
---
 net/tls/tls_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..a7cc4f9faac2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,6 +508,8 @@ static int tls_push_data(struct sock *sk,
 			zc_pfrag.offset = iter_offset.offset;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
+
+			iter_offset.offset += copy;
 		} else if (copy) {
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
-- 
2.39.2

