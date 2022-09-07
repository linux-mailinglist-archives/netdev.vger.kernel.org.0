Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CA45B0CCB
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiIGS7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiIGS7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:59:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC00513F16
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662577179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ixVu03txVJzmfV2UPML9i8C++ZJ1T0md3aHETXx0ojs=;
        b=CN05hjC/qLwSyq/90ewM7eqHWGo3ae9pqkXutnPz5VMuO1jEvmBSlfkrHGg5uF5JAS9ryY
        kN5WWQui5Uk4nuHa+6krWN4sr4cSi1HKNyHbxtumnSO2S2JdB6EpMk3y9KOSnQwe8TyjtL
        dVNHs5FtCW9pX2ngcjZqZtt7YEq1ioY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632--eRPXiNMNTmzIghSLtL2zQ-1; Wed, 07 Sep 2022 14:59:34 -0400
X-MC-Unique: -eRPXiNMNTmzIghSLtL2zQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 034903C1104B;
        Wed,  7 Sep 2022 18:59:33 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.194.61])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 023D840CF916;
        Wed,  7 Sep 2022 18:59:28 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
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
        <87edwo65lw.fsf@oldenburg.str.redhat.com>
        <20220906153046.GD25951@gate.crashing.org>
Date:   Wed, 07 Sep 2022 20:59:26 +0200
In-Reply-To: <20220906153046.GD25951@gate.crashing.org> (Segher Boessenkool's
        message of "Tue, 6 Sep 2022 10:30:47 -0500")
Message-ID: <87zgfbnh81.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Segher Boessenkool:

> On Tue, Sep 06, 2022 at 02:37:47PM +0200, Florian Weimer wrote:
>> > On Mon, Aug 22, 2022 at 4:01 PM Florian Weimer <fweimer@redhat.com> wrote:
>> > I did some research on the 'sibcalls' you mentioned above. Feel like
>> > It's a little similar to 'inline', and makes the callee use the same stack
>> > frame with the caller, which obviously will influence the result of
>> > '__builtin_return_address'.
>
> Sibling calls are essentially calls that can be replaced by jumps (aka
> "tail call"), without needing a separate entry point to the callee.
>
> Different targets can have a slightly different implementation and
> definition of what exactly is a sibling call, but that's the gist.
>
>> > Hmm......but I'm not able to find any attribute to disable this optimization.
>> > Do you have any ideas?
>> 
>> Unless something changed quite recently, GCC does not allow disabling
>> the optimization with a simple attribute (which would have to apply to
>> function pointers as well, not functions).
>
> It isn't specified what a sibling call exactly *is*, certainly not on C
> level (only in the generated machine code), and the details differs per
> target.

Sure, but GCC already disables this optimization in a generic fashion
for noreturn calls.  It should be possible to do the same based another
function attribute.

Thanks,
Florian

