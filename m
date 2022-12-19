Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAD3650876
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 09:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiLSIRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 03:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSIRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 03:17:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCF3BCAB
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 00:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671437811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/8QD47lJ78Es8HKcQbvS+wNA/WMPBK4QBWOLN4bwuY=;
        b=gbj2k4Bq63lY6VGnOcJe55w8yAWHfz2HEf2S4p2klCs4XPd2ZKG0MW8MCxb4q1ffUw+GKg
        EUQoIQgUBtJS1NWAdjwt1WIPWE+BfxHtc2PN+6Nx6LcVCQUS4gkHAc9t/zPiWgNdSPkSB2
        EaCHnQ1bVrAmBypTcjlSRQmqkqZUVdg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-OFgMfdVwMZWez9SqYofLLQ-1; Mon, 19 Dec 2022 03:16:50 -0500
X-MC-Unique: OFgMfdVwMZWez9SqYofLLQ-1
Received: by mail-wr1-f70.google.com with SMTP id c13-20020adfa70d000000b0024853fb8766so1264318wrd.11
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 00:16:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O/8QD47lJ78Es8HKcQbvS+wNA/WMPBK4QBWOLN4bwuY=;
        b=dpWfL12aS0ApBpKZq7VB45XjpmOsJydXSchzLOP2v6neu5YzPQ0Jcjqg/1ti8mFO+O
         /9c6L7INImg/EFXlhTJaXLZZ5bRI29lyOcD0sbR2ZNfnNA6QJnEuJ/viCOAGqwqWBpF3
         R1HDDfJvqK5/bOQpbbJZrBxZQS4gIQItGq9JUZPCjrIcr1ylgT45Qt6QuahBVSFlyhOj
         IpYRN9PjEcmBvTD2xVGSVWGM7+MpRrNdeFxMqZ7uNx2FYVB+3pRL7kn9WK5e5E3ErNIB
         0L+vyAoebToOnsMrHMT213dBWPRNrE80Z7TmwNiHUIZSBd1n39O9J2evTEgPbRPGCgiF
         23Rw==
X-Gm-Message-State: ANoB5pnTR6/IR32AqDj090GaK3HcQRiNVXyyPz3lgxTKzbyP+LqlrULd
        D7SJxN5ee60iYo6OSJT4VttLAgWnzys9eavAokBni1M75X5HdyWa+hF2jMjyYzZIqgBw2388M9o
        dkPnReBQ+b3ci4qjB
X-Received: by 2002:a05:600c:3ac8:b0:3c6:e63e:89c5 with SMTP id d8-20020a05600c3ac800b003c6e63e89c5mr31746315wms.33.1671437807231;
        Mon, 19 Dec 2022 00:16:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7iUf4ddwpo7Y8w2tsc+iO22SDjDzmmSFS/Vpf0uNX5dVxRWiTFQmLuWd8swEEZB14QYXIAIQ==
X-Received: by 2002:a05:600c:3ac8:b0:3c6:e63e:89c5 with SMTP id d8-20020a05600c3ac800b003c6e63e89c5mr31746306wms.33.1671437806995;
        Mon, 19 Dec 2022 00:16:46 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id g26-20020a7bc4da000000b003c65c9a36dfsm11187806wmk.48.2022.12.19.00.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 00:16:46 -0800 (PST)
Message-ID: <f2b3cabc7e0d20f647fc23f5943cd639bfe6aa27.camel@redhat.com>
Subject: Re: [Patch net] net_sched: reject TCF_EM_SIMPLE case for complex
 ematch module
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com,
        Jun Nie <jun.nie@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 19 Dec 2022 09:16:45 +0100
In-Reply-To: <20221217221707.46010-1-xiyou.wangcong@gmail.com>
References: <20221217221707.46010-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-12-17 at 14:17 -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When TCF_EM_SIMPLE was introduced, it is supposed to be convenient
> for ematch implementation:
> 
> https://lore.kernel.org/all/20050105110048.GO26856@postel.suug.ch/
> 
> "You don't have to, providing a 32bit data chunk without TCF_EM_SIMPLE
> set will simply result in allocating & copy. It's an optimization,
> nothing more."
> 
> So if an ematch module provides ops->datalen that means it wants a
> complex data structure (saved in its em->data) instead of a simple u32
> value. We should simply reject such a combination, otherwise this u32
> could be misinterpreted as a pointer.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-and-tested-by: syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com
> Reported-by: Jun Nie <jun.nie@linaro.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/sched/ematch.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/ematch.c b/net/sched/ematch.c
> index 4ce681361851..5c1235e6076a 100644
> --- a/net/sched/ematch.c
> +++ b/net/sched/ematch.c
> @@ -255,6 +255,8 @@ static int tcf_em_validate(struct tcf_proto *tp,
>  			 * the value carried.
>  			 */
>  			if (em_hdr->flags & TCF_EM_SIMPLE) {
> +				if (em->ops->datalen > 0)
> +					goto errout;
>  				if (data_len < sizeof(u32))
>  					goto errout;
>  				em->data = *(u32 *) data;


The patch LGTM, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

If I read correctly, this effectively rejects any ematch with
TCF_EM_SIMPLE set (all the existing tcf_ematch_ops structs have eiter
.change or . datalen > 0).

It looks like EM_SIMPLE does not work as intended since a lot of time
(possibly since its introduction !?!). Can we drop it completely?

Cheers,

Paolo

