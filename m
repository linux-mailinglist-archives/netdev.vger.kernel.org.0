Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67BE6D4CA0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjDCPwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbjDCPwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:52:22 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC7344B7
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:51:59 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so14713943wms.5
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680537071; x=1683129071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e7litT2ku0CKU9M7PH5y/5Y+4vyCKFBTn5xjvf/oTZA=;
        b=FuSw5DAKz+Hg0RXyuaoZn/jdQ86urSHFzYZRW+IWdQNrlpvhFB3vFrt+UQ65qLxyrq
         h3UKYlpU8ozXl8L49ecLPJal2q3eYjrqABR3a0aaoT9ALLcVm6z7kVhkSdYodZI5sMKH
         QU59dGaT5hV60i1RgpJ+P47Z9IJ2DqveEudprt5zeLTW/PvPJuPNxdMnxs8gad6ljtX5
         yXFFKDKiQ2WuedKoinr680hQ5oy+IXgijRrsmfax7Pide1XnyyXzhkHn+YG4TRqK3UsG
         Y/4gOYyHtQWYO0/rmD5J7FpSPY/Tq5DZK377hT+U5DFtOPrYBbhU+pGrCd50L1EiBxuA
         3bLQ==
X-Gm-Message-State: AAQBX9euUlEe1VAYGhvt5od7Yy/es0U/6VnlNN+eSeXT2mgkF+NBUxtA
        br+1acRLNWDmnCTS3lLLmbE=
X-Google-Smtp-Source: AKy350axQSLF/hDT9cyBm7N2x/F0vRpfgcI7KPkQaOL3AJPv/qmBdqmepUfbm4XQU7KMQjLPYkQ17A==
X-Received: by 2002:a05:600c:1c82:b0:3ed:d2ae:9adb with SMTP id k2-20020a05600c1c8200b003edd2ae9adbmr37206wms.0.1680537071615;
        Mon, 03 Apr 2023 08:51:11 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003ede06f3178sm12420692wmc.31.2023.04.03.08.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 08:51:11 -0700 (PDT)
Message-ID: <c7a07e1d-b300-dd1d-1be6-311666387820@grimberg.me>
Date:   Mon, 3 Apr 2023 18:51:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Boris Pismenny <borisp@nvidia.com>, john.fastabend@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
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
 <44fe87ba-e873-fa05-d294-d29d5e6dd4b5@grimberg.me>
 <20230403075946.26ad71ee@kernel.org>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230403075946.26ad71ee@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>> Some of the flags are call specific, others may be internal to the
>>>> networking stack (e.g. the DECRYPTED flag). Old protocols didn't do
>>>> any validation because people coded more haphazardly in the 90s.
>>>> This lack of validation is a major source of technical debt :(
>>>
>>> A-ha. So what is the plan?
>>> Should the stack validate flags?
>>> And should the rules for validating be the same for all protocols?
>>
>> MSG_SENDPAGE_NOTLAST is not an internal flag, I thought it was
>> essentially similar semantics to MSG_MORE but for sendpage. It'd
>> be great if this can be allowed in tls (again, at the very least
>> don't fail but continue as if it wasn't passed).
> 
> .. but.. MSG_SENDPAGE_NOTLAST is supported in TLS, isn't it?
> Why are we talking about it?

Ah, right.

What I'm assuming that Hannes is tripping on is that tls does
not accept when this flag is sent to sock_no_sendpage, which
is simply calling sendmsg. TLS will not accept this flag when
passed to sendmsg IIUC.

Today the rough logic in nvme send path is:

	if (more_coming(queue)) {
		flags = MSG_MORE | MSG_SENDPAGE_NOTLAST;
	} else {
		flags = MSG_EOR;
	}

	if (!sendpage_ok(page)) {
		kernel_sendpage();
	} else {
		sock_no_sendpage();
	}

This pattern (note that sock_no_sednpage was added later following bug
reports where nvme attempted to sendpage a slab allocated page), is
perfectly acceptable with normal sockets, but not with TLS.

So there are two options:
1. have tls accept MSG_SENDPAGE_NOTLAST in sendmsg (called from
    sock_no_sendpage)
2. Make nvme set MSG_SENDPAGE_NOTLAST only when calling
    kernel_sendpage and clear it when calling sock_no_sendpage

If you say that MSG_SENDPAGE_NOTLAST must be cleared when calling
sock_no_sendpage and it is a bug that it isn't enforced for normal tcp
sockets, then we need to change nvme, but I did not find
any documentation that indicates it, and right now, normal sockets
behave differently than tls sockets (wrt this flag in particular).

Hope this clarifies.
