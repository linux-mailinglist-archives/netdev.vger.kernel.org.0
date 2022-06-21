Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C62553256
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350543AbiFUMnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350547AbiFUMnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:43:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6115621B9
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655815388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JWyA3kDHpmSjtRPYXtckUhfY7bGtosb7ATeV51guGM8=;
        b=gQa1T8U0qEBxim6Sq8k8ERfhUvUcZogJXqagGM17wO2vSg+xvKhCbs5pR9Ne7JBB4gD4xC
        hf5vq73fO52H43hgeGMmnaXcjUO4TougPkiYWTpjn4iLwO1maZY//TGMR9jmKMrvU6x9gb
        tglhQ0prhv2a0yX6cWozAfTFdYzBW+E=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-8rdibzrOMamR3p-x3jBaNA-1; Tue, 21 Jun 2022 08:43:07 -0400
X-MC-Unique: 8rdibzrOMamR3p-x3jBaNA-1
Received: by mail-qv1-f70.google.com with SMTP id kd24-20020a056214401800b0046d7fd4a421so14191375qvb.20
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JWyA3kDHpmSjtRPYXtckUhfY7bGtosb7ATeV51guGM8=;
        b=k7uktPvRYBgup5RYr1IETXhataqrY53DVK98PODmbsobhUa9KuJe7U4yZkVe8xDAlf
         7453XO27JZFk+HsSRnXdC0AMvjCBAPhVtc++yjjW8XokgO+b/nddCZ5RtWs8XghkpgdZ
         OhZ4HzVCXN3p/aApSwbcXGrjfOtm7fMef4aWtSJ1DTNg1ECQSYFym6bX5cFzVjevpZEg
         Z1dgzWZdBVFISHFykrSVGTTiFfppmgiWYLneTQfWKZPq6GNcKPFHJg7pywj5aPHOgIdm
         WDxjycAwOECGyEwPaivUC9WkjAD88TzQhzbRDtYMK9I1TuiIc4uNtFj966miZviXakoV
         DmZQ==
X-Gm-Message-State: AJIora+nLEsEWoyvKvrR5W5ZYiFlHT7IlFxoGQJzmI9sPWQHN7iKGn25
        kHsCClWtuPwTboGi30qF/hIn+8E8OaaDWC1hBOi60aLtP2yLykjqiJNcjPk5Ll36JkJCxJeuxJl
        kd23tzBzA9GsTfEvO
X-Received: by 2002:a05:620a:2720:b0:6a7:c28:3afa with SMTP id b32-20020a05620a272000b006a70c283afamr19415713qkp.438.1655815385934;
        Tue, 21 Jun 2022 05:43:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1smuI+NYGC5EG1gB1dKUpsTviAaiAeLuQtaChCe8ccCuNUMklb/qNTMzkm96nEIaaTzUD8vhg==
X-Received: by 2002:a05:620a:2720:b0:6a7:c28:3afa with SMTP id b32-20020a05620a272000b006a70c283afamr19415700qkp.438.1655815385759;
        Tue, 21 Jun 2022 05:43:05 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id z16-20020a05620a08d000b006a5d2eb58b2sm13721269qkz.33.2022.06.21.05.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 05:43:05 -0700 (PDT)
Message-ID: <7c7b3121-4c16-f0df-4262-bba33b8e5234@redhat.com>
Date:   Tue, 21 Jun 2022 08:43:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv3 net-next 2/2] Bonding: add per-port priority for
 failover re-selection
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
 <20220621074919.2636622-3-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220621074919.2636622-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/22 03:49, Hangbin Liu wrote:
> Add per port priority support for bonding active slave re-selection during
> failover. A higher number means higher priority in selection. The primary
> slave still has the highest priority. This option also follows the
> primary_reselect rules.
> 
> This option could only be configured via netlink.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

> ---
> v3: store slave_dev in bond_opt_value directly to simplify setting
>      values for slave.
> 
> v2: using the extant bonding options management stuff instead setting
>      slave prio in bond_slave_changelink() directly.
> ---

