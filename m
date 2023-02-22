Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B9169FDFC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbjBVVu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjBVVu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:50:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F7D6E86
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677102603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R6IXijjfsOhQ7gBHCJ0QxrKhqJ/Fz8eXx6MZTsuMtqY=;
        b=Ic/M3UqxLMCe2U29zMgm9wMRxHtUxIEViMu+vu0ln8cAp2iCjuHuuqtL2Ua6hC2ICfQY6A
        ophJDx6FWnkXj6PxKf9qdJ8c7SsFi6EaGxaVrC8qBDM7fFp3E6wVHTGLJv3V9HlzoEW6J6
        lu57Ak9ez9TG/0IAl9e8+iXBqeGEL4U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-D29zT1GWOru-5mMLyhe0EA-1; Wed, 22 Feb 2023 16:50:02 -0500
X-MC-Unique: D29zT1GWOru-5mMLyhe0EA-1
Received: by mail-ed1-f70.google.com with SMTP id g24-20020a056402321800b004ace77022ebso12583140eda.8
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:50:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6IXijjfsOhQ7gBHCJ0QxrKhqJ/Fz8eXx6MZTsuMtqY=;
        b=RoN3oTAVTe1twJ6kjkHkSiFtaBW86TJ75npK7ByahR6jiX8erxfZlEX2rRHnv/HDZb
         KwkFjU+Wz9CDcXs5MHYvwk6RJdJOuxzAF5lsw55M1RelmXreP5uSLvlF5Hh4Hr8VXOvQ
         S568axIiMOGQ8ZEUaPtIGXMWHwLlhFp835/y9DEh+c1hbnETt1xNWxiOX6n5Lxmf/nBJ
         m0eWEj9lJYNhIHNopdXq5WH1ZNjt8PlREHZGZ+23F0YWbjqFPveT5KQZViki3DXn9cx/
         zGIXWZ/GcO6aHTDAiygGDfodP6oK8Ey0Is14zkLaU59DtChtTjpEBlsY3pMh+z+zwc7E
         nAFQ==
X-Gm-Message-State: AO0yUKVV8fhbwShMSWGUMPecVEVChW+ae2ZD0ZeK/7GeZ4ZvvFmjWK57
        BSzVYASJDK8X5F+TTPeiwdD3T0m7gsmxCWf2jpiz0Ynz7NUbOG5CkvHG1nUAqQJl0jR7oFlbLnJ
        nNgcpR0A+bOEesZ9C
X-Received: by 2002:a17:906:2b54:b0:87b:d400:e1df with SMTP id b20-20020a1709062b5400b0087bd400e1dfmr17526443ejg.72.1677102600774;
        Wed, 22 Feb 2023 13:50:00 -0800 (PST)
X-Google-Smtp-Source: AK7set+OWzWHD9rxUfuT2+1/dRsSv+jzA2j2/1Dlup0Hd9rw5sEZr2iufLqecElErRd3N+WFenguFw==
X-Received: by 2002:a17:906:2b54:b0:87b:d400:e1df with SMTP id b20-20020a1709062b5400b0087bd400e1dfmr17526424ejg.72.1677102600486;
        Wed, 22 Feb 2023 13:50:00 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id a27-20020a509b5b000000b004acc7202074sm3575868edj.16.2023.02.22.13.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:49:59 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <bff4d5eb-fe4d-786e-f41d-1c45f07a7282@redhat.com>
Date:   Wed, 22 Feb 2023 22:49:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net
Subject: Re: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
References: <167673444093.2179692.14745621008776172374.stgit@firesoul>
 <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
 <d8c514c6-15bf-c2fd-11f9-23519cdc9177@linux.dev>
 <613bbdb0-e7b0-59df-f2ee-6c689b15fe41@redhat.com>
 <8bb53544-94f4-601b-24ad-96c6cc87cf50@linux.dev>
In-Reply-To: <8bb53544-94f4-601b-24ad-96c6cc87cf50@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/02/2023 22.58, Martin KaFai Lau wrote:
> On 2/21/23 12:39 PM, Jesper Dangaard Brouer wrote:
>> For me this is more about the API we are giving the BPF-programmer.
>>
>> There can be natural cases why a driver doesn't provide any hardware
>> info for a specific hint.  The RX-timestamp is a good practical example,
>> as often only PTP packets will be timestamped by hardware.
>>
>> I can write a BPF-prog that create a stats-map for counting
>> RX-timestamps, expecting to catch any PTP packets with timestamps.  The
>> problem is my stats-map cannot record the difference of EOPNOTSUPP vs
>> ENODATA.  Thus, the user of my RX-timestamps stats program can draw the
>> wrong conclusion, that there are no packets with (PTP) timestamps, when
>> this was actually a case of driver not implementing this.
>>
>> I hope this simple stats example make is clearer that the BPF-prog can
>> make use of this info runtime.  It is simply a question of keeping these
>> cases as separate return codes. Is that too much to ask for from an API?
> 
> Instead of reserving an errno for this purpose, it can be decided at 
> load time instead of keep calling a kfunc always returning the same 
> dedicated errno. I still don't hear why xdp-features + bpf global const 
> won't work.
> 

Sure, exposing this to xdp-features and combining this with a bpf global
const is a cool idea, slightly extensive work for the BPF-programmer,
but sure BPF is all about giving the BPF programmer flexibility.

I do feel it is orthogonal whether the API should return a consistent
errno when the driver doesn't implement the kfunc.

I'm actually hoping in the future that we can achieve dead code
elimination automatically without having to special case this.
When we do Stanislav's BPF unroll tricks we get a constant e.g.
EOPNOTSUPP when driver doesn't implement the kfunc.  This should allow
the verifier to do deadcode elimination right?

For my stats example, where I want to count both packets with and
without timestamps, but not miscount packets that actually had a
timestamp, but my driver just doesn't support querying this.

Consider program-A:

  int err = bpf_xdp_metadata_rx_timestamp(ctx, &ts);
  if (!err) {
	ts_stats[HAVE_TS]++;
  } else {
	ts_stats[NO_TS_DATA]++;
  }

Program-A clearly does the miscount issue. The const propagation and
deadcode code elimination would work, but is still miscounts.
Yes, program-A could be extended with the cool idea of xdp-feature
detection that updates a prog const, for solving the issue.

Consider program-B:

  int err = bpf_xdp_metadata_rx_timestamp(ctx, &ts);
  if (!err) {
	ts_stats[HAVE_TS]++;
  } else if (err == -ENODATA) {
	ts_stats[NO_TS_DATA]++;
  }

If I had a separate return, then I can avoid the miscount as demonstrate
in program-B.  In this program the const propagation and deadcode
elimination would *also* work and still avoid the miscounts.  It should
elimination any updates to ts_stats map.

I do get the cool idea of bpf global const, but we will hopefully get
this automatically when we can do BPF unroll.

I hope this make it more clear, why I think it is valuable to "reserve"
an errno for the case when kfunc isn't implemented by driver.

Thanks for reading this far,
--Jesper

