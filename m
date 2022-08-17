Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090A759736B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiHQP6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbiHQP6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:58:46 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D294E632
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:58:44 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so1148393wms.5
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=CaiylPweYbBPH7P6w3/gCI7aD7cTZpyXWFSnp6igf/k=;
        b=K2dvT9WDbHpI1pxFo5DakmPHTN08tsCSpF2b9eUehKG+lSFbx1q8rlctf0FxXKeWRt
         i+IeOhp6xUMlouClhHEwdyxAPYwe2zccDehBRy+hVWEUNW9avaFr/ojn405NmXVRP3h+
         38m2yWw97S8sd9ZBtJ2sJI/3gWG9NXG305wKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=CaiylPweYbBPH7P6w3/gCI7aD7cTZpyXWFSnp6igf/k=;
        b=BJRuoUDXV1mXPbrO6YuvfBPmy438zkcx2/SOD+Ir1tF5kKsEFTHhKz7c9WxR/m+Slw
         MNQk6gr38N/ByXj0NVHlSZ95KabiFP5S0K6+15G1r45v8p7S2BPgrD9j76fa53nvaKeb
         76UbLswQFbO3COaOLs1GmZFX+PiJNYJcTHT7KGeqSoRXNTxSGBFvPQVvUF6HXkZOjE8l
         KnyWsYTd7e5HywbAUGeEHt+Fa/5DXy28u49wSXpbnEthJ12OsisOVvyArFB1lfEhRyn8
         /jVmgHPnWfmU8xrviDTuj3Fs48myNNgRmuAIXUiepyNKBaYeNV0o8ff4kqhkHnqnI+cU
         OGIQ==
X-Gm-Message-State: ACgBeo1TfGJeQ4UECScBeBy7B3GZnbmFK7wb43JZaK2VR6hZzc5c27YV
        v3G8Sea0WaKpLmftnpaaFEIxmw==
X-Google-Smtp-Source: AA6agR6VyCJ8rAIqi2Zrdaz/VI+wSU4kt7bqa22rfkN6arNCOBuNJgt0pM+6zrifeXYy+XNpacoX+g==
X-Received: by 2002:a05:600c:348d:b0:3a6:b4e:ff6d with SMTP id a13-20020a05600c348d00b003a60b4eff6dmr2452648wmq.95.1660751922696;
        Wed, 17 Aug 2022 08:58:42 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id z6-20020a5d6546000000b0021eed2414c9sm1925744wrv.40.2022.08.17.08.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 08:58:42 -0700 (PDT)
References: <20220815130107.149345-1-jakub@cloudflare.com>
 <20220816184150.78d6e3e3@kernel.org> <87edxfvsxs.fsf@cloudflare.com>
 <20220817085118.0c45c690@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Tom Parkin <tparkin@katalix.com>
Subject: Re: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock
 lock
Date:   Wed, 17 Aug 2022 17:56:32 +0200
In-reply-to: <20220817085118.0c45c690@kernel.org>
Message-ID: <87a682x3ny.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 08:51 AM -07, Jakub Kicinski wrote:
> On Wed, 17 Aug 2022 16:33:33 +0200 Jakub Sitnicki wrote:
>> > Note to other netdev maintainers that based on the discussion about 
>> > the reuseport locking it's unclear whether we shouldn't also take 
>> > the callback lock...  
>> 
>> You're right. reuseport_array, psock, and kcm protect sk_user_data with
>> the callback lock, not the sock lock. Need to fix it.
>
> Where 'it' == current patch? Would you mind adding to the kdoc on
> sk_user_data that it's protected by the callback lock while at it?

Yes, will prepare a v3 for review. Sorry, should have been explicit.

Will add a kdoc. Great idea.
