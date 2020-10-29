Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0965B29E4CB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732718AbgJ2HqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:46:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30702 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730754AbgJ2Hpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:45:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T7Iw9f013466
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:20:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JLzH51fIRRW8lUnrE08RZYYgZ99JFA8voFiaOqr+L40=;
 b=VixOnPxNVqbzZ+bkoBfyYrRYj3kp6whmAW7iQSDmjd4PHPKGyVGeVYWhhelKSL68jRca
 cScaiLap22uCVm7wE7HKzLy1YpAdREyXajJ8BY7q+g3b+eqHKz3ysFmQmJQzFdOpnhwx
 Dfd5196OgwsE2UNZDdq8RH9tWWe3vhVST2s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34egnfcnh1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:20:00 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 00:19:58 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4E1A362E580C; Thu, 29 Oct 2020 00:19:46 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 0/2] bpf: safeguard hashtab locking in NMI context
Date:   Thu, 29 Oct 2020 00:19:23 -0700
Message-ID: <20201029071925.3103400-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_03:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=454
 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010290051
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LOCKDEP NMI warning highlighted potential deadlock of hashtab in NMI
context:

[   74.828971] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   74.828972] WARNING: inconsistent lock state
[   74.828973] 5.9.0-rc8+ #275 Not tainted
[   74.828974] --------------------------------
[   74.828975] inconsistent {INITIAL USE} -> {IN-NMI} usage.
[   74.828976] taskset/1174 [HC2[2]:SC0[0]:HE0:SE1] takes:
[...]
[   74.828999]  Possible unsafe locking scenario:
[   74.828999]
[   74.829000]        CPU0
[   74.829001]        ----
[   74.829001]   lock(&htab->buckets[i].raw_lock);
[   74.829003]   <Interrupt>
[   74.829004]     lock(&htab->buckets[i].raw_lock);

Please refer to patch 1/2 for full trace.

This warning is a false alert, as "INITIAL USE" and "IN-NMI" in the tests
are from different hashtab. On the other hand, in theory, it is possible
to deadlock when a hashtab is access from both non-NMI and NMI context.
Patch 1/2 fixes this false alert by assigning separate lockdep class to
each hashtab. Patch 2/2 introduces map_locked counters, which is similar =
to
bpf_prog_active counter, to avoid hashtab deadlock in NMI context.

Song Liu (2):
  bpf: use separate lockdep class for each hashtab
  bpf: Avoid hashtab deadlock with map_locked

 kernel/bpf/hashtab.c | 126 +++++++++++++++++++++++++++++++------------
 1 file changed, 92 insertions(+), 34 deletions(-)

--
2.24.1
