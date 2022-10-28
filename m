Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C0661116D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJ1Mb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJ1Mb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:31:26 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CCC159D75;
        Fri, 28 Oct 2022 05:31:23 -0700 (PDT)
Received: from [172.20.1.180] (unknown [62.168.35.11])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 22B75422E8;
        Fri, 28 Oct 2022 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1666960282;
        bh=YfFt0/vCaAixY81u2/InzVHHiQaF1b6HYOm4KO4WUrU=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=dIWf05bK2FoeeaoK/VAsclxnU4rJTgXh18d2NRSN7XpAsrSJtOyQ+QiidGEwzfrKo
         mXl4ylsOdzObQXPw8BoX6eG+MoJBcUI0txRXSckKevDpBoDb02W6U1Or0El7h6hshw
         rd3hiTVujN+E2b2veexZv8NSf+EwF+IT+Oj/zAAKmolW/joHq9bIDBTqrcdW1Pul9t
         /MHxkU9eyUpHPdWu0DYrQE6SCnqjEeJpkrb1iy+WT9B2ZwlTPmXGE+5ZnSPtOGEy5v
         bqxot4ohRr21U5mYOjbqqVjBTJJ61fZ4zVesOqyG4S4Tn5nA5QKhi+XdASulZyglyJ
         dcA07EBL4gvlQ==
Message-ID: <8781116e-1738-5cbf-976c-328ebeafba67@canonical.com>
Date:   Fri, 28 Oct 2022 05:31:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t
 safe
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <166543910984.474337.2779830480340611497.stgit@olly>
 <CAHC9VhRfEiJunPo7bVzmPPg8UHDoFc0wvOhBaFrsLjfeDCg50g@mail.gmail.com>
From:   John Johansen <john.johansen@canonical.com>
Organization: Canonical
In-Reply-To: <CAHC9VhRfEiJunPo7bVzmPPg8UHDoFc0wvOhBaFrsLjfeDCg50g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/22 15:00, Paul Moore wrote:
> On Mon, Oct 10, 2022 at 5:58 PM Paul Moore <paul@paul-moore.com> wrote:
>>
>> Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
>> sockptr_t argument") made it possible to call sk_getsockopt()
>> with both user and kernel address space buffers through the use of
>> the sockptr_t type.  Unfortunately at the time of conversion the
>> security_socket_getpeersec_stream() LSM hook was written to only
>> accept userspace buffers, and in a desire to avoid having to change
>> the LSM hook the commit author simply passed the sockptr_t's
>> userspace buffer pointer.  Since the only sk_getsockopt() callers
>> at the time of conversion which used kernel sockptr_t buffers did
>> not allow SO_PEERSEC, and hence the
>> security_socket_getpeersec_stream() hook, this was acceptable but
>> also very fragile as future changes presented the possibility of
>> silently passing kernel space pointers to the LSM hook.
>>
>> There are several ways to protect against this, including careful
>> code review of future commits, but since relying on code review to
>> catch bugs is a recipe for disaster and the upstream eBPF maintainer
>> is "strongly against defensive programming", this patch updates the
>> LSM hook, and all of the implementations to support sockptr_t and
>> safely handle both user and kernel space buffers.
>>
>> Signed-off-by: Paul Moore <paul@paul-moore.com>
>> ---
>>   include/linux/lsm_hook_defs.h |    2 +-
>>   include/linux/lsm_hooks.h     |    4 ++--
>>   include/linux/security.h      |   11 +++++++----
>>   net/core/sock.c               |    3 ++-
>>   security/apparmor/lsm.c       |   29 +++++++++++++----------------
>>   security/security.c           |    6 +++---
>>   security/selinux/hooks.c      |   13 ++++++-------
>>   security/smack/smack_lsm.c    |   19 ++++++++++---------
>>   8 files changed, 44 insertions(+), 43 deletions(-)
> 
> Casey and John, could you please look over the Smack and AppArmor bits
> of this patch when you get a chance?  I did my best on the conversion,
> but I would appreciate a review by the experts :)
> 
yes, I plan to look at it this weekend

