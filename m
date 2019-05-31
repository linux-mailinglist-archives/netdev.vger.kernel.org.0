Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5119131736
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfEaW3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:29:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56694 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbfEaW3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:29:17 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VMOkEe001671
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=hf0iBmL+ZPzVVFEoCzjI/6lyyAyBGnjBbdBFpVUfY54=;
 b=Krr+iT7NPj8l45hO/CK6kHncf4mbnfBQXRIH1Q1Bv0yzLuhwByjC7dFh8JS8TAqg2F1I
 KmfnTC/5XTWpAlQ2eb+ZWHAW6nCVOM9m8h6jCTuJXU3cOy9ktkrqgoqrtwzd9M88bnRl
 ClDOggpkLbQppA7enuw/4fMmelox10Tbt3Q= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2suad2ghrm-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:15 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 31 May 2019 15:29:12 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 409E62941A0E; Fri, 31 May 2019 15:29:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/2] bpf: udp: A few reuseport's bpf_prog for udp lookup
Date:   Fri, 31 May 2019 15:29:10 -0700
Message-ID: <20190531222910.2499861-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=486 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series has fixes when running reuseport's bpf_prog for udp lookup.
If there is reuseport's bpf_prog, the common issue is the reuseport code
path expects skb->data pointing to the transport header (udphdr here).
A couple of commits broke this expectation.  The issue is specific
to running bpf_prog, so bpf tag is used for this series.

Please refer to the individual commit message for details.

Martin KaFai Lau (2):
  bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err
  bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro

 net/ipv4/udp.c | 6 +++++-
 net/ipv6/udp.c | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.17.1

