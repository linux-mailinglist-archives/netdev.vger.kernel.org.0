Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C4F518312
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiECLOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiECLO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:14:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFF36344C3
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651576256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cfcQ7UHxEnTQrEwVVu+lIRpxWaR29jUlJMX6nIplXY8=;
        b=GAxxYbSw/WSPObTg+YCD+FQIEWP6Quxgy4jlT+CE5H5KAh3kUXPo+ox9o9azCMBfLwx/zR
        ZaCHREP8WVC8WtNvE2CpILc2ma7qmM4fH/6hdq7MwegcyVAZSqjoOHDwdqhWaMQkUi/Ik3
        uTzWZ8A4NCB2rBqx6xPA+QEjL4NYF+0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-B9d6aPLDOqWFvh9XSLSxdg-1; Tue, 03 May 2022 07:10:55 -0400
X-MC-Unique: B9d6aPLDOqWFvh9XSLSxdg-1
Received: by mail-qk1-f197.google.com with SMTP id o13-20020a05620a0d4d00b0069f47054e58so12021563qkl.13
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 04:10:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cfcQ7UHxEnTQrEwVVu+lIRpxWaR29jUlJMX6nIplXY8=;
        b=uygiIcgjYEDGWQEiurydqwa+rkPkydFAi2Fa0asdYLZGR9uvrAw1iqJUmfCmq4nTaF
         o34iffn5wqckP5+qt0IHXVJfzdUQA6C6LLc3tNoGbsAGi/4xkqIxBvL7scP3N9zSM+d/
         +GEgYaYBtWKGcARS0YcaO9dpg2DmB507xt3JiFxI6tChpEqVovmEr6QosT2D1hwF1vrP
         ZVnj+fijQsxXooH+dK200iW9orzqtK7onkEhr6wcMUPw4MsnTuHU4KJX+nG4Rt2RP2j9
         Gq47GIuDg2C74MnazgyWwVRQt9Hqr8NPZYpMiRTiUG6agThotmUFYVo7SDEqWZiaSWuY
         JSjw==
X-Gm-Message-State: AOAM530egqOm0xSnYiEkf8UsP0fDVD08cbMzQt5BXj1ReRJQleYRHydO
        JHWRLPHxW34txcI/49DVCa3ICnYhPbSh9MnOiBWTX5jmI+YtlirIL6WQUYyOHetn2B8gA6+uu/6
        sJ5MrEnGdcoEDK4JD
X-Received: by 2002:ad4:5ba4:0:b0:446:1e27:6f87 with SMTP id 4-20020ad45ba4000000b004461e276f87mr13061929qvq.11.1651576255224;
        Tue, 03 May 2022 04:10:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8qEByazZnGImQtEKRWB0y0AN7Vx31Gv2N3dnCjtKHaZUcMy9ncS4fS4Ym1kWMFe5h4odN0w==
X-Received: by 2002:ad4:5ba4:0:b0:446:1e27:6f87 with SMTP id 4-20020ad45ba4000000b004461e276f87mr13061916qvq.11.1651576255002;
        Tue, 03 May 2022 04:10:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id z13-20020ac8710d000000b002f39b99f6a5sm5429724qto.63.2022.05.03.04.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 04:10:54 -0700 (PDT)
Message-ID: <3b114ba6d8f0e17759f0d676eead4b75a774b237.camel@redhat.com>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Dumazet <edumazet@google.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Date:   Tue, 03 May 2022 13:10:50 +0200
In-Reply-To: <aa61682d-f5cb-23ee-284e-a38316ad4333@I-love.SAKURA.ne.jp>
References: <00000000000045dc96059f4d7b02@google.com>
         <000000000000f75af905d3ba0716@google.com>
         <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
         <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
         <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
         <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
         <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
         <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
         <3b6bc24c8cd3f896dcd480ff75715a2bf9b2db06.camel@redhat.com>
         <aa61682d-f5cb-23ee-284e-a38316ad4333@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-03 at 18:56 +0900, Tetsuo Handa wrote:
> On 2022/05/03 18:02, Paolo Abeni wrote:
> 
> > https://lore.kernel.org/all/CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com/
> > 
> > but the latter looks a more generic solution. @Tetsuo could you please
> > test the above in your setup?
> 
> I already tested that fix, and the result was
> https://lore.kernel.org/all/78cdbf25-4511-a567-bb09-0c07edae8b50@I-love.SAKURA.ne.jp/ .

Thanks, I somewhat missed that reply.

Paolo

