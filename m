Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9C6D9B19
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbjDFOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239546AbjDFOtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE9A9037
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 07:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680792457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqJoxuZqB8p7t31oqnlEDDnV9FoOSn0+PyfGOBC1Qj4=;
        b=JRhU+Td29EGgAVPfX8VIX5B6tzO4A4vjNweuRJxRgA2RCihyNEcmPi8KpFB0D7iRsXq08f
        jw03c01BriGKrnuaAOiQTj2Zj2SDD2gWEqC5psr5mpglUqZJWjEK/lChr9nUav8ZfdCkG7
        cLg7aR8DIJKkH272GqXEhXKvoOyyyLs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-HbQbdxFpPWeScqcHE7qQeg-1; Thu, 06 Apr 2023 10:47:36 -0400
X-MC-Unique: HbQbdxFpPWeScqcHE7qQeg-1
Received: by mail-qt1-f197.google.com with SMTP id v7-20020a05622a188700b003e0e27bbc2eso26796382qtc.8
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 07:47:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680792455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqJoxuZqB8p7t31oqnlEDDnV9FoOSn0+PyfGOBC1Qj4=;
        b=Ixu512aZp2if1Y0+s0ggujm+Of3BH4gJ+DMIYU6bYkn8VrY1TOI7USqsQn5phKRDen
         P7Hv7VXHm5zgv3dPF3tGKx9tcPqNh6eA8rW40t1ovg0VO7gCwvedVFr6n3GTBZ5YAspT
         H2lGAvJ9Q9z71PF7nj60hyRleK5/FpkwA/yyUtnbS2Ee3pYKUlP9WPf4COgJBeUFUBS6
         6dH1zMZR6/Epji8FditBMSS2lY9qZ3TZ3P2nC920MTmiUqeHguSrMHW+bcSKYX0FT9Id
         kivDyE8NwoXqtI0+XauOdFx5v/21VRvo8D/hgKif7J7ni72ri0qgWLJvWKO97kqz0qnM
         VYaQ==
X-Gm-Message-State: AAQBX9eS/jBWzb5barInEYgTI/QuF7Lw80TN+BHoP1j5bdn8kozpSKZV
        1n7hcAOHzep4GPfX7R/qMa9Y4HGt/6NcRJS60l8cyv0UWMbTU/IM4Frh88vZSYFntn/mnkIh3aW
        K8ecpJAdvJN3aXRjc
X-Received: by 2002:a05:6214:2627:b0:56e:aa8b:90f1 with SMTP id gv7-20020a056214262700b0056eaa8b90f1mr4727238qvb.44.1680792455678;
        Thu, 06 Apr 2023 07:47:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y7ytwepCy7XZqV/rN+2yVxegU1gmuMAzQOERBu0op+ju0pj/DV5S6i345G/bTgJhtuFtDcEg==
X-Received: by 2002:a05:6214:2627:b0:56e:aa8b:90f1 with SMTP id gv7-20020a056214262700b0056eaa8b90f1mr4727215qvb.44.1680792455451;
        Thu, 06 Apr 2023 07:47:35 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id d7-20020ac85347000000b003e3982a6f2bsm468369qto.18.2023.04.06.07.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 07:47:34 -0700 (PDT)
Message-ID: <82b9a494-3cb6-5931-3f13-2b891a6dfb09@redhat.com>
Date:   Thu, 6 Apr 2023 10:47:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv2 net 2/3] selftests: bonding: re-format bond option tests
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20230406082352.986477-1-liuhangbin@gmail.com>
 <20230406082352.986477-3-liuhangbin@gmail.com>
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20230406082352.986477-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/23 04:23, Hangbin Liu wrote:
> To improve the testing process for bond options, A new bond topology lib
> is added to our testing setup. The current option_prio.sh file will be
> renamed to bond_options.sh so that all bonding options can be tested here.
> Specifically, for priority testing, we will run all tests using modes
> 1, 5, and 6. These changes will help us streamline the testing process
> and ensure that our bond options are rigorously evaluated.
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

