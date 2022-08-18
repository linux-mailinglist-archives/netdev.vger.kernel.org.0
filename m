Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341CD5988D3
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344740AbiHRQ07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343856AbiHRQ0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:26:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FCC2624
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660840008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bJKdNPCrAwflq0B+vpkU8Zee5XF8y4ubBjbkDVet4tY=;
        b=OZwOjeNkvSpdbDpMQvmbN+dhqaqeJs5lQIMXFD8wOZTl4QuV9Rio8IQn4IcJUB+veWWhyf
        xBcPQMTVQRGVmuRN2AfOmqPp/dy4ypeU8qUsYq0f2kIUk5WYOHfANUMxW7IBy1MLsauUwp
        I14QN5PeUzaoVMTh9k2t7Yn5k47+H4c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-0GHgbH_vMZ6qMRF-hKrIoA-1; Thu, 18 Aug 2022 12:26:47 -0400
X-MC-Unique: 0GHgbH_vMZ6qMRF-hKrIoA-1
Received: by mail-wm1-f70.google.com with SMTP id p19-20020a05600c1d9300b003a5c3141365so2926114wms.9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:26:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=bJKdNPCrAwflq0B+vpkU8Zee5XF8y4ubBjbkDVet4tY=;
        b=wl8wWPe7orzWSB3bImwqQqAgZOthdb8c6Xx9mr/J+TtBZOOgJnUwlaxXMJsuyMpruD
         BdFTVE71wnWEtm9dJ18wF0QhXCXHKtomDerXPZRKarscu1WOxx/qlZNGIMsmcqSBoW+v
         f9qxpAr0moDpOZI9H+reksug/2tizq+KWEj4jZnYZy2hgtPs5MNBoNZoLj5OD3ptntyE
         +LlScOUJcAOuCJHQmbVXDCJaCkHsUhb84RFosTjauHLjw0q2G7GarTGVKdak4AESSRsC
         iBXC09Kz4wrYVHhL+/V9YjJNdRcN7h5ubzkZ4+nZe5+kgUQT78pXClp44v1wNjHELauI
         KBaA==
X-Gm-Message-State: ACgBeo0BM4V0r0XrjrmFtr6DxOYkFi6crgdLSQPqyNDKjHa+0Ydxh4jV
        JdnWNbdcbmIPeCrSDhx83+grqQSQtk5VmkCs58sIzRvgCsWqN1tH5Eqnk2zY67sUW7mi+/qyqpr
        pNHJ8UoThzIYju/UJ
X-Received: by 2002:a05:600c:6009:b0:3a5:b069:5d34 with SMTP id az9-20020a05600c600900b003a5b0695d34mr2380616wmb.115.1660840006238;
        Thu, 18 Aug 2022 09:26:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5KITbJ8qgB+07lErslmt5pcI8kN96IiPvyxnCel1X9v6mNS9hTnhSgQY4lQsTxkRNwRZDdaw==
X-Received: by 2002:a05:600c:6009:b0:3a5:b069:5d34 with SMTP id az9-20020a05600c600900b003a5b0695d34mr2380597wmb.115.1660840006087;
        Thu, 18 Aug 2022 09:26:46 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id q6-20020a1ce906000000b003a342933727sm5893947wmc.3.2022.08.18.09.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:26:45 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
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
In-Reply-To: <20220818100820.3b45808b@gandalf.local.home>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220817175812.671843-2-vschneid@redhat.com>
 <20220818100820.3b45808b@gandalf.local.home>
Date:   Thu, 18 Aug 2022 17:26:43 +0100
Message-ID: <xhsmh35dtbjr0.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/22 10:08, Steven Rostedt wrote:
> On Wed, 17 Aug 2022 18:58:08 +0100
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> +#ifndef find_next_andnot_bit
>> +/**
>> + * find_next_andnot_bit - find the next set bit in one memory region
>> + *                        but not in the other
>> + * @addr1: The first address to base the search on
>> + * @addr2: The second address to base the search on
>> + * @size: The bitmap size in bits
>> + * @offset: The bitnumber to start searching at
>> + *
>> + * Returns the bit number for the next set bit
>> + * If no bits are set, returns @size.
>
> Can we make the above documentation more descriptive. Because I read this
> three times, and I still have no idea what it does.
>
> The tag line sounds like the nursery song "One of these things is not like
> the others".
>

How about:

  find the next set bit in ((first region) AND NOT(second region))

Or

  find the next set bit in (*addr1 & ~*addr2)

?

> -- Steve

