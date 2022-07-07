Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E28569C7D
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiGGIEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiGGIEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:04:37 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCAF25C5
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:04:35 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so12965956wmp.3
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 01:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tzmqTyKeHDALVK+yAQp68XxMSEoXmsZfsJiQwxJCiZY=;
        b=6uS59JjvqaEbJHJqzW0WFOVe+egtI/InStP96LLjHF/d1M7H1K1kJ7quCEcE58i2K6
         5UNtcHOQ4KzCY6SnHovKbY/Dd3DUZqiGEMyF4a1rKeJ0gTAqYsgTT4sFOtWVhsBSzl5V
         lgynUJEjU8UMTfqEHWldIrKncAWZQ4RmFu0cjq2OK1gj8fFnWv3ua9S7fjCaoNVU6DNV
         VfuOBKuvFyPSO+jQxKlm5pOFiGJ0byzcWQiB60LQ1tZTfquxslqzHhsQeQ5PUZoJPJvG
         239xxLuWie6x1ntT7ydigyHm8mrTcG8hIn4wmCSRKiO7Sgu/6PjQnYVAoPtsy002HxfG
         EDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tzmqTyKeHDALVK+yAQp68XxMSEoXmsZfsJiQwxJCiZY=;
        b=Wr9uZpSSpRi2FDqHx3bx9Tes1uBQa1LbOQqu5FqwcTRbtj5D5LnXv614TQhHCKT+Rw
         NPAx3xrlBUqtAghMTXdXa15MZrUtteO8yxUukHllKsNDEhz1MFj0lC+4UVsuoo4qjxDX
         wgvHAxRU+IV98dzJejAG3HO1O14fbV+VJONVvFXNrFOhfXArFdLQDGq0bb4jdb6UwjMW
         LXa7hfCuZkKlH9Saz18C38uIcSPZjE57oGs7y3mWNXSKXnIyogylO6w9eaSGuMS60vnb
         Hp2Dvu9akreqIcRHG8WFtOu6qqwSlXeTmldTwm2qnOdh3YKD/MqRN18YiDQMystf+jRL
         y7RQ==
X-Gm-Message-State: AJIora8nPw45JyXquhdR77kOdbYJ+N646++YCXco2/FgQzXpd+91ygJ7
        NEtDbGhgyDNt7LQI67Ffsr3n4A==
X-Google-Smtp-Source: AGRyM1vMCoiuBS8WD9hcEtKrK71vkUDjyoKcwGfZXDUHL/KeUwu02CYSOR0Yyoa4KrgiavXyIJMaHQ==
X-Received: by 2002:a05:600c:8a9:b0:3a0:3d78:21a4 with SMTP id l41-20020a05600c08a900b003a03d7821a4mr2905204wmp.112.1657181073681;
        Thu, 07 Jul 2022 01:04:33 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t5-20020a1c4605000000b0039db31f6372sm24836623wma.2.2022.07.07.01.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 01:04:33 -0700 (PDT)
Date:   Thu, 7 Jul 2022 10:04:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <YsaTkAV9uavlvPBH@nanopsycho>
References: <20220701095926.1191660-1-jiri@resnulli.us>
 <20220701095926.1191660-3-jiri@resnulli.us>
 <20220701093316.410157f3@kernel.org>
 <YsBrDhZuV4j3uCk3@nanopsycho>
 <20220702122946.7bfc387a@kernel.org>
 <YsKGZZ8ZggAf+jGT@nanopsycho>
 <20220704195839.34128dd3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704195839.34128dd3@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 05, 2022 at 04:58:39AM CEST, kuba@kernel.org wrote:
>On Mon, 4 Jul 2022 08:19:17 +0200 Jiri Pirko wrote:
>> Jakub, I don't really care. If you say we should do it differently, I
>> will do it differently. I just want the use to be consistent. From the
>> earlier reactions of DaveM on such helpers, I got an impression we don't
>> want them if possible. If this is no longer true, I'm fine with it. Just
>> tell me what I should do.
>
>As I said - my understanding is that we want to discourage (driver)
>authors from wrapping locks in lock/unlock helpers. Which was very
>fashionable at some point (IDK why, but it seem to have mostly gone
>away?).
>
>If the helper already exists I think consistency wins and we should use
>it.

Okay, will send a patch to convert devlink.c to use these helpers.
Thanks!
