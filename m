Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C03657C79
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 16:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiL1PdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 10:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiL1Pcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 10:32:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0257B15F3A;
        Wed, 28 Dec 2022 07:32:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63E63B81719;
        Wed, 28 Dec 2022 15:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB47C433D2;
        Wed, 28 Dec 2022 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241570;
        bh=mKY2bpqH2t/H56qSjTYe3tCTu4L1mi/O8q3pnYF6mS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4nEprsLrnBEpVop3b+EfQhWyKjUmbLRBypzLEBT+4ggChvWtCHoMf0+RWR4W+ZR9
         /jP6ZCtPbxqXUQdP2CJZBEndmCeC5E5uIc3ytsH2mmSHFv6JfF4/D+7DROaHlnad2V
         PMEbgLLIpNTM4X2uFzD0ssNe9UzoORv0QNB+J5Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0299/1073] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
Date:   Wed, 28 Dec 2022 15:31:27 +0100
Message-Id: <20221228144336.133974002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c3d96f690a790074b508fe183a41e36a00cd7ddd ]

Provide a CONFIG_PROC_FS=n fallback for proc_create_net_single_write().

Also provide a fallback for proc_create_net_data_write().

Fixes: 564def71765c ("proc: Add a way to make network proc files writable")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/proc_fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 81d6e4ec2294..0260f5ea98fe 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -208,8 +208,10 @@ static inline void proc_remove(struct proc_dir_entry *de) {}
 static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
 
 #define proc_create_net_data(name, mode, parent, ops, state_size, data) ({NULL;})
+#define proc_create_net_data_write(name, mode, parent, ops, write, state_size, data) ({NULL;})
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
 #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
+#define proc_create_net_single_write(name, mode, parent, show, write, data) ({NULL;})
 
 static inline struct pid *tgid_pidfd_to_pid(const struct file *file)
 {
-- 
2.35.1



