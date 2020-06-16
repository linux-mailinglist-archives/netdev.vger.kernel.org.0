Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064971FB3EB
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgFPOOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:14:33 -0400
Received: from tk2.ibw.com.ni ([190.106.60.158]:45404 "EHLO tk2.ibw.com.ni"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgFPOOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 10:14:33 -0400
Received: from tk2.ibw.com.ni (localhost [127.0.0.1])
        by tk2.ibw.com.ni (Proxmox) with ESMTP id 1A09C20ACE
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:14:32 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 japi.ibw.com.ni 8595214A931C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibw.com.ni;
        s=B01EB49E-4102-11E9-ABBB-FDA7C1AECE99; t=1592316866;
        bh=8oczgJSoZjcPzD4hp5B42nh2ce8dCEygtjK7MVkwosQ=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=jxhS2qv7c7a9RV2kGFkp7yiYJUNWt595Zixaqf0wW3Cw06rijeEJICHfOJrvZiNzY
         vjeiUUVtvfaaSuot2ZnPaNsckgdKcBEtwtQ3L0irVI0aAPGMzABvLyYIIolWIkaJPf
         u6B6/ka6cxH2qt6KakcMtk7h+EHLGEghu9Q8PH40jxUmBHI/O1XAfo+atvlrWfSyBm
         IZrecoOYsGKmQKPc5oejeeqpCucfuOuJR0YV51/lURZVHUlW4BdiYUHv8a4fzF1lDU
         vFZFIeUsuAlHIuzT5KqcQCBYQeKESmGqVCCRx+efA0GjR8UROjWjbjgOpNA4pOECUD
         f8LOMlg0erqZQ==
To:     netdev@vger.kernel.org
From:   "Roberto J. Blandino Cisneros" <roberto.blandino@ibw.com.ni>
Subject: RATE not being printed on tc -s class show dev XXXX
Message-ID: <22f9ee66-35b0-7aa0-bde3-fd63c5705110@ibw.com.ni>
Date:   Tue, 16 Jun 2020 08:14:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-NI
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Morning.

I am using debian buster 10.4 with iproute2 compile version 5.7.0.

I am testing Traffic Control but on the statistics no Rate value is shown=
.

For example in the following link "https://paste.ubuntu.com/10963208/",=20
i see following output:

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
jjo@jjo-x220:~/tmp$ ./iproute2-3.19.0-jjo/tc/tc -s class show dev eth0=20
class htb 1:10 parent 1:1 prio 0 rate 2500Mbit ceil 2500Mbit burst=20
15000b cburst 1250b Sent 699143 bytes 5790 pkt (dropped 0, overlimits 0=20
requeues 0) EST32 rate 0bit 0pps backlog 0b 0p requeues 0 lended: 5733=20
borrowed: 0 giants: 0 tokens: 761 ctokens: 74
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I am seing "rate 0bit".

But installing from debian package iproute2 i got nothing so i decide to=20
compile iproute2 using version 5.7.0

But my output is the same as below:

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# tc -s class show dev enp4s0 | grep 1:30 -A 4
class htb 1:30 parent 1:1 leaf 30: prio 1 rate 3Mbit ceil 3Mbit burst=20
5Kb cburst 1599b
 =C2=A0Sent 27793441 bytes 53351 pkt (dropped 26, overlimits 13707 requeu=
es 0)
 =C2=A0backlog 0b 0p requeues 0
 =C2=A0lended: 52095 borrowed: 0 giants: 0
 =C2=A0tokens: 209078 ctokens: 62406
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I did following changes in tc/tc_util.c for printing the rate enclosure=20
after and before condicion of printing rate:

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
843a844
 > printf("->");
865a867
 > printf("<-");
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The section of tc_util.c show like this :

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
printf("->");
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (tbs[TCA_STATS_RATE_EST64]=
) {
struct gnet_stats_rate_est64 re =3D {0};

memcpy(&re, RTA_DATA(tbs[TCA_STATS_RATE_EST64]),
MIN(RTA_PAYLOAD(tbs[TCA_STATS_RATE_EST64]),
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sizeof(re)));
print_string(PRINT_FP, NULL, "\n%s", prefix);
print_lluint(PRINT_JSON, "rate", NULL, re.bps);
print_string(PRINT_FP, NULL, "rate %s",
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sprint_rate(re.bps, b1));
print_lluint(PRINT_ANY, "pps", " %llupps", re.pps);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (tbs[TCA_STATS_RATE=
_EST]) {
struct gnet_stats_rate_est re =3D {0};

memcpy(&re, RTA_DATA(tbs[TCA_STATS_RATE_EST]),
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MIN(RTA_PAYL=
OAD(tbs[TCA_STATS_RATE_EST]),=20
sizeof(re)));
print_string(PRINT_FP, NULL, "\n%s", prefix);
print_uint(PRINT_JSON, "rate", NULL, re.bps);
print_string(PRINT_FP, NULL, "rate %s",
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sprint_rate(re.bps, b1));
print_uint(PRINT_ANY, "pps", " %upps", re.pps);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
printf("<-");
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

And as you can see no rate is being printed, does int need to be enable=20
something else to print the rate?, now with the changes done i Got:

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# tc -s class show dev enp4s0 | grep 1:30 -A 4
class htb 1:30 parent 1:1 leaf 30: prio 1 rate 3Mbit ceil 3Mbit burst=20
5Kb cburst 1599b
 =C2=A0Sent 35713116 bytes 72643 pkt (dropped 26, overlimits 16464 requeu=
es=20
0) -><-
 =C2=A0backlog 0b 0p requeues 0
 =C2=A0lended: 71083 borrowed: 0 giants: 0
 =C2=A0tokens: 209078 ctokens: 62406
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As you can see "-><-" is being printed.

Is necessary to do something else to get tbs[TCA_STATS_RATE_EST] working?

Even i compile the last kernel 5.7.2.

Any guide option or value that must need the processor, network card,=20
hardware, etc for this?


