Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF2510261
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352721AbiDZQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352713AbiDZQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:01:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1826C1632D2;
        Tue, 26 Apr 2022 08:58:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB5091F380;
        Tue, 26 Apr 2022 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650988719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/SnflrHI3KVsg8jdxxTvHBaYfhAF2HRDrFp9wuv+OU=;
        b=dFWOpfPHqSvnhwXztUTZYUl3fap1MBIe2lX8NCjDD53cErnGiOUxlL6EIaRMF5+SQ0E2ss
        oDHJqQCOgBTKrhIe4TylXMCrtGGS1OyhtalkCvWs2gw0HOTQZeH2+hVQUwC8aQx69va1lB
        bhqDHmxKkKNT9kC3fJ8QfnyAtLstYCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650988719;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/SnflrHI3KVsg8jdxxTvHBaYfhAF2HRDrFp9wuv+OU=;
        b=U7AZRG6f03hwa73y4K3qKVfFLvL2LYyPUlQ+lBtn9gKIZigltC2UxKvPFj5X/uJs/AofS/
        KPYJFqOfTlp5ykBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 95A6F13223;
        Tue, 26 Apr 2022 15:58:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t0vTI68WaGJ2dAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 26 Apr 2022 15:58:39 +0000
Message-ID: <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
Date:   Tue, 26 Apr 2022 17:58:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
 <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
 <20220426080247.19bbb64e@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220426080247.19bbb64e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/22 17:02, Jakub Kicinski wrote:
> On Tue, 26 Apr 2022 17:29:03 +0300 Sagi Grimberg wrote:
>>>> Create the socket in user space, do all the handshakes you need there
>>>> and then pass it to the kernel.  This is how NBD + TLS works.  Scales
>>>> better and requires much less kernel code.
>>>>   
>>> But we can't, as the existing mechanisms (at least for NVMe) creates the
>>> socket in-kernel.
>>> Having to create the socket in userspace would require a completely new
>>> interface for nvme and will not be backwards compatible.
>>
>> And we will still need the upcall anyways when we reconnect
>> (re-establish the socket)
> 
> That totally flew over my head, I have zero familiarity with in-kernel
> storage network users :S
> 
Count yourself lucky.

> In all honesty the tls code in the kernel is a bit of a dumping ground.
> People come, dump a bunch of code and disappear. Nobody seems to care
> that the result is still (years in) not ready for production use :/
> Until a month ago it'd break connections even under moderate memory
> pressure. This set does not even have selftests.
> 
Well, I'd been surprised that it worked, too.
And even more so that Boris Piskenny @ Nvidia is actively working on it.
(Thanks, Sagi!)

> Plus there are more protocols being actively worked on (QUIC, PSP etc.)
> Having per ULP special sauce to invoke a user space helper is not the
> paradigm we chose, and the time as inopportune as ever to change that.

Which is precisely what we hope to discuss at LSF.
(Yes, I know, probably not the best venue to discuss network stuff ...)

Each approach has its drawbacks:

- Establishing sockets from userspace will cause issues during 
reconnection, as then someone (aka the kernel) will have to inform 
userspace that a new connection will need to be established.
(And that has to happen while the root filesystem is potentially 
inaccessible, so you can't just call arbitrary commands here)
(Especially call_usermodehelper() is out of the game)
- Having ULP helpers (as with this design) mitigates that problem 
somewhat in the sense that you can mlock() that daemon and having it 
polling on an intermediate socket; that solves the notification problem.
But you have to have ULP special sauce here to make it work.
- Moving everything in kernel is ... possible. But then you have yet 
another security-relevant piece of code in the kernel which needs to be 
audited, CVEd etc. Not to mention the usual policy discussion whether it 
really belongs into the kernel.

So I don't really see any obvious way to go; best we can do is to pick 
the least ugly :-(

Cheers,

Hannes
