Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69F4CBB57
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiCCKaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiCCKac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:30:32 -0500
Received: from s-terra.s-terra.com (s-terra.s-terra.com [213.5.74.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC09179A23
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 02:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-terra.ru; s=mail;
        t=1646303383; bh=QIg9H9j2Zbsc0qUFhePL0mWB9qYGTznvlTdQigMByiU=;
        h=From:To:Subject:Date:From;
        b=ivvCTtsqn3hXlRD9f+X1PzO9qREU2CydIiJJU0anRGFS76T6LAm3fBY/HBDzKrWJ4
         CHA2tugnSmbxyVIgjTM830QegdRg8YdaQAvQqn7ncXWrkcC83l1QmePVaEaoZBIpMC
         nlF+9qitJvvbA9R2Cr43SjdrXXjENvKah6njfBZM=
From:   =?koi8-r?B?+9XNzsnLIOHMxcvTxco=?= <ashumnik@s-terra.ru>
To:     "'netdev@vger.kernel.org'" <'netdev@vger.kernel.org'>
Subject: [bug report] ip neigh: ipv6 as lladdr
Thread-Topic: [bug report] ip neigh: ipv6 as lladdr
Thread-Index: Adgu6WUJeoQVTuuIQaOja8/m7Xp6JA==
Date:   Thu, 3 Mar 2022 10:29:43 +0000
Message-ID: <2b76eb475bb647d38b4c91d9cf89a89e@s-terra.ru>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Maintainers,

I'm developing NHRP with IPv6 support as NBMA, at one stage I need to creat=
e an entry in the neighbors table, and I found a bug:
When I add an IPv4 address, everything works fine:

$ ip n add 10.10.10.100 dev mgre0 lladdr 10.10.106.123

But when I perform the same actions with IPv6:

$ ip -6 n add 2001::100 dev enp0s3 lladdr fd0e:a00:a7ff::fee1:99f5

get an error: "fd0e" is invalid lladdr
I realized that ip utility does not know how to add IPv6 addresses to the n=
eighbors list as lladdr.=20
I use this code to add IPv6 as lladdr to neighbors list and it's working, b=
ut it seems that kernel can't read this entry correctly.

    int kernel_inject_neighbor(struct nhrp_address *neighbor,

                                                   struct nhrp_address *hwa=
ddr,

                                                   struct nhrp_interface *d=
ev)

    {

                   struct {

                                   struct nlmsghdr                n;

                                   struct ndmsg                     ndm;

                                   char                                    =
  buf[256];

                   } req;

                   char neigh[MAX_BUFF_SIZE], nbma[MAX_BUFF_SIZE];

                   memset(&req.n, 0, sizeof(req.n));

                   memset(&req.ndm, 0, sizeof(req.ndm));

                   req.n.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ndmsg));

                   req.n.nlmsg_flags =3D NLM_F_REQUEST | NLM_F_REPLACE | NL=
M_F_CREATE;

                   req.n.nlmsg_type =3D RTM_NEWNEIGH;

                   req.ndm.ndm_family =3D neighbor->type;

                   req.ndm.ndm_ifindex =3D dev->index;

                   req.ndm.ndm_type =3D RTN_UNICAST;

                   netlink_add_rtattr_l(&req.n, sizeof(req), NDA_DST,

                                                                   (char *)=
&neighbor->addr, neighbor->addr_len);

                   if (hwaddr !=3D NULL && hwaddr->type !=3D PF_UNSPEC) {

                                   req.ndm.ndm_state =3D NUD_REACHABLE;

                                   netlink_add_rtattr_l(&req.n, sizeof(req)=
, NDA_LLADDR,

                                                                           =
                                       (char *)&hwaddr->addr, hwaddr->addr_=
len);

                                   nhrp_debug("NL-NEIGH(%s) %s is-at %s",

                                                   dev->name,

                                                   nhrp_address_format(neig=
hbor, sizeof(neigh), neigh),

                                                   nhrp_address_format(hwad=
dr, sizeof(nbma), nbma));

                   } else {

                                   req.ndm.ndm_state =3D NUD_FAILED;

                                   nhrp_debug("NL-NEIGN(%s) %s not-reachabl=
e",

                                                   dev->name,

                                                   nhrp_address_format(neig=
hbor, sizeof(neigh), neigh));

                   }

                   return netlink_send(&talk_fd, &req.n);

    }

Is this a bug and will it be fixed? How long will it take to fix this bug?=
=20
If I try to fix it myself, then where to start and where to look?

--
Aleksey Shumnik
