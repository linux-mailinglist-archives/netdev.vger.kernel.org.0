Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1EE52E49B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345689AbiETGAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345429AbiETGAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:00:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C57C14B66A
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54DC2CE282C
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A3EC385A9;
        Fri, 20 May 2022 06:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653026416;
        bh=6dwQ/h0+lGjJjXFdH29fMIB3ebOxNVqFeYcD8Z8RTt4=;
        h=From:To:Cc:Subject:Date:From;
        b=Dv6S4/KABYl8C6UCDy5cFhahc4DRugENTXJXAty71/GUmw2dpvOOnaSF6OHInQ1fc
         rQej9YjEWtwptEctNbqtEWc3tjCJcnE/Kr3X+HESnV5VeCML8QPsQT/gSUA7txfTvq
         8ZaYLuLKsPMXwyH4WJf1fIBArf4XBDfiSbpX4lv+Ce9Uc8gcmr4qhVLM0pXL8souX4
         Pfru5WtaV9v0g5unV/u52vI7u6X8BWmmis2jqzyUjHMHMoEL8j8PHRNlyh3+VcJgvj
         OomjxF99iBcZ3Zf1tQxkOwS6BQlAVLW++/rdIDt1jhQ5becD+FVHvp6dc1yBJnhyg8
         J52ed7YEAESOg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net
Subject: [PATCH net-next] wwan: iosm: use a flexible array rather than allocate short objects
Date:   Thu, 19 May 2022 23:00:13 -0700
Message-Id: <20220520060013.2309497-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC array-bounds warns that ipc_coredump_get_list() under-allocates
the size of struct iosm_cd_table *cd_table.

This is avoidable - we just need a flexible array. Nothing calls
sizeof() on struct iosm_cd_list or anything that contains it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: m.chetan.kumar@intel.com
CC: linuxwwan@intel.com
CC: loic.poulain@linaro.org
CC: ryazanov.s.a@gmail.com
CC: johannes@sipsolutions.net
---
 drivers/net/wwan/iosm/iosm_ipc_coredump.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_coredump.h b/drivers/net/wwan/iosm/iosm_ipc_coredump.h
index 0809ba664276..3da5ec75e0f0 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_coredump.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_coredump.h
@@ -14,9 +14,6 @@
 /* Max buffer allocated to receive coredump data */
 #define MAX_DATA_SIZE 0x00010000
 
-/* Max number of file entries */
-#define MAX_NOF_ENTRY 256
-
 /* Max length */
 #define MAX_SIZE_LEN 32
 
@@ -38,7 +35,7 @@ struct iosm_cd_list_entry {
  */
 struct iosm_cd_list {
 	__le32 num_entries;
-	struct iosm_cd_list_entry entry[MAX_NOF_ENTRY];
+	struct iosm_cd_list_entry entry[];
 } __packed;
 
 /**
-- 
2.34.3

