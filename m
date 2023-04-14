Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F7F6E2B0C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 22:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDNUUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 16:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjDNUUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 16:20:18 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AFB6A58
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:20:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-2f55ffdbaedso20466f8f.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 13:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681503615; x=1684095615;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvvNd+wHwGCcErTUPWuIL9UU1CBqAifvHTmE8loWibw=;
        b=rjmMr3nizgQGh7ILRC7D7SLrt0PwIWEA7b9nXpwgR+8OU5n+LYvMpNSdVeduebcaHC
         sGHY3vNHBhYpHMmQxY1LZVWwuSBgSqGGZKyLIgFFU38UB9H2YVyrVSyd3bFbE8kUQUtm
         jxn8t8OSOd2ZRE4P60ZPPhYj6FmzuofKbjEVoehKjbBwk9x61BQBcwYmymolQbZorWAj
         P/xuZvH2oOuYRUPvdAg4V+l4rsMXO8GhUgTTCXSzq2zd2gQiSTSQfzy6wQEoEdJsKBJZ
         sF5zje3eEAsxG9I1ToJtXOTGlyiQtwNhEyJ4Iw/j1w/oBazYc/H/HKBYqNdZFicqvXWo
         iYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681503615; x=1684095615;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvvNd+wHwGCcErTUPWuIL9UU1CBqAifvHTmE8loWibw=;
        b=BTBvRrLQccJSQseOXW4MCf7wocXly42/0DmLjS66PMzphV2LR6TD7bzFQuyTZBKFUr
         RSs4PYvhBVcTBEd0K35tBdLnHtu5Rv4jHoV0Fkmd/gMWCkdREJrcRnAeMc0MbMaxVIte
         IoruW6oxXLTI9vBP8tyQdTnJWQ9SYbscDceQdbH1PT3mX54aVr5br5x4Od8jCFHAUpOR
         ExqxiYXjw0S1OxqgKhZR7kK04o5t9ZX/AhXRBHc0qS0p34gUuWF/FyKSHhdZpHTgGnUU
         GofQVbyj3aAgTDLzGzp3ZDZoj/VNqWc4DqFAJkUAuqklH+EYgKh/AJSm8rr2rB9tHbFf
         jeIg==
X-Gm-Message-State: AAQBX9fAEGO2JNUB+KQjRaTFnvC0XGH/nTvOvdFY4yZAJUTiNF6EICBw
        p3eImsa+KgKK6LO+WWz2TRo=
X-Google-Smtp-Source: AKy350ZsgQKwhoMxkGxaeRs9SeTNCxeUmY5Z2wUv/I7A7x7ub4kJYuBn5spYDcEsTUMgtipo3Hlrmw==
X-Received: by 2002:adf:fecd:0:b0:2ee:da1c:381a with SMTP id q13-20020adffecd000000b002eeda1c381amr54690wrs.69.1681503615336;
        Fri, 14 Apr 2023 13:20:15 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id z13-20020adfd0cd000000b002ce9f0e4a8fsm4241863wrh.84.2023.04.14.13.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 13:20:15 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting
 RSS contexts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
 <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
 <69612358-2003-677a-80a2-5971dc026646@gmail.com>
 <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
 <3623a7f3-6f90-8570-5b9a-10ff56cc04e5@gmail.com>
 <20230412190650.70baee3e@kernel.org>
 <485ebfeb-61d7-7636-80af-50b6a008b6dc@gmail.com>
 <a628b861-47a9-44d2-a717-5268dc5b47f6@lunn.ch>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2122a8d2-9348-53ca-22f0-18f62109f1bb@gmail.com>
Date:   Fri, 14 Apr 2023 21:20:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a628b861-47a9-44d2-a717-5268dc5b47f6@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2023 22:58, Andrew Lunn wrote:
>> (Idk, maybe sfc is just uniquely complex and messy.  It wouldn't be
>>  the first time.)
> 
> Hi Ed
> 
> Have you looked at other drivers? It would be bad to design an API
> around a messy driver.

I have; there's really not many that implement custom RSS contexts
 (just Marvell's mvpp2 and octeontx2, and Mellanox's mlx5).  The
 `rss_ctx_max_id` field is designed for those as they all have fixed-
 size arrays currently and idk whether that's a purely software limit
 or whether it reflects the hardware.
I couldn't find anything in any of them that looked like "restore
 stuff after a device reboot"; maybe it's just not something those
 devices expect to experience normally.

I don't know enough about mlx5 hw to really understand their filter
 code, but the rough equivalent of our efx_mcdi_filter_insert_locked()
 in that driver appears to be _mlx5_add_flow_rules(), which seems to
 be doing some kind of hand-over-hand locking.  And no sign (whether
 in comments or in asserts) of whether the function expects callers to
 hold RTNL.  Same goes for their functions operating on TIRs (whatever
 those are) which are called from all over (aRFS, tc, even kTLS!) in
 addition to the ethtool RSS/ntuple paths.

Anyway I'll cc maintainers of those drivers on v3 so they can chime
 in on the API design.  (Should've done that on v1 really, but I
 forgot.  Mea culpa.)

-ed
