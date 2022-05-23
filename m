Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5A9530EEE
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiEWLb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiEWLb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:31:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCE236E0E;
        Mon, 23 May 2022 04:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC846B81014;
        Mon, 23 May 2022 11:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33631C385A9;
        Mon, 23 May 2022 11:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653305515;
        bh=ec/8ICRiIA0J8KQbodu4J3bWjx7guSjaJnAwLaZGMX4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dQizoHBLLVHuA3n7nqEfZI++hCTQbJHicLcfHSH/o17PYAIPjNqCNjRmH1zRNa70U
         k6JL9Qx9HHRuPQ/RDggsbYIzN5gEXNTxRshBY3YuOOisHu5lD9v5+Axnem6zzGqC6g
         9da0NUsOF5VKxk4txqaFArTcmYDWxVT3Ku2H8RY2S/O+3Gb95ZkjelB+yrJaJNqfxf
         hzRYuOb1srEuafbL5rjexfvb9qsGOXSrPQhuIdJoi6zZjwwtYWww2inEeFm9KlTEHc
         J6yumbfutNVJcClnaZYsU1vQsjMt2oMw7mn9od0+VdtLyj63Y9ds+G64idfz9NhIoj
         uFW94L1PYooNA==
From:   Kalle Valo <kvalo@kernel.org>
To:     duoming@zju.edu.cn
Cc:     "Greg KH" <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
References: <20220523052810.24767-1-duoming@zju.edu.cn>
        <YosqUjCYioGh3kBW@kroah.com>
        <41a266af.2abb6.180efa8594d.Coremail.duoming@zju.edu.cn>
Date:   Mon, 23 May 2022 14:31:48 +0300
In-Reply-To: <41a266af.2abb6.180efa8594d.Coremail.duoming@zju.edu.cn>
        (duoming's message of "Mon, 23 May 2022 14:43:49 +0800 (GMT+08:00)")
Message-ID: <87r14kzdqz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding Johannes)

duoming@zju.edu.cn writes:

>> > --- a/lib/kobject.c
>> > +++ b/lib/kobject.c
>> > @@ -254,7 +254,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>> >  	if (kobj->name && !fmt)
>> >  		return 0;
>> >  
>> > -	s = kvasprintf_const(GFP_KERNEL, fmt, vargs);
>> > +	s = kvasprintf_const(GFP_ATOMIC, fmt, vargs);
>> >  	if (!s)
>> >  		return -ENOMEM;
>> >  
>> > @@ -267,7 +267,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>> >  	if (strchr(s, '/')) {
>> >  		char *t;
>> >  
>> > -		t = kstrdup(s, GFP_KERNEL);
>> > +		t = kstrdup(s, GFP_ATOMIC);
>> >  		kfree_const(s);
>> >  		if (!t)
>> >  			return -ENOMEM;
>> 
>> Please no, you are hurting the whole kernel because of one odd user.
>> Please do not make these calls under atomic context.
>
> Thanks for your time and suggestions. I will remove the gfp_t
> parameter of dev_coredumpv in order to show it could not be used in
> atomic context.

In a way it would be nice to be able to call dev_coredump from atomic
contexts, though I don't know how practical it actually is. Is there any
other option? What about adding a gfp_t parameter to dev_set_name()? Or
is there an alternative for dev_set_name() which can be called in atomic
contexts?

Johannes&Greg, any ideas?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
