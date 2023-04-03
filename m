Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304CC6D54CA
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjDCWgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjDCWgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:36:18 -0400
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA54CF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:36:16 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id r11so123320714edd.5
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 15:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680561375; x=1683153375;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCRq1DTHGtVBTQJoDR0JwSt/krJ9xvX8WNwgXlKdvaM=;
        b=SSSOfUdTOwIwPzWAg/ZtFF48DuwiY4vvrnnnrzChf1QH4rG/cMVB4qu0X7KGR2ESXv
         tescQRunfaFrc8xaA0mR4YaqA6t0HpGfDF7i0FKZXDN/p78exhDV4NZvu9eAVcm5PA3t
         jRkxoCoi/vq1JE2L6XSacHZD0fTXYNeId4AC5Fr1K31wJZPi8VkllWD3uyuEM2sMSgR/
         5ERpxijm4TZqrTYtNTDytuSuMf1b94plzsyFS6mZQVOWCnnHszFAOdiEYDzA4Ad95Z9a
         JNMkGk5DfkgB1+4YtF/oQihr9nRP+2062/xnXdL6bEd5pSFmCQen04YZrearK1XoyaJQ
         4vXw==
X-Gm-Message-State: AAQBX9cq8sqD093JkmJrCc1vxXolTpJoLJI6NLSxYf6ieqR7Mr7F3P+q
        xyg+7yYspHV0iws+A0GFlmM=
X-Google-Smtp-Source: AKy350Yj9cdwFejMnGHyvP+jrUhICombvO6Omof3QfNzroLlnMkhoWjiDvKAlOXIXOh5flZmEGahag==
X-Received: by 2002:a17:906:c:b0:931:4285:ea16 with SMTP id 12-20020a170906000c00b009314285ea16mr202891eja.7.1680561374628;
        Mon, 03 Apr 2023 15:36:14 -0700 (PDT)
Received: from [10.100.102.14] (85.65.206.11.dynamic.barak-online.net. [85.65.206.11])
        by smtp.gmail.com with ESMTPSA id l15-20020a17090612cf00b009222a7192b4sm5054386ejb.30.2023.04.03.15.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 15:36:14 -0700 (PDT)
Message-ID: <6b4fb6d0-7090-96cb-c780-87c65c2d71a7@grimberg.me>
Date:   Tue, 4 Apr 2023 01:36:12 +0300
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
 <c7a07e1d-b300-dd1d-1be6-311666387820@grimberg.me>
 <20230403114835.61946198@kernel.org>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230403114835.61946198@kernel.org>
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



On 4/3/23 21:48, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 18:51:09 +0300 Sagi Grimberg wrote:
>> What I'm assuming that Hannes is tripping on is that tls does
>> not accept when this flag is sent to sock_no_sendpage, which
>> is simply calling sendmsg. TLS will not accept this flag when
>> passed to sendmsg IIUC.
>>
>> Today the rough logic in nvme send path is:
>>
>> 	if (more_coming(queue)) {
>> 		flags = MSG_MORE | MSG_SENDPAGE_NOTLAST;
>> 	} else {
>> 		flags = MSG_EOR;
>> 	}
>>
>> 	if (!sendpage_ok(page)) {
>> 		kernel_sendpage();
>> 	} else {
>> 		sock_no_sendpage();
>> 	}
>>
>> This pattern (note that sock_no_sednpage was added later following bug
>> reports where nvme attempted to sendpage a slab allocated page), is
>> perfectly acceptable with normal sockets, but not with TLS.
>>
>> So there are two options:
>> 1. have tls accept MSG_SENDPAGE_NOTLAST in sendmsg (called from
>>      sock_no_sendpage)
>> 2. Make nvme set MSG_SENDPAGE_NOTLAST only when calling
>>      kernel_sendpage and clear it when calling sock_no_sendpage
>>
>> If you say that MSG_SENDPAGE_NOTLAST must be cleared when calling
>> sock_no_sendpage and it is a bug that it isn't enforced for normal tcp
>> sockets, then we need to change nvme, but I did not find
>> any documentation that indicates it, and right now, normal sockets
>> behave differently than tls sockets (wrt this flag in particular).
>>
>> Hope this clarifies.
> 
> Oh right, it does, the context evaporated from my head over the weekend.
> 
> IMHO it's best if the caller passes the right flags. The semantics of
> MSG_MORE vs NOTLAST are quite murky and had already caused bugs in the
> past :(
> 
> See commit d452d48b9f8b ("tls: prevent oversized sendfile() hangs by
> ignoring MSG_MORE")

Well, that is fine with me. This may change anyways with
the new MSG_SPLICE_PAGES from David.

> Alternatively we could have sock_no_sendpage drop NOTLAST to help
> all protos. But if we consider sendfile behavior as the standard
> simply clearing it isn't right, it should be a:
> 
> 	more = (flags & (MORE | NOTLAST)) == MORE | NOTLAST
> 	flags &= ~(MORE | NOTLAST)
> 	if (more)
> 		flags |= MORE

I don't think this would be the best option. Requiring callers
to clear NOTLAST if not calling sendpages is reasonable, but we
need to have this consistent. And also fix this pattern for the
rest of the kernel socket consumers that use this flag.
