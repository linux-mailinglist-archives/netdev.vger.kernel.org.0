Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0999A510075
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbiDZOcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbiDZOcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:32:15 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD9E7CDF9;
        Tue, 26 Apr 2022 07:29:07 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id q23so12853617wra.1;
        Tue, 26 Apr 2022 07:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dPUzsVpQReDWK1+ZM1EtiHimITChzlKcI/0hyy3fCmQ=;
        b=MTITUZYWTSu3AzjYB7xgegauqfphORCVwrXTvoK/kd0IrXaNnpkvcdgCNs1wMwD5NG
         BFuItOUyNe4yKw9Btukt1gF2z4LJ4lC0OznUqmBDeLWtjjCVoxC2tykuDiNlm+8PK+hp
         3h3zRyRYVxQlg4zB89whhpW1wteomt18/tM0x69cUocqxfqSaXIOFGZpuz8IQTS6FPrz
         GZIBKgIeNLSeJpois+2ieIJZDUCva0ZWZQldG88alBTj678rNrfU/Z3clEwcTEp5i7yX
         e5OnSoD2Iqp9s9CwTvQxKSs3BcElknhzLwKsLjGyhp2KxbTrD5iBMhjmp+Vw9PhwD9ds
         Yxxw==
X-Gm-Message-State: AOAM5313q/J9puMj8sEfQJWfXNR5QVREU/EYVPb+1QnE7jbcVPkXa8eS
        vqL8JFW30xow+3p4bI6oyfM=
X-Google-Smtp-Source: ABdhPJzLjm32+x3PjFCtSgMX6CN/Awx9lzUWh+rzYyIYYtIJXXx/shQgSzAsNJny+Z1OwEIo5XILtA==
X-Received: by 2002:adf:8b90:0:b0:207:87ef:2720 with SMTP id o16-20020adf8b90000000b0020787ef2720mr18310239wra.567.1650983346024;
        Tue, 26 Apr 2022 07:29:06 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c190800b00393e80a7970sm7318361wmq.7.2022.04.26.07.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 07:29:05 -0700 (PDT)
Message-ID: <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
Date:   Tue, 26 Apr 2022 17:29:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ak@tempesta-tech.com,
        borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> Currently the prototype does not handle multiple listeners that
>>> overlap -- multiple listeners in the same net namespace that have
>>> overlapping bind addresses.
>>
>> Create the socket in user space, do all the handshakes you need there
>> and then pass it to the kernel.  This is how NBD + TLS works.  Scales
>> better and requires much less kernel code.
>>
> But we can't, as the existing mechanisms (at least for NVMe) creates the 
> socket in-kernel.
> Having to create the socket in userspace would require a completely new 
> interface for nvme and will not be backwards compatible.

And we will still need the upcall anyways when we reconnect 
(re-establish the socket)
