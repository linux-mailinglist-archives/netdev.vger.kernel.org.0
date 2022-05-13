Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BD9525F18
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379089AbiEMJgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 05:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379098AbiEMJgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 05:36:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BC53377D4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 02:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652434570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vi0fD3tJS3wyYDCLv58vpEppzaTBi27vEcqa6dGWfbQ=;
        b=I0aLohQCjZXqwpK2639UtZSlTFVyftaFZZpdu2PV6KFRfWzDfW5rpybBX0lw1XqCLlTdnl
        dgswekuJbklX2dCHIAwRUNCHnSq4AX2dh80Ce1IyQ9dionnLSJie+UnUEBPU3cLU5EFo6V
        fya0ZQfnJoWTNHMYGTkxymZ7AD3z9zQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-9ZdlCNtGOEGw7RofZnFEKA-1; Fri, 13 May 2022 05:36:08 -0400
X-MC-Unique: 9ZdlCNtGOEGw7RofZnFEKA-1
Received: by mail-wr1-f70.google.com with SMTP id ba21-20020a0560001c1500b0020ca6a45dfcso2741215wrb.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 02:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Vi0fD3tJS3wyYDCLv58vpEppzaTBi27vEcqa6dGWfbQ=;
        b=EgY/iOpN/VmJ9KaLGmWB8K6TwhhU44OC5FgCGygJeaRdNcAIo4wTw7FFyVsFtm3HG5
         O1ldyWEc/6+JiWNFTBFSH1SpR8YWd+GO4SSzTqEuF13vAy7mDe6qVi+dlT/Ij1x/R47f
         wRjDoESbK+1sPxJ4D6buDvFP2A1XW2dK3ZRwc7H+HhWlYBgMhDw+k4XkpX7c+HnR+mp4
         E8YQTkFgS5nY8oh6xcmZGV8XaWLKPTRPdz3XPQG53EYrQAgVUqCjtCYWktIG+aWP/2Eq
         FkJDL/u8JfKc9awkon2HnsogA1GDSfQMwcszjQ1ZpldMr/+s5jsSvSBYxENKx0OBw/o/
         AI+g==
X-Gm-Message-State: AOAM532bzNS4fyjeEj1Zlow2AG6+EkCJEMnnrsLnMRbkwRHBiiYoLC2a
        Nw2wdRqEYa0cABoCGBojkURZRbmBhKhUmWBYcl/Uzav4EMIuHPyq/ErLCn0LzPddDb32mqKs1n6
        GhrphlaLAFJI1tq7z
X-Received: by 2002:a05:600c:21c8:b0:394:7796:49c0 with SMTP id x8-20020a05600c21c800b00394779649c0mr3781830wmj.191.1652434567597;
        Fri, 13 May 2022 02:36:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAtMR59wSTmE1O8m+IbRTUXbZaaIZQReUBIEaQzPZK/bcmOYutSydx3ySDZenjDOYiOxoF3w==
X-Received: by 2002:a05:600c:21c8:b0:394:7796:49c0 with SMTP id x8-20020a05600c21c800b00394779649c0mr3781812wmj.191.1652434567389;
        Fri, 13 May 2022 02:36:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id d11-20020adfa34b000000b0020c86a9f33bsm2134925wrb.18.2022.05.13.02.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 02:36:06 -0700 (PDT)
Message-ID: <751e78f0aedffd19b0314c365fd5ecf0e73a52c1.camel@redhat.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in tcf_pedit_init
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 13 May 2022 11:36:05 +0200
In-Reply-To: <CANn89i+xqQafpRrF7=G0FqJNZkQUBCt_sKsSbhG64bq0iCnztQ@mail.gmail.com>
References: <0000000000005f1a8805ded719cc@google.com>
         <CANn89i+XHh1An6fDA0CH1Fb2k_-G8_CCzEmXGKqB4tRAMH9s4w@mail.gmail.com>
         <20220512155136.70554388@kernel.org>
         <CANn89i+xqQafpRrF7=G0FqJNZkQUBCt_sKsSbhG64bq0iCnztQ@mail.gmail.com>
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

On Thu, 2022-05-12 at 16:53 -0700, Eric Dumazet wrote:
> On Thu, May 12, 2022 at 3:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > 
> > On Thu, 12 May 2022 14:19:51 -0700 Eric Dumazet wrote:
> > > On Thu, May 12, 2022 at 2:18 PM syzbot
> > > > This report is generated by a bot. It may contain errors.
> > > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > > > 
> > > > syzbot will keep track of this issue. See:
> > > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > > syzbot can test patches for this issue, for details see:
> > > > https://goo.gl/tpsmEJ#testing-patches
> > > 
> > > As mentioned earlier, this came with
> > > 
> > > commit 8b796475fd7882663a870456466a4fb315cc1bd6
> > > Author: Paolo Abeni <pabeni@redhat.com>
> > > Date:   Tue May 10 16:57:34 2022 +0200
> > > 
> > >     net/sched: act_pedit: really ensure the skb is writable
> > 
> > Came in as in new stack trace for an old/existing bug, right?
> > Nothing checks the shift so it'd have already tripped UBSAN
> > later on in tcf_pedit_act(), anyway.
> 
> Maybe a prior syzbot was reported, and nobody cared.
> 
> Or maybe syzbot got its way into this path only recently.

I'm reasonably sure the issue predates the bisected commit. Possibly
syzbot was unable to catch it before such commit because is much harder
to achive complete coverage of the data path, I think.

I've sent a patch, thanks for the report.

Paolo

