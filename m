Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC34CBB7F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiCCKgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiCCKgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:36:02 -0500
Received: from s-terra.s-terra.com (s-terra.s-terra.com [213.5.74.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0CA33E96
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 02:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-terra.ru; s=mail;
        t=1646303710; bh=QIg9H9j2Zbsc0qUFhePL0mWB9qYGTznvlTdQigMByiU=;
        h=From:To:Subject:Date:From;
        b=M7+Xh5TY5G1AsBjH8PHyQ30OoiOiM3vpaN+mXeAnV9caR2dzHr8nJHZKXichs9Aai
         Oex7GWPT6bwmgFI7t+0zJXG9FWCylITTtGzrZ0UxdDSyeHnA7HOhlI0CPRdjiAvsXQ
         NFvGg4A/jVna45YaKFHlBRqicvrx0EqcRajRaovA=
From:   =?koi8-r?B?+9XNzsnLIOHMxcvTxco=?= <ashumnik@s-terra.ru>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [bug report] ip neigh: ipv6 as lladdr
Thread-Topic: [bug report] ip neigh: ipv6 as lladdr
Thread-Index: Adgu6lp3FZ1uu460S+GC56jgP9DQkA==
Date:   Thu, 3 Mar 2022 10:35:10 +0000
Message-ID: <2bc539d8b84d4e27b6dba96f0f7e14f1@s-terra.ru>
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
