Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0375522791
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiEJX1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiEJX1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:27:09 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECE4340F9;
        Tue, 10 May 2022 16:27:08 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id p4so539978qtq.12;
        Tue, 10 May 2022 16:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RxqE5ZJWuzRnOKii1KyY4gqmrmpnlt//j5R303qeipM=;
        b=KH33irEqLvUWALSUZFHF9bWSTnxx+Mrv458SV9MPHb64vxmRcUYD6tlPk4cHEO85Is
         3XyrWcEEG1IHlF3hszvonfGXocIOokZXJ/uaMKrJaJC2jXNtAq2LdEOjDNpu4vnkqF8x
         Bu+dMRCij/GS6GaOgrp6kOUdCN6C4Ia7Fxdnx1rQ4MrOdoVs3vtfxd8BR+YNW3pMxkfj
         UJiOlXeH6j+HC24getmLeJ0x8gcXce40unAAdwjzFI6u5sQIHxj+AyclnhZKRkY7+GVx
         ymOg/wR82FkDdzfWaEHrm2ns51X92tCD+zSprB4swzOAbO7YCDBZRtObaaHDuW1x4a6m
         G2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RxqE5ZJWuzRnOKii1KyY4gqmrmpnlt//j5R303qeipM=;
        b=UZP+KExPg4Pi+uSUhLiO+tPzKYD0Nqn0YYvOpv4XY8plNwCc7WWJP2P22qoQUfH8+y
         fVpRyBRU5O9l50wxF3RQCfdioOtoHuCShm2d+If8GH47gz4rYndSPJd9SF2k0hGgHkjW
         ERJnbEaISLL29DsaR3brD996MBRvbeVn8jx/qHgYyAd6UkjhAl45FMXUosC1dP+DOkKa
         +nUbYrM9U04rEN6Fq9BEWjzpSucjLc35zowg7f/n7ngBqqQT6BxpJSwPABsd4uZEOjDW
         tpiYDIMjdK3YPursAi8w5snShpTlty3viIOmiFAQzN32YIW9B0OVrurNSX39z8PNIjII
         fixw==
X-Gm-Message-State: AOAM531+eUUbqTVkdCFGeF70r8b8din5Y0MEGz/7SvNPJcG1CakGxuNF
        j6qM1WROxXOhm5ySYF27MxxZNt/F+g==
X-Google-Smtp-Source: ABdhPJxgDV7qCRup0DaOlqWibc0Iavyobr4jEzrOaIuzZ+nbAc/aQDkROUeW2jgxBWp2OqIprLSXSg==
X-Received: by 2002:ac8:5745:0:b0:2f3:e231:bc12 with SMTP id 5-20020ac85745000000b002f3e231bc12mr5893406qtx.291.1652225227371;
        Tue, 10 May 2022 16:27:07 -0700 (PDT)
Received: from bytedance (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id z21-20020ac87115000000b002f39b99f6adsm188086qto.71.2022.05.10.16.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 16:27:06 -0700 (PDT)
Date:   Tue, 10 May 2022 16:27:02 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC v1 net-next 0/4] net: Qdisc backpressure
 infrastructure
Message-ID: <20220510232702.GA11259@bytedance>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <2dbd5e38-b748-0c16-5b8b-b32bc0cc43b0@gmail.com>
 <20220510230347.GA11152@bytedance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510230347.GA11152@bytedance>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 04:03:47PM -0700, Peilin Ye wrote:
> This RFC does not cover EDT though, since it does not use Qdisc watchdog
> or friends.

Sorry, there is a call to qdisc_watchdog_schedule_range_ns() in
sch_fq.c.  I will learn more about how sch_fq is implemented.

Thanks,
Peilin Ye

