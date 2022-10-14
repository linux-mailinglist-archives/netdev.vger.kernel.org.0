Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66BC5FEC3E
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJNKFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJNKFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:05:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CFD4DF13;
        Fri, 14 Oct 2022 03:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6E37B82214;
        Fri, 14 Oct 2022 10:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977DBC4347C;
        Fri, 14 Oct 2022 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665741912;
        bh=kQ6GsrFoYb1xxcIqX5jvTD5g30h+H0/nMu6gMa3iuhQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bFVraoR+KBZlJMiW6OJVjKdA0qNbVdmvSKet627k8vi7WE3zkwz9rEzsWlwYCyLRP
         Vmzo9KzbyzclaeFyD9TjL2pJDFziWCr3G85oYE++ednWJZbakyDB4mZ8aPvv81ABAL
         iXw7ZMOon0ucQgdC4hwFkMGInljPH6jJatptCt3H4UvbHQlbrUo16g+iIIXH8A+ufs
         juNx8mE7h6CwGRQUEG8KFDpCdBqHfqyVy6dyO98N5104xOVjNAiNc/KTWP6uoSPDQi
         TvxmwTQ7jAbzwhmn+WfiyBPyPDsMX4ehQEnk178w0tTzDqll3TUAW2YNXfJsRx/xkh
         TBeKfB/RWB8Pg==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1370acb6588so5269316fac.9;
        Fri, 14 Oct 2022 03:05:12 -0700 (PDT)
X-Gm-Message-State: ACrzQf1tmrkcmE02EbHA0iUh8OglZLgcY2uEGFqD1mQuU6bnJh558yuA
        zPMoMGdaX5PB5Mx7eG8A7YIMQspBorTCC8nZDkY=
X-Google-Smtp-Source: AMsMyM6Z7SSf4AbBTLY7ienWTYZ/Glj67u/8CDcrGsvcrY5qq68jT2V5WDTo+MO4GNhF5+M7o7yeUe0ycoBROkcKZ5E=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr8050336oah.112.1665741911827; Fri, 14
 Oct 2022 03:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-3-guoren@kernel.org>
 <Y0kzKgHO51LlqGkY@smile.fi.intel.com>
In-Reply-To: <Y0kzKgHO51LlqGkY@smile.fi.intel.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 18:04:58 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTuPmd8MPK5vwWfKTLv+unjr=+Q8KOTzCmq5LHipKX62Q@mail.gmail.com>
Message-ID: <CAJF2gTTuPmd8MPK5vwWfKTLv+unjr=+Q8KOTzCmq5LHipKX62Q@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] net: Fixup virtnet_set_affinity() cause cpumask warning
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 6:00 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, Oct 13, 2022 at 11:04:59PM -0400, guoren@kernel.org wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > Don't pass nr_bits-1 as arg1 for cpumask_next_wrap, which would
> > cause warning now 78e5a3399421 ("cpumask: fix checking valid
> > cpu range").
>
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x5c/0x80
> > Modules linked in:
>
> Submitting Patches document suggests to cut this huge warning to only what
> makes sense to see in the report.
Okay
>
> --
> With Best Regards,
> Andy Shevchenko
>
>


-- 
Best Regards
 Guo Ren
