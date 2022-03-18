Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58174DE381
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiCRV2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241202AbiCRV2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:28:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B20012E741;
        Fri, 18 Mar 2022 14:26:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8so8375241pjb.4;
        Fri, 18 Mar 2022 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ngACJmeVV9pPVZzYzpTofY7PpGPGJ4tyVyA//CfbKMw=;
        b=I5DKGYi5JVESFPGE8929b6D4feB7CmGqV1QTUVY144tOMh4r8VrXHqZYItH1JtzF6+
         xWiu7ZgTBvNe0py4k0xnQPYWVt08Ps//7Uk7cGi5dmxN4vlrRAfaAZpeHGx+9HPDG2bf
         ZX+dZS8JGMK4CpcUosDYfgb8UdEC9ZBcT00t90sGBjfG+5fw4yOjmP8lZKXjhOBjoTE4
         zjsMNE3l5CkEIZDOJ+JM/NyhH5T7T+YgeSdP1JGi+7uL11u3YtdaUq/LP9gwgOs/pNMN
         gXx497yV8ujjTMkJI7iHQYkTtIBnPzR00RZUmH4DbxVvsQ1cek1HqBVJ/mfgv52w1FlP
         1hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ngACJmeVV9pPVZzYzpTofY7PpGPGJ4tyVyA//CfbKMw=;
        b=UAWiIZpvtcbHHhGvvU5gy+Yca7Jmc9q2oWc0xlPSQvQKC8uY1AVjuVSMM88FJO35C0
         VZ3ZjNz6IaypNDjfWKipAlu3vsgO7lRe9lBJJksHDjHZ6SXC2amxgvrfS309gmHsh02L
         uGoRXD4CmnKTksawLqa2sc64PTEJYUezAR9gFUXLK/n7AvhME8Fiey0E39uchEuEs0Uu
         l0TZabcpjWPj/ainb+WddWD0kpqUeQYfh9z7k5e7FiurcEQXUjOC+rhn/SI6jW6V3CjA
         ADe+icdOHpTY378LAN883HxR5YaYFcMU8lOzc5fMmWfrmjXzno9HaGiTpRpMsP9vGoVr
         x2uw==
X-Gm-Message-State: AOAM533cNq6fUINvPoxScFzlZ9+TKiCCr79quwfb5MdJCtqw6aWwBbz5
        uNNnaxeSbNA3HnZhbcGiyKsElire0qg=
X-Google-Smtp-Source: ABdhPJy+etAMlosAPHBEubVULFhPikXO3lrAyit0p0AdzhMJ1owsnFVy8PWq4CVWA2INxOFRIJ43pA==
X-Received: by 2002:a17:90b:4b8a:b0:1c6:35d1:4418 with SMTP id lr10-20020a17090b4b8a00b001c635d14418mr23227227pjb.176.1647638805484;
        Fri, 18 Mar 2022 14:26:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o3-20020a639203000000b003810e49ff4fsm8884375pgd.1.2022.03.18.14.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 14:26:44 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: Use stronger register read/writes to
 assure ordering
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
References: <20220310045358.224350-1-jeremy.linton@arm.com>
 <f831a4c6-58c9-20bd-94e8-e221369609e8@gmail.com>
 <de28c0ec-56a7-bfff-0c41-72aeef097ee3@arm.com>
 <2167202d-327c-f87d-bded-702b39ae49e1@gmail.com>
 <CALeDE9MerhZWwJrkg+2OEaQ=_9C6PHYv7kQ_XEQ6Kp7aV2R31A@mail.gmail.com>
 <472540d2-3a61-beca-70df-d5f152e1cfd1@gmail.com>
 <20220318122017.24341eb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <082a7743-2eb8-c067-e41d-2a3acca5c056@gmail.com>
Date:   Fri, 18 Mar 2022 14:26:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220318122017.24341eb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 12:20 PM, Jakub Kicinski wrote:
> On Fri, 18 Mar 2022 12:01:20 -0700 Florian Fainelli wrote:
>> Given the time crunch we should go with Jeremy's patch that uses
>> stronger I/O access method and then we will work with Jeremy offline to
>> make sure that our version of GCC12 is exactly the same as his, as well
>> as the compiler options (like -mtune/-march) to reproduce this.
>>
>> If we believe this is only a problem with GCC12 and 5.17 in Fedora, then
>> I would be inclined to remove the Fixes tag such that when we come up
>> with a more localized solution we do not have to revert "net: bcmgenet:
>> Use stronger register read/writes to assure ordering" from stable
>> branches. This would be mostly a courtesy to our future selves, but an
>> argument could be made that this probably has always existed, and that
>> different compilers could behave more or less like GCC12.
> 
> Are you expecting this patch to make 5.17? If Linus cuts final this
> weekend, as he most likely will, unless we do something special the
> patch in question will end up getting merged during the merge window.
> Without the Fixes tag you'll need to manually instruct Greg to pull 
> it in. Is that the plan?

Maybe I should have refrained from making that comment after all :)
Having the Fixes: tag dramatically helps with getting this patch applied
all the way to the relevant stable trees and surely correctness over
speed should prevail. If we want to restore the performance loss (with
the onus on Doug and I to prove that there is a performance drop), then
we could send a fix with the appropriate localized barrier followed by a
revert of Jeremy's patch. And if we cared about getting those two
patches applied to stable, we would tag them with the appropriate Fixes tag.

It looks like there are a few 'net' changes that showed up, are you
going to send a pull request to Linus before 5.17 final is cut?
-- 
Florian
