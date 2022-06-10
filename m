Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547FF546E91
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350364AbiFJUli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348862AbiFJUlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:41:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E71B369E4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 13:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654893694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i+vQxOmi+riU2VhFCggyMc0sWbKsqz/bI3sl5ByXRes=;
        b=KdeQ2SE7LTNui+3I/4k7v6KSDvcz8Do1qSZcdIIaAtvzgd5uEy2VNebpV5F6oHnOIuXDMF
        6tLw2uideIoKgHVQAlFq97mLpNCEgtrgoKOPNt5RRS56uTpaXWFtWj5wJPHekuiAdyuhxm
        kYk0/L1C2QHnAQwraq8gVIfzg7oSIuo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-23TaxkslOnyNy3JPi0lpyg-1; Fri, 10 Jun 2022 16:41:33 -0400
X-MC-Unique: 23TaxkslOnyNy3JPi0lpyg-1
Received: by mail-ej1-f72.google.com with SMTP id n2-20020a170906724200b006fed87ccbb8so59038ejk.7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 13:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=i+vQxOmi+riU2VhFCggyMc0sWbKsqz/bI3sl5ByXRes=;
        b=t4N4r/una+sYBPl/n8AnzcFnH9yJQCGXg0fMPFxqSvtOopaHAscfPdO0UcMNOyFiD3
         ngBu9mwwR/rMBv/u71sejNFupiVUUB4LFTOySwJJTh07hYJ51tA7WJk/2hqK09qQnRb4
         F4v0507LCW6Xgi8MHFdrve+UO0v4UdPDW34jpzWVb7u3PjTcMagNH58QA1j4LNi3Vz9u
         29ZmEnSQAJaQALr5VBNOd902gNFAObicPHvz96Lwz8DZ0pQnp57tyzEU6yB8uYdjyzdJ
         FuJC4unGFo9NkkradVdVPkOfKQHbdAoC9AQ53YsfCw0ixNErvyysMEUFydwCZSXuojLa
         kIHA==
X-Gm-Message-State: AOAM533ASHIPoBHcwo/nZOc8wxFRFtPoo8+4KnfV/Z5rg07IctFv5NuV
        0rzsuS1SFkGXZVamCOiXfmvOJQrD066Kxtk0Ao/csyKxmP3x72kSI/rw+Tjm6wK0pEWmHN0Bket
        UhsRTLZHHsZdy3WYD
X-Received: by 2002:a05:6402:42d4:b0:416:5cac:a9a0 with SMTP id i20-20020a05640242d400b004165caca9a0mr52539559edc.86.1654893691190;
        Fri, 10 Jun 2022 13:41:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7RdhjJLrtnWZpvxe1bASGP7CnMTMlVmufWQC4ofGDDPr0uyYVmc3g/8VLvipnq41gfVY0Gw==
X-Received: by 2002:a05:6402:42d4:b0:416:5cac:a9a0 with SMTP id i20-20020a05640242d400b004165caca9a0mr52539498edc.86.1654893690437;
        Fri, 10 Jun 2022 13:41:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h16-20020a1709060f5000b00711d0b41bcfsm74837ejj.0.2022.06.10.13.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 13:41:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 15BB7405EFE; Fri, 10 Jun 2022 22:41:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
In-Reply-To: <2f98188b-813b-e226-4962-5c2848998af2@iogearbox.net>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion> <87h74s2s19.fsf@toke.dk>
 <2f98188b-813b-e226-4962-5c2848998af2@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jun 2022 22:41:29 +0200
Message-ID: <87bkv02qva.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Except we'd want to also support multiple programs on different
>> priorities? I don't think requiring a libxdp-like dispatcher to achieve
>> this is a good idea if we can just have it be part of the API from the
>> get-go...
>
> Yes, it will be multi-prog to avoid a situation where dispatcher is needed.

Awesome! :)

-Toke

