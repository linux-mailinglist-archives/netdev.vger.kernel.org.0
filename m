Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A554C5E7672
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiIWJII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiIWJID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:08:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F4F12BD80;
        Fri, 23 Sep 2022 02:08:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A0F1B219BA;
        Fri, 23 Sep 2022 09:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663924080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NmV8dBleohq19FUTGjShv3qNCUcjTHlt1m0s7sWLVk=;
        b=V6wEuumqUBqjySkow4NVfoPBdDcct+QY2sSnA92ZeyPwH38i0NPhxZ2JBFN/nzoZI0qJDc
        KkeFL/D96aoTs49QcLygaGlMNADNI8AXG8StgjNUceGaiafR2+x2Vnsi6pDhmZ07qrK3n8
        Inta8iq5GzYLsx9ExrSXKnUXYR9y3Io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663924080;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NmV8dBleohq19FUTGjShv3qNCUcjTHlt1m0s7sWLVk=;
        b=U7EHAzZMP7bk2R61PfblSG7IYbc4Ddv8PLRV2h2xeqC20gD9ZFpGn6nKi00zf3zaGPeOWS
        aSCwMvZR9gmTbODQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 19F9B13AA5;
        Fri, 23 Sep 2022 09:08:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id e5i3BXB3LWM6HAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 23 Sep 2022 09:08:00 +0000
Message-ID: <6e6a5f86-3080-54ed-82ea-80e57e184fd0@suse.cz>
Date:   Fri, 23 Sep 2022 11:07:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 00/12] slab: Introduce kmalloc_size_roundup()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Pekka Enberg <penberg@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>
References: <20220922031013.2150682-1-keescook@chromium.org>
 <673e425d-1692-ef47-052b-0ff2de0d9c1d@amd.com>
 <202209220845.2F7A050@keescook>
 <cb38655c-2107-bda6-2fa8-f5e1e97eab14@suse.cz>
 <202209221446.5E90AEED@keescook>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <202209221446.5E90AEED@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 23:49, Kees Cook wrote:
> On Thu, Sep 22, 2022 at 11:05:47PM +0200, Vlastimil Babka wrote:
>> On 9/22/22 17:55, Kees Cook wrote:
>> > On Thu, Sep 22, 2022 at 09:10:56AM +0200, Christian König wrote:
>> > [...]
>> > > So when this patch set is about to clean up this use case it should probably
>> > > also take care to remove ksize() or at least limit it so that it won't be
>> > > used for this use case in the future.
>> > 
>> > Yeah, my goal would be to eliminate ksize(), and it seems possible if
>> > other cases are satisfied with tracking their allocation sizes directly.
>> 
>> I think we could leave ksize() to determine the size without a need for
>> external tracking, but from now on forbid callers from using that hint to
>> overflow the allocation size they actually requested? Once we remove the
>> kasan/kfence hooks in ksize() that make the current kinds of usage possible,
>> we should be able to catch any offenders of the new semantics that would appear?
> 
> That's correct. I spent the morning working my way through the rest of
> the ksize() users I didn't clean up yesterday, and in several places I
> just swapped in __ksize(). But that wouldn't even be needed if we just
> removed the kasan unpoisoning from ksize(), etc.
> 
> I am tempted to leave it __ksize(), though, just to reinforce that it's
> not supposed to be used "normally". What do you think?

Sounds good. Note in linux-next there's now a series in slab.git planned for
6.1 that moves __ksize() declaration to mm/slab.h to make it more private.
But we don't want random users outside mm and related kasan/kfence
subsystems to include mm/slab.h, so we'll have to expose it again instead of
ksize().
