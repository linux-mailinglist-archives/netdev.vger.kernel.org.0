Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE6836D283
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhD1GxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:53:12 -0400
Received: from relay.sw.ru ([185.231.240.75]:48210 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236596AbhD1GxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 02:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=SkoUid64jfWnCkxDzH08xkMfbWx02U1lgMhR2hvrunE=; b=GCzcIZi0eDzeq0ZbegH
        iERufDLHLjssGvo/t8qr90tulNdqAY5tC9zzRrxP3GXb7/tx1XDm1wWUttJGFLWc+R6l+W5VH4/h9
        9zQsmctC8mirothvNwKqpdOEtHLmNVElDEAi6oo7aKlttk0vWFApIhLLH499gPwpavCXSMVjwHM=
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lbe3c-001VjE-9e; Wed, 28 Apr 2021 09:52:24 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4 06/16] memcg: enable accounting for scm_fp_list objects
To:     cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Message-ID: <a979f2a8-21ba-704f-fa12-bf57e9cf3e60@virtuozzo.com>
Date:   Wed, 28 Apr 2021 09:52:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unix sockets allows to send file descriptors via SCM_RIGHTS type messages.
Each such send call forces kernel to allocate up to 2Kb memory for
struct scm_fp_list.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/core/scm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 8156d4f..e837e4f 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -79,7 +79,7 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
 
 	if (!fpl)
 	{
-		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL);
+		fpl = kmalloc(sizeof(struct scm_fp_list), GFP_KERNEL_ACCOUNT);
 		if (!fpl)
 			return -ENOMEM;
 		*fplp = fpl;
@@ -348,7 +348,7 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl)
 		return NULL;
 
 	new_fpl = kmemdup(fpl, offsetof(struct scm_fp_list, fp[fpl->count]),
-			  GFP_KERNEL);
+			  GFP_KERNEL_ACCOUNT);
 	if (new_fpl) {
 		for (i = 0; i < fpl->count; i++)
 			get_file(fpl->fp[i]);
-- 
1.8.3.1

