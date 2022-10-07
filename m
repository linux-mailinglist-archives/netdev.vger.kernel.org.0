Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6545F78DB
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiJGNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJGNVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BDDD01B7
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665148865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gapbr46EimdBMtXSAgF2LUjh4bKXgDefRpG9/OgyXIY=;
        b=CadMTZhHEfJQTs8FHRS/KehwN9EAZOFuvCPxf+b3E2JeRS79YPTpMUmmFrjJt7BSqvfn6n
        2zEHFSqs2RBf0qocFFaKVo6hVvUCpG8KuawLB1TJZfm98Medzhj1DaDSgAfUWyxJAii7sh
        tPVq0GPWI9/LR7Uh+wp3H4+XXeHBnfc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-536-vJBnKwjgNKelSCnRv8YdvQ-1; Fri, 07 Oct 2022 09:21:03 -0400
X-MC-Unique: vJBnKwjgNKelSCnRv8YdvQ-1
Received: by mail-il1-f197.google.com with SMTP id j29-20020a056e02219d00b002f9b13c40c5so3850641ila.21
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 06:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gapbr46EimdBMtXSAgF2LUjh4bKXgDefRpG9/OgyXIY=;
        b=PsjXhAdFrH7noYyUxl4DS3xq9d0R67q2FsXtHy9y1HMgoQ5Wyyv+LZRy7UqRwRGY/v
         +ZBoyGfAIH+pqDRpcceKs21jEDxlROjU/UYkf7MHJL0syje8rPNDU2Kha1H3IyuR3KHI
         S00MZxBLZpsolBWokPHg8vDd4M4EevOaFDVGejfTVIPz17P8v70/ZGu1SEj72FT6s8fz
         7vC6R4bgGm2vUXEDtQw1XcaG3G7HrW/ffcJ1xHVtCVewhA7n0VYqADekuvYLzn/bWj6H
         2y4fFPvL9otUpselrNUjYkQa3gHd/kpiQHk/lX66GOTfuswedJbo/XFMCQKQF/8wiDJz
         9MFQ==
X-Gm-Message-State: ACrzQf1g7ippAaEp3ZeZTcNMpXfTY2iD/G3RwYeN3aieyS/28+hEy70i
        GvZJWhV0cPP6nKzeuyc/Q8KCy0waaxqaxNwwD1FN4D4xhmH+ioULQHZ10tUPVGdTwZARbM2NttD
        hDxTgPVAwBE964kqLrMIkx7uQFFAXFwJ7
X-Received: by 2002:a05:6e02:1c48:b0:2f1:eed2:daf3 with SMTP id d8-20020a056e021c4800b002f1eed2daf3mr2490909ilg.27.1665148862366;
        Fri, 07 Oct 2022 06:21:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6TS+6Fi2KQVRtKQWh4YnG4o7TIpY8h0Nn1oMJYly644Bs8y2c1hb4Ofk73s2XC53HTlDq/qqAwz5RjcXT93U4=
X-Received: by 2002:a05:6e02:1c48:b0:2f1:eed2:daf3 with SMTP id
 d8-20020a056e021c4800b002f1eed2daf3mr2490892ilg.27.1665148862034; Fri, 07 Oct
 2022 06:21:02 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 7 Oct 2022 06:21:01 -0700
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20220914141923.1725821-1-simon.horman@corigine.com>
 <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
MIME-Version: 1.0
In-Reply-To: <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
Date:   Fri, 7 Oct 2022 06:21:01 -0700
Message-ID: <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, dcaratti@redhat.com,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(+TC folks and netdev@)

On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
> On 10/7/22 13:37, Eelco Chaudron wrote:
> >
> >
> > On 15 Sep 2022, at 14:03, Ilya Maximets wrote:
> >
> >> On 9/15/22 13:56, Ilya Maximets wrote:
> >>> On 9/15/22 13:38, Tianyu Yuan wrote:
> >>>>
> >>>> On 9/15/22 19:28,  Ilya Maximets wrote:
> >>>>> On 9/14/22 16:19, Simon Horman wrote:
> >>>>>> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> >>>>>>
> >>>>>> Since dd9881ed55e6 ("tc: Fix stats dump when using same meter tabl=
e")
> >>>>>> rule stats update will ignore meter police. Correspondingly, the
> >>>>>> reference stats of the test should also be modified to ensure the =
test
> >>>>>> could pass correctly.
> >>>>>>
> >>>>>> Fixes: dd9881ed55e6 ("tc: Fix stats dump when using same meter tab=
le")
> >>>>>> Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
> >>>>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> >>>>>> ---
> >>>>>>  tests/system-offloads-traffic.at | 2 +-
> >>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/tests/system-offloads-traffic.at
> >>>>>> b/tests/system-offloads-traffic.at
> >>>>>> index d9b815a5ddf4..24e49d42f589 100644
> >>>>>> --- a/tests/system-offloads-traffic.at
> >>>>>> +++ b/tests/system-offloads-traffic.at
> >>>>>> @@ -264,7 +264,7 @@ NS_CHECK_EXEC([at_ns0], [echo "mark" | nc
> >>>>>> $NC_EOF_OPT -u 10.1.1.2 5678 -p 6789])  done
> >>>>>>
> >>>>>>  AT_CHECK([ovs-appctl dpctl/dump-flows | grep "meter" |
> >>>>>> DUMP_CLEAN_SORTED], [0], [dnl
> >>>>>> -in_port(2),eth(macs),eth_type(0x0800),ipv4(proto=3D17,frag=3Dno),
> >>>>>> packets:10, bytes:330, used:0.001s, actions:meter(0),3
> >>>>>> +in_port(2),eth(macs),eth_type(0x0800),ipv4(proto=3D17,frag=3Dno),
> >>>>>> +packets:1, bytes:33, used:0.001s, actions:meter(0),3
> >>>>>
> >>>>> This looks very strange to me.  The test does send 10 packets.
> >>>>> Why the flow should report only one?
> >>>>>
> >>>> Thanks for your review Ilya.
> >>>> The test does send 10 packets but 9 of them are dropped by
> >>>> meter action. As we descript in commit (dd9881ed55e6), the
> >>>> flow stats should not report the police stats.
> >>
> >> "In previous patch, after parsing police action, the flower stats will
> >>  be updated by dumped meter table stats"
> >>
> >> I suppose, that is the root cause.  We should not mix these two
> >> completely different types of statistics.  I didn't look at the
> >> code though to say why this was implemented in a way it is or
> >> how to fix that.
> >
> > Tianyu I might have missed this, but is there a follow on fix for this?=
 Asking as the test in the current master is broken.
> >
> > Ilya/Simon should we undo =E2=80=9Cdd9881ed5 tc: Fix stats dump when us=
ing same meter table=E2=80=9D and get a proper fix, fixing these counter is=
sues?
>
> As far as I understand, kernel act_police is just not suitable
> to represent an OpenFlow meter.  The main problem is that with
> OVS we need two separate entities - actual meter and the meter
> action that is using some actual meter.  And these two entities
> should have separate sets of statistics.  Actions should count
> how many packets went through these actions (ideally, TC chain
> as a whole should count the number of successful matches, but that
> is anther inconsistency between TC and OVS) and the actual meter
> should count how many packets went through/dropped/etc.
> Multiple meter actions may reference the same actual meter.
> Each of these actions should have statistics separate from the
> statistics of the actual meter.  Stats of actions should be
> reported as flow stats, stats of the meter should be reported
> as meter stats.
>
> But with the act_police the actual meter and the action are the
> same entity, so the only statistics we have is the statistics
> of the actual meter.  So, there is no way to get the accurate
> flow statistics if the meter is the first action.  This is just
> a broken API by design.

Thanks Ilya for the detailed explanation.

>
> Saying that, commit dd9881ed5 seems to be correct, because we
> should not use statistics of the actual meter as flow stats.
> At the same time we have no way to get flow stats.  They are
> broken either way but differently.
>
> For the time being we may "fix" the test by adding some action
> before the meter in OpenFlow rules, so we can get accurate
> stats from it.
>
> For the real solution - I don't see any that doesn't involve
> kernel changes.  We either need to:
>
> - separate act_police from the actual policer in the kernel,
>   so we can query stats for them independently.

I don't see how we could achieve this without breaking much of the
user experience.

>
> - or create something like act_count - a dummy action that only
>   counts packets, and put it in every datapath action from OVS.

This seems the easiest and best way forward IMHO. It's actually the
3rd option below but "on demand", considering that tc will already use
the stats of the first action as the flow stats (in
tcf_exts_dump_stats()), then we can patch ovs to add such action if a
meter is also being used (or perhaps even always, because other
actions may also drop packets, and for OVS we would really be at the
3rd option below).

netfilter (with iptables or nft) has a way to do strict packet
counting. It's useful.

Thoughts?

  Marcelo

>
> - or make flower chains count packets that successfully matched
>   and use that information as flows stats.
>
> In any case, we need to document somehow that flow stats with
> meters are not correct.
>
> Any thoughts?
>
> Best regards, Ilya Maximets.
>
> >
> >>>> In this case, only
> >>>> one packet passes the meter action and be used to update
> >>>> flow stats.
> >>>
> >>> The flow statistics counts how many packets hit the flow by
> >>> the match criteria, not how many of them survived after the
> >>> action execution.
> >>>
> >>> See the same test with offloads disabled (next to it in the file).
> >>> It correctly counts all the 10 packets.
> >>>
> >>> If we will not count packets, OVS will eventually remove the
> >>> flow from the datapath causing removal from TC and hardware
> >>> and triggering upcalls on the next packet.  And OpenFlow
> >>> statistics will also be incorrect.
> >>>
> >>> Best regards, Ilya Maximets.
> >>>
> >>>>>>  ])
> >>>>>>
> >>>>>>  AT_CHECK([ovs-ofctl -O OpenFlow13 meter-stats br0 | sed -e
> >>>>>> 's/duration:[[0-9]].[[0-9]]*s/duration:0.001s/'], [0], [dnl
> >>>>>
> >>>>> These meter stats are correctly reporting 11 packets, so the datapa=
th flow
> >>>>> should report 10 (+1 on the upcall), AFAIU.
> >>>>>
> >>>>> Best regards, Ilya Maximets.
> >>>>
> >>>> Attach the tc filter information when running this test:
> >>>> filter protocol ip pref 3 flower chain 0
> >>>> filter protocol ip pref 3 flower chain 0 handle 0x1
> >>>>   dst_mac f0:00:00:01:01:02
> >>>>   src_mac f0:00:00:01:01:01
> >>>>   eth_type ipv4
> >>>>   ip_proto udp
> >>>>   ip_flags nofrag
> >>>>   not_in_hw
> >>>>         action order 1:  police 0x10000000 rate 0bit burst 0b mtu 64=
Kb pkts_rate 1 pkts_burst 1 action drop/pipe overhead 0b linklayer unspec
> >>>>         ref 2 bind 1  installed 2 sec used 0 sec firstused 0 sec
> >>>>         Action statistics:
> >>>>         Sent 330 bytes 10 pkt (dropped 9, overlimits 9 requeues 0)
> >>>>         backlog 0b 0p requeues 0
> >>>>
> >>>>         action order 2: mirred (Egress Redirect to device ovs-p1) st=
olen
> >>>>         index 8 ref 1 bind 1 installed 1 sec used 0 sec firstused 0 =
sec
> >>>>         Action statistics:
> >>>>         Sent 33 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
> >>>>         backlog 0b 0p requeues 0
> >>>>         cookie 8455fe4dcd4e3677d0ca43b42684d1a6
> >>>>         no_percpu
> >>>>
> >>>>
> >>>> Best regards,
> >>>> Tianyu Yuan
> >>>
> >
>

