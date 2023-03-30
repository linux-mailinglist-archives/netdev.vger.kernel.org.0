Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1C6D0982
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbjC3P0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjC3P0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:26:34 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715D0E395
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:26:08 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v6-20020a05600c470600b003f034269c96so1795534wmo.4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:26:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680189847; x=1682781847;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VlGPtSrw2R8pqr0Pj4WWPKBB0VVInHmRW+IQGsnGCo8=;
        b=eeCRKwnOzj+fIZkz2lZ9ph+p5BFaEt3Ydig0/MhwnYN3qGpBLF3r5OCcsNxmp6e9W5
         YT/lGhu8NQKCqdSQBFrbdRPDzmbglT7kkB0prRit992+PVO+JkTxzPSq+7cnBQJHeghW
         10v3bdtTk13ATOlS32luMOF2cfdQGLkUMGk3FuGy6NeVj7ewUxuhYvRiHvwxKKatBc9X
         1FKYqxaCH9ATJUvA9gfp0sId1qAdCdw50W4LkoU1i+xxjpod6uxeoDFVmivmfhkCZMNr
         6I3ZTNg6Ql4q7O7i3O3D40siFOqbRS+9Pc5ChKVtsc8y7n3PNe7I8XQ6+PeSqxhJ74aW
         69Sw==
X-Gm-Message-State: AAQBX9fPxm6tzpKaKOqb/JPHyFYrybf7GKdJ46HKT1HALdQXNNBt2CpZ
        P+SeMcEgSD3tD9xsr8Kz99A=
X-Google-Smtp-Source: AKy350Zp8ga7rUElh7ZS66R//b9iDODBzsxym/l0056NcE0QKDadMpst3XEgpILsxVkgH3yFbtEz4A==
X-Received: by 2002:a05:600c:4f4e:b0:3f0:330b:d316 with SMTP id m14-20020a05600c4f4e00b003f0330bd316mr3480367wmq.3.1680189846847;
        Thu, 30 Mar 2023 08:24:06 -0700 (PDT)
Received: from [10.100.102.14] (85.65.206.11.dynamic.barak-online.net. [85.65.206.11])
        by smtp.gmail.com with ESMTPSA id c9-20020a5d4cc9000000b002d21379bcabsm33073548wrt.110.2023.03.30.08.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 08:24:06 -0700 (PDT)
Message-ID: <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
Date:   Thu, 30 Mar 2023 18:24:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Boris Pismenny <borisp@nvidia.com>, john.fastabend@gmail.com,
        "kuba@kernel.org" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
        Chuck Lever <chuck.lever@oracle.com>,
        kernel-tls-handshake@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230329135938.46905-1-hare@suse.de>
 <20230329135938.46905-11-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230329135938.46905-11-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> kTLS does not support MSG_EOR flag for sendmsg(), and in general
> is really picky about invalid MSG_XXX flags.

CC'ing TLS folks.

Can't tls simply ignore MSG_EOR instead of consumers having to be 
careful over it?

> So ensure that the MSG_EOR flags is blanked out for TLS, and that
> the MSG_SENDPAGE_LAST is only set if we actually do sendpage().

You mean MSG_SENDPAGE_NOTLAST.

It is also a bit annoying that a tls socket dictates different behavior
than a normal socket.

The current logic is rather simple:
if more data comming:
	flags = MSG_MORE | MSG_SENDPAGE_NOTLAST
else:
	flags = MSG_EOR

Would like to keep it that way for tls as well. Can someone
explain why this is a problem with tls?
