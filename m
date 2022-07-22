Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08EF57E8C4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiGVVPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiGVVPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:15:38 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA156E8A8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 14:15:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id tk8so10572425ejc.7
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 14:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p4Vz7AmnjbsaKbRW72Az5ucqmlVaPJKQh86pIk5uWgs=;
        b=jCuvi4IH5EK0r4UiBDev9nicch54P6zTJaw65cpPNWnQtHcxnbDb/IBaHGT+FhqM/P
         VFyqqZr5w8iuJ4FKODmzfugwvZsR+cyjW9WLVMR2ttCmQ8DGltwK7xkjmJft7Nzxjk16
         QEazPgnWQZzTYJIaMSVBSW70DBGlSIwcmZHi2uHrnqlVWcvZT/Dt5nCJARgeATOdH0Nr
         jrjFknZBOLLKjUxoEZpkEOpmTlVn0ieMYXnsn8ykPYxCNSSh7C8tAbr3MMu9mnUiP0ch
         HGyK1xEDt9bdcSu4mew+EWgrGaByLvniYNUnRJVNKy+Y/W7apjjIlajWES060qdZ9hIP
         DuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p4Vz7AmnjbsaKbRW72Az5ucqmlVaPJKQh86pIk5uWgs=;
        b=aziMMSYGKVC5GKHApQA6LRSxRjNLKCOK+Yq1syhaTRqid72fMt7LLv6xZTkk386vXF
         x9229MMsR4IcZSKHOiLyZO1QcAeR0tvG3RAUxYJfsXOUtU9t1hLlOg/xM4rjWH1MifJD
         KWJ8ErsyuD1EC5qmUQSyEaLrporphhb4y6h9xsq1r8SyFNXnTLY2Ojw4MUb7pevRdEnQ
         UwJCOWd8aUMDJqSZHSvrJwP4knwJG9kjI29HceNlyVUgxdFDPyuoi2DBKBb0xWvWSCFz
         I9NzoSNDvAbWYw+LnUV+jhihwuB7nVCakoRpLUNMUvMfGZHSF33DzSx22h3cumhK7XKl
         wcdQ==
X-Gm-Message-State: AJIora/CeaDrk9Kp0WWn9uDSLBItEgy2wpjejHSqyxAVDx6VlRQBBUrR
        LS4nbMEOdP/bHmnJQXnmvr0=
X-Google-Smtp-Source: AGRyM1tq9REhFqwEitJalM5ywiqQ+F52+M/nJxiyf0hTln3NkG0UUTcXSFA/pL38HqZ5Q8aSggKOPw==
X-Received: by 2002:a17:907:2c61:b0:72b:3a12:5121 with SMTP id ib1-20020a1709072c6100b0072b3a125121mr1372599ejc.52.1658524532690;
        Fri, 22 Jul 2022 14:15:32 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906538400b0072ae174cdd4sm2414526ejo.111.2022.07.22.14.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 14:15:32 -0700 (PDT)
Date:   Sat, 23 Jul 2022 00:15:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 net-next 08/19] ipmr: do not acquire mrt_lock while
 calling ip_mr_forward()
Message-ID: <20220722211530.ywhc6pao4s6rx2ad@skbuf>
References: <20220623043449.1217288-1-edumazet@google.com>
 <20220623043449.1217288-9-edumazet@google.com>
 <20220722193432.zdcnnxyigq2yozok@skbuf>
 <CANn89iK+UO=FevJxnHN0ua17jwR__MfB_RZ_DavLdJz79eyCBw@mail.gmail.com>
 <20220722211005.p2pfvy4qwdvolxi3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722211005.p2pfvy4qwdvolxi3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 12:10:05AM +0300, Vladimir Oltean wrote:
> I just noticed that we appear to have the same problem with the
> equivalent call path for ipv6: ip6mr_mfc_add -> ip6mr_cache_resolve ->
> ip6_mr_forward, although I don't have smcroute or the kernel configured
> for any IPv6 multicast routes right now, so I can't say for sure.

Not to mention ip6_mr_forward() has a random rcu_read_unlock() thrown in
there, with no paired lock(), left from who knows what refactoring...
I don't think I'll be able to report all the locking problems with the
IP multicast routing code, maybe someone with more familiarity should
take a look there :-/
