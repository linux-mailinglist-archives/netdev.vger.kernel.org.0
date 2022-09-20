Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F61F5BE776
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiITNpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiITNpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:45:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B312F39BA4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663681531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DxHKjrVMawJTVmFBN2tlPLoDEtk3zoTr+D6pCmrZ1R0=;
        b=VvFmJ6vAIfCOanvll3AyWCVNfbODiT3HGL3TiskL7wWvcuTAeO0ZDj4jdUdlu5QHW3WII3
        E7d9rOA6vvMaFm8vBeedxSdCJ6e4vWcs/4mp/ZT4Qd86o9obeTfS7VrYnWwxYu76ipzfbX
        02GK0L7L2e/C15KmKeuYt79CsQxfYsU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-g1T6ZTqAMNmk-bAszdas3w-1; Tue, 20 Sep 2022 09:45:30 -0400
X-MC-Unique: g1T6ZTqAMNmk-bAszdas3w-1
Received: by mail-ed1-f71.google.com with SMTP id dz21-20020a0564021d5500b0045217702048so1908928edb.5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=DxHKjrVMawJTVmFBN2tlPLoDEtk3zoTr+D6pCmrZ1R0=;
        b=XGiH1cSSh04IPn1i6VaMob5tWirsF1qVTo323e0XyLd7nGVKGDQIxVidAuwNtnoKDG
         CKQXe6+WE5uKi9X5J0OjJxy0gZDBxH2YRzrMqwlqdtNSRkZhrlP7/oif5ETgmKiS2PoI
         8Zc27VfwPl26+oz572zJL+CCRZVUk8MneVg0hpO6G+vOKkzAKSS+9zuxROA8Ee42PUbp
         yvvyzix7X2MVM+ZI4hxpB77MGDmGJAlCXsSZ7ogAr+NhE4PcPOCIe1O5A4KlUuKKv6IO
         ZldR6YDMsxfON/mezBBwO4vyARYOdwPYdOQcqGyIiTRY3eqHxjyft3nVCqjRq5SyTWb0
         KAMA==
X-Gm-Message-State: ACrzQf3NhGlV4TnzaYLsHP4MZ74a7ePePcFoMO3cmlZgjR2rVHsWa2Br
        i6mSh947VtQDO5yIi6jkzpWknxVTKOSPyZns3WKPjdo2cj/e5HPJb15FZ+OkEzYhPzdYOfvfR7U
        0qZZXlaSTqwM2+C1e
X-Received: by 2002:a17:906:ef8c:b0:77c:8d9a:9aed with SMTP id ze12-20020a170906ef8c00b0077c8d9a9aedmr17889344ejb.704.1663681527165;
        Tue, 20 Sep 2022 06:45:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7E33JWAP3AhjFxcYXywbXSv1ZvnnxSk+uY3JXkypwF5KGToMYJwipqmJ/n7IuetlIHtn+W/Q==
X-Received: by 2002:a17:906:ef8c:b0:77c:8d9a:9aed with SMTP id ze12-20020a170906ef8c00b0077c8d9a9aedmr17889281ejb.704.1663681526444;
        Tue, 20 Sep 2022 06:45:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g13-20020a170906c18d00b0078015cebd8csm905122ejz.117.2022.09.20.06.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:45:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4842D61C33C; Tue, 20 Sep 2022 15:45:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vinicius.gomes@intel.com,
        stephen@networkplumber.org, shuah@kernel.org, victor@mojatatu.com
Cc:     zhijianx.li@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, shaozhengchao@huawei.com
Subject: Re: [PATCH net-next,v2 01/18] net/sched: sch_api: add helper for tc
 qdisc walker stats dump
In-Reply-To: <20220917050217.127342-1-shaozhengchao@huawei.com>
References: <20220917050217.127342-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Sep 2022 15:45:25 +0200
Message-ID: <87sfkmw45m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> The walk implementation of most qdisc class modules is basically the
> same. That is, the values of count and skip are checked first. If
> count is greater than or equal to skip, the registered fn function is
> executed. Otherwise, increase the value of count. So we can reconstruct
> them.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/pkt_sched.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 29f65632ebc5..243e8b0cb7ea 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -222,4 +222,17 @@ static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
>  	return cb;
>  }
>  
> +static inline bool tc_qdisc_stats_dump(struct Qdisc *sch,
> +				       struct qdisc_walker *arg,
> +				       unsigned long cl)
> +{
> +	if (arg->count >= arg->skip && arg->fn(sch, cl, arg) < 0) {

Seems a bit confusing that tc_qdisc_stats_dump() reverses the order of
the 'cl' and 'arg' parameters relative to the callback?

-Toke

