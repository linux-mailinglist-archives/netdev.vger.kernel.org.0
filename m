Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3302A6E9AC7
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjDTRcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjDTRcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:32:43 -0400
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0633C33
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:32:40 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Q2Pqn3z0KzMq6VV;
        Thu, 20 Apr 2023 19:32:37 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Q2Pqm20sjzMppF7;
        Thu, 20 Apr 2023 19:32:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1682011957;
        bh=fAnbmRZ7wTyF29YzCTBtEnYRkDr9hbMEBLNoGztZMtM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cIDOqDFj+mh+tVNGcDDcJEcbMC7z/JEwjq5mBTUb3kR99rhFDqVG8w+jIbezUKelx
         vJvGpoB9IZyllDMY/y1paYOzKgrLUFyIL487Sqh/J5jYdngxbSIde1IhTYJ0IzIo1B
         McwPgEfkNaDGxnXOIV/2uw6pnzJeur8X44cwclNg=
Message-ID: <17ddf6a0-79d1-b493-0432-c8e84593b165@digikod.net>
Date:   Thu, 20 Apr 2023 19:32:35 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 02/13] landlock: Allow filesystem layout changes for
 domains without such rule type
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-3-konstantin.meskhidze@huawei.com>
 <062447d5-bd64-f58e-9476-0d2d2034f333@digikod.net>
 <3dd0376c-2835-d1c0-60a9-79d1d22a4d3f@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <3dd0376c-2835-d1c0-60a9-79d1d22a4d3f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/04/2023 13:42, Konstantin Meskhidze (A) wrote:
> 
> 
> 4/16/2023 7:09 PM, Mickaël Salaün пишет:
>>
>> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>>> From: Mickaël Salaün <mic@digikod.net>
>>>
>>> Allow mount point and root directory changes when there is no filesystem
>>> rule tied to the current Landlock domain.  This doesn't change anything
>>> for now because a domain must have at least a (filesystem) rule, but
>>> this will change when other rule types will come.  For instance, a
>>> domain only restricting the network should have no impact on filesystem
>>> restrictions.
>>>
>>> Add a new get_current_fs_domain() helper to quickly check filesystem
>>> rule existence for all filesystem LSM hooks.
>>>
>>> Remove unnecessary inlining.
>>>
>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>> ---
>>>
>>> Changes since v9:
>>> * Refactors documentaion landlock.rst.
>>> * Changes ACCESS_FS_INITIALLY_DENIED constant
>>> to LANDLOCK_ACCESS_FS_INITIALLY_DENIED.
>>> * Gets rid of unnecessary masking of access_dom in
>>> get_raw_handled_fs_accesses() function.
>>>
>>> Changes since v8:
>>> * Refactors get_handled_fs_accesses().
>>> * Adds landlock_get_raw_fs_access_mask() helper.
>>>
>>> ---
>>>    Documentation/userspace-api/landlock.rst |  6 +-
>>>    security/landlock/fs.c                   | 78 ++++++++++++------------
>>>    security/landlock/ruleset.h              | 25 +++++++-
>>>    security/landlock/syscalls.c             |  6 +-
>>>    4 files changed, 68 insertions(+), 47 deletions(-)
>>>
>>
>> [...]
>>
>>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>>> index 71aca7f990bc..d35cd5d304db 100644
>>> --- a/security/landlock/syscalls.c
>>> +++ b/security/landlock/syscalls.c
>>> @@ -310,6 +310,7 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>>>    	struct path path;
>>>    	struct landlock_ruleset *ruleset;
>>>    	int res, err;
>>> +	access_mask_t mask;
>>>
>>>    	if (!landlock_initialized)
>>>    		return -EOPNOTSUPP;
>>> @@ -348,9 +349,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>>>    	 * Checks that allowed_access matches the @ruleset constraints
>>>    	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>>>    	 */
>>> -	if ((path_beneath_attr.allowed_access |
>>> -	     landlock_get_fs_access_mask(ruleset, 0)) !=
>>> -	    landlock_get_fs_access_mask(ruleset, 0)) {
>>> +	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
>>> +	if ((path_beneath_attr.allowed_access | mask) != mask) {
>>
>> This hunk can be moved to the previous patch (i.e. mask = …). This patch
>> should only contains the new landlock_get_raw_fs_access_mask() call.
>>
> 
>    Sorry. Did not get this tip. Please can you explain what do you mean here?

You can squash this part in the previous patch:

-	if ((path_beneath_attr.allowed_access |
-	     landlock_get_fs_access_mask(ruleset, 0)) !=
-	    landlock_get_fs_access_mask(ruleset, 0)) {
+	mask = landlock_get_fs_access_mask(ruleset, 0);
+	if ((path_beneath_attr.allowed_access | mask) != mask) {

And this patch will then only include this part:

-	mask = landlock_get_fs_access_mask(ruleset, 0);
+	mask = landlock_get_raw_fs_access_mask(ruleset, 0);


>>
>>>    		err = -EINVAL;
>>>    		goto out_put_ruleset;
>>>    	}
>>> --
>>> 2.25.1
>>>
>> .
