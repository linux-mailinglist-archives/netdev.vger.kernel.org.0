Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554195F55BF
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 15:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJENnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 09:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJENnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 09:43:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917EB1E72E
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 06:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664977427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GsSbujtCTt+IW+d/rBXbBcKeW+BBGKycYoOIn8QFlQI=;
        b=jUcbz4Gm1vnl8N5JnrH4g1lqpGijg+124lZpGav6nirRWYD1SxlQzHlLMKwoh57J3TyFg+
        ibfTWWzmRMhnPCaVql2NuSMTjIIdCBW53joHV/RtVSBFgMLVf+gNqoAbPnTW/z7e5uASad
        DhykHhk2Ng8admXciQC1MbzJevnA7AM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-333-H0T81xntMHSR9LkIeV8V6A-1; Wed, 05 Oct 2022 09:43:46 -0400
X-MC-Unique: H0T81xntMHSR9LkIeV8V6A-1
Received: by mail-ej1-f71.google.com with SMTP id gn33-20020a1709070d2100b00787e6fbcb72so6039023ejc.3
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 06:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=GsSbujtCTt+IW+d/rBXbBcKeW+BBGKycYoOIn8QFlQI=;
        b=JBHPkFuMhmDyO/tgoJZiWlzvtGnl/5pKPWn49+9H9tqPEIGBTDAurR8s+N3/mmzKgv
         dBxojB5BUYHrrawDxm8Kr8oUJThmqpfcw0CeKfSKH8IyxBQqVOW50IjxiZSabZflw77Z
         oPNh3Q8z0sJDl/meyGLLCmfzqyv8/ab95WlLYFtCYk0Jmjyv79+OV/N5/Uq9piIl9uvZ
         frfGFcqWzF4qgmdXtMoqtK48suaG+DuxMpJHdwmrymSAs26yaeX32hwc1XP32pChOqJA
         706wx28NjsoQfs1vOKkjZeEQSmUiAVQeBwypmGv5YDHx8/NwbGrATo6n089MrU93nyrc
         vafA==
X-Gm-Message-State: ACrzQf2HU/4lZXFrK/hAdUKop45kmF8ry1fWGke5OyFiiB725rjdVajS
        CggoivWLqq9N21JACDc3BR/XpFErKKM1/W6fjlp4JMLZucVswVhvfClQjAilWxcTHxUiDVYLwKn
        i2HmzwBoGlZNDQEaB
X-Received: by 2002:a05:6402:3806:b0:450:bad8:8cd5 with SMTP id es6-20020a056402380600b00450bad88cd5mr29071236edb.305.1664977425132;
        Wed, 05 Oct 2022 06:43:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4tKV4IdZ6t5ipdEbNxxbfP4IIcnxZBulYixB9jOklWI6+RrrOCPSFkdrSDcafwl7LtCwE9+g==
X-Received: by 2002:a05:6402:3806:b0:450:bad8:8cd5 with SMTP id es6-20020a056402380600b00450bad88cd5mr29071198edb.305.1664977424819;
        Wed, 05 Oct 2022 06:43:44 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id la3-20020a170907780300b00781dbdb292asm8634645ejc.155.2022.10.05.06.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 06:43:44 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <404395ad-ad96-d300-a7fe-1116c9fd7b57@redhat.com>
Date:   Wed, 5 Oct 2022 15:43:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
In-Reply-To: <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/10/2022 02.25, Martin KaFai Lau wrote:
> For rx hwtimestamp, the value could be just 0 if a specific hw/driver 
> cannot provide it for all packets while some other hw can.

Keep in mind that we want to avoid having to write a (64-bit) zero into
the metadata for rx_hwtimestamp, for every packet that doesn't carry a
timestamp.  It essentially reverts back to clearing memory like with
SKBs, due to performance overhead we don't want to go that path again!

There are multiple ways to avoid having to zero init the memory.

In this patchset I have choosen have the traditional approach of flags
(u32) approach located in xdp_hints_common, e.g. setting a flag if the
field is valid (p.s. John Fastabend convinced me of this approach ;-)).
But COMBINED with: some BTF ID layouts doesn't contain some fields e.g.
the rx_timestamp, thus the code have no reason to query those flag fields.


I am intrigued to find a way to leverage bpf_core_field_exists() some
more (as proposed by Stanislav).  (As this can allow for dead-code
elimination).

--Jesper

