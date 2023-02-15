Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBEC697F98
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBOPhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBOPhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:37:47 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA7D7DAB
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 07:37:46 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id by3so18263682wrb.10
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 07:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WsKks/P7EJeRelAE0tWb28pQdbQVKjpN5y1tY4IjVC0=;
        b=d3O/EC1EtW2u+A5NhqnShnQUl3lBjD5i0yl8FM1lpaysQ0v36EwNFq2oZ3WUC6CWtO
         g1vRubH+6Ji8c7KPs8v+K39esl+NlyEteS5FJnLCBaS7geG18mIOOSlvedTDjSmzfIZg
         8kQle3DsrFFzQJEPXl8t+6+hGU994o0sxDzKxKs6D+Jnlbk0NpX1t7Jn4cVn+ld6/2OS
         I0Kkd4ngJxApG8P51SNvGlk8CCGbdgmvu9Xdu3NHjY0cjdhJW3LObDM/ByGp/ihAgrqL
         N2/7esXCMTe5srItjVAXLn73y/byjti2PcEr4m1rDBZwJrHLz1tYqtiLCGbCPB50wK8E
         DvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsKks/P7EJeRelAE0tWb28pQdbQVKjpN5y1tY4IjVC0=;
        b=jgPyqiUladmAU88qw4E38AGX2rTvK06st8T/m+CWg7S6O+RmPzc6UiSnAsOZTV0QDw
         Avw7m2LEU2Oarb7jOzvjIqFbNKdtuB4Ssp4hoENgzmBnZeKeHPGszcHsLjO/W/I2UmGA
         n5KOoYbBi7CcAELLoiLovWYhepIl6HEOeFqTz6hHixV1GsuiWAoq6jSwZgFTgyvtL6NJ
         iUI95w7kHL3pJ83xoFYFGbFv8pBhMnhbnZOI3Q6pNs/sNZXv3jCU2O6xU4VXa305bOGd
         Sqm8uwUlIknDa07cdghXQB0mpzWVASIESdC0XwI6yDbLfDTXSyRbdT53ZmiKtaQDwIRk
         X8Pw==
X-Gm-Message-State: AO0yUKULA0IELHpqgkshLX833EIGwCxgVLH5wzviUMBwO0tNxG3J8N/Z
        k+WBIS8F/Z4hRocOHNiNLFU=
X-Google-Smtp-Source: AK7set/e59O3WCeokYh+V9bxS+EUbLD79/59GSvwTRFfKtSfhMUzp8JlZ8jy/z1ZQqE1tk/EsJn+4Q==
X-Received: by 2002:a05:6000:8c:b0:2c2:6541:7afc with SMTP id m12-20020a056000008c00b002c265417afcmr1829216wrx.64.1676475465335;
        Wed, 15 Feb 2023 07:37:45 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t13-20020adfe44d000000b002c557f82e27sm8577680wrm.99.2023.02.15.07.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 07:37:44 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        willemb@google.com, fw@strlen.de
References: <20230215034355.481925-1-kuba@kernel.org>
 <20230215034355.481925-3-kuba@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <21e4b97a-430f-832d-cf49-5f938d1a8b77@gmail.com>
Date:   Wed, 15 Feb 2023 15:37:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230215034355.481925-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2023 03:43, Jakub Kicinski wrote:
> On the driver -> GRO path we can avoid thrashing the kmemcache
> by holding onto one skb_ext.

Hmm, will one be enough if we're doing GRO_NORMAL batching?
As for e.g. UDP traffic up to 8 skbs (by default) can have
 overlapping lifetimes.
