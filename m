Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AAD6EBF17
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDWLK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 07:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDWLK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 07:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492711993
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 04:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682248180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qa5an+pMO/z37xFkKNIb5d1qvmQCeDMySUintGMWRFc=;
        b=hZyAQxig93D7opNlNrGlV4Jhqzaygjfsz6q5Xby9xzIz0d10eqjwoyZnkCxeQIwxp4ITrq
        8n1uaorOvEwg7zudRvc+OyZH1WhQDHFaQSwFU4jEbQxHGDMKnQj3hipmbPl/T5GR4msyde
        rjjOq/8imvravYahmDO0o6LzRnZRzfA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-83J4ls7cMHm4UQJ4DSZ4Yw-1; Sun, 23 Apr 2023 07:09:39 -0400
X-MC-Unique: 83J4ls7cMHm4UQJ4DSZ4Yw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f16ef3be6eso19785315e9.3
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 04:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682248178; x=1684840178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qa5an+pMO/z37xFkKNIb5d1qvmQCeDMySUintGMWRFc=;
        b=lKYZ/AUGhg5AzG5NiuoMrFaUSLynT4EVxixUd9EL9wrC7I/hSYPOmVwz64tfsh1s+r
         5dORa5I2g/8sMwaMck7Y99kvdsTETYDTLO7CZEuhINlaVHb1PHSTsjK+EUAfdvH3e0qV
         oow2OvWXVbM4Hqhw48MhBhap6G/NM+zkp00kPQNnRTrMTX+4/dTTfvYhJLj5ds4sp/3s
         UxRVB+gVV3VZghCo6QsH+G/l8XYOv5z1SEqSXy25FwmsnuQ6GLq+FMCW5S/en/p7we8S
         hgqp6j+Kpmjn/smMpRFvaCBosTZvVpd9++Fp+0invyUXXG5aPP7a2qqs+0YVm2gVUaoT
         GjyQ==
X-Gm-Message-State: AAQBX9cl1yg/eJ8JNAmca5leE9RTzrbLNFvMDZV4QY3ePqKOCgtx5ttE
        WJavS6qrhvPpuyfbwyoohBoy4cbY5nBjug5WlNzAj26xU3aG9hrrLq7lggqq7qv37JExjdkiuAl
        VBECMhSHG9tTeDK+B
X-Received: by 2002:a05:6000:1091:b0:2fb:1d3a:93ff with SMTP id y17-20020a056000109100b002fb1d3a93ffmr7134586wrw.61.1682248177956;
        Sun, 23 Apr 2023 04:09:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350aV4IFxLAe3RJ8HQ8N5xqnVRos1U8Sc00vmSPnpomKazzuEb3lleaW1Py4Fcaqvh482tdyrOA==
X-Received: by 2002:a05:6000:1091:b0:2fb:1d3a:93ff with SMTP id y17-20020a056000109100b002fb1d3a93ffmr7134574wrw.61.1682248177654;
        Sun, 23 Apr 2023 04:09:37 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id bi26-20020a05600c3d9a00b003eddc6aa5fasm9043356wmb.39.2023.04.23.04.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 04:09:37 -0700 (PDT)
Date:   Sun, 23 Apr 2023 07:09:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230423070849-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <20230416163751-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F658DCBF66632A74592BD49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723F658DCBF66632A74592BD49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 06:43:39AM +0000, Alvaro Karsz wrote:
> > > +static int virtnet_validate_vqs(struct virtnet_info *vi)
> > > +{
> > > +     u32 i, min_size = roundup_pow_of_two(MAX_SKB_FRAGS + 2);
> > 
> > why power of two?
> 
> The ring size is always a power of 2,

Not really, packed rings allow non power of 2.
Linux had a bug that it required power of 2 for packed, but
we are fixing that finally.

> so checking against
> MAX_SKB_FRAGS + 2 or against roundup_pow_of_two will result in the
> same, and I think that printing the warning with the actual min value
> is more helpful.  I can check the condition against MAX_SKB_FRAGS + 2,
> and print the rounded value in case of an error.
> 

