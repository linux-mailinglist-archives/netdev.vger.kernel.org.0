Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3447656A88A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiGGQqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiGGQqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:46:40 -0400
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [IPv6:2001:1600:3:17::190f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EA031214
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:46:39 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Lf2P96f5fzMqQhx;
        Thu,  7 Jul 2022 18:46:37 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Lf2P931wczlqwrn;
        Thu,  7 Jul 2022 18:46:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1657212397;
        bh=gppSphjURzSVISUgaNdkCDnGfz6Vgo6oN8MoVN6XCnU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FB24CKuD9quvNRsvNjgkNCdkE3t9SW8/QqesR5btCalCU+mP/wk6fzIcDzESzAjys
         lcgtmFu1rvpMEIw9uKs37KOI7Bpz2rT/CjLnFd28hQzG6vULlHzvtiSo1xKw0a7acL
         UeeZ8qXi/KDEMa9N6B4pmLgsE2Mx62ojFseyoMMs=
Message-ID: <b02d6f95-ea80-b82d-5b7b-6d116a9b5078@digikod.net>
Date:   Thu, 7 Jul 2022 18:46:36 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/06/2022 10:22, Konstantin Meskhidze wrote:
> Adds a new object union to support a socket port
> rule type. Refactors landlock_insert_rule() and
> landlock_find_rule() to support coming network
> modifications. Now adding or searching a rule
> in a ruleset depends on a rule_type argument
> provided in refactored functions mentioned above.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v5:
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors insert_rule() and create_rule() functions by deleting
> rule_type from their arguments list, it helps to reduce useless code.
> 
> Changes since v3:
> * Splits commit.
> * Refactors landlock_insert_rule and landlock_find_rule functions.
> * Rename new_ruleset->root_inode.
> 
> ---
>   security/landlock/fs.c      |   7 ++-
>   security/landlock/ruleset.c | 105 ++++++++++++++++++++++++++----------
>   security/landlock/ruleset.h |  27 +++++-----
>   3 files changed, 96 insertions(+), 43 deletions(-)

[...]

> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index bd7ab39859bf..a22d132c32a7 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -53,15 +53,17 @@ struct landlock_rule {
>   	 */
>   	struct rb_node node;
>   	/**
> -	 * @object: Pointer to identify a kernel object (e.g. an inode).  This
> -	 * is used as a key for this ruleset element.  This pointer is set once
> -	 * and never modified.  It always points to an allocated object because
> -	 * each rule increments the refcount of its object.
> -	 */
> -	struct landlock_object *object;
> -	/**
> -	 * @num_layers: Number of entries in @layers.
> +	 * @object: A union to identify either a kernel object (e.g. an inode) or
> +	 * a raw data value (e.g. a network socket port). This is used as a key
> +	 * for this ruleset element. This pointer/@object.ptr/ is set once and
> +	 * never modified. It always points to an allocated object because each
> +	 * rule increments the refcount of its object (for inodes).;

Extra ";"
