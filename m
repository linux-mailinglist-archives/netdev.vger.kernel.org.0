Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477C5692488
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjBJRfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbjBJRfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:35:05 -0500
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6042477B85
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:35:03 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PD18N0KhrzMqHj0;
        Fri, 10 Feb 2023 18:35:00 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PD18M2XF2zlgQ;
        Fri, 10 Feb 2023 18:34:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676050499;
        bh=qq9/iBzdW2JJ7LVb5FrkmL3nT8Cyk8jQS1aBdesp2Ow=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bE223pPu7T9gAGiAJsTtK6XLms+0odBCnUoBzhwBQrVindPNB5yE0QKyy+BxaEidy
         K+AwcJHzSKfPCHFVZ0QZWNufG2cGNQbiOtRWdbccqVPj9ZDJFUtPu6m2/NLc2umAL6
         t23GJ2z0PesQM6V3oEmcHP22Md/C533XceBElnyY=
Message-ID: <97ff3f0f-1704-3003-fe60-d7444579e0d7@digikod.net>
Date:   Fri, 10 Feb 2023 18:34:57 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 02/12] landlock: Allow filesystem layout changes for
 domains without such rule type
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-3-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-3-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Konstantin,

I think this patch series is almost ready. Here is a first batch of 
review, I'll send more next week.


I forgot to update the documentation. Can you please squash the 
following patch into this one?


diff --git a/Documentation/userspace-api/landlock.rst 
b/Documentation/userspace-api/landlock.rst
index 980558b879d6..fc2be89b423f 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -416,9 +416,9 @@ Current limitations
  Filesystem topology modification
  --------------------------------

-As for file renaming and linking, a sandboxed thread cannot modify its
-filesystem topology, whether via :manpage:`mount(2)` or
-:manpage:`pivot_root(2)`.  However, :manpage:`chroot(2)` calls are not 
denied.
+Threads sandboxed with filesystem restrictions cannot modify filesystem
+topology, whether via :manpage:`mount(2)` or :manpage:`pivot_root(2)`.
+However, :manpage:`chroot(2)` calls are not denied.

  Special filesystems
  -------------------


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> From: Mickaël Salaün <mic@digikod.net>
> 
> Allow mount point and root directory changes when there is no filesystem
> rule tied to the current Landlock domain.  This doesn't change anything
> for now because a domain must have at least a (filesystem) rule, but
> this will change when other rule types will come.  For instance, a
> domain only restricting the network should have no impact on filesystem
> restrictions.
> 
> Add a new get_current_fs_domain() helper to quickly check filesystem
> rule existence for all filesystem LSM hooks.
> 
> Remove unnecessary inlining.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
> 
> Changes since v8:
> * Refactors get_handled_fs_accesses().
> * Adds landlock_get_raw_fs_access_mask() helper.
> 
