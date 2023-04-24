Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F536ED33F
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjDXRKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjDXRKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:10:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BE65FC6
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682356198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OgUsTW9maVz5SYqmXCdcKI0jUBBCt41uSwRWxLob5gI=;
        b=W0pC6nhupnce7puxOAXemF7UvBG4NXqFBvIH2brXnE0tNq3BqiMV5duif+BnXBZAkuoP00
        k/q+o1sQFADJWF9U5OC38WFsOm85KaMsq8FwohDSe4rDC0/jCR1X6WX2Jii8NLrZ4GDpC6
        V6Z4uU1MBNITYR/eUiZcWr00DgFJoUE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-YrnGmtYwOLSpEQS1Il-dtg-1; Mon, 24 Apr 2023 13:09:56 -0400
X-MC-Unique: YrnGmtYwOLSpEQS1Il-dtg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f18b63229bso38936065e9.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682356195; x=1684948195;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OgUsTW9maVz5SYqmXCdcKI0jUBBCt41uSwRWxLob5gI=;
        b=HvuBvM1L0kpv39rJlRC4XS/wBZpyR6BM55uRZ1d+WxHi2wL2x6cyiAtExdxljtluHZ
         nJkgKntG8au8Znls/lBqcGSBFh7uzUNFg77CbQvCPRVHA02KqhruboHoi9ObPR3KqKeE
         whutkCw4MJotBgM2qWH64UaLOINiPvWXpnmeG4YicCp3URKH8fVnXBHL4TLzyZevLeiX
         j5hHrkbndhvZe3jOtjRjpciE6L1RrdiIMhGO+eQeunRSuxDJ8iSYX9oOCHIdw2JI4e2D
         Z+NiJasizthJxMZp3g7r2BktpFo4t3cxaJnEulfsx9s/KwbJkurQLd+xc5qPvIYYYgsI
         Fb2g==
X-Gm-Message-State: AAQBX9f6fU72acJQpAzrrGPr/g5NhnO5WU44cEB1itWjkHeQ/KyueaRm
        MXQDfrFgFScAzuruS9xz4asOOEr3Nx+hZhnvhcCTmz6kVnp3wxOdpESV5CixCouDLbyu7qjnSH2
        CmbMo36rJYcW1t38X
X-Received: by 2002:adf:ee91:0:b0:2f0:2e16:7e0c with SMTP id b17-20020adfee91000000b002f02e167e0cmr14022953wro.26.1682356195279;
        Mon, 24 Apr 2023 10:09:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350YHammZSSXtFBRiRgQbIBE6xsn5b0O7mWQ6zsuEYOSTLmqZ/wx8guTLKGPMZOG3vHcfAOeOBg==
X-Received: by 2002:adf:ee91:0:b0:2f0:2e16:7e0c with SMTP id b17-20020adfee91000000b002f02e167e0cmr14022941wro.26.1682356195016;
        Mon, 24 Apr 2023 10:09:55 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id z4-20020a05600c0a0400b003ef4cd057f5sm16353354wmp.4.2023.04.24.10.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 10:09:54 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 7/8] lib: add test for for_each_numa_{cpu,hop_mask}()
In-Reply-To: <20230420051946.7463-8-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-8-yury.norov@gmail.com>
Date:   Mon, 24 Apr 2023 18:09:52 +0100
Message-ID: <xhsmh8rehkxzz.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/23 22:19, Yury Norov wrote:
> +	for (node = 0; node < sched_domains_numa_levels; node++) {
> +		unsigned int hop, c = 0;
> +
> +		rcu_read_lock();
> +		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
> +			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
> +		rcu_read_unlock();
> +	}

I'm not fond of the export of sched_domains_numa_levels, especially
considering it's just there for tests.

Furthermore, is there any value is testing parity with
cpumask_local_spread()? Rather, shouldn't we check that using this API does
yield CPUs of increasing NUMA distance?

Something like

        for_each_node(node) {
                unsigned int prev_cpu, hop = 0;

                cpu = cpumask_first(cpumask_of_node(node));
                prev_cpu = cpu;

                rcu_read_lock();

                /* Assert distance is monotonically increasing */
                for_each_numa_cpu(cpu, hop, node, cpu_online_mask) {
                        expect_ge_uint(cpu_to_node(cpu), cpu_to_node(prev_cpu));
                        prev_cpu = cpu;
                }

                rcu_read_unlock();
        }

