Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F7D6B54CA
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjCJWwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCJWwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:52:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE3110CEA4;
        Fri, 10 Mar 2023 14:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=xq1C+pCs+PTk//P8h5Wao2x+E1zhW4GXd2PFLTG6YZg=; b=QJhjCT/UH2SS/B76vB0Dj7jyEh
        wAzP+XwockP69rCscgjgknaDx/1Cl+2ht7/IR8vMZbAyfUcXwTAOKq3XmCrTW9xfQjEe3v/4Lq1k/
        0FT3whmNwD0z9+iNOHWbRYFEPimcy/RXIWpikrGtjhjDcGhjAWdpG+ushNylnBmLKL4cnwJsdw9Bn
        SCdkJpVEDKfVSPJ7dhlOrFwT81pa19EytHk0dUzd5Ied3mwn1Y6ky+DPbfkKHyD2jO8lXbTs1xdql
        y1oyEJs5X3MaKNPueEHrCemYK1uagkPw9wxe/Jfk/5ZthVvwYjBqxYG2Qz64RQLyTdAF4A5IONwnE
        KYnC8LlA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1palbL-00GWqc-ID; Fri, 10 Mar 2023 22:52:39 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/5] sunrpc: simplfy sysctl registrations
Date:   Fri, 10 Mar 2023 14:52:31 -0800
Message-Id: <20230310225236.3939443-1-mcgrof@kernel.org>
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

We're trying to deprecate the APIs for sysctl that try to do
registration and but are exposed to recursion. Those paths are
only needed in complex cases and even those can be simplified
with time.

Sunrpc uses has simple requirements: just to have their parent
directory created. The new sysctl APIs can be used for this. If
you are curious about new requirements just review the new patch
for documentation I just posted:

https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     

So just simplify all this.

I haven't even build tested this, this is all being compile tested
now through sysctl-testing [0] along with the other rest of the
changes.

Posting this early in the development cycle so it gets proper testing
and review.

Feel free to take these patches or let me know and I'm happy to also
take these in through sysctl-next. Typically I use sysctl-next for
core sysctl changes or for kernel/sysctl.c cleanup to avoid conflicts.
All these syctls however are well contained to sunrpc so they can also
go in separately. Let me know how you'd like to go about these patches.

For those curious -- yes most of this is based on Coccinelle grammar,
you can see the SmPL patch I first wrote years ago for some other use
cases here:

https://lore.kernel.org/all/20211123202422.819032-6-mcgrof@kernel.org/

This is just an evolution of that with more complex cases, however
always writing the SmPL patch to each commit eats my time away and
I really cannot be bothered by that. Small modifications to the above
can be used however to do things which are similar.

Luis Chamberlain (5):
  sunrpc: simplify two-level sysctl registration for tsvcrdma_parm_table
  sunrpc: simplify one-level sysctl registration for xr_tunables_table
  sunrpc: simplify one-level sysctl registration for xs_tunables_table
  sunrpc: move sunrpc_table above
  sunrpc: simplify one-level sysctl registration for debug_table

 net/sunrpc/sysctl.c             | 90 ++++++++++++++-------------------
 net/sunrpc/xprtrdma/svc_rdma.c  | 21 +-------
 net/sunrpc/xprtrdma/transport.c | 11 +---
 net/sunrpc/xprtsock.c           | 13 +----
 4 files changed, 44 insertions(+), 91 deletions(-)

-- 
2.39.1

