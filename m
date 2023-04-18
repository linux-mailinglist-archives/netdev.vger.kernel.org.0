Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F0E6E668F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjDROCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjDROCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:02:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DCA13866
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681826495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fONgD5ZI0CkRixaJ2Z/vCiQZM4I6ehW6VIFsC+eLAk=;
        b=aygsn9EkFvLQXwkuHK+fy7LhUj4TOqqXfwFB5wKsvS6pil/9Ga89t1ZORN0IVUYA0pObgq
        DyVDKWJlU9WPAylx+Y0+FaM3HStHUsoL9Q7GlI+rjF5XC57BdMaS5gcN7yQsr5beRX28vj
        PJN6FSXstfSj1yta+do01s7Iq3gBtro=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-5CmZ9j6sMLKtS-f3s3rxnA-1; Tue, 18 Apr 2023 10:01:34 -0400
X-MC-Unique: 5CmZ9j6sMLKtS-f3s3rxnA-1
Received: by mail-ed1-f70.google.com with SMTP id u19-20020a50a413000000b0050670a8cb7dso8673603edb.13
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826493; x=1684418493;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5fONgD5ZI0CkRixaJ2Z/vCiQZM4I6ehW6VIFsC+eLAk=;
        b=YJwc74ult9vbkF2pM8M6rIbc22hPozyB1j5S2ZgHD34jwu/LAgVucUda4uV7MZf7/a
         PaazosMUIcASKXavmKqm2sQZ1kgSscKO24ZQzotY32QflRtTKeVhuszXKmwdLp72vekk
         I/mZ4mGXIfzA2F2a9HG12X51rH3av9DXUsJ9oil2W7yJqwlOhjofihlOQ7DDKUHTvRC9
         PgFR/cal110BigiIRO9Tn7/q+CLfo9ENGshME4Xo9VRse6Nu0qVRXbzCrYizrnypQf1o
         5Bou7cDVha9KzPswF3oWjpi7tlO2vDifUbs7WZFxv9uqvkRImi6OVU2pkA0hofpBooy8
         lsiQ==
X-Gm-Message-State: AAQBX9f+kshJfxRrJk5DJrpnBAHv/uj4ZgSfl39tl3JaCF31+3FCElPa
        356yajfSp31VJPfBQQkFenwHu7zEhICrZcfl6Um0qvbQ8XyVISpkgDA4YdPEMTsb7dlVucCB+yN
        btZXWniceXuuFH5gs
X-Received: by 2002:a17:907:d689:b0:953:1a7c:51b7 with SMTP id wf9-20020a170907d68900b009531a7c51b7mr1833372ejc.28.1681826493390;
        Tue, 18 Apr 2023 07:01:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350aemARlMVPdy8kgJgXVuHzGD4sbX/Gl6p99Go7osU8PHjd+oUCms+1rCgpAgVHjctvdD0LBVw==
X-Received: by 2002:a17:907:d689:b0:953:1a7c:51b7 with SMTP id wf9-20020a170907d68900b009531a7c51b7mr1833311ejc.28.1681826492813;
        Tue, 18 Apr 2023 07:01:32 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id qx11-20020a170906fccb00b0094f499257f7sm4053337ejb.151.2023.04.18.07.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 07:01:31 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d805e350-1d59-eb3a-ec27-adaa72cdc20b@redhat.com>
Date:   Tue, 18 Apr 2023 16:01:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, bpf@vger.kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Pasi Vaananen <pvaanane@redhat.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V1 5/5] selftests/bpf:
 xdp_hw_metadata track more timestamps
Content-Language: en-US
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        yoong.siang.song@intel.com
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174344813.593471.4026230439937368990.stgit@firesoul>
 <87leiqsexd.fsf@kurt>
In-Reply-To: <87leiqsexd.fsf@kurt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/04/2023 17.31, Kurt Kanzenbach wrote:
> On Mon Apr 17 2023, Jesper Dangaard Brouer wrote:
>> To correlate the hardware RX timestamp with something, add tracking of
>> two software timestamps both clock source CLOCK_TAI (see description in
>> man clock_gettime(2)).
>>
>> XDP metadata is extended with xdp_timestamp for capturing when XDP
>> received the packet. Populated with BPF helper bpf_ktime_get_tai_ns(). I
>> could not find a BPF helper for getting CLOCK_REALTIME, which would have
>> been preferred. In userspace when AF_XDP sees the packet another
>> software timestamp is recorded via clock_gettime() also clock source
>> CLOCK_TAI.
>>
>> Example output shortly after loading igc driver:
>>
>>    poll: 1 (0) skip=1 fail=0 redir=2
>>    xsk_ring_cons__peek: 1
>>    0x12557a8: rx_desc[1]->addr=100000000009000 addr=9100 comp_addr=9000
>>    rx_hash: 0x82A96531 with RSS type:0x1
>>    rx_timestamp:  1681740540304898909 (sec:1681740540.3049)
>>    XDP RX-time:   1681740577304958316 (sec:1681740577.3050) delta sec:37.0001 (37000059.407 usec)
>>    AF_XDP time:   1681740577305051315 (sec:1681740577.3051) delta sec:0.0001 (92.999 usec)
>>    0x12557a8: complete idx=9 addr=9000
>>
>> The first observation is that the 37 sec difference between RX HW vs XDP
>> timestamps, which indicate hardware is likely clock source
>> CLOCK_REALTIME, because (as of this writing) CLOCK_TAI is initialised
>> with a 37 sec offset.
> 
> Maybe I'm missing something here, but in order to compare the hardware
> with software timestamps (e.g., by using bpf_ktime_get_tai_ns()) the
> time sources have to be synchronized by using something like
> phc2sys. That should make them comparable within reasonable range
> (nanoseconds).

Precisely, in this test I've not synchronized the clocks.
The observation is that driver igc clock gets initialized to
CLOCK_REALTIME wall-clock time, and it slowly drifts as documented in 
provided link[1].

  [1] 
https://github.com/xdp-project/xdp-project/blob/master/areas/hints/xdp_hints_kfuncs02_driver_igc.org#driver-igc-clock-drift-observations
  [2] 
https://github.com/xdp-project/xdp-project/blob/master/areas/hints/xdp_hints_kfuncs02_driver_igc.org#quick-time-sync-setup

I've also played with using phc2sys (in same doc[2]) to sync HW clock
with SW clock. I do *seek input* if I'm using it correctly?!?.

I don't have a PTP clock setup , so I manually: Use phc2sys to
synchronize the system clock to the PTP hardware clock (PHC) on the
network card (which driver inited to CLOCK_REALTIME wall-clock).

Stop ntp clock sync and disable most CPU sleep states:

   sudo systemctl stop chronyd
   sudo tuned-adm profile latency-performance
   sudo hexdump --format '"%d\n"' /dev/cpu_dma_latency
   2

Adjust for the 37 sec offset to TAI, such that our BPF-prog using TAI 
will align:

   sudo phc2sys -s igc1 -O -37 -R 2 -u 10

Result on igc with xdp_hw_metadata:

  poll: 1 (0) skip=1 fail=0 redir=6
  xsk_ring_cons__peek: 1
  rx_hash: 0x82A96531 with RSS type:0x1
  rx_timestamp:  1681825632645744805 (sec:1681825632.6457)
  XDP RX-time:   1681825632645755858 (sec:1681825632.6458) delta 
sec:0.0000 (11.053 usec)
  AF_XDP time:   1681825632645769371 (sec:1681825632.6458) delta 
sec:0.0000 (13.513 usec)

The log file from phc2sys says:

  phc2sys[1294263]: [86275.140] CLOCK_REALTIME rms    6 max   11 freq 
+13719 +/-   5 delay  1435 +/-   5

Notice the delta between HW and SW timestamps is 11.053 usec.
Even-though it is small, I don't really trust it, because the phc2sys
log says frequency offset mean is "+13719" nanosec.

So, it is true that latency/delay between HW to XDP-SW is 11 usec?
Or is this due to (in)accuracy of phc2sys sync?

--Jesper

