Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6B6D3F57
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjDCIpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjDCIpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:45:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629897DBA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 01:45:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id ek18so114195578edb.6
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 01:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680511507;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=gls3PzAYkrjqLecU7D6fK2kYJv7shqoopRvlQDPgL3E=;
        b=pHtBhCqR6ULW6wB+dbwdre+EP14JapbRBJyoy1SWol6oyWNlm3jpd3Tm3AoVi/z4gl
         K5q6vI0TWGBqadYNSuQ3pkwxGBjRdyOqn4vF/VPHjhLA5leUdiqA9NuttL8Nv8h3aFu2
         /mU/UeqgO8sPecCkL/BGXxXNcI5xJOek54JQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680511507;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gls3PzAYkrjqLecU7D6fK2kYJv7shqoopRvlQDPgL3E=;
        b=em6BYmwI0x58Lozg4ut5Wz9Rr2NPJCWCpqsnz53Dex7SQJ5aTmpdNbykaAUuKkwy0I
         8qzB/HEI46DKMrw4+T4LmcRJxAJj0MVKZmAmNhzYLefGXZrX5NUPepmECAFKOFK0GHAO
         lsAJlUtDJepVWvvdqekorU1JTgALybx83mBbME+43UrI3FxZ6WIfAT4BX87hYvfnJxkA
         Zmwqzq09LpKhaNommo183sx0GC+IemmQ5EEDhcKts9Zk6nG+orEPTkJuIN4c3eqrxpBL
         C0WC7CFN/TbKXVwAcd5E1D0hfQiQWbys13mH2cJ6ls1CcTfSK179B3eNQstQZk69IgxT
         9wPg==
X-Gm-Message-State: AAQBX9eJziMI4mKr0RXpKxfOyqUeTGZmRnjO7jIxrsrnxy+0iTpvZtDj
        WY5N35JxjrkGcaW9SLB+YUAzNQ==
X-Google-Smtp-Source: AKy350bFHkDO2VkvPa70FYS4i3I6JoMsXr3EW5Bxu9gfdRI2FSKC3rLrjdGd+X0wCXTUIPnfIEjQUw==
X-Received: by 2002:aa7:d74b:0:b0:4fb:5607:6a24 with SMTP id a11-20020aa7d74b000000b004fb56076a24mr33712857eds.8.1680511506914;
        Mon, 03 Apr 2023 01:45:06 -0700 (PDT)
Received: from cloudflare.com (79.184.147.137.ipv4.supernova.orange.pl. [79.184.147.137])
        by smtp.gmail.com with ESMTPSA id z21-20020a056402275500b00501d73cfc86sm4223679edd.9.2023.04.03.01.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 01:45:06 -0700 (PDT)
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-4-john.fastabend@gmail.com>
 <87zg7vbu60.fsf@cloudflare.com> <642782044cf76_c503a208d5@john.notmuch>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v2 03/12] bpf: sockmap, improved check for empty queue
Date:   Mon, 03 Apr 2023 10:42:32 +0200
In-reply-to: <642782044cf76_c503a208d5@john.notmuch>
Message-ID: <87edp1e4mm.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 05:59 PM -07, John Fastabend wrote:
> Jakub Sitnicki wrote:

[...]

>> It's just an idea and I don't want to block a tested fix that LGTM so
>> consider this:
>
> Did you get a chance to try this? Otherwise I can also give the idea
> a try next week.

No. By all means, feel free. You caught me at a busy time. That's also
why the review has been going so slow.
