Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A779C4E4AC4
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiCWCNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 22:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiCWCNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 22:13:51 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79F85AA66;
        Tue, 22 Mar 2022 19:12:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u22so352737pfg.6;
        Tue, 22 Mar 2022 19:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UncvP6XNcDMsck6iIpDxBH4/BrcQCa39MJmzvdmtf24=;
        b=S8FzccePabKNM+jUXRPDPAAmqqvJFMrOTpIx/44A+okbVkDtd7JV1SINXMokVU2rfN
         X+TjvDdxhc51e8PLirZku4PlJlI6R1QKmhTj3TvSR4NHt45/QFFFBoV1zC6aHe9prrxD
         PqORVWffMMzZ3RVavHxT3ga/5ayx48jUX40pPVYO9VwhwhxUQ8kZrPM0+txRbro0evBI
         xuDkBS/zc/E+p9WGpOLot/kJc70bfDuxpAZKvaUtp40H6Zlirvg7sopvyjlZNGyzyWU7
         oflbUM2yqtMX6q1ZxKGDRQuERqJuOaKOZsJYEVRFYOrk/6S178mvDNUWdBpHDwNOo+qY
         0qvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UncvP6XNcDMsck6iIpDxBH4/BrcQCa39MJmzvdmtf24=;
        b=LtdGwBWu2fKsy0JwgFPzSee09Mp9eOKPulklGshroit1OEIdJCO5gj35j7OeoOKKwE
         HSoFSxgT2ehfNq1KHEpkiO7b3qa8QquhszLotqhiMMZbEnO2og3Ha7AeZKdWB+aUwgy1
         8iNdpWIvZ3/3UVtwdonf/ZuZLS5FMD2jYnMq7hdwWZs2BEMKeK1c9MxtLQ7LcHSaqNo/
         BgrkyzbPfU+5MeU/F7QEYWTp6iw53WaSdGKL0649qQQmgNGsrNy/5QiHKlo/lKkenCUe
         16cIORljORvKrfbaemjRbBfxL1Su25WuFusXvC4kRPEBoKhoafnUk5s08KkACoH5Axx4
         qGOQ==
X-Gm-Message-State: AOAM533J3Y3ODfGOrXKSzlZqm1Kpw/vNzVvgEeKHF+91JLfwSdrX1d3E
        Vby6au+HJo0P0oZPi8EJZ9I=
X-Google-Smtp-Source: ABdhPJwcuAX9ufS9jBuMCOPE0vwKOOY3dWNaEapYdpv0C4xUbMIvOBS5vD67fHzSObiHNokwJXkl+Q==
X-Received: by 2002:a63:ce48:0:b0:373:ac94:f489 with SMTP id r8-20020a63ce48000000b00373ac94f489mr24454999pgi.622.1648001542398;
        Tue, 22 Mar 2022 19:12:22 -0700 (PDT)
Received: from [10.11.37.162] ([103.84.139.52])
        by smtp.gmail.com with ESMTPSA id s141-20020a632c93000000b0038134d09219sm18824633pgs.55.2022.03.22.19.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 19:12:22 -0700 (PDT)
Message-ID: <2f7ed3fa-9fd0-4109-8cdd-815ff3cfb35e@gmail.com>
Date:   Wed, 23 Mar 2022 10:12:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] can: mcba_usb: fix possible double dev_kfree_skb in
 mcba_usb_start_xmit
Content-Language: en-US
To:     Yasushi SHOJI <yashi@spacecubics.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        stefan.maetje@esd.eu, Pavel Skripkin <paskripkin@gmail.com>,
        remigiusz.kollataj@mobica.com,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220311080208.45047-1-hbh25y@gmail.com>
 <CAGLTpnK=4Gd8S488osvrbttkMvtsPy8eCGspV4-=z2N3UGZ5rw@mail.gmail.com>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <CAGLTpnK=4Gd8S488osvrbttkMvtsPy8eCGspV4-=z2N3UGZ5rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi yashi,

You are right. There are a series of the same problems about 
can_put_echo_skb.

This issue was discovered while I was discussing a incorrect patch with 
Marc. You can check this in

https://lore.kernel.org/all/20220225060019.21220-1-hbh25y@gmail.com/

So i submitted a new patch. This was the first place where the problem 
occurs. You can check this in

[1] https://lore.kernel.org/all/20220228083639.38183-1-hbh25y@gmail.com/

After a week, I realized it could be a series of problems. So
i submitted the following patches

[2] 
https://lore.kernel.org/all/0d2f9980-fb1d-4068-7868-effc77892a97@gmail.com/
[3] 
https://lore.kernel.org/all/de416319-c027-837d-4b8c-b8c3c37ed88e@gmail.com/
[4] https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de/

I think this is all affected. None of the four have been merged 
upstream. Do i need to remake all these four patches?

Thanks,
Hangyu






On 2022/3/23 07:08, Yasushi SHOJI wrote:
> Hi Hangyu,
> 
> On Fri, Mar 11, 2022 at 5:02 PM Hangyu Hua <hbh25y@gmail.com> wrote:
>>
>> There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
>> can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
>> skb.
> 
> So, it's more like, "we don't need to call dev_kfree_skb() after
> can_put_echo_skb()
> because can_put_echo_skb() consumes the given skb.".  It seems it doesn't depend
> on the condition of usb_submit_urb().  Plus, we don't see the "cloned
> skb" at the
> call site.
> 
> Would you mind adding a comment on can_put_echo_skb(), in a separate patch,
> saying the fact that it consumes the skb?
> 
> ems_usb.c, gs_usb.c and possibly some others seem to call
> dev_kfree_skb() as well.
> Are they affected?
> 
> Best,
