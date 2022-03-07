Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE9A4D0B42
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243147AbiCGWja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243206AbiCGWj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:39:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC91BC35
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:38:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 583C0B81733
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7AC340EF;
        Mon,  7 Mar 2022 22:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646692711;
        bh=QgB0awSZcjP3K0FWO031CcxIlDALat10naLo/iD3Bts=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=pjqsFADGpH8t7snwQlyimFX1CVXsTSpuw6Cn2slO4YZMh9Nb1T263VWrjBy3BAhXL
         iHyqhY4K/PbLN6DjbvJoFI0LTIYx0bzpCLPQnOb0Zj3z8g2vhnw4teItL1raUeWUjM
         weXrUb59VuOMPzrG6YIttssG3Q3UQc0/ao+1B4irRjqz8Aasgk+7kLJX+myPBE0i3f
         cquPVupBXUDPqjuhI69qrNjTBBOsgH86l6z5VV2ps8GRgFVLxJEzi1Cm1cC291FYPy
         GOvy48NOYZa/JzedjVT9whhvOODqXZUgEGY3ivaMe+PJ/zvTC6KlNx9m5QBfGQlrOG
         Mt/B4WZ/qbzBQ==
Message-ID: <bace0fb9-2ac4-f402-ca2e-8e2a7de50560@kernel.org>
Date:   Mon, 7 Mar 2022 15:38:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Content-Language: en-US
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        markzhang@nvidia.com, leonro@nvidia.com
References: <cover.1646223467.git.aclaudi@redhat.com>
 <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
 <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org> <YiZNNQB727Il+EVN@tc2>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <YiZNNQB727Il+EVN@tc2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/22 11:21 AM, Andrea Claudi wrote:
> On Mon, Mar 07, 2022 at 10:58:37AM -0700, David Ahern wrote:
>> On 3/2/22 5:28 AM, Andrea Claudi wrote:
>>> diff --git a/include/utils.h b/include/utils.h
>>> index b6c468e9..81294488 100644
>>> --- a/include/utils.h
>>> +++ b/include/utils.h
>>> @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
>>>  __u64 get_cgroup2_id(const char *path);
>>>  char *get_cgroup2_path(__u64 id, bool full);
>>>  int get_command_name(const char *pid, char *comm, size_t len);
>>> -char *get_task_name(pid_t pid);
>>> +int get_task_name(pid_t pid, char *name);
>>>  
>>
>> changing to an API with an assumed length is not better than the current
>> situation. Why not just fixup the callers as needed to free the allocation?
>>
> 
> I actually did that on v1. After Stephen's comment about asprintf(), I
> got the idea to make get_task_name() similar to get_command_name() and
> a bit more "user-friendly", so that callers do not need a free().
> 

get_command_name passes a buffer and length. That's a better API - no
assumptions.
