Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD05AE88A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbiIFMiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiIFMiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:38:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C537E27FF6
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662467880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NwavP4bpJ5RCOsyXBh4N8THSIxStyZegdjcyZhUquBU=;
        b=eykW6yBjuJDaQaDz4ly/TKiFBY7y5+IphExgAU8GxovoQ5fg25hk6lmXIV31BL66PWqA4s
        xLu+eHz9pVzDnT3lxsONgmLoG4BjuRDO69UU9FtvZElpHM9HMMEv70zzZTu42RIwuuEYaf
        QcUQF1aOnJGPJtn1wBRa2bhxUe/ZPkw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-xyxTHjOaPfqDg-3_GN9Jlw-1; Tue, 06 Sep 2022 08:37:56 -0400
X-MC-Unique: xyxTHjOaPfqDg-3_GN9Jlw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EF72101A54E;
        Tue,  6 Sep 2022 12:37:55 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 968181121314;
        Tue,  6 Sep 2022 12:37:49 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Nick Desaulniers <ndesaulniers@google.com>, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
References: <20220816032846.2579217-1-imagedong@tencent.com>
        <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
        <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com>
        <20220818165838.GM25951@gate.crashing.org>
        <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com>
        <20220819152157.GO25951@gate.crashing.org>
        <CADxym3Y-=6pRP=CunxRomfwXf58k0LyLm510WGtzsBnzjqdD4g@mail.gmail.com>
        <871qt86711.fsf@oldenburg.str.redhat.com>
        <CADxym3Z7WpPbX7VSZqVd+nVnbaO6HvxV7ak58TXBCqBqodU+Jg@mail.gmail.com>
Date:   Tue, 06 Sep 2022 14:37:47 +0200
In-Reply-To: <CADxym3Z7WpPbX7VSZqVd+nVnbaO6HvxV7ak58TXBCqBqodU+Jg@mail.gmail.com>
        (Menglong Dong's message of "Wed, 24 Aug 2022 00:23:02 +0800")
Message-ID: <87edwo65lw.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Menglong Dong:

> Hello,
>
> On Mon, Aug 22, 2022 at 4:01 PM Florian Weimer <fweimer@redhat.com> wrote:
>>
>> * Menglong Dong:
>>
>> > /*
>> >  * Used by functions that use '__builtin_return_address'. These function
>> >  * don't want to be splited or made inline, which can make
>> >  * the '__builtin_return_address' got unexpected address.
>> >  */
>> > #define __fix_address noinline __noclone
>>
>> You need something on the function *declaration* as well, to inhibit
>> sibcalls.
>>
>
> I did some research on the 'sibcalls' you mentioned above. Feel like
> It's a little similar to 'inline', and makes the callee use the same stack
> frame with the caller, which obviously will influence the result of
> '__builtin_return_address'.
>
> Hmm......but I'm not able to find any attribute to disable this optimization.
> Do you have any ideas?

Unless something changed quite recently, GCC does not allow disabling
the optimization with a simple attribute (which would have to apply to
function pointers as well, not functions).  asm ("") barriers that move
out a call out of the tail position are supposed to prevent the
optimization.

Thanks,
Florian

