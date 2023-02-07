Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BEA68CEBF
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjBGFK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjBGFJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:09:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C53937F00
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 21:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675746421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZaOno6mIUez6lOMJUMjpJpJV7sKiSSnsw9eTLrThEo=;
        b=NaOq0Gc94098adUhpRFr2u06fd91pIEOd5ukxoB6dn5Va/QJPzFrKM9zcPqnpIDQhuJwH6
        PJ8/JecFIfrxTY6rWPzOmYvNBaq09t8T4bh7cdg1IMLuzNPW8XF4FO1q/NtpZA90uK1vKg
        1mdSfbXckXq71IkKkDZJGbhYhyaiN9g=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-U-7GgbqyPLSKUU_aCzXrHw-1; Tue, 07 Feb 2023 00:03:19 -0500
X-MC-Unique: U-7GgbqyPLSKUU_aCzXrHw-1
Received: by mail-ua1-f69.google.com with SMTP id f5-20020ab074c5000000b0067f820091deso5091471uaq.17
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 21:03:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lZaOno6mIUez6lOMJUMjpJpJV7sKiSSnsw9eTLrThEo=;
        b=TfTZV6pOKZeT8ZZLIrLbcEoL/tTh60hisBWN7VqflB8gHpZ5bGY7OI13J+gnHa73vW
         0qSYuN3zFQyQ9gHaZcUTih77KwKc5aCHivt9coK1qBBJhnz8tgHC0RaorRrb2KgyWnxX
         nJGFnPamYrhmRotUW/WVRFiFnBq6HkvoZCkvBz8KcY5d7LYh+41aQiuo0R5KNaMS1nss
         m/UZstI7fkfbMGEu2X6jm3CCSYMPmG9IkITE+gSSMXwFUL+5JKHRkGF65YK+adRLPmVC
         BgC9p6N+WVEOniCGlxJHZMw6FblB5I9GzfrNuz4XcxhuYbMh60oWj5rhTz9h6D1Di5Hi
         3D6Q==
X-Gm-Message-State: AO0yUKUgtMpKj1xuwe1DI2MIuLO/Q2pjk4LAyXDs0ypdYLvufHnWldCg
        Gbbu1uCrz8XoXxCmH6CqxerBY/gGiX8C1U9kY3pULXDZnoKQs2UWhH/gelCKrPH0BgxE27T0qcb
        h++ef1GPA68TfSpzFhV2v1Ue13Bi5gzwT
X-Received: by 2002:a67:6a44:0:b0:411:a536:cea5 with SMTP id f65-20020a676a44000000b00411a536cea5mr32180vsc.42.1675746196908;
        Mon, 06 Feb 2023 21:03:16 -0800 (PST)
X-Google-Smtp-Source: AK7set9QNMIRuZ9WjpFRJbAGbS+TGVAORDB/lL4Nu3aH5UzmEb0TpkvO0AtwHWyyvi+Yh0q7Oeri+lEtrEsLCu3l9fU=
X-Received: by 2002:a67:6a44:0:b0:411:a536:cea5 with SMTP id
 f65-20020a676a44000000b00411a536cea5mr32172vsc.42.1675746196652; Mon, 06 Feb
 2023 21:03:16 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 6 Feb 2023 21:03:15 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20230205154934.22040-1-paulb@nvidia.com> <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
 <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com> <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
MIME-Version: 1.0
In-Reply-To: <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
Date:   Mon, 6 Feb 2023 21:03:15 -0800
Message-ID: <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 01:20:55AM +0100, Ilya Maximets wrote:
> On 2/6/23 18:14, Paul Blakey wrote:
> >
> >
> > On 06/02/2023 14:34, Ilya Maximets wrote:
> >> On 2/5/23 16:49, Paul Blakey wrote:
> >>> Hi,
> >>>
> >>> This series adds support for hardware miss to instruct tc to continue=
 execution
> >>> in a specific tc action instance on a filter's action list. The mlx5 =
driver patch
> >>> (besides the refactors) shows its usage instead of using just chain r=
estore.
> >>>
> >>> Currently a filter's action list must be executed all together or
> >>> not at all as driver are only able to tell tc to continue executing f=
rom a
> >>> specific tc chain, and not a specific filter/action.
> >>>
> >>> This is troublesome with regards to action CT, where new connections =
should
> >>> be sent to software (via tc chain restore), and established connectio=
ns can
> >>> be handled in hardware.
> >>>
> >>> Checking for new connections is done when executing the ct action in =
hardware
> >>> (by checking the packet's tuple against known established tuples).
> >>> But if there is a packet modification (pedit) action before action CT=
 and the
> >>> checked tuple is a new connection, hardware will need to revert the p=
revious
> >>> packet modifications before sending it back to software so it can
> >>> re-match the same tc filter in software and re-execute its CT action.
> >>>
> >>> The following is an example configuration of stateless nat
> >>> on mlx5 driver that isn't supported before this patchet:
> >>>
> >>> =C2=A0 #Setup corrosponding mlx5 VFs in namespaces
> >>> =C2=A0 $ ip netns add ns0
> >>> =C2=A0 $ ip netns add ns1
> >>> =C2=A0 $ ip link set dev enp8s0f0v0 netns ns0
> >>> =C2=A0 $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
> >>> =C2=A0 $ ip link set dev enp8s0f0v1 netns ns1
> >>> =C2=A0 $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
> >>>
> >>> =C2=A0 #Setup tc arp and ct rules on mxl5 VF representors
> >>> =C2=A0 $ tc qdisc add dev enp8s0f0_0 ingress
> >>> =C2=A0 $ tc qdisc add dev enp8s0f0_1 ingress
> >>> =C2=A0 $ ifconfig enp8s0f0_0 up
> >>> =C2=A0 $ ifconfig enp8s0f0_1 up
> >>>
> >>> =C2=A0 #Original side
> >>> =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower=
 \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 ct_state -trk ip_proto tcp dst_port 8888 \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action pedit ex munge tcp dport =
set 5001 pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action csum ip tcp pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action goto chain 1
> >>> =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower=
 \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 ct_state +trk+est \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redirect de=
v enp8s0f0_1
> >>> =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower=
 \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 ct_state +trk+new \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct commit pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redirect de=
v enp8s0f0_1
> >>> =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flowe=
r \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redirect de=
v enp8s0f0_1
> >>>
> >>> =C2=A0 #Reply side
> >>> =C2=A0 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flowe=
r \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redirect de=
v enp8s0f0_0
> >>> =C2=A0 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower=
 \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0 ct_state -trk ip_proto tcp \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action pedit ex munge tcp sport =
set 8888 pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action csum ip tcp pipe \
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redirect de=
v enp8s0f0_0
> >>>
> >>> =C2=A0 #Run traffic
> >>> =C2=A0 $ ip netns exec ns1 iperf -s -p 5001&
> >>> =C2=A0 $ sleep 2 #wait for iperf to fully open
> >>> =C2=A0 $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
> >>>
> >>> =C2=A0 #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardw=
are packets:
> >>> =C2=A0 $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | =
grep "hardware.*pkt"
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware 931011=
6832 bytes 6149672 pkt
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware 931011=
6832 bytes 6149672 pkt
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware 931011=
6832 bytes 6149672 pkt
> >>>
> >>> A new connection executing the first filter in hardware will first re=
write
> >>> the dst port to the new port, and then the ct action is executed,
> >>> because this is a new connection, hardware will need to be send this =
back
> >>> to software, on chain 0, to execute the first filter again in softwar=
e.
> >>> The dst port needs to be reverted otherwise it won't re-match the old
> >>> dst port in the first filter. Because of that, currently mlx5 driver =
will
> >>> reject offloading the above action ct rule.
> >>>
> >>> This series adds supports partial offload of a filter's action list,
> >>> and letting tc software continue processing in the specific action in=
stance
> >>> where hardware left off (in the above case after the "action pedit ex=
 munge tcp
> >>> dport... of the first rule") allowing support for scenarios such as t=
he above.
> >>
> >>
> >> Hi, Paul.=C2=A0 Not sure if this was discussed before, but don't we al=
so need
> >> a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
> >>
> >> Currently the in_hw/not_in_hw flags are reported per filter, i.e. thes=
e
> >> flags are not per-action.=C2=A0 This may cause confusion among users, =
if flows
> >> are reported as in_hw, while they are actually partially or even mostl=
y
> >> processed in SW.
> >>
> >> What do you think?
> >>
> >> Best regards, Ilya Maximets.
> >
> > I think its a good idea, and I'm fine with proposing something like thi=
s in a
> > different series, as this isn't a new problem from this series and exis=
ted before
> > it, at least with CT rules.
>
> Hmm, I didn't realize the issue already exists.

Maintainers: please give me up to Friday to review this patchset.

Disclaimer: I had missed this patchset, and I didn't even read it yet.

I don't follow. Can someone please rephase the issue please?
AFAICT, it is not that the NIC is offloading half of the action list
and never executing a part of it. Instead, for established connections
the rule will work fully offloaded. While for misses in the CT action,
it will simply trigger a miss, like it already does today.

>
> >
> > So how about I'll propose it in a different series and we continue with=
 this first?

So I'm not sure either on what's the idea here.

Thanks,
Marcelo

>
> Sounds fine to me.  Thanks!
>
> Best regards, Ilya Maximets.
>

