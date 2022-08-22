Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408CB59BAC8
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiHVICO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiHVICA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:02:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6018A2B19F
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661155318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fy/d/XAb6vTN4trgjkzV7eMaGE/wqYSvDDnSrzB5bmU=;
        b=YGWt3q6YkPiVMsXOEqGJGtvwO19XKI4qhNgmrP57i76ujq3lknkw0v1DvSJqvr7XKmWKWJ
        brv5H2q2NekC9QDPLyDM4Joh6iOQtis1FDhSwTVosJKeQEGjNg217TfuhHlp/47BEqqWDM
        zNg3xO1Sy0Y8/GG/R3iyxPcK/3x0WoM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-Kl5qBtN1OLq5FGkeuJ_I-A-1; Mon, 22 Aug 2022 04:01:55 -0400
X-MC-Unique: Kl5qBtN1OLq5FGkeuJ_I-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE4D685A585;
        Mon, 22 Aug 2022 08:01:53 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.199])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62394141511A;
        Mon, 22 Aug 2022 08:01:48 +0000 (UTC)
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
Date:   Mon, 22 Aug 2022 10:01:46 +0200
In-Reply-To: <CADxym3Y-=6pRP=CunxRomfwXf58k0LyLm510WGtzsBnzjqdD4g@mail.gmail.com>
        (Menglong Dong's message of "Sat, 20 Aug 2022 19:00:41 +0800")
Message-ID: <871qt86711.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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

> /*
>  * Used by functions that use '__builtin_return_address'. These function
>  * don't want to be splited or made inline, which can make
>  * the '__builtin_return_address' got unexpected address.
>  */
> #define __fix_address noinline __noclone

You need something on the function *declaration* as well, to inhibit
sibcalls.

Thanks,
Florian

