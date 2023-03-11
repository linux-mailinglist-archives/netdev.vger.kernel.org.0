Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899C66B60A9
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCKUwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCKUwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:52:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32DA6B320;
        Sat, 11 Mar 2023 12:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=epir3kUlhwZi0ch2uSTIsF69TiKLgNjq3KCcq98c0O4=; b=R+dZ//ubz4V6Nr9bKl/jSds2bB
        oTZq7+72nRwC7sTYVui6f0o0c5bkl+Y0cB3FaoSyRedMPnqsVsoZvNek6F16DgCV2u8903aiYZN1F
        Gnhyz+MtlGhrLcwd5gKnQGBfIF7ydk7YAp8qikDA5PoZiVfJFyQk54QFjxe1t7hH2Sxm21rDpZwno
        FJ0y4DTbqc0d/yiiEYbBgnPXfFyB9V+BmdBxLdHABNL3I8zAgybA+W/8Oxww5OkhySEk6S+tl38RD
        Ts0594cQz74PsxfDNCqpNqEQ6lZPSmAO51xc3T/MHBdnwB6p6jyVD1e+FxyAFaVr6pWZx6QhWHzvH
        7bbK1xgQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb6Bz-001EK8-O9; Sat, 11 Mar 2023 20:51:51 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 0/5] sunrpc: simplfy sysctl registrations
Date:   Sat, 11 Mar 2023 12:51:43 -0800
Message-Id: <20230311205148.293375-1-mcgrof@kernel.org>
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

This is my v2 series to simplify sysctl registration for sunrpc. The
first series was posted just yesterday [0]. On this v2 I address the
only compilation issues found by 0day through my entire tree of
sysctl conversions.

Changes sincce v1:

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

 net/sunrpc/sysctl.c             | 44 ++++++++++++---------------------
 net/sunrpc/xprtrdma/svc_rdma.c  | 21 ++--------------
 net/sunrpc/xprtrdma/transport.c | 11 +--------
 net/sunrpc/xprtsock.c           | 13 ++--------
 4 files changed, 21 insertions(+), 68 deletions(-)

-- 
2.39.1

