Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5C6D4441
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjDCMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCMUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:20:19 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826BAE393
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:20:17 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so67570wmb.3
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 05:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680524416; x=1683116416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLTeks8eELiIGcTY5wF4oXdJ+bPSmjNFBcw73Z/uIUE=;
        b=1FpsY8sTMvYCmlpkJksoHj2ol1br1amPLFFRWH+YE9j2BuypGQQd26dzEzYEvh/wbm
         42a+ev6ClGSZupSWMjR6/nvgUhPq/JE7RGPI8Bi6kxRLYDwUWA+CLMDCT68m1BZcUht6
         wi0/8rnG4UZiadIIFOWDagjCQV03E5HvMjPbypzKhJEHmwfn8niay0p8E6P/RSGjfDu/
         65mTWNIAHQXJ4UTFUBUtLY5fR+0M55nZX9REq48X8KFqcyn77lQbAW7nhUcjioc6qCpe
         7ylCnA9CDWDbxH08NiPtYSmR/7BwLB7C6CLXGFh+mAH/naMMIm61wGjvWBt+Uyy9CbLt
         fb+w==
X-Gm-Message-State: AAQBX9cWgp5fJdB18etMtUlR6lsmRYUQXueD6d+UyOP4sOWAU6B9Qam3
        IwvSLLPVbmxbKYaC8e1nhGw=
X-Google-Smtp-Source: AKy350YxmO96TAvXra/msTOS7cA1FwhAgYJY37TVSY7/z3X8F/c5jraEpEwEAHhi8th5HWQB1BJOjA==
X-Received: by 2002:a05:600c:3b8a:b0:3f0:34cb:a542 with SMTP id n10-20020a05600c3b8a00b003f034cba542mr11934460wms.2.1680524415877;
        Mon, 03 Apr 2023 05:20:15 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id y4-20020a056000108400b002cfec8b7f89sm9670709wrw.77.2023.04.03.05.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 05:20:15 -0700 (PDT)
Message-ID: <44fe87ba-e873-fa05-d294-d29d5e6dd4b5@grimberg.me>
Date:   Mon, 3 Apr 2023 15:20:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Boris Pismenny <borisp@nvidia.com>,
        john.fastabend@gmail.com, Paolo Abeni <pabeni@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org,
        Chuck Lever <chuck.lever@oracle.com>,
        kernel-tls-handshake@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230329135938.46905-1-hare@suse.de>
 <20230329135938.46905-11-hare@suse.de>
 <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
 <20230330224920.3a47fec9@kernel.org>
 <7f057726-8777-2fd3-a207-b3cd96076cb9@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <7f057726-8777-2fd3-a207-b3cd96076cb9@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Jakub, Hannes.

>>>> kTLS does not support MSG_EOR flag for sendmsg(), and in general
>>>> is really picky about invalid MSG_XXX flags.
>>>
>>> CC'ing TLS folks.
>>>
>>> Can't tls simply ignore MSG_EOR instead of consumers having to be
>>> careful over it?
>>
>> I think we can support EOR, I don't see any fundamental problem there.

It would help at least one consumer (nvme-tcp) to not change its
behavior between tls and non-tls. At the very minimum don't fail
the send operation (just do the same as if it wasn't passed).

>>>> So ensure that the MSG_EOR flags is blanked out for TLS, and that
>>>> the MSG_SENDPAGE_LAST is only set if we actually do sendpage().
>>>
>>> You mean MSG_SENDPAGE_NOTLAST.
>>>
>>> It is also a bit annoying that a tls socket dictates different behavior
>>> than a normal socket.
>>>
>>> The current logic is rather simple:
>>> if more data comming:
>>>     flags = MSG_MORE | MSG_SENDPAGE_NOTLAST
>>> else:
>>>     flags = MSG_EOR
>>>
>>> Would like to keep it that way for tls as well. Can someone
>>> explain why this is a problem with tls?
>>
>> Some of the flags are call specific, others may be internal to the
>> networking stack (e.g. the DECRYPTED flag). Old protocols didn't do
>> any validation because people coded more haphazardly in the 90s.
>> This lack of validation is a major source of technical debt :(
> 
> A-ha. So what is the plan?
> Should the stack validate flags?
> And should the rules for validating be the same for all protocols?

MSG_SENDPAGE_NOTLAST is not an internal flag, I thought it was
essentially similar semantics to MSG_MORE but for sendpage. It'd
be great if this can be allowed in tls (again, at the very least
don't fail but continue as if it wasn't passed).

If this turns out to be a big project, I would prefer to change
nvme-tcp for now in order not to block nvme tls support (although it is
a hidden capability interface, which is always bad).
