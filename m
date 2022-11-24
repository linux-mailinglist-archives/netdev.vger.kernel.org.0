Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2AA637E82
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKXRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXRnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:43:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F15146F8B
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669311720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x5hDIAkhYVXHmawXP7R5N1/dLM+T4/Ck1lNYEvtFc+s=;
        b=PJqiFfL3tgu3o3Awjt5idjTFY1UnYsJdbIpIewq0+BeQx5phLxQmCttgJcinPkeUhOxODm
        cJBv/dafjdDcdTmNf2+Mds9rY8UzqwV+anbNnh+qGAvJYYJFh3HRPuCx1c1S4/MhlrFE0d
        CqnBroDZqxZgYba+aILUCzmcUwzb/vI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-IkFSqXi5P7qbVUGHEyYoDA-1; Thu, 24 Nov 2022 12:41:59 -0500
X-MC-Unique: IkFSqXi5P7qbVUGHEyYoDA-1
Received: by mail-qk1-f200.google.com with SMTP id w14-20020a05620a424e00b006fc46116f7dso1903217qko.12
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:41:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x5hDIAkhYVXHmawXP7R5N1/dLM+T4/Ck1lNYEvtFc+s=;
        b=2hlLoQZfSQ3Pvhiny7EGdEasmok/rrBL6Y15bSSuphxBWGukvKcM6fdvu/bC/1LauZ
         5EgzCv+4AVfAOIRYycwV4QUMkUPjzNYirsfIllo0TZ/8sNAxjaAFcC24mys7sn1UN4qe
         e8f6sCvaKusBz/Nk0G6w5ECuG/4gdxlZY3v/YJD8e6ceiiSHaX9+ggdq7V2ZaZuW8Q3B
         p3vHIA+IVmqp0E+H/MmfcqzpjGJXgbLXwcMXldb6jrIagk+ZRbfGrambCmTOl7qSs2KY
         q0lbffUS8mfty6ybndm19plQ2aHR0TDkFWSSarIbI+cH0tzxi3Mmy7oOdB/y81u4+VYb
         yVkQ==
X-Gm-Message-State: ANoB5pnSo1Gi6e/TG0grsJ+/UDo/p8zshHiByJaVwmFQXme5aF9T5h0V
        Ufy7FeFllRtCdKOGkJu4qSdcoXiNx53+9dvpIIifiwvx7x1wloIsdz3MF/WOhPhRdHZ4m7Xws5g
        VvrkOKKYOzySFCFfZ
X-Received: by 2002:ac8:4e0a:0:b0:3a5:3134:cc67 with SMTP id c10-20020ac84e0a000000b003a53134cc67mr32020224qtw.475.1669311718638;
        Thu, 24 Nov 2022 09:41:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6gN4CvJ5MuzjVBx80H7ajXx7sNn0dFDTxa/wEzPGMwqY2IbGkOfZD+bLR49p/xGCaySRxEaQ==
X-Received: by 2002:ac8:4e0a:0:b0:3a5:3134:cc67 with SMTP id c10-20020ac84e0a000000b003a53134cc67mr32020201qtw.475.1669311718355;
        Thu, 24 Nov 2022 09:41:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a240d00b006fab68c7e87sm1205244qkn.70.2022.11.24.09.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 09:41:58 -0800 (PST)
Message-ID: <75af69306b8f23d66043f0b6df9764df82ff9c5e.camel@redhat.com>
Subject: Re: [PATCH v3 net 0/6] hsr: HSR send/recv fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Date:   Thu, 24 Nov 2022 18:41:55 +0100
In-Reply-To: <Y3+k38K5C2GWXAWQ@linutronix.de>
References: <20221123095638.2838922-1-bigeasy@linutronix.de>
         <3e8a822d1e9f0dad7256763cb7d2fdaf1115c0f5.camel@redhat.com>
         <Y3+k38K5C2GWXAWQ@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-11-24 at 18:07 +0100, Sebastian Andrzej Siewior wrote:
> On 2022-11-24 16:06:15 [+0100], Paolo Abeni wrote:
> 
> > I think this series is too invasive for -net at this late point of the
> > release cycle. Independently from that, even if contains only fixes, is
> > a so relevant refactor that I personally see it more suited for net-
> > next.
> 
> As you wish. The huge patch is the first one basically reverting the
> initial change plus its fixup back to pre v5.18 time.
> Right now it is not usable here due to the double delete under RCU
> which happens randomly but usually within 30min. But it appears I'm the
> only one complaining so far ;)

I can agree that the hsr code will be in a better shaper with this
patches, but my personal concerns is with the timing. We are almost at
the end of the 6.1 release cycle. Sending relativelly large changes and
significant refactor this late would be "unusual" at best.

> If you want to merge it via next, be my guest. Can you apply it as-it
> or do I need to repost it again?

I'd like to see the self-tests, if possible. So a repost will likelly
be needed.

> > In any case it looks like you have some testing setup handy, could you
> > please use it as starting point to add some basic selftests?
> 
> This task might be within my capabilities. I guess you ask for something
> that spins a few virtual interfaces and then creates a HSR ring on top
> of it.

Exactly. Possibly you have to create different namespaces, and create
hsr devices on top of veths. There are a few existing self-tests you
can have a look to as a reference - to make a "random" example, the
setup phase in tools/testing/selftests/net/mptcp/mptcp_connect.sh.

Cheers,

Paolo

