Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192F65AE236
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbiIFINM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238876AbiIFINI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:13:08 -0400
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Sep 2022 01:13:06 PDT
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C43647FD
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:13:06 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMHzg2QrNzMqjmV;
        Tue,  6 Sep 2022 10:07:11 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMHzf50FQzMppMk;
        Tue,  6 Sep 2022 10:07:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451631;
        bh=CuHbQ5QW8jdDi75yRxwIOrfGONW43/Qt8QGpRAUA+cs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=W8Yo4hKqyfhciiKW9aQ4IhIHPvFfywglXqAd2mxc6ASY9qRIC2esT5ST5O0/N3cjm
         C4NIfcDaWoyA1xjLYo8AC0mPVp4ge/98t+l1mvo5DOXym6kmknBUjisMQGWwlVuPm3
         2yIu0o4XM3evzfflLZX5htayxkjKuHKIkTYRJp0g=
Message-ID: <431e5311-7072-3a20-af75-d81907b22d61@digikod.net>
Date:   Tue, 6 Sep 2022 10:07:10 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 02/18] landlock: refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-3-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-3-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good to see such clean commit!

On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> Adds a new landlock_key union and landlock_id structure to support
> a socket port rule type. Refactors landlock_insert_rule() and
> landlock_find_rule() to support coming network modifications.

> This patch also adds is_object_pointer() and get_root() helpers.

Please explain a bit what these helpers do.


> Now adding or searching a rule in a ruleset depends on a landlock id
> argument provided in refactored functions mentioned above.

More explanation:
A struct landlock_id identifies a unique entry in a ruleset: either a 
kernel object (e.g inode) or a typed data (e.g. TCP port). There is one 
red-black tree per key type.

> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

Because most changes come from 
https://git.kernel.org/mic/c/8f4104b3dc59e7f110c9b83cdf034d010a2d006f 
and 
https://git.kernel.org/mic/c/7d6cf40a6f81adf607ad3cc17aaa11e256beeea4 
you can append
Co-developed-by: Mickaël Salaün <mic@digikod.net>

> ---
> 
> Changes since v6:
> * Adds union landlock_key, enum landlock_key_type, and struct
>    landlock_id.
> * Refactors ruleset functions and improves switch/cases: create_rule(),
>    insert_rule(), get_root(), is_object_pointer(), free_rule(),
>    landlock_find_rule().
> * Refactors landlock_append_fs_rule() functions to support new
>    landlock_id type.
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
>   security/landlock/fs.c      |  21 ++++--
>   security/landlock/ruleset.c | 146 +++++++++++++++++++++++++-----------
>   security/landlock/ruleset.h |  51 ++++++++++---
>   3 files changed, 156 insertions(+), 62 deletions(-)

[...]

> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index 647d44284080..bb1408cc8dd2 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -49,6 +49,33 @@ struct landlock_layer {
>   	access_mask_t access;
>   };
> 
> +/**
> + * union landlock_key - Key of a ruleset's red-black tree
> + */
> +union landlock_key {
> +	struct landlock_object *object;
> +	uintptr_t data;
> +};
> +
> +/**
> + * enum landlock_key_type - Type of &union landlock_key
> + */
> +enum landlock_key_type {
> +	/**
> +	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
> +	 * keys.
> +	 */
> +	LANDLOCK_KEY_INODE = 1,
> +};
> +
> +/**
> + * struct landlock_id - Unique rule identifier for a ruleset
> + */
> +struct landlock_id {
> +	union landlock_key key;
> +	const enum landlock_key_type type;
> +};

You can add these new types to Documentation/security/landlock.rst (with 
this commit). You need to complete all the new field descriptions though 
(otherwise you'll get Sphinx warnings): object, data, key, type.
