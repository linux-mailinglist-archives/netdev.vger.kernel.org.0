Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B47F6B6D1B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 02:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCMBhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 21:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCMBhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 21:37:42 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDB925287
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 18:37:41 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id y3so7366739qvn.4
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 18:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678671460;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/umDBoRvKkCeCaOFDPpbyvWBfWNplwxe84pc3eu4BY=;
        b=dxY22y0PBMozS+rrOt8RiVX3V8apiHOxpgapqBdraF3/i2oqDPFjCODhUIXpwOQm3u
         Pq6FDbIv0H97JreH9TKxK14cKiiEK6t9OHoTs04CjjZTc42hDG3ZTcplzshRdGYBao6f
         oqAJenMLbWaFNZ+mT9+q7HLXCqgg2PH3DgEXL9yvk4PXSCXQ8H/7wJTQltemWf8tdFM9
         1604QofWfYbEUgJcDXlpg+1Bxqr+UNkqRsBQo4Mtrq1KXdnkPqyXm9xyH2bgh0aRvPzD
         vCj+6vIuU0bdMDyFDyh6W6e/8lwS+wWWVf3+u16XIhOUq0DK1z3ehX5YSsR0mychSEPT
         UTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678671460;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q/umDBoRvKkCeCaOFDPpbyvWBfWNplwxe84pc3eu4BY=;
        b=3lVnEapTMMRI01m7MXNX4N0RkXz5U+qWiEUufcS3A8tB3JrhcmG9PTc/aItBzKKXwQ
         CWJMqaGQE6LCT56wZ9v73tFSnXuIURYMt5gxYIv5r5Mb/49h1akwRSjURFB4oLMkqzYT
         qtH+gyfXTQdaml1E11hFIKAM1b7OEU6B8Yinzr/OCwdN4cm4KBS4e6XNA8DBmOoqV1Ys
         G/WqTNvrZlU21xiHFPDT1Es3B2HH1CswvXxBRW8RFSKNQEnuGBQ4XTI//Us9ueYEAWYe
         5VhcQs+fr6AUiu+JC4aFf37tXQdmT8dwG1NjwHaJqmTN3tqFIVLxjhTdGp7Y+QA4GIGr
         jADA==
X-Gm-Message-State: AO0yUKV/VUa0RP9Y6irVQDmCWYDubG/56dFYBplvakJsiE3Ny8TJz61a
        hpeUfyFsw/xvHUWxzumnhRU=
X-Google-Smtp-Source: AK7set8eigJi//B+fSmk88PYuzXiCrxFTn2p8/17Lu0nCIq9TfP9HQPOam9SPSgVn760D7MZPPgbSQ==
X-Received: by 2002:a05:6214:21ee:b0:56e:93b6:27fc with SMTP id p14-20020a05621421ee00b0056e93b627fcmr9830749qvj.17.1678671459982;
        Sun, 12 Mar 2023 18:37:39 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id t21-20020a37ea15000000b0070648cf78bdsm4354237qkj.54.2023.03.12.18.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 18:37:39 -0700 (PDT)
Date:   Sun, 12 Mar 2023 21:37:39 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com, roman.gushchin@linux.dev
Message-ID: <640e7e633acec_24c5ed2088c@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230311082826.3d2050c9@hermes.local>
References: <20230311050130.115138-1-kuba@kernel.org>
 <20230311082826.3d2050c9@hermes.local>
Subject: Re: [RFC net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger wrote:
> On Fri, 10 Mar 2023 21:01:28 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > A lot of drivers follow the same scheme to stop / start queues
> > without introducing locks between xmit and NAPI tx completions.
> > I'm guessing they all copy'n'paste each other's code.
> > 
> > Smaller drivers shy away from the scheme and introduce a lock
> > which may cause deadlocks in netpoll.
> > 
> > Provide macros which encapsulate the necessary logic.
> 
> Could any of these be inline functions instead for type safety?

I suppose not because of the condition that is evaluated.

Btw: perdicate -> predicate
