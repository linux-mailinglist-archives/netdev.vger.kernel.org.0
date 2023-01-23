Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5F36777FE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjAWJ6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjAWJ6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:58:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A984C1D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674467871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fp28RUK0xFhE/7bBO5cA+KdBINu5fWDxIv0BbY/vqSI=;
        b=Hp28R70xEspKtuoKndgQAa0DivOHMmZHssM5vLhsp1F45/t4mCYw9QCsmws+9QGl2i83tf
        VeRdWd0AZKgUwPw4DymB7dBZOOwJQ0h7Ulv429kxzzBBjCajLaDgbL/FvVm/ExASdgH8F9
        77VDuqstTZi82C+PTw0I6eVE/IEPa/A=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-HbgZckimMTK5M9Jwsk0OBQ-1; Mon, 23 Jan 2023 04:57:50 -0500
X-MC-Unique: HbgZckimMTK5M9Jwsk0OBQ-1
Received: by mail-qk1-f198.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso8552281qko.11
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp28RUK0xFhE/7bBO5cA+KdBINu5fWDxIv0BbY/vqSI=;
        b=2SLVou4u0ss32RipQZk7czg26caoplTT7sStZohTy5TfUw6hInU+BDspUTujU4s5Kx
         f8LKp7mFjXM95s82o3giNXWJajqeOLg8SiItxbmhQaLrjDw1gYQ2zqnw6bSYcCV6HI/K
         HW4dSTjg17fQw5j0aTKmJvWr87LeyZib7h/ZbQSodmHelauxTvB/2vLxQXw0neHjpAaZ
         qIms0YCCGmxUyKAJgP3Fw9Bsp+5vYdgsixYxSmUFWmu78OVBq48yQDeleY3ha1DXgAhr
         dtWdppgMYhgN9pGt1oP1KVpfhlpN5YAcm5DwwUB0PSSYyToGiio9FSPPzvXT1srn9MOK
         BiNw==
X-Gm-Message-State: AFqh2kp8MRuOzOFanyXCvPbMr1iJqEIQrOFA21W5DkgDQe0oj/G8hOlp
        vjz+EfAWlkAGBMkNNYvG9352tYszTa/6lVPf5Ai9rmCBZtLywhlJct/Pzbx5k0pdX4M/fTKwool
        a6oIWy1R58eVsCvRU
X-Received: by 2002:ac8:7312:0:b0:3ab:7bb3:4707 with SMTP id x18-20020ac87312000000b003ab7bb34707mr30347667qto.64.1674467869592;
        Mon, 23 Jan 2023 01:57:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDz4IWmjCsAs0UGbUioIk0MXga0k2KGKS9Tagt1MmSL1NfufKTZiRd8nkPQ0lsXafcagQtmA==
X-Received: by 2002:ac8:7312:0:b0:3ab:7bb3:4707 with SMTP id x18-20020ac87312000000b003ab7bb34707mr30347657qto.64.1674467869404;
        Mon, 23 Jan 2023 01:57:49 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id bz25-20020a05622a1e9900b003a591194221sm9405436qtb.7.2023.01.23.01.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:57:48 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on
 cpumask_local_spread() locality
In-Reply-To: <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
Date:   Mon, 23 Jan 2023 09:57:43 +0000
Message-ID: <xhsmhv8kxh8tk.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/01/23 14:57, Tariq Toukan wrote:
> On 21/01/2023 6:24, Yury Norov wrote:
>>
>> This series was supposed to be included in v6.2, but that didn't happen. It
>> spent enough in -next without any issues, so I hope we'll finally see it
>> in v6.3.
>>
>> I believe, the best way would be moving it with scheduler patches, but I'm
>> OK to try again with bitmap branch as well.
>
> Now that Yury dropped several controversial bitmap patches form the PR,
> the rest are mostly in sched, or new API that's used by sched.
>
> Valentin, what do you think? Can you take it to your sched branch?
>

I would if I had one :-)

Peter/Ingo, any objections to stashing this in tip/sched/core?

