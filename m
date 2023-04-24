Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1FA6ED78F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbjDXWJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDXWJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:09:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E018682
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:08:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b70ca0a84so6384046b3a.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682374108; x=1684966108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zh/fMVXEy/p80NSjVlrYa0mXRDr2h0FO6hsq5CtXg2M=;
        b=U8WDTr5sOlNki+xImOiBT+SbmEbKLNcSJOjygVaEWZeUJGOtSuCtLZFnT6TR90jW8a
         DVF7QEGW32zuyR4Nw7uVKP5H+pN9+Xv18FvnKNRBsae31njlZgMot10OOi3m2++3CTqM
         AdnixvthVDI9MRyeGYNgsF5nu4rPJKaqCb1Ph5PP7Kfeh5creb47rVyuzZOx+qvY2fZj
         N8zrbQJXWFM5IV3lG1c03Asowtpoqxm/iMXbsa0p55ciJJ4m/D0bkvZkRpTai5C5nEBt
         OOibxE3Yk7B67mpoZPvrpQyIahwcvWbv8mmvZz/bO+nBPLXpnKm8E/3OiCsEdFxGVmZR
         kz9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682374108; x=1684966108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zh/fMVXEy/p80NSjVlrYa0mXRDr2h0FO6hsq5CtXg2M=;
        b=dLy0BOCd/6Gn5G77JyODCcOVkHfGjKIi8KyyVU0bsQAzVMC5DXaCi4CRlAzKnbRz4q
         TjfXaGXmxqInJtLLpqwPJsq95F2NfqkoBtiJYQmi4kKjNNorLNhNQ2m6JMmWCfeSYYNU
         7p8Hf9f0bs/2ot1E9D2shVryZuhzyCjvvALG736ib8VfBZE/2RLt/G79pR9snofbA4l5
         L0PtJMibAK9Pv4sQ1EbdJbKM4q7dtv/qUoo++U1WmYEYTZx7bTWFJ6s8dIfn1Z3XrMRU
         mx2yBgKEMSF4sxwO/fkY6azk5t1w3n2h2wZQqIP8qYOuPrXmO/X+f706Cku0xvIwIm6z
         lO9g==
X-Gm-Message-State: AAQBX9ct/UwdEKNQuAk4a37bczgSBVknbCFH4na5YiYfqpoGqcnR9gU/
        nCHePWl/5zVjQp6xqzyZEiqyvLKp6Xcmhrr0kAtxrQ==
X-Google-Smtp-Source: AKy350ZklP4u15lRaBdhabzYgXZeviQOUp9gn18+n5jO01qWXnN9OM25FsKAXd595JCzUDVW+l74eg==
X-Received: by 2002:a05:6a00:1887:b0:63d:3a18:4a03 with SMTP id x7-20020a056a00188700b0063d3a184a03mr21008048pfh.5.1682374108518;
        Mon, 24 Apr 2023 15:08:28 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id q14-20020aa7842e000000b00640dbbd7830sm1711720pfn.18.2023.04.24.15.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 15:08:27 -0700 (PDT)
Date:   Mon, 24 Apr 2023 15:08:25 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [Bridge] [Question] Any plan to write/update the bridge doc?
Message-ID: <20230424150825.051f4b4a@hermes.local>
In-Reply-To: <20230424142800.3d519650@kernel.org>
References: <ZEZK9AkChoOF3Lys@Laptop-X1>
        <20230424142800.3d519650@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 14:28:00 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 24 Apr 2023 17:25:08 +0800 Hangbin Liu wrote:
> > Maybe someone already has asked. The only official Linux bridge document I
> > got is a very ancient wiki page[1] or the ip link man page[2][3]. As there are
> > many bridge stp/vlan/multicast paramegers. Should we add a detailed kernel
> > document about each parameter? The parameter showed in ip link page seems
> > a little brief.
> > 
> > I'd like to help do this work. But apparently neither my English nor my
> > understanding of the code is good enough. Anyway, if you want, I can help
> > write a draft version first and you (bridge maintainers) keep working on this.
> > 
> > [1] https://wiki.linuxfoundation.org/networking/bridge
> > [2] https://man7.org/linux/man-pages/man8/bridge.8.html
> > [3] https://man7.org/linux/man-pages/man8/ip-link.8.html  
> 
> Sounds like we have 2 votes for the CLI man pages but I'd like to
> register a vote for in-kernel documentation.
> 
> I work at a large company so my perspective may differ but from what 
> I see:
> 
>  - users who want to call the kernel API should not have to look at 
>    the CLI's man

Internal Kernel API's are not stable. So documentation is only the auto
generated kernel docs.

There is an effort to cover netlink API's with YAML. Bridge could/should
be part of that.

>  - man pages use archaic and arcane markup, I'd like to know how many
>    people actually know how it works and how many copy / paste / look;
>    ReST is prevalent, simple and commonly understood

Yes, but that is what distributions want.

>  - in-kernel docs are rendered on the web as soon as they hit linux-next
>  - we can make sure documentation is provided with the kernel changes,
>    in an ideal world it doesn't matter but in practice the CLI support
>    may never happen (no to mention that iproute does not hold all CLI)
> 
> Obviously if Stephen and Ido prefer to document the bridge CLI that's
> perfectly fine, it's their call :) For new sections of uAPI, however,
> I personally find in-kernel docs superior.


The in-kernel documents usually only cover the architecture and motivation.
What/why/how... Not the user visible public API's.

