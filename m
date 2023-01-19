Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE79674364
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjASUR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjASURx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:17:53 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C1D9AA8E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:17:50 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id 123-20020a4a0681000000b004faa9c6f6b9so686318ooj.11
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2E2KcmwdHgUJkkGoPfxWueyrWAFrLSOfNe+KVT0iIlQ=;
        b=MnNaMseLwZyOJBQV5fMJ9cuAL5Csmyc+VJudM7hB0lnFnzTq4+oXyW73WWcgRsu1Ah
         aLjmfv2ihDTBb1XgWBQ1/aKQqSGYsrAawdUp4XZKwjF1gVU24kls8GplzDiH1Za/2xvj
         iSGZ6I1U2SDVhoF7B9LS0lhQ68KO0RELVoHLg68yU3WuYcEDd3VZEk5FdbdOEQqRdq9X
         cGBIcx/wl462DH47bhvLM4JakzC4TpWyUxd1uX+S942J6+7ECXiG4doyJVdqSpQfl3o2
         BkRNNv+vqR8Xq+9BaSm/oCip5xMY7pfzZvuI/92m39xch/sz+LXDdnETVWTER55srUlP
         9eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2E2KcmwdHgUJkkGoPfxWueyrWAFrLSOfNe+KVT0iIlQ=;
        b=xwBLGLGwX4CqueLvKT91OcUPrPCi6JlnYfCFnhmWgNRIG9KhaTJyntaWlCYr5wQh0n
         xmiV/fT0ogw/FE4AaPi5PyTVHcXkPkpu5g2Zd+KgOHvH9/qk42THocbTctICBuulqDzS
         w0MiGkNdVZXAUDTCNLwUMKOLmeah2qLxIr2mkUpZQL1TC1fXxnE56XYzVpgMqoo2A+2M
         6DjggVkM2Pbhu9tTq5FESrA+UTYF8jepHbHPyT7fOwAmTvE3Jn8gF2sJRt1NHPUF6Yfs
         OJ+gINm/hHkf6JmzWZnYPyQNvKEW1zSZWC+vRvO5upI54+7zwwtpMEPPS2ylDscVYxsW
         /9NQ==
X-Gm-Message-State: AFqh2ko8o/XDpCy+MEMhX9PRlVjVuL1m3XTVmKYbHsbDfX+2w0SK6O1X
        7tj0mKTDi78t4FpmVSctZVY=
X-Google-Smtp-Source: AMrXdXtWmdj4pK0ed8wJpQ7f0td8zSFQwAOJtZgXJQVCwbWUh4Pn2esFpYCxYKQI/TimfhmrMDaigA==
X-Received: by 2002:a4a:be03:0:b0:4f2:9e:3e9e with SMTP id l3-20020a4abe03000000b004f2009e3e9emr5906307oop.5.1674159469731;
        Thu, 19 Jan 2023 12:17:49 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:3a02:bbf0:9a75:78ad])
        by smtp.gmail.com with ESMTPSA id o79-20020a4a2c52000000b004f8cf5f45e9sm4505018ooo.22.2023.01.19.12.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:17:49 -0800 (PST)
Date:   Thu, 19 Jan 2023 12:17:48 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, jiri@resnulli.us, john.hurley@netronome.com
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding offloads
 to stats
Message-ID: <Y8mlbKZK3aFA/sAH@pop-os.localdomain>
References: <20230113044137.1383067-1-kuba@kernel.org>
 <Y8Ni7XYRj5/feifn@pop-os.localdomain>
 <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 10:00:56AM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Sat, 2023-01-14 at 18:20 -0800, Cong Wang wrote:
> > On Thu, Jan 12, 2023 at 08:41:37PM -0800, Jakub Kicinski wrote:
> > > Naresh reports seeing a warning that gred is calling
> > > u64_stats_update_begin() with preemption enabled.
> > > Arnd points out it's coming from _bstats_update().
> > 
> > 
> > The stack trace looks confusing to me without further decoding.
> > 
> > Are you sure we use sch->qstats/bstats in __dev_queue_xmit() there
> > not any netdev stats? It may be a false positive one as they may end up
> > with the same lockdep class.
> 
> I'm unsure I read you comment correctly. Please note that the
> referenced message includes several splats. The first one - arguably
> the most relevant - points to the lack of locking in the gred control
> path.

I think it means lack of BH disable, not necessarily locking.

> 
> The posted patch LGTM, could you please re-phrase your doubts?

Yes, because the key in lockdep ("&syncp->seq#14") may be same for other
dev stats (aka, not qdisc stats).

Also, HTB does not accquire this lock when dumping
(htb_dump_class_stats()) stats. Why don't we have a problem there? ;)

Thanks.
