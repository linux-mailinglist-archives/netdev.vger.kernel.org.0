Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42695999E2
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348323AbiHSKeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347973AbiHSKeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:34:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDB93DF1C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660905245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9qConcsVrFeMSKZiZOZ7jvIr/WxjYXLhBQh/vLaFNc=;
        b=Sa+EqwxqY5TNC8cxtn6xkrhHOGjcuP4AiVEIHDvZLba02ddxN8YcnSwGbaZWyPyNVwpt9q
        b/SJ/CIgSMYUxkNR+CnGE20uTkm4Z+KmwstNdsdfRsyu4CnZO4T+Tp46FE4yyvGZ3Is0Tc
        i6DnsqV8T8p5VKVXoIWRdQcTjE8rFpE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-7d1VIyhhO_a3udN6pDZatw-1; Fri, 19 Aug 2022 06:34:04 -0400
X-MC-Unique: 7d1VIyhhO_a3udN6pDZatw-1
Received: by mail-wr1-f72.google.com with SMTP id i29-20020adfa51d000000b002251fd0ff14so636086wrb.16
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=t9qConcsVrFeMSKZiZOZ7jvIr/WxjYXLhBQh/vLaFNc=;
        b=4GjKM4Oj32+TgfeFxZDYOgw29c4xcQ+axnlm8MoCZJha8oWx4t200JVN9r9kxP11xX
         /jtLqbTql+21OMhA0SXIsK/D9INZXzfzyLSnPsawA8WuiZrllTD5P2HatwHQHq9mmpG3
         hnwK3YBGf4GWZxW4lXjouOB0jAxzA3kDoJBVnxxBSHshgtjOPqKAv3UafcG1xLyrSR8F
         yZOPB1FUBo5lcG2xoXmffPpPB/w1mXRH3T91W1i4tbshPYvTC8d0knXua3xpzWm0clR+
         90VGul8jFDhFyMKsH+/CFmD6wAqaLomEtsDTjd4hutvzai9s9ocGsK02/CVpWbREuyfg
         VsNQ==
X-Gm-Message-State: ACgBeo0SXBrRwj4+rN654rwu+Oe89GA7ohe6Npnk27IgdX/q1Pdkroew
        CmtzVaxjZ9KFEi7ijrtEMkmT8pB85L1lmaB5o5fW39tMqCJThJ8rH5OV9VsPzDQI8bWy8biL5Ua
        5boPNb/0z1Dt0WC/D
X-Received: by 2002:a5d:64e9:0:b0:220:7dd7:63eb with SMTP id g9-20020a5d64e9000000b002207dd763ebmr3831683wri.590.1660905243409;
        Fri, 19 Aug 2022 03:34:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7AoX+VQs/b3XMThsgV+BYuePZtBIHhF6hh6s7w1xBiDvXh8zDLXmM78RPTeY/EF0PqfZ3SJQ==
X-Received: by 2002:a5d:64e9:0:b0:220:7dd7:63eb with SMTP id g9-20020a5d64e9000000b002207dd763ebmr3831663wri.590.1660905243244;
        Fri, 19 Aug 2022 03:34:03 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id b18-20020adff252000000b00224f605f39dsm3501436wrp.76.2022.08.19.03.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 03:34:02 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v2 1/5] bitops: Introduce find_next_andnot_bit()
In-Reply-To: <CAHp75VcaSwfy7kOm_d28-87QKQ5KPB69=X=Z9OYUzJJKwRCSmQ@mail.gmail.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220817175812.671843-2-vschneid@redhat.com>
 <20220818100820.3b45808b@gandalf.local.home>
 <xhsmh35dtbjr0.mognet@vschneid.remote.csb>
 <20220818130041.5b7c955f@gandalf.local.home>
 <CAHp75VcaSwfy7kOm_d28-87QKQ5KPB69=X=Z9OYUzJJKwRCSmQ@mail.gmail.com>
Date:   Fri, 19 Aug 2022 11:34:01 +0100
Message-ID: <xhsmhk074a5eu.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/22 22:04, Andy Shevchenko wrote:
> On Thu, Aug 18, 2022 at 8:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Thu, 18 Aug 2022 17:26:43 +0100
>> Valentin Schneider <vschneid@redhat.com> wrote:
>>
>> > How about:
>>
>> >
>> >   find the next set bit in (*addr1 & ~*addr2)
>>
>> I understand the above better. But to convert that into English, we could
>> say:
>>
>>
>>   Find the next bit in *addr1 excluding all the bits in *addr2.
>>
>> or
>>
>>   Find the next bit in *addr1 that is not set in *addr2.
>
> With this explanation I'm wondering how different this is to
> bitmap_bitremap(), with adjusting to using an inverted mask. If they
> have something in common, perhaps make them in the same namespace with
> similar naming convention?
>

I'm trying to wrap my head around the whole remap thing, IIUC we could have
something like remap *addr1 to ~*addr2 and stop rather than continue with a
wraparound, but that really feels like shoehorning.

> --
> With Best Regards,
> Andy Shevchenko

