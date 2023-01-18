Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C6B67226D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjARQFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjARQEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:04:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B29F1CADF
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674057632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e89KUReRnFC8BiPtT5Ew2vQW49yhC6/bm7l7rms+PfA=;
        b=TLmjXfQVkLTvFiN6Z9Cfdxa8bLtELu+z6UDguc8cFXpuSK9rP+JbIMUD285TjCvoWskljx
        WJ/xyeC4N3X09HS/URdNQfetgO3EfVuo/RfmHkizB9VrIWpYEV+hj5WqxjQZ7ds7Roy+Yh
        KpQzZgGQlTS2arqn3Kism77MCgV6ZJc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-357-sPFDAKgtOx61P5btuiYW9g-1; Wed, 18 Jan 2023 11:00:30 -0500
X-MC-Unique: sPFDAKgtOx61P5btuiYW9g-1
Received: by mail-ej1-f70.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso24261739ejb.5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:00:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e89KUReRnFC8BiPtT5Ew2vQW49yhC6/bm7l7rms+PfA=;
        b=U/eXIx+F0x/wW756rzNcVsNL7DE1lynY1aYGbSyZga4EwVDX7sV5+QHqIdUMNiLpyZ
         TYVBjGDYnI873rkdEsQ7Gq8qep0PzCAYs9FsPm9n/AF2g631EAfWuTJv/HG45yuVKwMs
         8qAMi8+JzEbPmT72HYwktnd5doh8G9o3+l3TYaMV8SJpu4ugJZkXgaf5mlDezIFGCyNa
         lAEN/tNGTeeZ3FAOdMCIz9fvtqwMpITWtPM7Ll/1FWpNhggZhwzRBqs6Jci7VIrs7eSr
         JxpRUkM6v8Mo2tEsB4vjvMoPALRjhmJEE8Y2MC087VAiYjxVI5fMVv5Q+6A8+ps0vtuY
         xJZg==
X-Gm-Message-State: AFqh2kofZegTh8x84h0+jsaaFVXIKfD1jDayxZ/H8G8MlvozU2xYURIW
        oFNlgK9zT2EfhNuPAyr994zyrq++5DZgRYqfNrKU6NPd0j/MuV5WdiG4qQ+S4kdEvgWMsEztxyH
        nJiNhSuOwokgL6lES
X-Received: by 2002:a17:906:a898:b0:820:4046:1586 with SMTP id ha24-20020a170906a89800b0082040461586mr3806489ejb.12.1674057628366;
        Wed, 18 Jan 2023 08:00:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtMrjro6MGIf58FeS0x/blGstqUXuBSGjww3H9B30h+D1mdgmlN5ENxxFZilKhcjCy7ENf0Vg==
X-Received: by 2002:a17:906:a898:b0:820:4046:1586 with SMTP id ha24-20020a170906a89800b0082040461586mr3806472ejb.12.1674057628152;
        Wed, 18 Jan 2023 08:00:28 -0800 (PST)
Received: from localhost (net-37-179-25-230.cust.vodafonedsl.it. [37.179.25.230])
        by smtp.gmail.com with ESMTPSA id ec20-20020a170906b6d400b007c0f5d6f754sm14964926ejb.79.2023.01.18.08.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:00:26 -0800 (PST)
Date:   Wed, 18 Jan 2023 17:00:26 +0100
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results
 when asked to drop") may be not bug for branch LTS 5.10
Message-ID: <Y8gXmjlFPZdcoSzW@dcaratti.users.ipa.redhat.com>
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
 <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com>
 <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

all good points!

On Wed, Jan 18, 2023 at 08:06:12AM -0500, Jamal Hadi Salim wrote:

> The main issue is bigger than tcf_classify: It has to do with
> interpretation of tcf_result and the return codes.

Some classful qdiscs ignore the value of res.class and just lookup the
configured classes based on the value of res.classid. In this case, the qdisc
code validates tcf_results, and the resulting class is always a valid pointer
with correct layout and size.

With HTB, CBQ, DRR, HFSC, QFQ and ATM it's possible that the TC classifier
selects a traffic class for a given packet and writes that pointer in 'res.class'.
When/if this happens, the qdisc doesn't need to use res.classid and then lookup for
the traffic class: it assumes that res.class is already a good pointer to a
struct of the correct type (struct hfsc_class for HFSC, for instance).

> The main environmental rule that was at stake here is the return
> (verdict) code said to drop the packet. The validity of tcf_result in
> such a case is questionable and setting it to 0 was irrelevant.

I remember that the first matchall implementation forgot the assignment
of 'res' and this caused a problem similar to the reported one [1]. In my opinion
we should consider to eliminate 'res.class' and its usage in the above qdiscs,
if we find out that current TC filters just write res.classid (not sure of what
cls_bpf does, though) and constantly write 0 to res.class.

[1] https://lore.kernel.org/netdev/b930159de5531a4d216a1cd2c2ef03aa41f421f9.1505562794.git.dcaratti@redhat.com/

> The current return code is a "verdict" on what happened. Given that
> there is potential to misinterpret - as was seen here - a safer approach is to get the
> return code to be either an error/success code(eg ELOOP for the example being quoted) since
> that is a more common pattern and we store the "verdict code" in tcf_result (TC_ACT_SHOT).
> I was planning to send an RFC patch for that.

well, the implementation of "goto_chain" actually abuses tcf_result:
since it's going to pass the packet to another classifier, it
temporarily stores a handle to the next filter in the tcf_result -   
instead of passing it through the stack. That is not a problem, unless
a packet hits the max_reclassify_loop and a CBQ qdisc that dereferences
'res.class' even with a packet drop :)

> I am still not clear on the correlation that Zhengchao Shao was making between
> Davide's patch and this issue...

In my understanding there is no correlation. Oh, last small note:

> On Wed, Jan 18, 2023 at 6:06 AM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> >
> > The merged patch looks good to me; however, I wonder if it's sufficient.
> > If I well read the code, there is still the possibility of hitting the
> > same problem on a patched kernel when TC_ACT_TRAP / TC_ACT_STOLEN is
> > returned after a 'goto chain' when the qdisc is CBQ.

I think it is sufficient to avoid the crash, since the value of 'res.class'
should be a valid pointer (NULL most of the times?) after each call to 

tp->classify(skb, tp, res);

if the return value is different than TC_ACT_UNSPEC and TC_ACT_SHOT.
However, I still don't understand why cbq should charge classes when the
packet has been 'stolen' or 'trapped'...

-- 
davide

