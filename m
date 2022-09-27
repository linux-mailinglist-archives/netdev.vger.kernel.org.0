Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3535EC321
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiI0MnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiI0MnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:43:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E777F101
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664282589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rU2B4pS7ZGEFHrPkwWaKQmodtthUefxcZfoR2Tssn1s=;
        b=Dm+6GNzcXNmmtowupdyQNRWS5WDtELI1jabc/EyKmrH/HhwZ5jX0t3jVq4Mh5FGoZ0jq/G
        KKf7Z7aVmj8G1u3jpC7+iajQ3VSryvpRHKwHv5TAV1HLL8oSEQbGe4yOQK3PL2CzPoF5PK
        cvSvc2JO+eXOvLYzQbyWvESUKcOvORg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-203-kHikNxZ8PL2mqGp9XfvDog-1; Tue, 27 Sep 2022 08:43:08 -0400
X-MC-Unique: kHikNxZ8PL2mqGp9XfvDog-1
Received: by mail-wr1-f69.google.com with SMTP id h20-20020adfaa94000000b0022cc1de1251so384018wrc.15
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=rU2B4pS7ZGEFHrPkwWaKQmodtthUefxcZfoR2Tssn1s=;
        b=JnisBTooRtlyV+38qXVycvgBK9swuNc0D1rkbIscoSxEnch6n0yTDTRMV/aZR1E+mJ
         idaranj8QcapKeKooQKNpEYLbnwWKnLslvcraPesvCMiHMs7xJNvO5QsjwRdfVju8P+A
         63tbb/rJsBMEL/rERGgUNBAi9rGecXv6id+hKJ0X0VUFAjuqbn9dOy3LS2ZIzfUrWXj0
         LDcAKN3AhbI5jSr/pvrk0nlgOzgbhvg781/bTJIn/eGmheAs+Q7HhNUv3L50WGjjIiXp
         d9/uPz+9gAzRBQy3jFemHUq0q5XveD0pr0EMqBwBRHE9zaaGGk7RtI6/8fGRnEOER3jJ
         z44A==
X-Gm-Message-State: ACrzQf2wUvplYuiVyhkNgDWmHkccUTKQ+KFJeebEFIa+X3iefLWmBQPS
        UhkVLRhKtqQiN61fM5XWEj0OpwbUsz1QPkaWRez4XiP+B91qLkMWjiNrHc9ho5OJZtPKrxhBa1p
        xfIr/PwLzZBm6svvM
X-Received: by 2002:a5d:6d07:0:b0:22a:3f21:3b56 with SMTP id e7-20020a5d6d07000000b0022a3f213b56mr16363363wrq.679.1664282586822;
        Tue, 27 Sep 2022 05:43:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Pcsg/TBB9EfSIfpEGBG2uGxB8J+7UAlyIzPAokOasmpqUmY3nny/ctIsR0WHg9tnAIzKXcg==
X-Received: by 2002:a5d:6d07:0:b0:22a:3f21:3b56 with SMTP id e7-20020a5d6d07000000b0022a3f213b56mr16363348wrq.679.1664282586592;
        Tue, 27 Sep 2022 05:43:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id v187-20020a1cacc4000000b003b492338f45sm1685135wme.39.2022.09.27.05.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 05:43:06 -0700 (PDT)
Message-ID: <5a7a07d34b68b36410aa42f22fb4c08c5ec6a08c.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: sched: fix the err path of
 tcf_ct_init in act_ct
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
Date:   Tue, 27 Sep 2022 14:43:04 +0200
In-Reply-To: <208333ca564baf0994d3af3c454dc16127c9ad09.1663946157.git.lucien.xin@gmail.com>
References: <cover.1663946157.git.lucien.xin@gmail.com>
         <208333ca564baf0994d3af3c454dc16127c9ad09.1663946157.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-23 at 11:28 -0400, Xin Long wrote:
> When it returns err from tcf_ct_flow_table_get(), the param tmpl should
> have been freed in the cleanup. Otherwise a memory leak will occur.
> 
> While fixing this problem, this patch also makes the err path simple by
> calling tcf_ct_params_free(), so that it won't cause problems when more
> members are added into param and need freeing on the err path.
> 
> Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

I think it's better if you re-submit this patch for -net explicitly, as
it LGTM and makes sense to let it reach the affected kernel soon.

Thanks!

Paolo


