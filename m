Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A4E6B6231
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 00:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCKXj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 18:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCKXjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 18:39:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16E23647B;
        Sat, 11 Mar 2023 15:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=WbqYZjJpU+1PcZrTGrNzziUjjV/M7hAxp2OwdHagJ+Q=; b=EpH1Web2oo+7BVAyfP4XAd0oWb
        JpuUNAZJaewTVAaWl00eZw3cklOLr3Wz3KAh3RAoU1Vr/6v4rjYGZTEAIZgV3hYgiLZhvQZ5Q43Mz
        4FFXgZeda5nzjUk5vC2FJ6tQ0dAtoAzI5tCflzArz+g8zdVqvZtPsirnfynC+xBiG+S8zER2t7oXq
        62dZDgQ2vuhDcJNjqcKd/MqmdCZjswH6mdznvnjZmKrPCDpRGqL6g/vl5Q7ThXKFgAPPQGVl0Jlf3
        xdBR7AFHArHtGGNCRIWf7dYUnfe1F0hdSQJSRW9xwJP9HrFbkM9z1V77Yan2HVsR6p87jFD7H+AMZ
        RVHE2tbw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb8oS-001UJg-U2; Sat, 11 Mar 2023 23:39:44 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 0/5] sunrpc: simplfy sysctl registrations
Date:   Sat, 11 Mar 2023 15:39:39 -0800
Message-Id: <20230311233944.354858-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is my v3 series to simplify sysctl registration for sunrpc. The
first series was posted just yesterday [0] but 0-day found an issue with
CONFIG_SUNRPC_DEBUG. After this fix I poasted a fix for v2 [1] but alas
0-day then found an issue when CONFIG_SUNRPC_DEBUG is disabled. This
fixes both cases... hopefully that's it.
                                                                                                                                                                                              
Changes on v3:

   o Fix compilation when CONFIG_SUNRPC_DEBUG is disabled.. forgot to
     keep all the sysctl stuff under the #ifdef.

Changes on v2:

   o Fix compilation when CONFIG_SUNRPC_DEBUG is enabled, I forgot to move the
     proc routines above, and so the 4th patch now does that too.
                                                                                                                                                                                              
Feel free to take these patches or let me know and I'm happy to also
take these in through sysctl-next. Typically I use sysctl-next for
core sysctl changes or for kernel/sysctl.c cleanup to avoid conflicts.
All these syctls however are well contained to sunrpc so they can also
go in separately. Let me know how you'd like to go about these patches.
                                                                                                                                                                                              
[0] https://lkml.kernel.org/r/20230310225236.3939443-1-mcgrof@kernel.org

Luis Chamberlain (5):
  sunrpc: simplify two-level sysctl registration for tsvcrdma_parm_table
  sunrpc: simplify one-level sysctl registration for xr_tunables_table
  sunrpc: simplify one-level sysctl registration for xs_tunables_table
  sunrpc: move sunrpc_table and proc routines above
  sunrpc: simplify one-level sysctl registration for debug_table

 net/sunrpc/sysctl.c             | 42 ++++++++++++---------------------
 net/sunrpc/xprtrdma/svc_rdma.c  | 21 ++---------------
 net/sunrpc/xprtrdma/transport.c | 11 +--------
 net/sunrpc/xprtsock.c           | 13 ++--------
 4 files changed, 20 insertions(+), 67 deletions(-)

-- 
2.39.1

