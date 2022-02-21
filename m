Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8DD4BDFFF
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354908AbiBUR0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:26:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236985AbiBUR0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:26:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B71FAE67;
        Mon, 21 Feb 2022 09:26:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAAB36145B;
        Mon, 21 Feb 2022 17:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E26DC340E9;
        Mon, 21 Feb 2022 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645464384;
        bh=qBj7d9tqvyTrDe+jWiLg29epXyfUz1hfeK++4JVGmVk=;
        h=Date:From:To:Cc:Subject:From;
        b=M6kK0PUmEHFlsMnWb9+vjHramr2qb7w17MMGVH1XG7r33RWg1yWvRaKS2NMNNWZfN
         3Ie7iVXOVTyipUk7BYbkGz7tcstInHR88fjKt3UCjVsXfU/wzkyI1sIKG96G67ltC7
         MLVakHJI7Ae7Ux9jFq58fqBaW7B1NChs5PyvJJO1cJXbiOT0+xDDPt1ZHLR/duGjyK
         nMuud5YTo60laoCJLEmNBGog0S0EMDsOfYg6fIyAiXhh5yYZ9nDjRmr5N7tpdhil56
         dKZkrlXQci3XQnyGDp4IkTHtrPUAKrUyeQu7o95JfcQDowdAY6GVSzsV2M8KuHki+n
         f+rPXNl5vTs+A==
Date:   Mon, 21 Feb 2022 11:34:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] usbnet: gl620a: Replace one-element array with
 flexible-array member
Message-ID: <20220221173415.GA1149599@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/usb/gl620a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/gl620a.c b/drivers/net/usb/gl620a.c
index 13a9a83b8538..46af78caf457 100644
--- a/drivers/net/usb/gl620a.c
+++ b/drivers/net/usb/gl620a.c
@@ -56,7 +56,7 @@
 
 struct gl_packet {
 	__le32		packet_length;
-	char		packet_data [1];
+	char		packet_data[];
 };
 
 struct gl_header {
-- 
2.27.0

