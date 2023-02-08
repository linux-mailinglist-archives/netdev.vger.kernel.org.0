Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1753968F691
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjBHSGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjBHSGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:06:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607E659E
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 10:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675879509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mSX9bd6ixif8w9NPRLxuVnieBaqqmtIv2WilInTDmN4=;
        b=RBkvN8M7bEvQvEGmjOmf2Kl5yMBRGGcCFGBcNdEjEyVwUcp6ImCojvhshNYWWlrkrR6dRd
        7XcR/6hdA3rBtKkDjtVr68IoFvyojipeqbQj0hOAQdYovvdoCiXbYneC8F+Ci0BqbP1oTY
        sgaGVkote5n87DVt1QNMgnr2lcJZ66Y=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-mN4-5YxeMZytY-V2Sb9rbA-1; Wed, 08 Feb 2023 13:01:58 -0500
X-MC-Unique: mN4-5YxeMZytY-V2Sb9rbA-1
Received: by mail-vs1-f72.google.com with SMTP id u9-20020a056102374900b00403019bc794so2632568vst.21
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 10:01:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mSX9bd6ixif8w9NPRLxuVnieBaqqmtIv2WilInTDmN4=;
        b=0dtNhYJKu17vZ2CM0YYJtTxAFEwFmjcM7JpmSJowv7wLctuWblWdLFpYmPXVzcUi4k
         IdiDji4CzfFK49JFYP6tYs0r9WxHOCmBA1aiqHSRlUlYjHo21Wqq1jwurjzyLf2ftzmI
         2BOkM9LzHgaNrBYAX16MW0ylVhzoozw+xvL+WbnwwWFI+EHHVimNbuKys38C6SYi2kD0
         jp7X5YRxC5NeZbhq++8tFYSlYxs2rVE/ex+qr3wOYuIFISCV3FQYtjtebN8lBjD3+JJD
         0m+5LteZ7AVtx6jQ0jREwkAHXoEQ8NGqJyotQ4Kk7xedSHad/oHY+3cSjZlV6A0A0LZe
         E+WA==
X-Gm-Message-State: AO0yUKWYCMAjaNbQYQ+eYebCWVL0V2y0IRhFU7aGA6dfAsxsPFxk9XuJ
        K8aIe27Lb/M/P6to6q2acqutyHL4pEnxUpBu6nPD2RcujhLrRhPDoC//6JrzStCssiRuA0GBOhx
        Yr2TFc0eA+cj+7OKdIWU+FnoEBtOjMY+A
X-Received: by 2002:ab0:6415:0:b0:5fc:a2ef:4b70 with SMTP id x21-20020ab06415000000b005fca2ef4b70mr2110329uao.36.1675879315274;
        Wed, 08 Feb 2023 10:01:55 -0800 (PST)
X-Google-Smtp-Source: AK7set/Y5WXMa/hA4cuqUhUL8iUK2wlTodXhkQZj3eWesNqOpo6Q3RbwCzh+IzAW9yJJuVr/GC9NaGcQyarjA0N4x2Q=
X-Received: by 2002:ab0:6415:0:b0:5fc:a2ef:4b70 with SMTP id
 x21-20020ab06415000000b005fca2ef4b70mr2110320uao.36.1675879314875; Wed, 08
 Feb 2023 10:01:54 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Feb 2023 10:01:54 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20230205154934.22040-1-paulb@nvidia.com> <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
 <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com> <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
 <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com> <a2f19534-9752-845c-9b8a-3aa75b5f3706@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <a2f19534-9752-845c-9b8a-3aa75b5f3706@nvidia.com>
Date:   Wed, 8 Feb 2023 10:01:54 -0800
Message-ID: <CALnP8ZbQtyRx-s9GWvTVyBVU3SoGTDA9r9u+eEj39ZVq8LotHA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org,
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

On Wed, Feb 08, 2023 at 10:41:39AM +0200, Paul Blakey wrote:
>
>
> On 07/02/2023 07:03, Marcelo Leitner wrote:
> > On Tue, Feb 07, 2023 at 01:20:55AM +0100, Ilya Maximets wrote:
> > > On 2/6/23 18:14, Paul Blakey wrote:
> > > >
> > > >
> > > > On 06/02/2023 14:34, Ilya Maximets wrote:
> > > > > On 2/5/23 16:49, Paul Blakey wrote:
> > > > > > Hi,
> > > > > >
> > > > > > This series adds support for hardware miss to instruct tc to co=
ntinue execution
> > > > > > in a specific tc action instance on a filter's action list. The=
 mlx5 driver patch
> > > > > > (besides the refactors) shows its usage instead of using just c=
hain restore.
> > > > > >
> > > > > > Currently a filter's action list must be executed all together =
or
> > > > > > not at all as driver are only able to tell tc to continue execu=
ting from a
> > > > > > specific tc chain, and not a specific filter/action.
> > > > > >
> > > > > > This is troublesome with regards to action CT, where new connec=
tions should
> > > > > > be sent to software (via tc chain restore), and established con=
nections can
> > > > > > be handled in hardware.
> > > > > >
> > > > > > Checking for new connections is done when executing the ct acti=
on in hardware
> > > > > > (by checking the packet's tuple against known established tuple=
s).
> > > > > > But if there is a packet modification (pedit) action before act=
ion CT and the
> > > > > > checked tuple is a new connection, hardware will need to revert=
 the previous
> > > > > > packet modifications before sending it back to software so it c=
an
> > > > > > re-match the same tc filter in software and re-execute its CT a=
ction.
> > > > > >
> > > > > > The following is an example configuration of stateless nat
> > > > > > on mlx5 driver that isn't supported before this patchet:
> > > > > >
> > > > > >  =C2=A0 #Setup corrosponding mlx5 VFs in namespaces
> > > > > >  =C2=A0 $ ip netns add ns0
> > > > > >  =C2=A0 $ ip netns add ns1
> > > > > >  =C2=A0 $ ip link set dev enp8s0f0v0 netns ns0
> > > > > >  =C2=A0 $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
> > > > > >  =C2=A0 $ ip link set dev enp8s0f0v1 netns ns1
> > > > > >  =C2=A0 $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
> > > > > >
> > > > > >  =C2=A0 #Setup tc arp and ct rules on mxl5 VF representors
> > > > > >  =C2=A0 $ tc qdisc add dev enp8s0f0_0 ingress
> > > > > >  =C2=A0 $ tc qdisc add dev enp8s0f0_1 ingress
> > > > > >  =C2=A0 $ ifconfig enp8s0f0_0 up
> > > > > >  =C2=A0 $ ifconfig enp8s0f0_1 up
> > > > > >
> > > > > >  =C2=A0 #Original side
> > > > > >  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip=
 flower \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state -trk ip_proto tcp dst_port 8=
888 \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action pedit ex munge tcp=
 dport set 5001 pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action csum ip tcp pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action goto chain 1
> > > > > >  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip=
 flower \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state +trk+est \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redi=
rect dev enp8s0f0_1
> > > > > >  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip=
 flower \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state +trk+new \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct commit pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redi=
rect dev enp8s0f0_1
> > > > > >  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ar=
p flower \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redi=
rect dev enp8s0f0_1
> > > > > >
> > > > > >  =C2=A0 #Reply side
> > > > > >  =C2=A0 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ar=
p flower \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redi=
rect dev enp8s0f0_0
> > > > > >  =C2=A0 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip=
 flower \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state -trk ip_proto tcp \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action pedit ex munge tcp=
 sport set 8888 pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action csum ip tcp pipe \
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redi=
rect dev enp8s0f0_0
> > > > > >
> > > > > >  =C2=A0 #Run traffic
> > > > > >  =C2=A0 $ ip netns exec ns1 iperf -s -p 5001&
> > > > > >  =C2=A0 $ sleep 2 #wait for iperf to fully open
> > > > > >  =C2=A0 $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
> > > > > >
> > > > > >  =C2=A0 #dump tc filter stats on enp8s0f0_0 chain 0 rule and se=
e hardware packets:
> > > > > >  =C2=A0 $ tc -s filter show dev enp8s0f0_0 ingress chain 0 prot=
o ip | grep "hardware.*pkt"
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware=
 9310116832 bytes 6149672 pkt
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware=
 9310116832 bytes 6149672 pkt
> > > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware=
 9310116832 bytes 6149672 pkt
> > > > > >
> > > > > > A new connection executing the first filter in hardware will fi=
rst rewrite
> > > > > > the dst port to the new port, and then the ct action is execute=
d,
> > > > > > because this is a new connection, hardware will need to be send=
 this back
> > > > > > to software, on chain 0, to execute the first filter again in s=
oftware.
> > > > > > The dst port needs to be reverted otherwise it won't re-match t=
he old
> > > > > > dst port in the first filter. Because of that, currently mlx5 d=
river will
> > > > > > reject offloading the above action ct rule.
> > > > > >
> > > > > > This series adds supports partial offload of a filter's action =
list,
> > > > > > and letting tc software continue processing in the specific act=
ion instance
> > > > > > where hardware left off (in the above case after the "action pe=
dit ex munge tcp
> > > > > > dport... of the first rule") allowing support for scenarios suc=
h as the above.
> > > > >
> > > > >
> > > > > Hi, Paul.=C2=A0 Not sure if this was discussed before, but don't =
we also need
> > > > > a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
> > > > >
> > > > > Currently the in_hw/not_in_hw flags are reported per filter, i.e.=
 these
> > > > > flags are not per-action.=C2=A0 This may cause confusion among us=
ers, if flows
> > > > > are reported as in_hw, while they are actually partially or even =
mostly
> > > > > processed in SW.
> > > > >
> > > > > What do you think?
> > > > >
> > > > > Best regards, Ilya Maximets.
> > > >
> > > > I think its a good idea, and I'm fine with proposing something like=
 this in a
> > > > different series, as this isn't a new problem from this series and =
existed before
> > > > it, at least with CT rules.
> > >
> > > Hmm, I didn't realize the issue already exists.
> >
> > Maintainers: please give me up to Friday to review this patchset.
> >
> > Disclaimer: I had missed this patchset, and I didn't even read it yet.
> >
> > I don't follow. Can someone please rephase the issue please?
> > AFAICT, it is not that the NIC is offloading half of the action list
> > and never executing a part of it. Instead, for established connections
> > the rule will work fully offloaded. While for misses in the CT action,
> > it will simply trigger a miss, like it already does today.
>
> You got it right, and like you said it was like this before so its not
> strictly related by this series and could be in a different patchset. And=
 I
> thought that (extra) flag would mean that it can miss, compared to other
> rules/actions combination that will never miss because they
> don't need sw support.

This is different from what I understood from Ilya's comment. Maybe I
got his comment wrong, but I have the impression that he meant it in
the sense of having some actions offloaded and some not. Which I think
it is not the goal here.

But anyway, flows can have some packets matching in sw while also
being in hw. That's expected. For example, in more complex flow sets,
if a packet hit a flow with ct action and triggered a miss, all
subsequent flows will handle this packet in sw. Or if we have queued
packets in rx ring already and ovs just updated the datapath, these
will match in tc sw instead of going to upcall. The latter will have
only a few hits, yes, but the former will be increasing over time.
I'm not sure how a new flag, which is probably more informative than
an actual state indication, would help here.

>
> >
> > >
> > > >
> > > > So how about I'll propose it in a different series and we continue =
with this first?
> >
> > So I'm not sure either on what's the idea here.
> >
> > Thanks,
> > Marcelo
> >
> > >
> > > Sounds fine to me.  Thanks!
> > >
> > > Best regards, Ilya Maximets.
> > >
> >
>

