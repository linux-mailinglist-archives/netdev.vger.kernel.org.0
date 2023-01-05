Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C703C65F338
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbjAERy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbjAERy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:54:57 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D836106
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:54:57 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-46198b81e5eso528345077b3.4
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 09:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWYTwrtmvd+fD0HY3yxRpifh8OFrjtIJPBazT40Ubuw=;
        b=FFGl/2yzHoGOC88yWeBZXJAPwq5wHBcmaU0KKFlc4PSXj2jGL55f4DuZRefajZl6pv
         WWHWkQlcmyAsII/KfGMVyjVCruvvJpcQt87nnixXfjzRJNii8GOW0iBc9poioWBAxMnl
         6QpS0mgApQ81sfaoK2PVh5F9L3R4pez2sWwpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hWYTwrtmvd+fD0HY3yxRpifh8OFrjtIJPBazT40Ubuw=;
        b=6At3CBdiDL01Vbo8j/vYvDVp2nfpxJ9nIZMs4E63a90viKCmYspnnnjeDOYBdwYaOY
         s+AXO63910VKP/UD298Yi4A5S0cKNT/m3lkPSQsh6bIlaoTuFc2+ZpL4xiHbzqldiuya
         cxLb9fwJzOOYsarmMtCUJQFDjwr4Qh4SGpSt0nfjsCC0lCn/NCwKrOYdEtKmxD3SKmtW
         YT1E3amRRv7qvP9BsnoDTsNXWpPFwTicdGf9UpxiNdb5hj2FgnM0kQ8jipPnzAO7KeV7
         xh+5WigxnhSMTBUm7gNHkfg0kjEsjVHL83Zjd0y9QwljRAEaBrSIgEtMPSzONr6LlTX4
         pR6A==
X-Gm-Message-State: AFqh2kqkQ4evP5HHtvGmArs5t3fR78LtP0f5m1/Un54wPbw0e8TBy8tL
        LblCXWGX8cUWPK+GVxu27f4FxaZ6MaRgOiKSvuVWEg==
X-Google-Smtp-Source: AMrXdXs0gUcJS0VReobUHBsOUM+HzeVse3XIHCd+QcMSijUgXTNcqenyqRpVVtr/Tam3I3KmH2Z2/dXiqtOIW1Na5KY=
X-Received: by 2002:a0d:cbd4:0:b0:475:5ef6:9679 with SMTP id
 n203-20020a0dcbd4000000b004755ef69679mr5276169ywd.402.1672941296230; Thu, 05
 Jan 2023 09:54:56 -0800 (PST)
MIME-Version: 1.0
References: <CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com>
 <CANn89iJFmfv569Mu7REiP5OBMscuv8EBSGJqi_7c4pxcJymrKw@mail.gmail.com>
In-Reply-To: <CANn89iJFmfv569Mu7REiP5OBMscuv8EBSGJqi_7c4pxcJymrKw@mail.gmail.com>
From:   Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date:   Thu, 5 Jan 2023 18:54:30 +0100
Message-ID: <CAK8fFZ7cyhnUsFiCE-mpQF9P_Q7M70RiDbXGNvjA+2Y_PyuQYQ@mail.gmail.com>
Subject: Re: Network performance regression with linux 6.1.y. Issue bisected
 to "5eddb24901ee49eee23c0bfce6af2e83fd5679bd" (gro: add support of (hw)gro
 packets to gro stack)
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, lixiaoyan@google.com, pabeni@redhat.com,
        davem@davemloft.net, Igor Raits <igor.raits@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is at KVM based VMs "CentOS 9 Stream" and "CentOS 8 Stream" using
upstream kernel 6.1.y. Hosted on Dell PowerEdge 7525 servers (2x AMD
74F3) and OS CentOS 9 Stream again with upstream kernel 6.1.y or
6.0.y.

# ethtool -k eth0
Features for eth0:
rx-checksumming: on [fixed]
tx-checksumming: on
tx-checksum-ipv4: off [fixed]
tx-checksum-ip-generic: on
tx-checksum-ipv6: off [fixed]
tx-checksum-fcoe-crc: off [fixed]
tx-checksum-sctp: off [fixed]
scatter-gather: on
tx-scatter-gather: on
tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
tx-tcp-segmentation: on
tx-tcp-ecn-segmentation: on
tx-tcp-mangleid-segmentation: off
tx-tcp6-segmentation: on
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off [fixed]
rx-vlan-offload: off [fixed]
tx-vlan-offload: off [fixed]
ntuple-filters: off [fixed]
receive-hashing: off [fixed]
highdma: on [fixed]
rx-vlan-filter: on [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: on [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: off [fixed]
tx-gre-csum-segmentation: off [fixed]
tx-ipxip4-segmentation: off [fixed]
tx-ipxip6-segmentation: off [fixed]
tx-udp_tnl-segmentation: off [fixed]
tx-udp_tnl-csum-segmentation: off [fixed]
tx-gso-partial: off [fixed]
tx-tunnel-remcsum-segmentation: off [fixed]
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: off [fixed]
tx-udp-segmentation: off [fixed]
tx-gso-list: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off [fixed]
hw-tc-offload: off [fixed]
esp-hw-offload: off [fixed]
esp-tx-csum-hw-offload: off [fixed]
rx-udp_tunnel-port-offload: off [fixed]
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: on
tls-hw-record: off [fixed]
rx-gro-list: off
macsec-hw-offload: off [fixed]
rx-udp-gro-forwarding: off
hsr-tag-ins-offload: off [fixed]
hsr-tag-rm-offload: off [fixed]
hsr-fwd-offload: off [fixed]
hsr-dup-offload: off [fixed]

# ethtool -i eth0
driver: virtio_net
version: 1.0.0
firmware-version:
expansion-rom-version:
bus-info: 0000:03:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

=C4=8Dt 5. 1. 2023 v 18:43 odes=C3=ADlatel Eric Dumazet <edumazet@google.co=
m> napsal:
>
> On Thu, Jan 5, 2023 at 6:37 PM Jaroslav Pulchart
> <jaroslav.pulchart@gooddata.com> wrote:
> >
> > Hello,
> >
> > I would like to report a 6.1,y regression in a network performance
> > observed when using "git clone".
> >
> > BAD: "git clone" speed with kernel 6.1,y:
> >    # git clone git@github.com:..../.....git
> >    ...
> >    Receiving objects:   8% (47797/571306), 20.69 MiB | 3.27 MiB/s
> >
> > GOOD: "git clone" speed with kernel 6.0,y:
> >    # git clone git@github.com:..../.....git
> >    ...
> >    Receiving objects:  72% (411341/571306), 181.05 MiB | 60.27 MiB/s
> >
> > I bisected the issue to a commit
> > 5eddb24901ee49eee23c0bfce6af2e83fd5679bd "gro: add support of (hw)gro
> > packets to gro stack". Reverting it from 6.1.y branch makes the git
> > clone fast like with 6.0.y.
> >
>
> Hmm, please provide more information.
>
> NIC used ? (ethtool -i eth0)
>
> ethtool -k eth0  # replace by your netdev name
>
> And packet captures would be nice (with and without the patch)
>
> Thanks.



--=20
Jaroslav Pulchart
Sr. Principal SW Engineer
GoodData
