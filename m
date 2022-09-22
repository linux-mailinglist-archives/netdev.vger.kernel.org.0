Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820A35E6D9F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiIVVFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIVVFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:05:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2A310CA5F;
        Thu, 22 Sep 2022 14:05:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4788F1F8BD;
        Thu, 22 Sep 2022 21:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663880748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XKo+i59z16xYCKZljHHhrwZOK4kULyS2cn+2CLRfUM0=;
        b=yYZqXMGxzMVH0hLKeYU8DtcEW5z+72E8D8wluVkMB38JNQ6mVtvWYW44sf9Qr+ZQm+We5X
        ZxoqRMYTP+O1T/rNawICmYwKgqmViLi4WF8AuUeX1BOp9TwGPEwvLg1O9HhwZMa65TkR9W
        yGHcw9EwWtJmQERB8NRzG2kYdmwST+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663880748;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XKo+i59z16xYCKZljHHhrwZOK4kULyS2cn+2CLRfUM0=;
        b=kaD9JOgsDV+IpQlfyoPslHKu+574Yw//haDJvp79fZBtXqIgPNRCscY2PniCUaAEZMnwWD
        sPWSH1zmuGYRGABQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B86DF1346B;
        Thu, 22 Sep 2022 21:05:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QI4BLCvOLGP2JwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 22 Sep 2022 21:05:47 +0000
Message-ID: <cb38655c-2107-bda6-2fa8-f5e1e97eab14@suse.cz>
Date:   Thu, 22 Sep 2022 23:05:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 00/12] slab: Introduce kmalloc_size_roundup()
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     Pekka Enberg <penberg@kernel.org>, Feng Tang <feng.tang@intel.com>,
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
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Feng Tang <feng.tang@intel.com>
References: <20220922031013.2150682-1-keescook@chromium.org>
 <673e425d-1692-ef47-052b-0ff2de0d9c1d@amd.com>
 <202209220845.2F7A050@keescook>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <202209220845.2F7A050@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 17:55, Kees Cook wrote:
> On Thu, Sep 22, 2022 at 09:10:56AM +0200, Christian König wrote:
>> Am 22.09.22 um 05:10 schrieb Kees Cook:
>> > Hi,
>> > 
>> > This series fixes up the cases where callers of ksize() use it to
>> > opportunistically grow their buffer sizes, which can run afoul of the
>> > __alloc_size hinting that CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE
>> > use to perform dynamic buffer bounds checking.
>> 
>> Good cleanup, but one question: What other use cases we have for ksize()
>> except the opportunistically growth of buffers?
> 
> The remaining cases all seem to be using it as a "do we need to resize
> yet?" check, where they don't actually track the allocation size
> themselves and want to just depend on the slab cache to answer it. This
> is most clearly seen in the igp code:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/intel/igb/igb_main.c?h=v6.0-rc6#n1204
> 
> My "solution" there kind of side-steps it, and leaves ksize() as-is:
> https://lore.kernel.org/linux-hardening/20220922031013.2150682-8-keescook@chromium.org/
> 
> The more correct solution would be to add per-v_idx size tracking,
> similar to the other changes I sent:
> https://lore.kernel.org/linux-hardening/20220922031013.2150682-11-keescook@chromium.org/
> 
> I wonder if perhaps I should just migrate some of this code to using
> something like struct membuf.
> 
>> Off hand I can't see any.
>> 
>> So when this patch set is about to clean up this use case it should probably
>> also take care to remove ksize() or at least limit it so that it won't be
>> used for this use case in the future.
> 
> Yeah, my goal would be to eliminate ksize(), and it seems possible if
> other cases are satisfied with tracking their allocation sizes directly.

I think we could leave ksize() to determine the size without a need for
external tracking, but from now on forbid callers from using that hint to
overflow the allocation size they actually requested? Once we remove the
kasan/kfence hooks in ksize() that make the current kinds of usage possible,
we should be able to catch any offenders of the new semantics that would appear?

> -Kees
> 

